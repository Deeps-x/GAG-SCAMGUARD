local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- GUIManager.lua
-- Modular GUI manager for Next-Gen Anti-Gift
-- Author: Deeps-x

local Players = game:GetService(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('xkdcnCHqNKppqWRYGWKMsxZiMWNIqJKCQCoaJHGHnmYtdPRueIuwjtVUGxheWVycw=='))
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('CunaVkzyxPKcqgwjlemKHHoCGZoijQZEIePIGLdXueAzyTwjlgvgKuGVHdlZW5TZXJ2aWNl'))

local GUIManager = {}

-- GUI references
GUIManager.ScreenGui = nil
GUIManager.StatusDot = nil
GUIManager.StatusLabel = nil
GUIManager.LoaderFrame = nil
GUIManager.LoaderTitle = nil
GUIManager.LoaderInfo = nil
GUIManager.BarBG = nil
GUIManager.Bar = nil

-- Initialize GUI
function GUIManager:Initialize()
    -- ScreenGui
    self.ScreenGui = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('ZRiUNRRmrBzXKrWlBeBjszAFRENsAIldeMaWdwSsMvVknQcsHdNStEDU2NyZWVuR3Vp'))
    self.ScreenGui.Name = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('XIHwDXGxajXHkEUVQZTPQULJwmATlAJNfFuHkNOPtiWXJZadqBfoTkKTmV4dEdlbkFudGlHaWZ0VUk=')
    self.ScreenGui.Parent = LocalPlayer:WaitForChild(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('WzqqOtNzVBokwQWoBISDUwEBLjaZPzSFYbOHvZWdAikTYNWBXPIWEBBUGxheWVyR3Vp'))

    -- Status Dot
    self.StatusDot = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('iCOUxnMYINEUXLfGOrtMgDneJoYQXpukWobChhqAIxndWMcQCDywCYARnJhbWU='))
    self.StatusDot.Size = UDim2.new(0, 20, 0, 20)
    self.StatusDot.Position = UDim2.new(0.5, -10, 0, 12)
    self.StatusDot.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    self.StatusDot.BorderSizePixel = 0
    self.StatusDot.Parent = self.ScreenGui
    local corner = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('FcLyirHMnuYCJFKcbiYnXZbwEuXNCcJvxvzkEKTqNRnUjTXdukdrCEaVUlDb3JuZXI='))
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = self.StatusDot

    -- Status Label
    self.StatusLabel = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('bIEVThDmAICWVXSsUiYKxZBvVIGNGeNjCVABIOCAFhgkNkvLlslzLEFVGV4dExhYmVs'))
    self.StatusLabel.Size = UDim2.new(0, 200, 0, 24)
    self.StatusLabel.Position = UDim2.new(0.5, -100, 0, 36)
    self.StatusLabel.BackgroundTransparency = 1
    self.StatusLabel.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('iapLfjGGIZLlytKIEmnfqbORlDnujPkDObJruxWBkUDazyjkumDoxfQU0FGRQ==')
    self.StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.StatusLabel.Font = Enum.Font.GothamBold
    self.StatusLabel.TextScaled = true
    self.StatusLabel.TextWrapped = true
    self.StatusLabel.Parent = self.ScreenGui

    -- Loading Frame
    self.LoaderFrame = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('eURXHoSvENyFnvRPfCHXDHfOfKWaMIGAhLhjvROGtpmuQnlPelVXYjvRnJhbWU='))
    self.LoaderFrame.Size = UDim2.new(0.5, 0, 0.22, 0)
    self.LoaderFrame.Position = UDim2.new(0.25, 0, 0.39, 0)
    self.LoaderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.LoaderFrame.BorderSizePixel = 0
    self.LoaderFrame.ZIndex = 50
    self.LoaderFrame.ClipsDescendants = true
    self.LoaderFrame.Active = true
    self.LoaderFrame.Parent = self.ScreenGui
    local loaderCorner = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('tbYyJHSnhuxxMmPaoXbiyXeSABoWvucisVNgollczsIdSCVRAPdwTjmVUlDb3JuZXI='))
    loaderCorner.CornerRadius = UDim.new(0, 12)
    loaderCorner.Parent = self.LoaderFrame

    -- Loader Title
    self.LoaderTitle = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('MSTbwtoCbqzMAQSaIsgxonzRHCJFsPTfDUVZaByNBGWOoJJNmrzmyNmVGV4dExhYmVs'))
    self.LoaderTitle.Size = UDim2.new(1, 0, 0.3, 0)
    self.LoaderTitle.Position = UDim2.new(0, 0, 0, 0)
    self.LoaderTitle.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('xIGZPbqfOaGoKmMidZychnKfuwSyaWrZhVNydpzOnSvltmDopKDKNVz8J+boe+4jyBBbnRpLUdpZnQgU2Nhbg==')
    self.LoaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.LoaderTitle.BackgroundTransparency = 1
    self.LoaderTitle.Font = Enum.Font.GothamBold
    self.LoaderTitle.TextScaled = true
    self.LoaderTitle.TextWrapped = true
    self.LoaderTitle.Parent = self.LoaderFrame

    -- Loader Info
    self.LoaderInfo = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('CTDxOoyexBfhvJwPTjatGlaAIRKBjVKBuYVRwLOAaadvriKCaIhwukhVGV4dExhYmVs'))
    self.LoaderInfo.Size = UDim2.new(1, 0, 0.2, 0)
    self.LoaderInfo.Position = UDim2.new(0, 0, 0.35, 0)
    self.LoaderInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    self.LoaderInfo.BackgroundTransparency = 1
    self.LoaderInfo.TextScaled = true
    self.LoaderInfo.TextWrapped = true
    self.LoaderInfo.Font = Enum.Font.Gotham
    self.LoaderInfo.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('HuNrxQwZRemfjWxSkDsjzLOLnOvnMDpSHlfSbiGCMxFQlJpWaHGHWPrSW5pdGlhbGl6aW5nIHN5c3RlbS4uLg==')
    self.LoaderInfo.Parent = self.LoaderFrame

    -- Progress Bar
    self.BarBG = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('xOFXpYfQldWADVFdtyROszMpYiRCqbMphkEmWPOOabnCzRYZPyajuiqRnJhbWU='))
    self.BarBG.Size = UDim2.new(0.8, 0, 0.15, 0)
    self.BarBG.Position = UDim2.new(0.1, 0, 0.65, 0)
    self.BarBG.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    self.BarBG.Parent = self.LoaderFrame
    local barCorner = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('chxaPjChREloQcuaHRNWZHaltdKFzuVhbTfJRGrJAsuHlrNXLyfyYtXVUlDb3JuZXI='))
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = self.BarBG

    self.Bar = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('VoExtRjozXmeLVXQBZbaLpUBZuHbpsaNXQilvyJvbJVQeaSmIJIayDvRnJhbWU='))
    self.Bar.Size = UDim2.new(0, 0, 1, 0)
    self.Bar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    self.Bar.Parent = self.BarBG
    local innerCorner = Instance.new(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('bJGgmvKaLmijtnCmSdxJuadwnBZweAymsyAqbZUwSPgGqTQxuUAFsoGVUlDb3JuZXI='))
    innerCorner.CornerRadius = UDim.new(0, 6)
    innerCorner.Parent = self.Bar
