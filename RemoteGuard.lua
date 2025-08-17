local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function ZRDMiIXnRPEhsZxhYUubViHxJVJeoc(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- RemoteGuard.lua (Robust)
-- Scans for ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('FllSVkccZQFbyVErXJxWEDNXUNANJgtGrQBXNmisxAvbDohLgUQjDfNZ2lmdA==')-like remotes and attempts safe client-side wrapping to prevent local exploit scripts
-- Notes:
--  * This module is executor-safe: it avoids exploit-only APIs (no hookfunction, no hookmetamethod)
--  * It attempts to overwrite RemoteEvent.FireServer and RemoteFunction.InvokeServer where possible.
--  * If the environment prevents overwriting, the module will mark that remote as ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('XOzCjmXSomuetjBJrgYylvKVpnqiauTBESNYtkzfwacHKSlboaTGXxydW5ibG9ja2Vk') and log a warning.
--  * Best-effort: continuous re-application and health checks.

local ReplicatedStorage = game:GetService(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('HOfuQgpLprfXDllMCKtyGPWcdGHRfbpCzwwyYZbjkpMeWJERqMpdQGPUmVwbGljYXRlZFN0b3JhZ2U='))
local RunService = game:GetService(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('otVSebNmjmqsBczgiSdRiMJeNYrzSWLoIsrJDmyZwRFjuHFHkKMVeKuUnVuU2VydmljZQ=='))
local Players = game:GetService(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('lHqiARleUHEMXjginbkPsQcIFdMXHtnIyVKWHPMeHYqpNPBBqwkPPNeUGxheWVycw=='))
local LocalPlayer = Players.LocalPlayer

local RemoteGuard = {}
RemoteGuard.__index = RemoteGuard

-- Public Bindable for external reaction
RemoteGuard.OnRemoteTriggered = Instance.new(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('BIZNXgWYMTkchOElRiTeZBIBLyZURrzYQBkIAbKrTomkbftYwTVkqrKQmluZGFibGVFdmVudA=='))

-- Internal state
local _wrapped = {}          -- [remote] = {type = ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('LHYDbxEIZgTxKRvGkpzlVkcATbMtinZmYdXMQIZYMSYqrQzCrTodzPZZXZlbnQ=')/ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('IBhEKMFqwhflhxfcRtgomcdmwMxqBOlxjZvKgHfdstBxCmLSnppnCxoZnVuYw=='), original = originalFunction, wrapper = wrapperFunction}
local _blockedNames = {}     -- array of remote names (for GUI)
local _patterns = {ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('cTydnIiJnEBqzLVDSHZTyCJgKlJFPDhLQAadbEbPtZYvGZsNytlrAdVZ2lmdA=='),ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('nCPDnOvtJxYnNHmwnGMGqnpRmbmtVsURhJGwcBIphlyAuBiJGBfIdijZ2l2ZQ=='),ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('ybIglQZctmKPVpthzRIsHaTSjoxuzIMCeWcVLFpdMmaqweIXYqnpZJaZ2lmdGluZw=='),ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('WmTqaxiwfCLvOAOsHwcwmQEbAowDwQJYFnDqcmBYxpvKCGUUXPxCJuqZ2lmdHRv'),ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('xMcHtGTXeRNXKjJYtNBcOsMBNSfMFssduKpxnLwfnKKGFBASvxADiNlZ2lmdF9wZXQ=')}
local _logger = nil
local _guimgr = nil
local _config = {
    ReapplyInterval = 8,     -- seconds between reapply attempts
    HealthCheckInterval = 10,
}
local _status = ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('MNNrxIKPuCYhwAqdQaAEcuvnhLVQxxyRQwtNDntsXNfPDDByOGZVgapdW5rbm93bg==')  -- safe, warn, danger, bypass, unknown

-- Utils
local function safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

local function log(msg, level)
    level = level or ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('exQQgxMfwkXENTsTLwGhkmMPtCOwCvCYElApThhGmcquuewrYpirmrNaW5mbw==')
    if _logger and type(_logger.AddEntry) == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('pqlrHNMoSkIWXxhDXKiMFBYiEmHkzPemHSksKjDfFOkIlkGvWuuuGNrZnVuY3Rpb24=') then
        pcall(function() _logger:AddEntry(msg, level) end)
    else
        if level == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('LsUOdJTJqtLywlWgOXhVDzAgLCBscCinLdiuqNMKdaIaTgLBApopFVoYWxlcnQ=') or level == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('tAHmztUlRxryjtzFiakzHPtxAeiGUJlOYhmvrspCANtlBqpqpBixDZvZXJyb3I=') then
            pcall(function() warn(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('pzZaaHgcCIdksKhxsmMbxzUbfdPIisOWortieexUmjRLtyijTRqmemDW1JlbW90ZUd1YXJkXSA=')..tostring(msg)) end)
        end
    end
    if _guimgr and type(_guimgr.AddLogEntry) == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('NtopljBmuesRNhKsNemzAEtexTdEXBESXPEBwoIyTnbEKZmlYGEPywUZnVuY3Rpb24=') then
        pcall(function() _guimgr:AddLogEntry(msg, level) end)
    end
end

local function guiAddBlocked(name)
    if _guimgr and type(_guimgr.AddBlockedRemote) == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('SmAEumZfDIOjYcKplDXwscgzOndtVNElErqIbBcSxugabJkApSTGUuEZnVuY3Rpb24=') then
        pcall(function() _guimgr:AddBlockedRemote(name) end)
    end
end

local function guiRecordTrigger(name)
    if _guimgr and type(_guimgr.RecordTrigger) == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('PeLJpLCaBxFxHRjGdsCwCPwVJsOacVKaliPfDcQTGQdTkrDyuaQQhUHZnVuY3Rpb24=') then
        pcall(function() _guimgr:RecordTrigger(name) end)
    end
end

-- detection
local function isGiftRemote(inst)
    if not inst or not inst.Name then return false end
    local n = tostring(inst.Name):lower()
    for _, pat in ipairs(_patterns) do
        if type(pat) == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('kWYpSBIIIgTswfgWtqNoLyFPDJbYLbUfrYhaYgxzZDoEvGcGvgsIcnSc3RyaW5n') and n:find(pat, 1, true) then
            return true
        end
    end
    return false
end

-- Safe wrapper creators
local function makeEventWrapper(remote)
    -- wrapper blocks any calls coming from other local scripts that try to call remote:FireServer
    local name = tostring(remote.Name)
    local function wrapper(...)
        -- When wrapper is invoked, we treat it as a triggering attempt and block it
        log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('vatRxtAehfgXnoqOhtOmDcpsfMXCmAMHMefCvGYXUzrpYyrbaIWcitAQmxvY2tlZCBGaXJlU2VydmVyIGNhbGwgb24gcmVtb3RlOiA=')..name, ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('hJfHRawkWRmEaDOZnzBgSwKMWjVUKCSwgEpdXzABOltbsOecFZBCxhgYWxlcnQ='))
        guiRecordTrigger(name)
        RemoteGuard.OnRemoteTriggered:Fire(name)
        -- do nothing (block)
        return nil
    end
    return wrapper
