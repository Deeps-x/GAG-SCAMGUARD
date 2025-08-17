-- GUIManager.lua
-- Upgraded GUI manager for Next-Gen Anti-Gift
-- Features: animated status dot + ring, info popup, collapsible log console, responsive loading screen
-- Author: Deeps-x (upgraded)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local GUIManager = {}
GUIManager.__index = GUIManager

-- Internal state
local _screenGui = nil
local _statusDot, _statusLabel, _ring = nil, nil, nil
local _infoPopup = nil
local _logFrame, _logList = nil, {}
local _loadingFrame, _loadingBar, _loadingText, _spinner = nil
local _blockedRemotes = {}
local _lastTriggered = nil
local _uiScale = nil

-- UI color palette
local COLORS = {
    safe = Color3.fromRGB(0, 200, 0),
    warn = Color3.fromRGB(255, 200, 0),
    danger = Color3.fromRGB(200, 0, 0),
    bypass = Color3.fromRGB(0, 0, 0),
    bg = Color3.fromRGB(28, 28, 30),
    panel = Color3.fromRGB(36, 36, 38),
    text = Color3.fromRGB(230, 230, 230),
    muted = Color3.fromRGB(170, 170, 170),
}

-- helper: safe pcall wrapper
local function safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

-- helper: create UI instances with properties
local function new(cls, props)
    local obj = Instance.new(cls)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- helper: tween property
local function tween(obj, props, time, style, dir)
    style = style or Enum.EasingStyle.Sine
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(time or 0.25, style, dir)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- responsive scaling: add UIScale based on screen size (simple)
local function applyUIScale(screenGui)
    if _uiScale then return end
    local scale = Instance.new("UIScale")
    -- basic scale: smaller screens get smaller UI
    local base = math.clamp(math.min(workspace.CurrentCamera.ViewportSize.X / 1200, 1.2), 0.8, 1.2)
    scale.Scale = base
    scale.Parent = screenGui
    _uiScale = scale
end

