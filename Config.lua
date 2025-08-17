-- Config.lua
-- Central configuration for GAG-SCAMGUARD

local Config = {}

-- Logging and GUI
Config.EnableLogging = true
Config.ShowConsoleGUI = true

-- Loading screen settings
Config.LoadingScreenDuration = 15 -- seconds
Config.LoadingScreenText = "Initializing GAG-SCAMGUARD..."
Config.LoadingScreenAnimation = true

-- Anti-steal / remote settings
Config.KickOnRemoteBypass = true
Config.DetectionPatterns = {"gift","give","gifting","giftto","gift_pet"}

-- Inventory locking
Config.InventoryScanContainers = {"Backpack","Character"}
Config.AutoFavoriteNames = {"Mythic","Legendary","Ultra","Prismatic"}
Config.ForceAttributeName = "d"
Config.AutoLockInventory = true

-- GUI settings
Config.StatusDotPosition = UDim2.new(0.5,0,0,30) -- middle-top
Config.StatusDotSize = UDim2.new(0,24,0,24)
Config.StatusColors = {
    Safe = Color3.fromRGB(0,255,0),
    Vulnerable = Color3.fromRGB(255,255,0),
    Dangerous = Color3.fromRGB(255,0,0),
    Triggered = Color3.fromRGB(0,0,0)
}

return Config
