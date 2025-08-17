local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- RemoteGuard.lua
-- Modular remote blocking for Next-Gen Anti-Gift
-- Author: Deeps-x

local ReplicatedStorage = game:GetService(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('ZAIMJwDRykMnZzztszMAhUCOsTypuQYpPqfXVStkvizkxtgmOVNSNIRUmVwbGljYXRlZFN0b3JhZ2U='))
local RunService = game:GetService(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('dyJeDLCagSNZTYJyRYfeHHkLLHrlIfnNFEslembDYlZbcCwEuJEQRfVUnVuU2VydmljZQ=='))
local Players = game:GetService(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('TwRUbFICpRToPjNxVARstmyimMSPzCXTrLniolacpsCtdMQgMQAwZDiUGxheWVycw=='))
local LocalPlayer = Players.LocalPlayer

local RemoteGuard = {}

RemoteGuard.BlockedRemotes = {}
RemoteGuard.Status = NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('DeEXgBbhwBFKeSuzsZFYoJeLpzaPKARsWZhHlEzftLCiSLPBtDjuJbcc2FmZQ==') -- safe, warn, danger, bypass

-- Event fired when a remote is triggered
RemoteGuard.OnRemoteTriggered = Instance.new(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('hnhMYGMXJUJgqEPxbjvEZxQSuHHuBwhaiLZQbucVoGdovKMhAirFTruQmluZGFibGVFdmVudA=='))

-- Scan and block gift remotes
function RemoteGuard:ScanAndBlock()
    local giftRemotes = {}
    
    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
        if (r:IsA(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('aRDUwLIGZuBsFHOtqKMgdkwxqxYtcJmsxiCSCUvWZfhAEzLoDgDFPPlUmVtb3RlRXZlbnQ=')) or r:IsA(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('ReZsDgMquitVeFNbOXulXCLQpcQdvAmpqJAgcKbAQIuGByCkguhMHUYUmVtb3RlRnVuY3Rpb24='))) and r.Name:lower():find(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('QMDNhALJjFKZrtdSUSHDWmnQSUsNtQpSixNtyxkMXoXxnMrMnkaVzLgZ2lmdA==')) then
            table.insert(giftRemotes, r)
        end
    end

    for _, remote in ipairs(giftRemotes) do
        if typeof(remote) == NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('ieYTDpEAQflQGCMgVYeHDYZINFddZxynamOaPTOxvCbTFlXwTKzoLTySW5zdGFuY2U=') then
            local oldFire
            oldFire = hookfunction(remote.FireServer, function(self, ...)
                -- Trigger bypass status
                RemoteGuard.Status = NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('dkbuXESFDKpxfddtEXIJykMDBrtsYIcggosBSHiHFrXoRDtAJfxadIsYnlwYXNz')
                RemoteGuard.OnRemoteTriggered:Fire(remote.Name)
                return nil
            end)
            RemoteGuard.BlockedRemotes[remote] = oldFire
        end
    end

    if #giftRemotes > 0 then
        RemoteGuard.Status = NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('WwIdhzkxbWAhhMnkeuWzktnDXliGHXLLHRGZcWjiNhTfSVArqwTIgrnc2FmZQ==')
    else
        RemoteGuard.Status = NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('FWkgUFHxJjuEjBlCABqnfTSNfHZEsMOYSaQoxoreFwxmecmfRNkyLAoZGFuZ2Vy')
    end
end

-- Monitor new remotes dynamically
function RemoteGuard:MonitorNewRemotes()
    ReplicatedStorage.DescendantAdded:Connect(function(r)
        if (r:IsA(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('RSRuQFbOsZlqoHDLmrvvWvkGrwogbJvknUKdTneUtBFWndesANmjcQyUmVtb3RlRXZlbnQ=')) or r:IsA(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('DjHIsuIJnAvPiCbvFOAMzCMZcubIOtcVEhiuaFQqWAGfnmvkdeWLSkaUmVtb3RlRnVuY3Rpb24='))) and r.Name:lower():find(NCkzCNandHfwkPldCBCufcXUEVgWdbVjJGKNOmlpuevAZm('fmFUmJjPRvshzXhxucULGJsRJMfgVpVgmFIQVbVifIEiMdDtxIFJqMvZ2lmdA==')) then
            self:ScanAndBlock()
        end
    end)
end

-- Get current status
function RemoteGuard:GetStatus()
    return self.Status
end

return RemoteGuard
    