-- create main ScreenGui & elements
function GUIManager:Initialize()
    if _screenGui then return _screenGui end

    _screenGui = new("ScreenGui", {
        Name = "NextGenAntiGiftUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })
    _screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    applyUIScale(_screenGui)

    -- Animated ring behind status dot
    _ring = new("Frame", {
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(0.5, -22, 0, 6),
        BackgroundColor3 = COLORS.safe,
        BorderSizePixel = 0,
        ZIndex = 3,
        Active = true,
    })
    _ring.AnchorPoint = Vector2.new(0, 0)
    _ring.Parent = _screenGui
    new("UICorner", {Parent = _ring, CornerRadius = UDim.new(1, 0)})
    _ring.BackgroundTransparency = 0.6

    -- Status Dot
    _statusDot = new("TextButton", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0.5, -9, 0, 14),
        BackgroundColor3 = COLORS.safe,
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 4,
    })
    _statusDot.AnchorPoint = Vector2.new(0, 0)
    _statusDot.Parent = _screenGui
    new("UICorner", {Parent = _statusDot, CornerRadius = UDim.new(1, 0)})
    _statusDot.AutoButtonColor = false

    -- Status label under the dot
    _statusLabel = new("TextLabel", {
        Size = UDim2.new(0, 260, 0, 22),
        Position = UDim2.new(0.5, -130, 0, 36),
        BackgroundTransparency = 1,
        Text = "SAFE",
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamBold,
        TextScaled = true,
        ZIndex = 4,
    })
    _statusLabel.Parent = _screenGui

    -- Info popup (hidden by default)
    _infoPopup = new("Frame", {
        Size = UDim2.new(0, 300, 0, 160),
        Position = UDim2.new(0.5, -150, 0, 60),
        BackgroundColor3 = COLORS.panel,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 50,
    })
    new("UICorner", {Parent = _infoPopup, CornerRadius = UDim.new(0, 8)})
    _infoPopup.Parent = _screenGui

    -- Info popup header
    local header = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "Protection Info",
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 51,
        Parent = _infoPopup,
    })
    header.Position = UDim2.new(0, 10, 0, 2)

    -- Info content area (list of blocked remotes)
    local content = new("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -38),
        Position = UDim2.new(0, 10, 0, 34),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ZIndex = 51,
        Parent = _infoPopup,
    })
    content.CanvasSize = UDim2.new(0, 0, 1, 0)

    -- store content for later log updates
    _infoPopup.Content = content

    -- Close button
    local closeBtn = new("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -28, 0, 4),
        BackgroundTransparency = 0.4,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Text = "X",
        TextColor3 = COLORS.text,
        AutoButtonColor = true,
        ZIndex = 52,
        Parent = _infoPopup,
    })
    new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0, 6)})
    closeBtn.MouseButton1Click:Connect(function()
        _infoPopup.Visible = false
    end)

    -- Collapsible log console (bottom-left)
    _logFrame = new("Frame", {
        Size = UDim2.new(0, 380, 0, 180),
        Position = UDim2.new(0.02, 0, 0.72, 0),
        BackgroundColor3 = Color3.fromRGB(18, 18, 20),
        BorderSizePixel = 0,
        ZIndex = 40,
        Visible = false,
    })
    new("UICorner", {Parent = _logFrame, CornerRadius = UDim.new(0, 8)})
    _logFrame.Parent = _screenGui

    local logTitle = new("TextLabel", {
        Size = UDim2.new(1, -10, 0, 24),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundTransparency = 1,
        Text = "Anti-Gift Log",
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = _logFrame,
    })

    local logScroll = new("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -36),
        Position = UDim2.new(0, 8, 0, 30),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(0, 0, 2, 0),
        Parent = _logFrame,
    })
    _logFrame.Scroll = logScroll

    -- Toggle button (top-right)
    local toggleBtn = new("TextButton", {
        Size = UDim2.new(0, 38, 0, 28),
        Position = UDim2.new(1, -46, 0, 10),
        BackgroundColor3 = Color3.fromRGB(40, 40, 44),
        BorderSizePixel = 0,
        Text = "LOG",
        TextColor3 = COLORS.text,
        ZIndex = 40,
        Parent = _screenGui,
    })
    new("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(0, 6)})
    toggleBtn.MouseButton1Click:Connect(function()
        _logFrame.Visible = not _logFrame.Visible
    end)

    -- Loading elements (separate frame inside loader)
    _loadingFrame = new("Frame", {
        Size = UDim2.new(0.46, 0, 0.18, 0),
        Position = UDim2.new(0.27, 0, 0.4, 0),
        BackgroundColor3 = COLORS.panel,
        BorderSizePixel = 0,
        ZIndex = 60,
        Parent = _screenGui,
    })
    new("UICorner", {Parent = _loadingFrame, CornerRadius = UDim.new(0, 12)})

    _loadingText = new("TextLabel", {
        Size = UDim2.new(1, -20, 0, 28),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = "Initializing Anti-Gift...",
        TextColor3 = COLORS.text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = _loadingFrame,
    })

    _loadingBar = new("Frame", {
        Size = UDim2.new(0, 0, 0, 10),
        Position = UDim2.new(0.06, 0, 0.65, 0),
        BackgroundColor3 = COLORS.safe,
        BorderSizePixel = 0,
        Parent = _loadingFrame,
    })
    new("UICorner", {Parent = _loadingBar, CornerRadius = UDim.new(0, 6)})

    -- simple spinner
    _spinner = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.88, 0, 0.12, 0),
        BackgroundColor3 = COLORS.safe,
        BorderSizePixel = 0,
        Parent = _loadingFrame,
    })
    new("UICorner", {Parent = _spinner, CornerRadius = UDim.new(1, 0)})

    -- input handling: click/tap the dot to toggle info popup
    local function onStatusActivate()
        if _infoPopup then
            _infoPopup.Visible = not _infoPopup.Visible
            if _infoPopup.Visible then
                -- populate list
                self:RefreshInfoPopup()
            end
        end
    end

    _statusDot.MouseButton1Click:Connect(onStatusActivate)
    -- support touch via InputBegan as well
    _statusDot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            onStatusActivate()
        end
    end)

    -- start ring rotation animation (non-blocking)
    spawn(function()
        while _ring and _ring.Parent do
            _ring.Rotation = (_ring.Rotation + 3) % 360
            task.wait(0.03)
        end
    end)

    return _screenGui
end

-- refresh info popup list (blocked remotes & last trigger)
function GUIManager:RefreshInfoPopup()
    if not _infoPopup or not _infoPopup.Content then return end
    local content = _infoPopup.Content
    -- clear children
    for _, c in ipairs(content:GetChildren()) do
        if not (c:IsA("UIListLayout") or c:IsA("UITextSizeConstraint")) then
            c:Destroy()
        end
    end

    local y = 0
    -- last trigger
    if _lastTriggered then
        local lbl = new("TextLabel", {
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, y),
            BackgroundTransparency = 1,
            Text = "Last Trigger: " .. tostring(_lastTriggered),
            TextColor3 = COLORS.warn,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = content,
        })
        y = y + 22
    end

    -- list blocked remotes
    if #_blockedRemotes == 0 then
        local lbl = new("TextLabel", {
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, y),
            BackgroundTransparency = 1,
            Text = "No gift remotes blocked.",
            TextColor3 = COLORS.muted,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = content,
        })
        y = y + 22
    else
        for i, name in ipairs(_blockedRemotes) do
            local lbl = new("TextLabel", {
                Size = UDim2.new(1, -10, 0, 18),
                Position = UDim2.new(0, 5, 0, y),
                BackgroundTransparency = 1,
                Text = "• " .. tostring(name),
                TextColor3 = COLORS.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = content,
            })
            y = y + 20
        end
    end

    content.CanvasSize = UDim2.new(0, 0, 0, math.max(y + 8, 60))
end