end

local function makeFunctionWrapper(remote)
    local name = tostring(remote.Name)
    local function wrapper(...)
        log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('almYhtmyKKclawqvLIZWZrpbpORmKJlNNbyyyVDeugSQCpRupzatxrbQmxvY2tlZCBJbnZva2VTZXJ2ZXIgY2FsbCBvbiByZW1vdGU6IA==')..name, ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('YdiJzriETKiXOjFaMdkgRbGyrnEQYmcUfTqWPzsgYVzlnOwlbYQFEYUYWxlcnQ='))
        guiRecordTrigger(name)
        RemoteGuard.OnRemoteTriggered:Fire(name)
        -- return nil or default safe value
        return nil
    end
    return wrapper
end

-- Attempt to safely overwrite remote functions. Returns true if wrapper applied.
local function tryWrapRemote(remote)
    if not remote or not remote.Parent then return false end
    if _wrapped[remote] then return true end

    local name = tostring(remote.Name)
    local success = false

    if remote:IsA(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('vNDKPcRhqvUbcDCdsukEZuBQvMfVfnPeellNWzrGUuFJNGqoHRmMOraUmVtb3RlRXZlbnQ=')) then
        -- try to store original and assign wrapper
        local ok, orig = pcall(function() return remote.FireServer end)
        local wrapper = makeEventWrapper(remote)
        -- try assignment
        local setOk, setRes = pcall(function() remote.FireServer = wrapper end)
        if setOk then
            _wrapped[remote] = { type = ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('eFyvDUKLCDkhOjNcmeWNHfzIzPnIHTpnQtfQnbAlkIPPzYZAtwjXwmaZXZlbnQ='), original = (ok and orig) or nil, wrapper = wrapper }
            table.insert(_blockedNames, 1, name)
            guiAddBlocked(name)
            log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('LpJpZwazlETyjBHCruvqlbeSvTyUQIfTjSbbcueUhiDSwwlUJqqxzcnV3JhcHBlZCBSZW1vdGVFdmVudCBGaXJlU2VydmVyOiA=')..name, ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('FEtDRpDwLBWRgZUptxahXaxAsDjTeKczzjrZsvCHpBhiFkGeRaeEjKLaW5mbw=='))
            success = true
        else
            -- assignment failed (read-only), log and mark as unwrapped
            log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('vnxDUuNFOEclNjRmmagmyhAIctAqCEUxvZPXJdVyiVPcsSdwSRNmfYWRmFpbGVkIHRvIGFzc2lnbiB3cmFwcGVyIHRvIFJlbW90ZUV2ZW50LkZpcmVTZXJ2ZXIgZm9yIA==')..name..ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('RBWTSxxPtBazrIpLwixRLHPxnYdbUZATAmRsvfQAEEFghKcExsROqfoIDog')..tostring(setRes), ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('zwlvfveowynEJloIeQnZHNAPTdoegirXrxkFUvEMQWRqrXbGYcOZwmSd2Fybg=='))
            success = false
        end
    elseif remote:IsA(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('lnPhNzfXOxbybiuTLSjXiJTfMcKIpurTJrMnlsBEvmCQNlliAHIaTVZUmVtb3RlRnVuY3Rpb24=')) then
        local ok, orig = pcall(function() return remote.InvokeServer end)
        local wrapper = makeFunctionWrapper(remote)
        local setOk, setRes = pcall(function() remote.InvokeServer = wrapper end)
        if setOk then
            _wrapped[remote] = { type = ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('ltlixbsbfZUMrGcrMKaRYSupUmIvIIkoasvxRcUvlTvygeLlHQSnXHPZnVuYw=='), original = (ok and orig) or nil, wrapper = wrapper }
            table.insert(_blockedNames, 1, name)
            guiAddBlocked(name)
            log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('PvgzLSWmPlwZIwkXqpsOzTqdtwQsYMjCswNAiRObouSFaBeJGkFtGEoV3JhcHBlZCBSZW1vdGVGdW5jdGlvbiBJbnZva2VTZXJ2ZXI6IA==')..name, ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('QMHlZqsERatenFcHlkQwPjbwmKATHCtATVOaubSKavzWSdKajBepyuEaW5mbw=='))
            success = true
        else
            log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('druIYseyGYnEFsOWDSenRlDtXPEUZjhpiStEFtEHpmpeANCIgKqYDMdRmFpbGVkIHRvIGFzc2lnbiB3cmFwcGVyIHRvIFJlbW90ZUZ1bmN0aW9uLkludm9rZVNlcnZlciBmb3Ig')..name..ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('YzicTzQIobYZXHaZNanrACTNDOLFblfBBAdQtSREBiSKnaQopDJDDanIDog')..tostring(setRes), ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('KPdgcxtYQxTWyXkrwIntgXWescABUNAxraMQkzNzYsohTNURaRwNwOzd2Fybg=='))
            success = false
        end
    end

    return success
