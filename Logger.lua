-- Logger.lua
-- Handles logs, console GUI, and analytics

local Logger = {}
Logger.Entries = {}
Logger.GUIFrame = nil

-- Initialize console GUI
function Logger:InitGUI(parent)
    if Logger.GUIFrame then Logger.GUIFrame:Destroy() end
    local screenGui = Instance.new("ScreenGui")
    screenGui.ResetOnSpawn = false
    screenGui.Name = "GAGLoggerGUI"
    screenGui.Parent = parent or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,400,0,200)
    frame.Position = UDim2.new(0.5,-200,0,20)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.3
    frame.Parent = screenGui
    Logger.GUIFrame = frame

    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = frame
end

-- Add log entry
function Logger:AddEntry(msg,level)
    level = level or "info"
    table.insert(Logger.Entries,{Time=os.time(),Level=level,Message=msg})
    Logger:UpdateGUI(msg,level)
end

-- Update GUI
function Logger:UpdateGUI(msg,level)
    if not Logger.GUIFrame then return end
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,0,20)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = (level=="error" and Color3.fromRGB(255,50,50)) or (level=="alert" and Color3.fromRGB(255,200,50)) or Color3.fromRGB(200,200,200)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Font = Enum.Font.Code
    textLabel.TextSize = 14
    textLabel.Text = os.date("[%H:%M:%S]",os.time()) .. " ["..level.."] " .. msg
    textLabel.Parent = Logger.GUIFrame
end

return Logger
