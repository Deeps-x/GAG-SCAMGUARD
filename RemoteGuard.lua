-- RemoteGuard.lua
-- Advanced Remote Guard for Next-Gen Anti-Gift
-- Scans, hooks and protects gift-related remotes (RemoteEvent/RemoteFunction)
-- Multi-layer hooking: FireServer, InvokeServer, and best-effort __namecall interception
-- Provides reapply hooks for TamperProtection and events for Main to react to

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RemoteGuard = {}
RemoteGuard.__index = RemoteGuard

-- Public event fired when a remote is triggered
RemoteGuard.OnRemoteTriggered = Instance.new("BindableEvent")

-- internal state
local blocked = {}            -- maps Remote instance -> original function/table of originals
local patterns = { "gift", "give", "gifting", "giftto", "gift_pet" } -- detection keywords (lowercase)
local status = "safe"        -- safe, warn, danger, bypass
local logger = nil            -- optional Logger module (set by Main)
local guimgr = nil            -- optional GUIManager module (set by Main)
local config = {
    AutoKick = true,
    ReapplyDelay = 1.0,
}

-- helpers --------------------------------------------------
local function safePcall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

local function log(msg, lvl)
    lvl = lvl or "info"
    if logger and logger.AddEntry then
        pcall(function() logger:AddEntry(msg, lvl) end)
    else
        if lvl == "alert" or lvl == "error" then
            pcall(function() warn("[RemoteGuard] ", msg) end)
        end
    end
end

local function guiAddBlocked(name)
    if guimgr and guimgr.AddBlockedRemote then
        pcall(function() guimgr:AddBlockedRemote(name) end)
    end
end

local function guiRecordTrigger(name)
    if guimgr and guimgr.RecordTrigger then
        pcall(function() guimgr:RecordTrigger(name) end)
    end
end

-- pattern matcher (case-insensitive)
local function isGiftRemote(inst)
    if not inst or not inst.Name then return false end
    local n = tostring(inst.Name):lower()
    for _, p in ipairs(patterns) do
        if n:find(p, 1, true) then
            return true
        end
    end
    return false
end

-- Hook availability checks (exploit-dependent functions)
local hasHookFunction = type(hookfunction) == "function"
local hasHookMeta = type(hookmetamethod) == "function" or type(hookmetamethod) == "userdata"
-- note: some exploit envs expose hookmetamethod, others hookmetamethod/game/ or hookfunction

-- store original metamethod if we hook it
local originalNamecall = nil
local namecallHooked = false

-- Attempt to hook __namecall for broad interception (best-effort)
local function tryHookNamecall()
    if namecallHooked then return true end
    if not hasHookMeta then
        -- attempt alternative common name (some exploits expose 'hookmetamethod' as hookmetamethod)
        if type(hookmetamethod) ~= "function" then
            return false
        end
    end

    -- try to hook __namecall; signature depends on exploit API
    local success, err = pcall(function()
        -- common exploit signature: hookmetamethod(game, "__namecall", function(self, ...)
        originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or tostring("__namecall")
            -- inspect method and args to detect remote calls
            local args = {...}
            -- if it's FireServer/InvokeServer on a remote instance, block
            local target = self
            if typeof(target) == "Instance" and (target:IsA("RemoteEvent") or target:IsA("RemoteFunction")) then
                local n = tostring(target.Name):lower()
                if isGiftRemote(target) then
                    -- report trigger and block
                    RemoteGuard.OnRemoteTriggered:Fire(target.Name)
                    guiRecordTrigger(target.Name)
                    status = "bypass"
                    -- do not call original
                    return nil
                end
            end
            -- fallback: call original
            return originalNamecall(self, ...)
        end)
        namecallHooked = true
    end)

    if not success then
        log("hookmetamethod/__namecall hook failed: " .. tostring(err), "error")
        return false
    end
    log("Namecall hook installed.", "info")
    return true
end

-- store originals for reapplication
local originalHooks = {}

-- Hook FireServer / InvokeServer for a single remote
local function hookRemote(remote)
    if not remote or not remote:IsA("Instance") then return false end
    if blocked[remote] then return true end

    local ok = true
    local originals = {}

    -- Hook FireServer (RemoteEvent)
    if remote:IsA("RemoteEvent") then
        if hasHookFunction then
            local success, res = pcall(function()
                originals.FireServer = hookfunction(remote.FireServer, function(self, ...)
                    -- block and report
                    status = "bypass"
                    RemoteGuard.OnRemoteTriggered:Fire(remote.Name)
                    guiRecordTrigger(remote.Name)
                    -- don't forward
                    return nil
                end)
            end)
            if not success then
                ok = false
                log("Failed to hook FireServer for "..tostring(remote.Name).." : "..tostring(res), "error")
            end
        else
            -- no hookfunction available; try to wrap via metamethod after install
            ok = ok and true
        end
    end

    -- Hook InvokeServer (RemoteFunction)
    if remote:IsA("RemoteFunction") then
        if hasHookFunction then
            local success, res = pcall(function()
                originals.InvokeServer = hookfunction(remote.InvokeServer, function(self, ...)
                    -- block and report
                    status = "bypass"
                    RemoteGuard.OnRemoteTriggered:Fire(remote.Name)
                    guiRecordTrigger(remote.Name)
                    return nil
                end)
            end)
            if not success then
                ok = false
                log("Failed to hook InvokeServer for "..tostring(remote.Name).." : "..tostring(res), "error")
            end
        else
            ok = ok and true
        end
    end

    blocked[remote] = originals
    originalHooks[remote] = originals
    if ok then
        guiAddBlocked(remote.Name)
        table.insert(RemoteGuard.Logs or {}, {Time=os.time(), Action="Blocked", Remote=remote.Name})
    end
    return ok
