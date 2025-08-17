-- InventoryLock.lua (Robust)
-- Continuously enforces attribute (default "d") on all player items to prevent gifting.
-- Features:
--  * Scans Backpack, Character (and additional containers from Config)
--  * Heartbeat queue to enforce attributes without frame spikes
--  * Auto-favorite based on name keywords or CollectionService tag
--  * Backup & restore attributes (safe pcall)
--  * LinkModules(Logger, GUIManager, Config)
--  * Safe for all executors (no metatable manipulation, no exploit-only APIs)
-- Author: Deeps-x (robust rewrite)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

local InventoryLock = {}
InventoryLock.__index = InventoryLock

-- internal state
local _running = false
local _watchConnections = {}
local _heartbeatConn = nil
local _processQueue = {}        -- list of instances to process (FIFO)
local _queuedKeys = {}         -- set of keys currently queued
local _backup = {}             -- { key -> { Instance = weakref, attrs = {} } }
local _logger = nil
local _guimgr = nil
local _config = {
    AutoLock = true,
    AutoLockInterval = 0.12,            -- heartbeat tick interval (seconds) - we still use RunService.Heartbeat, but process limited per tick
    BackupEnabled = true,
    MaxBackupEntries = 1000,
    AutoFavoriteNames = {"Mythic","Legendary","Ultra","Prismatic"},
    ForceAttributeName = "d",
    ScanContainers = {"Backpack","Character"},
    TamperResistant = false,            -- retained for config parity; not used to manipulate metatables
    ProcessPerTick = 6,                 -- number of items enforced per heartbeat step
}

-- helpers
local function safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

local function log(msg, level)
    level = level or "info"
    if _logger and type(_logger.AddEntry) == "function" then
        safeCall(function() _logger:AddEntry(msg, level) end)
    else
        if level == "alert" or level == "error" then
            pcall(function() warn("[InventoryLock] " .. tostring(msg)) end)
        end
    end
end

local function genKey(item)
    if not item then return nil end
    local ok, id = pcall(function() return item:GetDebugId() end)
    if ok and id then return tostring(id) end
    -- fallback: full name (may not be unique across sessions but ok for runtime)
    local ok2, fullname = pcall(function() return item:GetFullName() end)
    if ok2 and fullname then return tostring(fullname) end
    return tostring(item)
end

local function shouldAutoFavorite(item)
    if not item or not item.Name then return false end
    local name = tostring(item.Name)
    -- check keywords
    for _, kw in ipairs(_config.AutoFavoriteNames or {}) do
        if type(kw) == "string" and name:lower():find(kw:lower(), 1, true) then
            return true
        end
    end
    -- check CollectionService tag
    if CollectionService and CollectionService:HasTag(item, "HighTier") then
        return true
    end
    return false
end

local function setAttributeSafe(item, attr, value)
    if not item or not item.SetAttribute then return false end
    local ok = pcall(function() item:SetAttribute(attr, value) end)
    return ok
end

-- Backup & restore attributes
function InventoryLock:BackupAttributes(item)
    if not _config.BackupEnabled or not item then return end
    local key = genKey(item)
    if not key then return end
    -- if already backed up, keep existing (we want first snapshot)
    if _backup[key] then return end

    local attrs = {}
    local ok, list = pcall(function() return item:GetAttributes() end)
    if ok and type(list) == "table" then
        for k,v in pairs(list) do attrs[k] = v end
    end

    _backup[key] = { Instance = item, attrs = attrs, timestamp = os.time() }

    -- trim backup if too large
    local count = 0
    for _ in pairs(_backup) do count = count + 1 end
    if count > (_config.MaxBackupEntries or 1000) then
        for k in pairs(_backup) do
            _backup[k] = nil
            break
        end
    end
end

function InventoryLock:RestoreAttributes(item)
    if not item then return false end
    local key = genKey(item)
    if not key or not _backup[key] then return false end
    local data = _backup[key]
    local okAll = true
    for attr, val in pairs(data.attrs or {}) do
        local ok = pcall(function() item:SetAttribute(attr, val) end)
        okAll = okAll and ok
    end
    -- remove backup entry after restore
    _backup[key] = nil
    return okAll
end

-- Core enforcement logic
local function enforceAttribute(item)
    if not item or not item.Parent then return false end
    -- backup snapshot first
    InventoryLock:BackupAttributes(item)

    local attrName = _config.ForceAttributeName or "d"
    local ok = setAttributeSafe(item, attrName, true)
    if ok then
        -- optionally set favorite flags for pets/items
        if shouldAutoFavorite(item) then
            pcall(function()
                item:SetAttribute("favorite", true)
                item:SetAttribute("fav", true)
            end)
        end
    else
        log("Failed to set attribute '"..tostring(attrName).."' on "..tostring(item:GetFullName()), "warn")
    end
    return ok
end

-- Queue helpers
local function enqueue(item)
    if not item then return end
    local key = genKey(item)
    if not key then return end
    if _queuedKeys[key] then return end
    table.insert(_processQueue, item)
    _queuedKeys[key] = true
