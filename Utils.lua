-- Utils.lua
-- Shared utility functions for GAG-SCAMGUARD

local Utils = {}

-- Safe call wrapper
function Utils.SafeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

-- Format time in HH:MM:SS
function Utils.FormatTime(seconds)
    local h = math.floor(seconds/3600)
    local m = math.floor((seconds%3600)/60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d",h,m,s)
end

-- Create a colored status dot
function Utils.CreateStatusDot(parent, size, color, position)
    local dot = Instance.new("Frame")
    dot.Size = size or UDim2.new(0,24,0,24)
    dot.Position = position or UDim2.new(0.5,0,0,30)
    dot.BackgroundColor3 = color or Color3.fromRGB(0,255,0)
    dot.BorderSizePixel = 0
    dot.AnchorPoint = Vector2.new(0.5,0)
    dot.Rotation = 0
    dot.ZIndex = 5
    dot.Parent = parent
    dot.Name = "StatusDot"
    dot.BackgroundTransparency = 0

    -- Optional hover tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(1,0,0,20)
    tooltip.Position = UDim2.new(0,0,1,2)
    tooltip.BackgroundTransparency = 1
    tooltip.Text = "Status"
    tooltip.TextColor3 = Color3.fromRGB(255,255,255)
    tooltip.Font = Enum.Font.SourceSans
    tooltip.TextSize = 14
    tooltip.TextScaled = true
    tooltip.Visible = false
    tooltip.Parent = dot

    dot.MouseEnter:Connect(function() tooltip.Visible = true end)
    dot.MouseLeave:Connect(function() tooltip.Visible = false end)

    return dot, tooltip
end

return Utils
