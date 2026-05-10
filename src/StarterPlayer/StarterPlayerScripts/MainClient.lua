--[[
    MainClient.lua (StarterPlayerScripts)
    Main client initialization script.
    Sets up UI, input handling, and connects to server remotes.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))
local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")

------------------------------------------------------------
-- WAIT FOR DATA
------------------------------------------------------------
local playerData = nil
local function refreshData()
    local getDataRemote = remotesFolder:WaitForChild("GetPlayerData")
    playerData = getDataRemote:InvokeServer()
end

task.spawn(refreshData)

------------------------------------------------------------
-- STATS TRACKING (local mirror)
------------------------------------------------------------
local stats = {
    Money = Config.STARTING_MONEY,
    Strength = Config.STARTING_STRENGTH,
    Speed = Config.STARTING_SPEED,
    Luck = Config.STARTING_LUCK,
    Rebirths = Config.STARTING_REBIRTHS,
}

remotesFolder:WaitForChild("UpdatePlayerStats").OnClientEvent:Connect(function(newStats)
    for k, v in pairs(newStats) do
        stats[k] = v
    end
    if _G.UpdateStatsBar then
        _G.UpdateStatsBar(stats)
    end
end)

------------------------------------------------------------
-- LUCKY BLOCK INPUT
------------------------------------------------------------
local isKicking = false
local powerBarActive = false
local powerBarValue = 0
local powerBarDirection = 1
local currentZone = "Basico"

local function startPowerBar()
    if powerBarActive or isKicking then return end
    powerBarActive = true
    powerBarValue = 0
    powerBarDirection = 1

    if _G.ShowPowerBar then
        _G.ShowPowerBar(true)
    end
end

local function stopPowerBar()
    if not powerBarActive then return end
    powerBarActive = false
    isKicking = true

    if _G.ShowPowerBar then
        _G.ShowPowerBar(false)
    end

    remotesFolder:WaitForChild("KickLuckyBlock"):FireServer(powerBarValue, currentZone)

    if _G.PlayKickAnimation then
        _G.PlayKickAnimation()
    end

    task.wait(Config.LuckyBlock.Cooldown)
    isKicking = false
end

local function updatePowerBar(dt)
    if not powerBarActive then return end

    powerBarValue = powerBarValue + (dt * Config.PowerBar.Speed * powerBarDirection)

    if powerBarValue >= 1 then
        powerBarValue = 1
        powerBarDirection = -1
    elseif powerBarValue <= 0 then
        powerBarValue = 0
        powerBarDirection = 1
    end

    if _G.UpdatePowerBar then
        _G.UpdatePowerBar(powerBarValue)
    end
end

game:GetService("RunService").RenderStepped:Connect(function(dt)
    updatePowerBar(dt)
end)

------------------------------------------------------------
-- CLICK DETECTION FOR LUCKY BLOCKS
------------------------------------------------------------
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if not target then return end

    if target.Name:find("LuckyBlock") then
        local zoneValue = target:FindFirstChild("Zone")
        if zoneValue then
            currentZone = zoneValue.Value
        end

        if not powerBarActive then
            startPowerBar()
        else
            stopPowerBar()
        end
    elseif target.Name:find("Weight_") then
        remotesFolder:WaitForChild("TrainStrength"):FireServer()
    elseif target.Name == "UpgradeTerminal" then
        if _G.ToggleBaseUpgradeUI then
            _G.ToggleBaseUpgradeUI()
        end
    end
end)

------------------------------------------------------------
-- TOUCH INPUT (MOBILE)
------------------------------------------------------------
UserInputService.TouchTap:Connect(function(touchPositions, gameProcessedEvent)
    if gameProcessedEvent then return end
    -- Mobile tap handling is done through ClickDetectors
end)

------------------------------------------------------------
-- REWARD DISPLAY
------------------------------------------------------------
remotesFolder:WaitForChild("ShowReward").OnClientEvent:Connect(function(rewardData)
    if _G.ShowRewardPopup then
        _G.ShowRewardPopup(rewardData)
    end
end)

------------------------------------------------------------
-- BRAINROT OBTAINED
------------------------------------------------------------
remotesFolder:WaitForChild("BrainrotObtained").OnClientEvent:Connect(function(brainrotData)
    if _G.ShowBrainrotObtained then
        _G.ShowBrainrotObtained(brainrotData)
    end
end)

------------------------------------------------------------
-- NOTIFICATION
------------------------------------------------------------
remotesFolder:WaitForChild("ShowNotification").OnClientEvent:Connect(function(message, notifType)
    if _G.ShowNotification then
        _G.ShowNotification(message, notifType)
    end
end)

------------------------------------------------------------
-- REBIRTH SUCCESS
------------------------------------------------------------
remotesFolder:WaitForChild("RebirthSuccess").OnClientEvent:Connect(function(rebirthData)
    if _G.ShowRebirthEffect then
        _G.ShowRebirthEffect(rebirthData)
    end
end)

------------------------------------------------------------
-- EFFECTS
------------------------------------------------------------
remotesFolder:WaitForChild("PlayEffect").OnClientEvent:Connect(function(effectName, effectData)
    if _G.PlayEffect then
        _G.PlayEffect(effectName, effectData)
    end
end)

------------------------------------------------------------
-- PURCHASE SUCCESS
------------------------------------------------------------
remotesFolder:WaitForChild("PurchaseSuccess").OnClientEvent:Connect(function(purchaseData)
    if _G.OnPurchaseSuccess then
        _G.OnPurchaseSuccess(purchaseData)
    end
end)

------------------------------------------------------------
-- ZONE DETECTION
------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.5)
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                for _, rarity in ipairs(Config.Rarities) do
                    local zoneIndex = rarity.Order
                    local zoneStart = Config.RarityRoad.StartPosition.Z - ((zoneIndex - 1) * (Config.RarityRoad.ZoneLength + Config.RarityRoad.GapBetweenZones))
                    local zoneEnd = zoneStart - Config.RarityRoad.ZoneLength

                    if pos.Z <= zoneStart and pos.Z >= zoneEnd then
                        if currentZone ~= rarity.Name then
                            currentZone = rarity.Name
                            if _G.ShowZoneChange then
                                _G.ShowZoneChange(rarity)
                            end
                        end
                        break
                    end
                end
            end
        end
    end
end)

------------------------------------------------------------
-- INITIALIZE V2 SYSTEMS
------------------------------------------------------------
local EffectsClient = require(script.Parent:WaitForChild("EffectsClient"))
EffectsClient.Initialize()

task.spawn(function()
    local AdminUI = require(playerGui:WaitForChild("AdminUI", 10))
    if AdminUI then
        AdminUI.Initialize()
    end
end)

print("[Client] MainClient v2.0 initialized for " .. player.Name)
