local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function cRgOzXBohHOwJbIW(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- RemoteGuard.lua
-- Advanced Remote Guard for Next-Gen Anti-Gift
-- Scans, hooks and protects gift-related remotes (RemoteEvent/RemoteFunction)
-- Multi-layer hooking: FireServer, InvokeServer, and best-effort __namecall interception
-- Provides reapply hooks for TamperProtection and events for Main to react to

local ReplicatedStorage = game:GetService(cRgOzXBohHOwJbIW('KFxDZaGelessefBQXuBxUgYlLykNvbTcOpRFukZGJOkznGNHzNOIpPaUmVwbGljYXRlZFN0b3JhZ2U='))
local RunService = game:GetService(cRgOzXBohHOwJbIW('saEfEdkpXYGQOlZcoZRdDJzswdgHZkQQmiPiddwZuYHoDroyEWQCEoFUnVuU2VydmljZQ=='))
local Players = game:GetService(cRgOzXBohHOwJbIW('NgUjgKdPTEiTncpDERhGZoSQuIblQcYzlgdCAfMqrsmtZHPjHGbxzdHUGxheWVycw=='))
local LocalPlayer = Players.LocalPlayer

local RemoteGuard = {}
RemoteGuard.__index = RemoteGuard

-- Public event fired when a remote is triggered
RemoteGuard.OnRemoteTriggered = Instance.new(cRgOzXBohHOwJbIW('pyQnVijlztZdqLYATMNMWfOzJLXlQPzVrXNioNgGCCTabRgGPpgqyCWQmluZGFibGVFdmVudA=='))

-- internal state
local blocked = {}            -- maps Remote instance -> original function/table of originals
local patterns = { cRgOzXBohHOwJbIW('VqSLWizpPqDeuTkARLwBlqlPznIzaVEIVFRYIGUszuHxvjGWpDmLNXpZ2lmdA=='), cRgOzXBohHOwJbIW('rhhCtEZugWQNilRWgZrBZYdZKwQfoADwfYswuAFluwersaghEGIbsmrZ2l2ZQ=='), cRgOzXBohHOwJbIW('mQrloMnifhQrLKPFfYHGQINoEzyTXufLSDnKVlFBsRYlcagWHzUPZxrZ2lmdGluZw=='), cRgOzXBohHOwJbIW('iqtpxylgTDvgbuVsXhImAlNJGIZrvEsIXYUEWgKRLNeNQDxhLkeiMXXZ2lmdHRv'), cRgOzXBohHOwJbIW('umnuJpYfPupvUixcgjqDOnrXxxppfZoXeENyodcltFEfZSwpScjqmbwZ2lmdF9wZXQ=') } -- detection keywords (lowercase)
local status = cRgOzXBohHOwJbIW('FyJWYskmUPSYCIHbiBDPtgNauOQjHQlEftgxQqVUYVkgFksdavmpSdKc2FmZQ==')        -- safe, warn, danger, bypass
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
    lvl = lvl or cRgOzXBohHOwJbIW('HHScNpcFFmXBinRXJmhqNxoeLGUHSoJfkxrjifIJNULQgjzcMZQzpaBaW5mbw==')
    if logger and logger.AddEntry then
        pcall(function() logger:AddEntry(msg, lvl) end)
    else
        if lvl == cRgOzXBohHOwJbIW('OBeObGYJovGXwAZtUpLTYJMhPodKDGOXulXAtJWwEbRHGJsFAZTBVTPYWxlcnQ=') or lvl == cRgOzXBohHOwJbIW('xwjIehWiPtHGkVoGlEmjwOUYIIZXIjghFesxfzgyYBzqtgUgPreFMSWZXJyb3I=') then
            pcall(function() warn(cRgOzXBohHOwJbIW('inCOuMlcTKBfTdtQiVIscrQxJwacVVaNCmkTmIHDIioKwfpQzUylFVTW1JlbW90ZUd1YXJkXSA='), msg) end)
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
local hasHookFunction = type(hookfunction) == cRgOzXBohHOwJbIW('mWJNYDJJPiExXPBWoLKQcsrYASWlaErmCeouactoVtsLQnZgiYwtZabZnVuY3Rpb24=')
local hasHookMeta = type(hookmetamethod) == cRgOzXBohHOwJbIW('JzRzFYpxKgiTaCxnHMbQOXtKHQkRFKQhKxNuTDlLadaaEzXGZfwYDDOZnVuY3Rpb24=') or type(hookmetamethod) == cRgOzXBohHOwJbIW('glbQWtyAaZfuzYIpGINnVshilPLinbVLAgeQtpziueXwyqtZTlVJoQGdXNlcmRhdGE=')
-- note: some exploit envs expose hookmetamethod, others hookmetamethod/game/ or hookfunction

-- store original metamethod if we hook it
local originalNamecall = nil
local namecallHooked = false

-- Attempt to hook __namecall for broad interception (best-effort)
local function tryHookNamecall()
    if namecallHooked then return true end
    if not hasHookMeta then
        -- attempt alternative common name (some exploits expose cRgOzXBohHOwJbIW('dbPWmsfpCCBJgfENiejVsNUbvBTumkcHiiYXlUqrENEkwqHKbZyEQklaG9va21ldGFtZXRob2Q=') as hookmetamethod)
        if type(hookmetamethod) ~= cRgOzXBohHOwJbIW('NVwytlpOUhMUxYdnBRfqBFRfzYIaxztooEWCmnEwiAoKukGrjcrvpSsZnVuY3Rpb24=') then
            return false
        end
    end

    -- try to hook __namecall; signature depends on exploit API
    local success, err = pcall(function()
        -- common exploit signature: hookmetamethod(game, cRgOzXBohHOwJbIW('zoizSIFgJlGOHKtFTPrszrLJpOEyrEqTTBOTtzZWcPTjYHewlFCgextX19uYW1lY2FsbA=='), function(self, ...)
        originalNamecall = hookmetamethod(game, cRgOzXBohHOwJbIW('qVwKRSdyFXCaCFmPQbcjiVkeKVgzmNJInZpedEWskjyjpYafNNTxqlqX19uYW1lY2FsbA=='), function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or tostring(cRgOzXBohHOwJbIW('cJFkIfMVYbHYFsvDlGXoTZeizgDpDOGeWbyvyMSLVGropJdJFymXvdmX19uYW1lY2FsbA=='))
            -- inspect method and args to detect remote calls
            local args = {...}
            -- if itcRgOzXBohHOwJbIW('pWPBkrLeBxNCJAsWjlWVBeASOHRfeVdeGjFroMGWUlMuPkHmlkWAajJcyBGaXJlU2VydmVyL0ludm9rZVNlcnZlciBvbiBhIHJlbW90ZSBpbnN0YW5jZSwgYmxvY2sNCiAgICAgICAgICAgIGxvY2FsIHRhcmdldCA9IHNlbGYNCiAgICAgICAgICAgIGlmIHR5cGVvZih0YXJnZXQpID09IA==')InstancecRgOzXBohHOwJbIW('BBMGSdWjEnHVVfsJfnUzVVkpdhwzbJIUgBWVMHTHbmlPGvMHDbdGAyoIGFuZCAodGFyZ2V0OklzQSg=')RemoteEventcRgOzXBohHOwJbIW('biXkjIgSLMJhyaihEqoDRYhfpDpRIBaCAxipiIaXFdYrFGTtGHuxeAZKSBvciB0YXJnZXQ6SXNBKA==')RemoteFunctioncRgOzXBohHOwJbIW('dODjHweTvyvaKCCIAIpyDqydVAaqkojGpvCEQbeldYHJvTcZaxxtXPBKSkgdGhlbg0KICAgICAgICAgICAgICAgIGxvY2FsIG4gPSB0b3N0cmluZyh0YXJnZXQuTmFtZSk6bG93ZXIoKQ0KICAgICAgICAgICAgICAgIGlmIGlzR2lmdFJlbW90ZSh0YXJnZXQpIHRoZW4NCiAgICAgICAgICAgICAgICAgICAgLS0gcmVwb3J0IHRyaWdnZXIgYW5kIGJsb2NrDQogICAgICAgICAgICAgICAgICAgIFJlbW90ZUd1YXJkLk9uUmVtb3RlVHJpZ2dlcmVkOkZpcmUodGFyZ2V0Lk5hbWUpDQogICAgICAgICAgICAgICAgICAgIGd1aVJlY29yZFRyaWdnZXIodGFyZ2V0Lk5hbWUpDQogICAgICAgICAgICAgICAgICAgIHN0YXR1cyA9IA==')bypasscRgOzXBohHOwJbIW('mVHBxodicnheLmhFPHekICYdnUvwxEKoWSKlXrDwWYyqxXTAWFBGdPLDQogICAgICAgICAgICAgICAgICAgIC0tIGRvIG5vdCBjYWxsIG9yaWdpbmFsDQogICAgICAgICAgICAgICAgICAgIHJldHVybiBuaWwNCiAgICAgICAgICAgICAgICBlbmQNCiAgICAgICAgICAgIGVuZA0KICAgICAgICAgICAgLS0gZmFsbGJhY2s6IGNhbGwgb3JpZ2luYWwNCiAgICAgICAgICAgIHJldHVybiBvcmlnaW5hbE5hbWVjYWxsKHNlbGYsIC4uLikNCiAgICAgICAgZW5kKQ0KICAgICAgICBuYW1lY2FsbEhvb2tlZCA9IHRydWUNCiAgICBlbmQpDQoNCiAgICBpZiBub3Qgc3VjY2VzcyB0aGVuDQogICAgICAgIGxvZyg=')hookmetamethod/__namecall hook failed: cRgOzXBohHOwJbIW('eRrGBvneyGzajbCxYHxVDEZLwmIjBSBzJypbwzcJDLYEVCioafoeoAlIC4uIHRvc3RyaW5nKGVyciksIA==')errorcRgOzXBohHOwJbIW('aGjJEzDJFdbyOKmakRHjghWIDtJbkkMEmDiEbVeHyQelMnaSPwkekXpKQ0KICAgICAgICByZXR1cm4gZmFsc2UNCiAgICBlbmQNCiAgICBsb2co')Namecall hook installed.cRgOzXBohHOwJbIW('cBvLpEmFjXTNbVFCpGydlrwIsYxgrlMIvhWyQwanxMIqnrWyPGxkTnyLCA=')infocRgOzXBohHOwJbIW('oHsDoiyDZEaKFQrmksFBUvWQbPbNlmghKYCQqXCAqWpZLtsYoMkRKkQKQ0KICAgIHJldHVybiB0cnVlDQplbmQNCg0KLS0gc3RvcmUgb3JpZ2luYWxzIGZvciByZWFwcGxpY2F0aW9uDQpsb2NhbCBvcmlnaW5hbEhvb2tzID0ge30NCg0KLS0gSG9vayBGaXJlU2VydmVyIC8gSW52b2tlU2VydmVyIGZvciBhIHNpbmdsZSByZW1vdGUNCmxvY2FsIGZ1bmN0aW9uIGhvb2tSZW1vdGUocmVtb3RlKQ0KICAgIGlmIG5vdCByZW1vdGUgb3Igbm90IHJlbW90ZTpJc0Eo')InstancecRgOzXBohHOwJbIW('rXMaGGeBvajfpDVwYBSqnFJophPOxcNzSolJOJrurgitmnKItzdnNQHKSB0aGVuIHJldHVybiBmYWxzZSBlbmQNCiAgICBpZiBibG9ja2VkW3JlbW90ZV0gdGhlbiByZXR1cm4gdHJ1ZSBlbmQNCg0KICAgIGxvY2FsIG9rID0gdHJ1ZQ0KICAgIGxvY2FsIG9yaWdpbmFscyA9IHt9DQoNCiAgICAtLSBIb29rIEZpcmVTZXJ2ZXIgKFJlbW90ZUV2ZW50KQ0KICAgIGlmIHJlbW90ZTpJc0Eo')RemoteEventcRgOzXBohHOwJbIW('DmBZyDJKYglaVWNiBYZLhilaDnxrZiMlVjEPbMueqKhvfDScFkwlBKuKSB0aGVuDQogICAgICAgIGlmIGhhc0hvb2tGdW5jdGlvbiB0aGVuDQogICAgICAgICAgICBsb2NhbCBzdWNjZXNzLCByZXMgPSBwY2FsbChmdW5jdGlvbigpDQogICAgICAgICAgICAgICAgb3JpZ2luYWxzLkZpcmVTZXJ2ZXIgPSBob29rZnVuY3Rpb24ocmVtb3RlLkZpcmVTZXJ2ZXIsIGZ1bmN0aW9uKHNlbGYsIC4uLikNCiAgICAgICAgICAgICAgICAgICAgLS0gYmxvY2sgYW5kIHJlcG9ydA0KICAgICAgICAgICAgICAgICAgICBzdGF0dXMgPSA=')bypasscRgOzXBohHOwJbIW('ZFKegMCfruriDoHPgceGtAoklYMcNhpEaJjWoSefkzlheYTmbebbNkeDQogICAgICAgICAgICAgICAgICAgIFJlbW90ZUd1YXJkLk9uUmVtb3RlVHJpZ2dlcmVkOkZpcmUocmVtb3RlLk5hbWUpDQogICAgICAgICAgICAgICAgICAgIGd1aVJlY29yZFRyaWdnZXIocmVtb3RlLk5hbWUpDQogICAgICAgICAgICAgICAgICAgIC0tIGRvbg==')t forward
                    return nil
                end)
            end)
            if not success then
                ok = false
                log(cRgOzXBohHOwJbIW('HFSIfVXXVvfjNgVZoIuOonEcTgjQfhaUfaqdxWQwGKuORODgxgFkQbqRmFpbGVkIHRvIGhvb2sgRmlyZVNlcnZlciBmb3Ig')..tostring(remote.Name)..cRgOzXBohHOwJbIW('KqYGSodXWrJQOFhehLiPYRejdNyGoCoITRdwKQCRznfWsjnHXpfLjmgIDog')..tostring(res), cRgOzXBohHOwJbIW('IRsBrEvQhldpEdjZAcbfvcmjZCwIlxUBDwGTKbLAKkoTcnFGspCklPbZXJyb3I='))
            end
        else
            -- no hookfunction available; try to wrap via metamethod after install
            ok = ok and true
        end
    end

    -- Hook InvokeServer (RemoteFunction)
    if remote:IsA(cRgOzXBohHOwJbIW('gDgeovnLIoAaoPkCJReIMloIazJOmaGdepiiqoYCyMvwxdctiwgyJKnUmVtb3RlRnVuY3Rpb24=')) then
        if hasHookFunction then
            local success, res = pcall(function()
                originals.InvokeServer = hookfunction(remote.InvokeServer, function(self, ...)
                    -- block and report
                    status = cRgOzXBohHOwJbIW('oiFOYLhKDPcilVBFQcSoTjgpXAKExHIEntiTxNcnFLowNfvrZOlYPJfYnlwYXNz')
                    RemoteGuard.OnRemoteTriggered:Fire(remote.Name)
                    guiRecordTrigger(remote.Name)
                    return nil
                end)
            end)
            if not success then
                ok = false
                log(cRgOzXBohHOwJbIW('XjDszUpcjSFNJbTAClgWHNBTyRLUKibijybNhDlSEYVxNvmCwnRFcUORmFpbGVkIHRvIGhvb2sgSW52b2tlU2VydmVyIGZvciA=')..tostring(remote.Name)..cRgOzXBohHOwJbIW('dZiirvnayGGzmsbLJlxRrpkLPiGjHFCcwWWNTbuJpwdokcqSZYqJpYyIDog')..tostring(res), cRgOzXBohHOwJbIW('ZcpURoDwTebDchUKBoptzlGHduSGBrgEtMMkRjbbNydPkddfsnkiDNmZXJyb3I='))
            end
        else
            ok = ok and true
        end
    end

    blocked[remote] = originals
    originalHooks[remote] = originals
    if ok then
        guiAddBlocked(remote.Name)
        table.insert(RemoteGuard.Logs or {}, {Time=os.time(), Action=cRgOzXBohHOwJbIW('fTVHKZbudGuVBNGBZPUqnxcGpYHzfZiYtdCFMKYvBiSEVhfbXKqLUwWQmxvY2tlZA=='), Remote=remote.Name})
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
    log(cRgOzXBohHOwJbIW('afaePYeUIoWrqoJPoUmWjJQRhgffKyokGgEUUBUyJTwyePdIyHvUNofUmVhcHBseUhvb2tzIGV4ZWN1dGVkLg=='), cRgOzXBohHOwJbIW('eWiBTKLvXZVCQblqakMTxurfeuXHkEUEpojshkgSdcRerGpBXsopkgWaW5mbw=='))
end

-- Public: Scan and hook all gift remotes
function RemoteGuard:ScanAndBlock()
    local found = 0
    local all = ReplicatedStorage:GetDescendants()
    for _, inst in ipairs(all) do
        if (inst:IsA(cRgOzXBohHOwJbIW('YZDZRSxmWfpeTjEammdzaawDaKevWNhizzAKLvuOBPaQDokTMfOvXKNUmVtb3RlRXZlbnQ=')) or inst:IsA(cRgOzXBohHOwJbIW('qwsZsrvZsPWKLoIlEcgBudfFjApYIHSskytnHsHfhzXEDLIUOenoZifUmVtb3RlRnVuY3Rpb24='))) and isGiftRemote(inst) then
            found = found + 1
            pcall(function() hookRemote(inst) end)
        end
    end
    if found > 0 then
        status = cRgOzXBohHOwJbIW('dOelwGnPPqtqppTLQbpaufrHlfXdMuQaFUZDfPNnSiBzycphJXCxoNkc2FmZQ==')
        log(cRgOzXBohHOwJbIW('XuxWLuEoFDibIFMNbBTQjQliYtYXFbGaYGbPIdBMZQZUKJGOVcxBbgJU2NhbkFuZEJsb2NrOiBibG9ja2VkIA==')..tostring(found)..cRgOzXBohHOwJbIW('KksxIZWvlCVPbxnhDvVQPksFbJRwrqtIJOiIoYEivtmywugBRDzxpokIHJlbW90ZXMu'), cRgOzXBohHOwJbIW('JWFanFShoQulcvvvabyotHJFvjXqPOYXjCQtlpRHFVpmhbpPAyuhrTOaW5mbw=='))
    else
        status = cRgOzXBohHOwJbIW('WNHRlvOaDaRRERFZiKLeiGdHRuTrHPuqVMcoQaCzGAHNILpTshRawKZZGFuZ2Vy')
        log(cRgOzXBohHOwJbIW('DnMlPVVFpfHPUilUAgFNuJgaMPCwByfIVvqoJnOgVIUeSUpWMhPWCiWU2NhbkFuZEJsb2NrOiBubyBnaWZ0IHJlbW90ZXMgZm91bmQu'), cRgOzXBohHOwJbIW('BItTDCOUjiVWPckpCEtsTQlGbbDgwIRiDsOZmivkmPxISmMAvMTBcoud2Fybg=='))
    end
    return found
end

-- Monitor new remotes added at runtime and auto-block
function RemoteGuard:MonitorNewRemotes()
    ReplicatedStorage.DescendantAdded:Connect(function(inst)
        if (inst:IsA(cRgOzXBohHOwJbIW('jbQufCwvXiIAWobFmxLBWruQEFzTpwJLzTOSQRYGuJytYwypxeThikYUmVtb3RlRXZlbnQ=')) or inst:IsA(cRgOzXBohHOwJbIW('BkxQCVgQpBUnZoKgEUKScPohbLUbbIxZPXnztdHYskTMQlWKVkmtznlUmVtb3RlRnVuY3Rpb24='))) and isGiftRemote(inst) then
            pcall(function()
                hookRemote(inst)
                log(cRgOzXBohHOwJbIW('qWSiNRUAQYoXlhuxogOaynmkcYcqWuydaeWGHbhWsOwShhlVfTOKvJLTW9uaXRvck5ld1JlbW90ZXM6IGJsb2NrZWQgbmV3IHJlbW90ZTog')..tostring(inst.Name), cRgOzXBohHOwJbIW('noeqYsKmRBhaIVuKqcvygwuzSitdQZJAaqlrKkIbvxXFGEtDNUeNSUcaW5mbw=='))
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
    log(cRgOzXBohHOwJbIW('rFGpiFaETtixChRCUxTdyDvSJmKmOGAgYvcuoGHHIMEueoObjjpknJXVW5ob29rQWxsIGV4ZWN1dGVkLg=='), cRgOzXBohHOwJbIW('ZvBmmfjSxYsrQTAYeIXXoBdZyovvMAzDAxxaMKerqTFjUZRicFqalxjaW5mbw=='))
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
    if opts.Config and opts.Config.DetectionPatterns and type(opts.Config.DetectionPatterns) == cRgOzXBohHOwJbIW('wLVrISLnjVlKEoHHoBucQMInBTKvTOgORNXJbOQzgwcgixqXgqcpJbidGFibGU=') then
        patterns = opts.Config.DetectionPatterns
    end
end

-- Lightweight health-check for TamperProtection to call
function RemoteGuard:HealthCheck()
    -- ensure that hooks are still in place (best-effort): check blocked remotescRgOzXBohHOwJbIW('lIgxqiDGlVakqATISWPWGAQZOINtaodmHxapGFLuRPOtbVmmEjskrFzIEZpcmVTZXJ2ZXIvSW52b2tlU2VydmVyIGFyZSBmdW5jdGlvbnMNCiAgICBmb3IgcmVtb3RlLCBvbGRzIGluIHBhaXJzKGJsb2NrZWQpIGRvDQogICAgICAgIGlmIG5vdCByZW1vdGUgb3Igbm90IHJlbW90ZS5QYXJlbnQgdGhlbg0KICAgICAgICAgICAgbG9nKA==')HealthCheck: protected remote missing: cRgOzXBohHOwJbIW('JyOhiCBSNNwpjiBIldRmYGKChPcUfVzBrELmmpZvWVYDYnUhZahqTxtLi50b3N0cmluZyhyZW1vdGUpLCA=')alert')
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
    