end

-- Scan storage and attempt to wrap all gift-like remotes
function RemoteGuard:ScanAndBlock()
    local found = 0
    for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
        if (inst:IsA(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('NFTAIHdVdaFxpdojtJJFAwBUckcQkYVGIBFmWXQlYfHONotvTgobvCQUmVtb3RlRXZlbnQ=')) or inst:IsA(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('YuUFfGLyJAaoWVRLBcCVmSSQRydEBTnewuTeBGHhyjqDbsCHSIcbFmNUmVtb3RlRnVuY3Rpb24='))) and isGiftRemote(inst) then
            found = found + 1
            pcall(function() tryWrapRemote(inst) end)
        end
    end
    if found > 0 then
        _status = ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('jAmZMYtjtwrmtwLiFdfkGgTAdvIRDkhiSwXMrBJqyoeuqYnZBnBVdZVc2FmZQ==')
    else
        _status = ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('CcqJRQslgRyEarHPCNSWmDybkitEQPdGwACqFFWftuFVZdvcOlwmgNwZGFuZ2Vy')
    end
    log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('xHQzWLmaMRzDOIkWtejWyUbvuSzwOUDVTcHOEdyHWFgHSLeFRPCumAfU2NhbkFuZEJsb2NrIGNvbXBsZXRlZC4gRm91bmQ6IA==')..tostring(found), ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('bYdGawMXESpIXXLrsJxgfMeFHfvdNPNgYVvtRaKcLwSYhMUzgvOIvBXaW5mbw=='))
    return found
