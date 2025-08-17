-- GUIManager.lua
-- Handles loading screen, status dot, and UI feedback

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local GUIManager = {}
GUIManager.__index = GUIManager

-- Internal
local _statusDot = nil
local _loadingFrame = nil
local _progressBar = nil
local _screenGui = nil
local _currentStatus = "green"

-- Create UI
local function createUI()
    _screenGui = Instance.new("ScreenGui")
    _screenGui.Name = "GAG_SCAM_GUARD_UI"
    _screenGui.ResetOnSpawn = false
    _screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Loading frame
    _loadingFrame = Instance.new("Frame")
    _loadingFrame.Size = UDim2.new(0,300,0,80)
    _loadingFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
    _loadingFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    _loadingFrame.BorderSizePixel = 0
    _loadingFrame.Parent = _screenGui
    _loadingFrame.Visible = false
    _loadingFrame.AnchorPoint = Vector2.new(0.5,0.5)
    _loadingFrame.ClipsDescendants = true
    _loadingFrame.Rotation = 0

    -- Progress bar
    _progressBar = Instance.new("Frame")
    _progressBar.Size = UDim2.new(0,0,1,0)
    _progressBar.Position = UDim2.new(0,0,0,0)
    _progressBar.BackgroundColor3 = Color3.fromRGB(0,200,0)
    _progressBar.BorderSizePixel = 0
    _progressBar.Parent = _loadingFrame

    -- Status dot
    _statusDot = Instance.new("Frame")
    _statusDot.Size = UDim2.new(0,24,0,24)
    _statusDot.Position = UDim2.new(0.5, -12, 0, 10)
    _statusDot.AnchorPoint = Vector2.new(0.5,0)
    _statusDot.BackgroundColor3 = Color3.fromRGB(0,255,0)
    _statusDot.BorderSizePixel = 0
    _statusDot.Parent = _screenGui
    _statusDot.Visible = true
    _statusDot.Name = "StatusDot"
    _statusDot.ZIndex = 10
end

-- Update status dot color and optional tooltip text
function GUIManager:SetStatus(mode, text)
    _currentStatus = mode
    local color
    if mode == "green" then color = Color3.fromRGB(0,255,0)
    elseif mode == "yellow" then color = Color3.fromRGB(255,255,0)
    elseif mode == "red" then color = Color3.fromRGB(255,0,0)
    elseif mode == "black" then color = Color3.fromRGB(0,0,0)
    else color = Color3.fromRGB(0,255,0) end

    _statusDot.BackgroundColor3 = color
    -- Optional tooltip: use a TextLabel for simplicity
    if text then
        if not _statusDot:FindFirstChild("Tooltip") then
            local tooltip = Instance.new("TextLabel")
            tooltip.Name = "Tooltip"
            tooltip.Size = UDim2.new(0,200,0,50)
            tooltip.Position = UDim2.new(0.5,-100,0,40)
            tooltip.BackgroundTransparency = 0.5
            tooltip.BackgroundColor3 = Color3.fromRGB(0,0,0)
            tooltip.TextColor3 = Color3.fromRGB(255,255,255)
            tooltip.TextScaled = true
            tooltip.Text = text
            tooltip.Parent = _statusDot
        else
            _statusDot.Tooltip.Text = text
        end
    end
end

-- Show loading screen with animated progress
-- duration in seconds, stageCallback(stageText) optional
function GUIManager:ShowLoadingScreen(duration, stageCallback)
    _loadingFrame.Visible = true
    _progressBar.Size = UDim2.new(0,0,1,0)

    local startTime = tick()
    local endTime = startTime + duration

    spawn(function()
        while tick() < endTime do
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed/duration,0,1)
            _progressBar.Size = UDim2.new(progress,0,1,0)

            -- Stage text callback
            if stageCallback then
                local stageText = string.format("Loading... %d%%", math.floor(progress*100))
                pcall(stageCallback, stageText)
            end
            task.wait(0.05)
        end
        -- Finished
        _progressBar.Size = UDim2.new(1,0,1,0)
        task.wait(0.5)
        _loadingFrame:Destroy()
    end)
end

-- Initialize GUIManager
function GUIManager:Initialize()
    createUI()
end

return GUIManager