end

-- Reapply hooks for remotes we previously hooked (used by TamperProtection)
function RemoteGuard:ReapplyHooks()
    for remote, olds in pairs(originalHooks) do
        if not remote or not remote.Parent then
            -- remote gone; skip
        else
            -- try to re-hook if currently unhooked
            -- naive approach: attempt hookRemote again
            pcall(function() hookRemote(remote) end)
        end
    end
    log("ReapplyHooks executed.", "info")
end

-- Public: Scan and hook all gift remotes
function RemoteGuard:ScanAndBlock()
    local found = 0
    local all = ReplicatedStorage:GetDescendants()
    for _, inst in ipairs(all) do
        if (inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction")) and isGiftRemote(inst) then
            found = found + 1
            pcall(function() hookRemote(inst) end)
        end
    end
    if found > 0 then
        status = "safe"
        log("ScanAndBlock: blocked "..tostring(found).." remotes.", "info")
    else
        status = "danger"
        log("ScanAndBlock: no gift remotes found.", "warn")
    end
    return found
end

-- Monitor new remotes added at runtime and auto-block
function RemoteGuard:MonitorNewRemotes()
    ReplicatedStorage.DescendantAdded:Connect(function(inst)
        if (inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction")) and isGiftRemote(inst) then
            pcall(function()
                hookRemote(inst)
                log("MonitorNewRemotes: blocked new remote: "..tostring(inst.Name), "info")
            end)
        end
    end)
end

-- Unhook all (best-effort; restores original functions when possible)
function RemoteGuard:UnhookAll()
    for remote, originals in pairs(blocked) do
        if remote and remote.Parent and originals then
            pcall(function()
                if originals.FireServer then
                    -- try to restore via rawset if possible (exploit-dependent)
                    pcall(function() remote.FireServer = originals.FireServer end)
                end
                if originals.InvokeServer then
                    pcall(function() remote.InvokeServer = originals.InvokeServer end)
                end
            end)
        end
    end
    blocked = {}
    originalHooks = {}
    log("UnhookAll executed.", "info")
end

-- Get status
function RemoteGuard:GetStatus()
    return status
end

function RemoteGuard:GetBlockedList()
    local t = {}
    for remote,_ in pairs(blocked) do
        pcall(function() table.insert(t, tostring(remote.Name)) end)
    end
    return t
end

-- Link external modules (called by Main)
function RemoteGuard:LinkModules(opts)
    if not opts then return end
    if opts.Logger then logger = opts.Logger end
    if opts.GUIManager then guimgr = opts.GUIManager end
    if opts.Config then for k,v in pairs(opts.Config) do config[k] = v end end
    -- inject patterns from config if provided
    if opts.Config and opts.Config.DetectionPatterns and type(opts.Config.DetectionPatterns) == "table" then
        patterns = opts.Config.DetectionPatterns
    end
end

-- Lightweight health-check for TamperProtection to call
function RemoteGuard:HealthCheck()
    -- ensure that hooks are still in place (best-effort): check blocked remotes' FireServer/InvokeServer are functions
    for remote, olds in pairs(blocked) do
        if not remote or not remote.Parent then
            log("HealthCheck: protected remote missing: "..tostring(remote), "alert")
            return false
        end
        -- if hasHookFunction and original stored, compare tostring
        if olds and (olds.FireServer or olds.InvokeServer) then
            -- nothing precise we can do cross-env; rely on existence
        end
    end
    return true
end

-- Expose API
RemoteGuard.BlockedRemotes = blocked
RemoteGuard.GetStatus = RemoteGuard.GetStatus
RemoteGuard.ScanAndBlock = RemoteGuard.ScanAndBlock
RemoteGuard.MonitorNewRemotes = RemoteGuard.MonitorNewRemotes
RemoteGuard.ReapplyHooks = RemoteGuard.ReapplyHooks
RemoteGuard.UnhookAll = RemoteGuard.UnhookAll
RemoteGuard.GetBlockedList = RemoteGuard.GetBlockedList
RemoteGuard.LinkModules = RemoteGuard.LinkModules
RemoteGuard.HealthCheck = RemoteGuard.HealthCheck

return RemoteGuard