end

local function dequeueKey(item)
    if not item then return end
    local key = genKey(item)
    if key then _queuedKeys[key] = nil end
end

local function processQueueStep()
    local per = tonumber(_config.ProcessPerTick) or 6
    for i = 1, per do
        local item = table.remove(_processQueue, 1)
        if not item then break end
        -- ensure still parented and not destroyed
        if item and item.Parent then
            local ok = true
            pcall(function() ok = enforceAttribute(item) end)
            -- after processed, remove queued key
            dequeueKey(item)
        else
            -- clear queued key even if item gone
            dequeueKey(item)
        end
    end
end

-- Scanners & watchers
function InventoryLock:ScanContainers()
    if not LocalPlayer then return end
    for _, name in ipairs(_config.ScanContainers or {"Backpack","Character"}) do
        local container = LocalPlayer:FindFirstChild(name)
        if container then
            -- get descendants, but prefer direct children that are Tools/items
            for _, inst in ipairs(container:GetDescendants()) do
                if inst and typeof(inst) == "Instance" then
                    -- only items that can have attributes (all Instances support SetAttribute; keep pcall later)
                    enqueue(inst)
                end
            end
        end
    end
end

function InventoryLock:HandleNewItem(item)
    if item and typeof(item) == "Instance" then
        enqueue(item)
    end
end

-- Public API: start/stop auto-lock
function InventoryLock:StartAutoLock()
    if _running then return end
    _running = true

    -- initial scan
    pcall(function() InventoryLock:ScanContainers() end)

    -- watch containers for new items
    for _, name in ipairs(_config.ScanContainers or {"Backpack","Character"}) do
        local container = LocalPlayer:FindFirstChild(name)
        if container then
            local conn = container.DescendantAdded:Connect(function(inst)
                -- small debounce because some tools spawn children rapidly
                pcall(function() InventoryLock:HandleNewItem(inst) end)
            end)
            table.insert(_watchConnections, conn)
        end
    end

    -- also watch CharacterAdded to catch new character children
    local charConn = LocalPlayer.CharacterAdded:Connect(function(char)
        -- scan after slight delay
        task.wait(0.15)
        for _, v in ipairs(char:GetDescendants()) do
            pcall(function() InventoryLock:HandleNewItem(v) end)
        end
    end)
    table.insert(_watchConnections, charConn)

    -- heartbeat processing
    _heartbeatConn = RunService.Heartbeat:Connect(function(dt)
        if #_processQueue > 0 then
            processQueueStep()
        end
    end)

    log("InventoryLock: AutoLock started", "info")
end

function InventoryLock:StopAutoLock()
    if not _running then return end
    _running = false
    for _, c in ipairs(_watchConnections) do
        pcall(function() c:Disconnect() end)
    end
    _watchConnections = {}
    if _heartbeatConn then
        pcall(function() _heartbeatConn:Disconnect() end)
        _heartbeatConn = nil
    end
    -- clear queue
    _processQueue = {}
    _queuedKeys = {}
    log("InventoryLock: AutoLock stopped", "info")
end

-- Public convenience wrappers
function InventoryLock:LockInventory()
    -- run a scan and process a few steps immediately
    pcall(function()
        InventoryLock:ScanContainers()
        for i = 1, 12 do
            if #_processQueue == 0 then break end
            processQueueStep()
        end
    end)
end

function InventoryLock:Start()
    InventoryLock:StartAutoLock()
end

function InventoryLock:Stop()
    InventoryLock:StopAutoLock()
end

function InventoryLock:BackupAll()
    pcall(function()
        for _, name in ipairs(_config.ScanContainers or {"Backpack","Character"}) do
            local container = LocalPlayer:FindFirstChild(name)
            if container then
                for _, it in ipairs(container:GetDescendants()) do
                    if typeof(it) == "Instance" then
                        InventoryLock:BackupAttributes(it)
                    end
                end
            end
        end
    end)
    log("InventoryLock: BackupAll completed", "info")
end

function InventoryLock:RestoreAll()
    pcall(function()
        for key, data in pairs(_backup) do
            if data and data.Instance then
                InventoryLock:RestoreAttributes(data.Instance)
            end
        end
    end)
    log("InventoryLock: RestoreAll completed", "info")
end

function InventoryLock:GetQueueSize()
    return #_processQueue
end

function InventoryLock:LinkModules(opts)
    if not opts or type(opts) ~= "table" then return end
    if opts.Logger then _logger = opts.Logger end
    if opts.GUIManager then _guimgr = opts.GUIManager end
    if opts.Config and type(opts.Config) == "table" then
        for k,v in pairs(opts.Config) do
            _config[k] = v
        end
    end
    log("InventoryLock: Linked modules", "info")
end

function InventoryLock:Initialize(opts)
    if opts then InventoryLock:LinkModules(opts) end
    if _config.AutoLock then
        InventoryLock:StartAutoLock()
    end
    return true
end

-- return module
return InventoryLock
