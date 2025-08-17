local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- RemoteGuard.lua
-- Detects and blocks all gift-related remotes safely

local Players = game:GetService(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('TxQNZYrIVGRkqKcssWDYhSBpqzXvtxZEdojCeVKipbUiSBpFYQpXKNrUGxheWVycw=='))
local ReplicatedStorage = game:GetService(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('CNMzUBlkwAXdrSfxMrkNquTHUxatPWbJTrJNnDWkoialCpVXlkGWISNUmVwbGljYXRlZFN0b3JhZ2U='))
local RunService = game:GetService(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('VtgBYjsEgYbCdhJrVVUkUGnzNkGGSYEWKBDsgguJoRtdVHdGqqslSsVUnVuU2VydmljZQ=='))
local LocalPlayer = Players.LocalPlayer

local RemoteGuard = {}
RemoteGuard.__index = RemoteGuard

-- Internal state
local _blockedRemotes = {}
local _vulnerableRemotes = {}
local _watchConnections = {}
local _initialized = false
local _logger = nil
local _gui = nil
local _config = {
    ScanInterval = 10, -- seconds
    RemoteNameKeyword = CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('lrGxNugquPAGwMQSDSZaogKYyIqLyAixeQVJXrVrVEhHJbpGoBCvWPMZ2lmdA=='), -- case-insensitive
}

-- BindableEvent for triggers
RemoteGuard.OnRemoteTriggered = Instance.new(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('sUHqLHDwywlEJXcdFAUEBoDOqSrbHyZBAlcZdCNsslYmbJUHbnBMTxtQmluZGFibGVFdmVudA=='))

-- Helper
local function safeCall(fn,...)
    local ok,res = pcall(fn,...)
    return ok,res
end

local function isGiftRemote(remote)
    if not remote or not remote.Name then return false end
    return string.find(string.lower(remote.Name), string.lower(_config.RemoteNameKeyword)) ~= nil
end

local function blockRemote(remote)
    if not remote then return end
    if _blockedRemotes[remote] then return end
    if remote:IsA(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('owGXoKFGVEsUhXKrLemccChLdUQmRhdtJCFrxJWbNkMnagRnOPUHKihUmVtb3RlRXZlbnQ=')) then
        local oldFire = remote.FireServer
        remote.FireServer = function(self,...)
            RemoteGuard.OnRemoteTriggered:Fire(self.Name)
            return nil
        end
    elseif remote:IsA(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('JXgiNVOSJNubMVmWGCFEVYBJkRaMrkEfByDQGVSzPZBskEMTglmSurjUmVtb3RlRnVuY3Rpb24=')) then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = function(self,...)
            RemoteGuard.OnRemoteTriggered:Fire(self.Name)
            return nil
        end
    end
    _blockedRemotes[remote] = true
end

local function scanAllRemotes()
    local allRemotes = {}
    for _,inst in pairs(ReplicatedStorage:GetDescendants()) do
        if (inst:IsA(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('bgagTQfUeMStIJSbwnRllMDqmhGqSuSSzaDFtASwuWCvLZFGtNNdCVOUmVtb3RlRXZlbnQ=')) or inst:IsA(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('TDRgRZKJYJLPUIVafEEBAXdtObHTGupcMUAlCsbBsgInKVvRwjukdcGUmVtb3RlRnVuY3Rpb24='))) and isGiftRemote(inst) then
            table.insert(allRemotes,inst)
        end
    end
    for _,r in ipairs(allRemotes) do
        blockRemote(r)
    end
end

-- Periodic scan for new remotes
local function periodicScan()
    while _initialized do
        scanAllRemotes()
        task.wait(_config.ScanInterval)
    end
end

-- API functions
function RemoteGuard:IsAllBlocked()
    return next(_vulnerableRemotes) == nil
end

function RemoteGuard:IsVulnerable()
    return next(_vulnerableRemotes) ~= nil
end

function RemoteGuard:Initialize(opts)
    if _initialized then return end
    _initialized = true
    if opts then
        _logger = opts.Logger
        _gui = opts.GUIManager
        if opts.Config then
            for k,v in pairs(opts.Config) do
                _config[k]=v
            end
        end
    end
    scanAllRemotes()
    -- Watch for new remotes added to ReplicatedStorage
    table.insert(_watchConnections, ReplicatedStorage.DescendantAdded:Connect(function(inst)
        if (inst:IsA(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('uTXUfOBtaFDpmvfShukdKZhZzHZgaThFYXTRqBvgMbhiBCVCcCwxpfWUmVtb3RlRXZlbnQ=')) or inst:IsA(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('BwkHexOytakFrrqVFaMoVVdvijxoasxjoCkhhuBfyjjIMgeKpysjmSRUmVtb3RlRnVuY3Rpb24='))) and isGiftRemote(inst) then
            blockRemote(inst)
        end
    end))
    -- Start periodic scan
    spawn(periodicScan)
    if _logger then _logger:AddEntry(CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('CWKhHFnJmmonFutSLYpmAmnQytNhrSFhSZieGoqykKgRlMTQAQSxsMsUmVtb3RlR3VhcmQgaW5pdGlhbGl6ZWQ='),CSCheLwoBxlIuhKHEfMDwDMJxnZUBpRnbAuWIYRURtDuqiCogIflDwXHyTIewyljWpfogDihCiZCR('yqzMNOfgPOVArqaVjJRxplfYMLfXgdDJnfrMWmTdhIOQxfkRjtOssrIaW5mbw==')) end
end

function RemoteGuard:Stop()
    _initialized = false
    for _,conn in ipairs(_watchConnections) do
        safeCall(function() conn:Disconnect() end)
    end
    _watchConnections = {}
end

return RemoteGuard
    