end

-- Monitor newly added remotes and wrap them
function RemoteGuard:MonitorNewRemotes()
    ReplicatedStorage.DescendantAdded:Connect(function(inst)
        if (inst:IsA(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('BTQnPvAdfcOIHeAbBvlmTZrKbqgjvCmIfhLCuBQzvSHkeyYdtExLkoAUmVtb3RlRXZlbnQ=')) or inst:IsA(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('xEBvAYbVuAZiiJOIrZxSVlSIWCOVDyvGfHkzGnyDeFWwgkMHVZVsHghUmVtb3RlRnVuY3Rpb24='))) and isGiftRemote(inst) then
            pcall(function()
                local ok = tryWrapRemote(inst)
                if ok then log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('NhgwxNOJKdRbFCuJIpIWRlcDxocyNozVFKUgUtZaKTEBUwZtBObSelXTW9uaXRvcjogd3JhcHBlZCBuZXcgcmVtb3RlOiA=')..tostring(inst.Name), ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('BUmGLgSKGDymLKXOJrBbnyTxggOGoMaquYlWgNEmeCIQoxDFCdSYIRIaW5mbw==')) end
            end)
        end
    end)
end

-- Reapply wrappers for remotes previously wrapped or found
function RemoteGuard:ReapplyHooks()
    for remote, meta in pairs(_wrapped) do
        -- if remote lost wrapper (maybe overwritten), try to reapply
        if remote and remote.Parent then
            local good = false
            pcall(function()
                if meta.type == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('oFCZFuSClQmwgXNafkeuofaWiLjjCzTlKsaULsHwBSkgXLAKWEUOztBZXZlbnQ=') then
                    good = (remote.FireServer == meta.wrapper)
                    if not good then
                        -- try to reassign
                        pcall(function() remote.FireServer = meta.wrapper end)
                        good = (remote.FireServer == meta.wrapper)
                    end
                elseif meta.type == ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('PErMCPgJNpfxtCdUJNMivhBQFTjxNCMNNKYJKJkAoDslStNLSfbqUYNZnVuYw==') then
                    good = (remote.InvokeServer == meta.wrapper)
                    if not good then
                        pcall(function() remote.InvokeServer = meta.wrapper end)
                        good = (remote.InvokeServer == meta.wrapper)
                    end
                end
            end)
            if not good then
                log(ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('UYcnpWRzcTLFAoKCSGcIcIPwgDmtokKrjRsWZWpaRwEWKlTzPyfZDnkUmVhcHBseUhvb2tzOiBjb3VsZCBub3QgZW5zdXJlIHdyYXBwZXIgb24g')..tostring(remote.Name), ZRDMiIXnRPEhsZxhYUubViHxJVJeoc('CZGNwflaxwRYUfqPUIXExPREBPDppDeXTEQvBdiNqgyWsoNRsPYBDDnd2Fybg=='))
            end
        end
    end