end

-- Set Status Dot
function GUIManager:SetStatus(mode)
    if mode == cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('rWXQAiYSONrlMfOhUsyNlbJnzsdJfaZIhxFJUKSxElABreKjwvZIYfnc2FmZQ==') then
        self.StatusDot.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        self.StatusLabel.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('VbjUrayJUJrnKeoAgHeGbAcXPNszIuZHHTSiBHURUtGZbSYtljEEZNKU0FGRQ==')
    elseif mode == cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('jtqSJMCySoxsBnLeIrLwKcxyzIUhHUUDOHqCXtdtmTjaSYqOoTsxnzhd2Fybg==') then
        self.StatusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        self.StatusLabel.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('JKvcOyLQlegWCPWOiHruAOCDdmpFJnQpputfyZtwOVQVgVxkUWxlQDSVlVMTkVSQUJMRQ==')
    elseif mode == cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('wuLkBVKikSnFqBEmeaMcclEKFTcYTQwQbJHvucUbCbciuaddkVOqBIYZGFuZ2Vy') then
        self.StatusDot.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        self.StatusLabel.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('ureydJGmsvNHXSCVpdKYJGAsyOmpkWorbMEfQOrChXhYgOUtdBgQUxtRkFJTEVE')
    elseif mode == cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('QRBKLGPByCukfKhQnCaZrZdhcSJroojfEPCHDaPlSYujLPKWspjbVWPYnlwYXNz') then
        self.StatusDot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        self.StatusLabel.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('ZVZMbEZddJnjqFtdYNnOCZAhOqDRnACARRiOsiCtNqxZPlwTAAQgoaFVFJJR0dFUkVE')
    end
end

-- Show Loading Screen
function GUIManager:ShowLoadingScreen(duration)
    duration = duration or 15
    local stepTime = 0.5
    local steps = duration / stepTime
    for i = 1, steps do
        local progress = i / steps
        self.Bar:TweenSize(UDim2.new(progress, 0, 1, 0), cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('LmRAPFBvnLcyiQcLuKOziVJxtVFmnedgBvWtlYuqYZATRngucWdNsoXT3V0'), cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('fnmRQYOALHDFNCDZshUigDfAPezWsiZYQJkzNtEaRQwwBgHXWrEgdhPU2luZQ=='), stepTime, true)
        self.LoaderInfo.Text = cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('zQSKoeeEvZLOqCQcICBEifjUxVwfiJkEYvyIdvnAtmJjupNdQLwacOfU2Nhbm5pbmcgYW5kIGJsb2NraW5nIHJlbW90ZXM=')..string.rep(cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('MVsTQIvQcJZhbASqYctDjAiDchBIejyzoWiXdNZXqxgBbxvjFIxUAwULg=='), i%4)
        task.wait(stepTime)
    end
    -- Fade out loader
    self.LoaderFrame:TweenPosition(UDim2.new(0.25, 0, -0.25, 0), cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('ONqXGoTiwbjEDsBbJSZWUwmYzoAOXfxzHkXyqOxMTWXugAKaoVlmsyZT3V0'), cPpTbcSIFlNbVUdwtAModeyGUGpgAPYiNGExDUKeKlXmruLzVqwaqoStFinTTKlvXSPRRTZfYDoYtJpNFQgPRvI('cRDUUGRUbWBXtiQzjqIzrLcgHIKVaCOzBQgmJPkOHMwzVoTlnVrawfpU2luZQ=='), 0.8, true)
    task.delay(1, function()
        if self.LoaderFrame then
            self.LoaderFrame:Destroy()
        end
    end)
end

return GUIManager
    