-- Add blocked remote to internal list and log UI
function GUIManager:AddBlockedRemote(name)
    if not name then return end
    table.insert(_blockedRemotes, 1, name)
    -- keep list reasonably small
    while #_blockedRemotes > 60 do
        table.remove(_blockedRemotes)
    end
    self:RefreshInfoPopup()
    self:AddLogEntry("Blocked remote: " .. tostring(name), "block")
end

-- Update status dot (mode = "safe"|"warn"|"danger"|"bypass"), optional display text
function GUIManager:SetStatus(mode, optText)
    optText = optText or nil
    local color = COLORS.safe
    if mode == "safe" then color = COLORS.safe
    elseif mode == "warn" then color = COLORS.warn
    elseif mode == "danger" then color = COLORS.danger
    elseif mode == "bypass" then color = COLORS.bypass end

    -- tween ring and dot colors smoothly
    if _ring then tween(_ring, {BackgroundColor3 = color}, 0.35) end
    if _statusDot then tween(_statusDot, {BackgroundColor3 = color}, 0.25) end

    if _statusLabel then
        local text = optText or string.upper(mode or "SAFE")
        _statusLabel.Text = tostring(text)
    end

    -- small pulse animation when entering bypass
    if mode == "bypass" and _statusDot then
        tween(_statusDot, {Size = UDim2.new(0, 26, 0, 26)}, 0.12)
        task.delay(0.18, function()
            if _statusDot then tween(_statusDot, {Size = UDim2.new(0, 18, 0, 18)}, 0.12) end
        end)
    end
end

-- Update loading progress (value between 0 and 1) and optional text
function GUIManager:UpdateProgress(value, text)
    value = math.clamp(value or 0, 0, 1)
    if _loadingBar then
        tween(_loadingBar, {Size = UDim2.new(value, 0, 0, 10)}, 0.25)
    end
    if _loadingText and text then
        _loadingText.Text = tostring(text)
    end
end

-- Show loading screen for a duration. Optional stepCallback(stepIndex, totalSteps)
function GUIManager:ShowLoadingScreen(duration, stepCallback)
    duration = duration or 12
    if not _loadingFrame then return end
    _loadingFrame.Visible = true
    local steps = math.max(8, math.floor(duration / 0.5))
    local stepTime = duration / steps
    for i = 1, steps do
        local progress = i / steps
        self:UpdateProgress(progress, ("Scanning %d/%d"):format(i, steps))
        if stepCallback then
            safeCall(stepCallback, i, steps)
        end
        task.wait(stepTime)
    end
    -- finish and fade
    self:UpdateProgress(1, "Finalizing protections")
    tween(_loadingFrame, {Position = UDim2.new(0.27, 0, -0.25, 0)}, 0.6)
    task.delay(0.9, function()
        if _loadingFrame and _loadingFrame.Parent then
            _loadingFrame:Destroy()
            _loadingFrame = nil
        end
    end)
end

-- Add a log entry to the console GUI (level: "info"|"block"|"alert")
function GUIManager:AddLogEntry(text, level)
    level = level or "info"
    if not _logFrame or not _logFrame.Scroll then return end
    table.insert(_logList, 1, {Text = text, Level = level, Time = os.time()})
    -- keep 200 entries max
    while #_logList > 200 do table.remove(_logList) end

    -- rebuild visible log entries
    for _, child in ipairs(_logFrame.Scroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end

    local y = 0
    local idx = 0
    for i = 1, math.min(#_logList, 60) do
        local entry = _logList[i]
        local color = COLORS.text
        if entry.Level == "block" then color = COLORS.warn
        elseif entry.Level == "alert" then color = COLORS.danger
        elseif entry.Level == "info" then color = COLORS.muted end

        local lbl = new("TextLabel", {
            Size = UDim2.new(1, -12, 0, 18),
            Position = UDim2.new(0, 8, 0, y),
            BackgroundTransparency = 1,
            Text = os.date("%H:%M:%S", entry.Time) .. " - " .. entry.Text,
            TextColor3 = color,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = _logFrame.Scroll,
            ZIndex = 41,
        })
        y = y + 18
        idx = idx + 1
    end
    _logFrame.Scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(y, 1))
end

-- Record last triggered remote (for Tamper/RemoteGuard to call)
function GUIManager:RecordTrigger(remoteName)
    _lastTriggered = remoteName
    self:AddLogEntry("Trigger detected: " .. tostring(remoteName), "alert")
    self:SetStatus("bypass", "TRIGGERED")
    -- update popup if open
    if _infoPopup and _infoPopup.Visible then
        self:RefreshInfoPopup()
    end
end

-- Get access to the ScreenGui (for TamperProtection register)
function GUIManager:GetScreenGui()
    return _screenGui
end

-- Destroy and cleanup
function GUIManager:Destroy()
    if _screenGui and _screenGui.Parent then
        _screenGui:Destroy()
    end
    _screenGui = nil
    _statusDot = nil
    _statusLabel = nil
    _infoPopup = nil
    _logFrame = nil
    _loadingFrame = nil
end

-- Export API
return setmetatable(GUIManager, {
    __call = function(_, ...) return GUIManager end
})