end

-- Health check: verify wrappers still in place and track unwrapped remotes
function RemoteGuard:HealthCheck()
    -- If any gift remotes exist that we couldnZRDMiIXnRPEhsZxhYUubViHxJVJeoc('krJuDxLeekIkDkXjZomUStLmQjVzFOxzATSKmafUffORPbjkGHtXPxTdCB3cmFwLCBzZXQgc3RhdHVzIHRvIHdhcm4vZGFuZ2VyDQogICAgbG9jYWwgdW53cmFwcGVkID0gZmFsc2UNCiAgICBsb2NhbCB0b3RhbEZvdW5kID0gMA0KICAgIGZvciBfLCBpbnN0IGluIGlwYWlycyhSZXBsaWNhdGVkU3RvcmFnZTpHZXREZXNjZW5kYW50cygpKSBkbw0KICAgICAgICBpZiAoaW5zdDpJc0Eo')RemoteEventZRDMiIXnRPEhsZxhYUubViHxJVJeoc('hKBubFwgjbkbAJDqkRwNBaXBAMYmwvpeTXshGkSFrqmFFHUWIMRdgeaKSBvciBpbnN0OklzQSg=')RemoteFunctionZRDMiIXnRPEhsZxhYUubViHxJVJeoc('YoukCEXcgSbmtSmanwExZOeCcKeqVurOvWDYzLtoyMPyIzNlUjYMJFBKSkgYW5kIGlzR2lmdFJlbW90ZShpbnN0KSB0aGVuDQogICAgICAgICAgICB0b3RhbEZvdW5kID0gdG90YWxGb3VuZCArIDENCiAgICAgICAgICAgIGxvY2FsIHdyYXBwZWRJbmZvID0gX3dyYXBwZWRbaW5zdF0NCiAgICAgICAgICAgIGlmIG5vdCB3cmFwcGVkSW5mbyB0aGVuDQogICAgICAgICAgICAgICAgdW53cmFwcGVkID0gdHJ1ZQ0KICAgICAgICAgICAgZWxzZQ0KICAgICAgICAgICAgICAgIC0tIGNoZWNrIHdyYXBwZXIgc3RpbGwgcHJlc2VudA0KICAgICAgICAgICAgICAgIGxvY2FsIG9rLCBpc0dvb2QgPSBwY2FsbChmdW5jdGlvbigpDQogICAgICAgICAgICAgICAgICAgIGlmIHdyYXBwZWRJbmZvLnR5cGUgPT0g')eventZRDMiIXnRPEhsZxhYUubViHxJVJeoc('eTgTvizhUcfqsbOhxJAwyrMFOXoYKMaJeojwlIjhDKoypiLDHyXjqWxIHRoZW4gcmV0dXJuIGluc3QuRmlyZVNlcnZlciA9PSB3cmFwcGVkSW5mby53cmFwcGVyIGVuZA0KICAgICAgICAgICAgICAgICAgICBpZiB3cmFwcGVkSW5mby50eXBlID09IA==')funcZRDMiIXnRPEhsZxhYUubViHxJVJeoc('edahEyIbwbULJhtiRvulYNmCFaQObQztRFlqkxeZbTKbOJGMmcqKVlKIHRoZW4gcmV0dXJuIGluc3QuSW52b2tlU2VydmVyID09IHdyYXBwZWRJbmZvLndyYXBwZXIgZW5kDQogICAgICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZQ0KICAgICAgICAgICAgICAgIGVuZCkNCiAgICAgICAgICAgICAgICBpZiBub3Qgb2sgb3Igbm90IGlzR29vZCB0aGVuDQogICAgICAgICAgICAgICAgICAgIHVud3JhcHBlZCA9IHRydWUNCiAgICAgICAgICAgICAgICBlbmQNCiAgICAgICAgICAgIGVuZA0KICAgICAgICBlbmQNCiAgICBlbmQNCg0KICAgIGlmIHRvdGFsRm91bmQgPT0gMCB0aGVuDQogICAgICAgIF9zdGF0dXMgPSA=')dangerZRDMiIXnRPEhsZxhYUubViHxJVJeoc('AnVVvtMLhvZqGbOgKUcTnpPNzJDJpvxQpIUEcBCAfjlhnzLYSkEyYTpIC0tIG5vIGdpZnQgcmVtb3RlcyAobWF5YmUgc2FmZSkgYnV0IHBlciBlYXJsaWVyIGxvZ2ljIGRhbmdlcjsga2VlcCBjb25zaXN0ZW50DQogICAgZWxzZWlmIHVud3JhcHBlZCB0aGVuDQogICAgICAgIF9zdGF0dXMgPSA=')warnZRDMiIXnRPEhsZxhYUubViHxJVJeoc('NHRYbymvQAPOsdGXCWTFaMlcaiUOxOluQjFHgcWwGoqfWuURtshfbDfDQogICAgZWxzZQ0KICAgICAgICBfc3RhdHVzID0g')safeZRDMiIXnRPEhsZxhYUubViHxJVJeoc('MDbRzYsKDvqPSTpzMXyWGBVyyoOUJvbWGfUDsMAoFDqHwGrfxGfTfqDDQogICAgZW5kDQogICAgcmV0dXJuIG5vdCB1bndyYXBwZWQNCmVuZA0KDQotLSBHZXR0ZXJzDQpmdW5jdGlvbiBSZW1vdGVHdWFyZDpHZXRTdGF0dXMoKQ0KICAgIHJldHVybiBfc3RhdHVzDQplbmQNCg0KZnVuY3Rpb24gUmVtb3RlR3VhcmQ6R2V0QmxvY2tlZExpc3QoKQ0KICAgIGxvY2FsIGxpc3QgPSB7fQ0KICAgIGZvciBfLCBuYW1lIGluIGlwYWlycyhfYmxvY2tlZE5hbWVzKSBkbyB0YWJsZS5pbnNlcnQobGlzdCwgbmFtZSkgZW5kDQogICAgcmV0dXJuIGxpc3QNCmVuZA0KDQotLSBMaW5rIGV4dGVybmFsIG1vZHVsZXMgKEdVSU1hbmFnZXIsIExvZ2dlciwgQ29uZmlnKQ0KZnVuY3Rpb24gUmVtb3RlR3VhcmQ6TGlua01vZHVsZXMob3B0cykNCiAgICBpZiBub3Qgb3B0cyBvciB0eXBlKG9wdHMpIH49IA==')tableZRDMiIXnRPEhsZxhYUubViHxJVJeoc('rDsRBXKoqrOTWiJyvKbyegbiTdwhyWYzHYkENlwOvNLZWrAfFPmxhhQIHRoZW4gcmV0dXJuIGVuZA0KICAgIGlmIG9wdHMuTG9nZ2VyIHRoZW4gX2xvZ2dlciA9IG9wdHMuTG9nZ2VyIGVuZA0KICAgIGlmIG9wdHMuR1VJTWFuYWdlciB0aGVuIF9ndWltZ3IgPSBvcHRzLkdVSU1hbmFnZXIgZW5kDQogICAgaWYgb3B0cy5Db25maWcgYW5kIHR5cGUob3B0cy5Db25maWcpID09IA==')tableZRDMiIXnRPEhsZxhYUubViHxJVJeoc('xWfZWfXFJgcCMAFwKmWoSIdhCxxvxghUjHDJFAVFNgsDhaXFQzOwTHZIHRoZW4NCiAgICAgICAgZm9yIGssdiBpbiBwYWlycyhvcHRzLkNvbmZpZykgZG8gX2NvbmZpZ1trXSA9IHYgZW5kDQogICAgICAgIGlmIG9wdHMuQ29uZmlnLkRldGVjdGlvblBhdHRlcm5zIGFuZCB0eXBlKG9wdHMuQ29uZmlnLkRldGVjdGlvblBhdHRlcm5zKSA9PSA=')tableZRDMiIXnRPEhsZxhYUubViHxJVJeoc('nqyRsvZGGmXNoRiacDIwHhmLJBFDCsvjQjVSSgLGqGzYTsQbpcWljnOIHRoZW4NCiAgICAgICAgICAgIF9wYXR0ZXJucyA9IG9wdHMuQ29uZmlnLkRldGVjdGlvblBhdHRlcm5zDQogICAgICAgIGVuZA0KICAgIGVuZA0KICAgIGxvZyg=')RemoteGuard linked with external modulesZRDMiIXnRPEhsZxhYUubViHxJVJeoc('HdQGgxhmAzuxQTVZzOtCStPAEmHpaJGXQToPbBswstIPrywvvEYfUbcLCA=')infoZRDMiIXnRPEhsZxhYUubViHxJVJeoc('IGOqkqLFrSqrOLABHREugViJFFtVTasFciEFBeWURuRQrTdmkqjJIkDKQ0KZW5kDQoNCi0tIFBlcmlvZGljIHJlYXBwbHkgYW5kIGhlYWx0aCBjaGVjayBsb29wcyAoc3RhcnQgd2hlbiBtb2R1bGUgcmVxdWlyZWQpDQpzcGF3bihmdW5jdGlvbigpDQogICAgd2hpbGUgdHJ1ZSBkbw0KICAgICAgICBwY2FsbChmdW5jdGlvbigpDQogICAgICAgICAgICBSZW1vdGVHdWFyZDpSZWFwcGx5SG9va3MoKQ0KICAgICAgICBlbmQpDQogICAgICAgIHRhc2sud2FpdChfY29uZmlnLlJlYXBwbHlJbnRlcnZhbCBvciA4KQ0KICAgIGVuZA0KZW5kKQ0KDQpzcGF3bihmdW5jdGlvbigpDQogICAgd2hpbGUgdHJ1ZSBkbw0KICAgICAgICBsb2NhbCBvayA9IHRydWUNCiAgICAgICAgcGNhbGwoZnVuY3Rpb24oKSBvayA9IFJlbW90ZUd1YXJkOkhlYWx0aENoZWNrKCkgZW5kKQ0KICAgICAgICBpZiBub3Qgb2sgdGhlbg0KICAgICAgICAgICAgbG9nKA==')HealthCheck failed: some remotes unwrapped or missing wrapperZRDMiIXnRPEhsZxhYUubViHxJVJeoc('QLKpjEAHsmYMWAUIDLZsJGQGzBjLLFjUjIyGuTXuQMLLtcohgWhudkBLCA=')warn')
        end
        task.wait(_config.HealthCheckInterval or 10)
    end
end)

-- Export
RemoteGuard.GetStatus = RemoteGuard.GetStatus
RemoteGuard.ScanAndBlock = RemoteGuard.ScanAndBlock
RemoteGuard.MonitorNewRemotes = RemoteGuard.MonitorNewRemotes
RemoteGuard.ReapplyHooks = RemoteGuard.ReapplyHooks
RemoteGuard.GetBlockedList = RemoteGuard.GetBlockedList
RemoteGuard.LinkModules = RemoteGuard.LinkModules
RemoteGuard.HealthCheck = RemoteGuard.HealthCheck

return RemoteGuard
    
