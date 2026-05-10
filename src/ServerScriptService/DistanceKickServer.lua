--[[
    DistanceKickServer.lua  v2.0
    Reworked kick system with distance-based progression.
    Character spins, flies forward, physics effects, trails.
    Distance depends on strength, multipliers, and rebirths.
]]

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local DistanceKickServer = {}

local Config
local DataStoreManager
local remotesFolder

function DistanceKickServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local kickRemote = remotesFolder:FindFirstChild("PerformKick")
    if not kickRemote then
        kickRemote = Instance.new("RemoteEvent")
        kickRemote.Name = "PerformKick"
        kickRemote.Parent = remotesFolder
    end

    local kickResultRemote = remotesFolder:FindFirstChild("KickResult")
    if not kickResultRemote then
        kickResultRemote = Instance.new("RemoteEvent")
        kickResultRemote.Name = "KickResult"
        kickResultRemote.Parent = remotesFolder
    end

    kickRemote.OnServerEvent:Connect(function(player, powerBarValue)
        DistanceKickServer.ProcessKick(player, powerBarValue)
    end)
end

function DistanceKickServer.CalculateDistance(strength, rebirths, powerMultiplier, luckMultiplier)
    local base = Config.Kick.BaseDistance
    local strScale = strength * Config.Kick.StrengthScaling
    local rebScale = 1 + (rebirths * Config.Kick.RebirthScaling)
    local distance = (base + strScale) * rebScale * powerMultiplier * (1 + luckMultiplier * 0.1)
    return math.min(distance, Config.Kick.MaxDistance)
end

function DistanceKickServer.GetZoneForDistance(distance)
    for i = #Config.DistanceZones, 1, -1 do
        local zone = Config.DistanceZones[i]
        if distance >= zone.MinDist then
            return zone
        end
    end
    return Config.DistanceZones[1]
end

function DistanceKickServer.ProcessKick(player, powerBarValue)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    powerBarValue = math.clamp(powerBarValue or 0, 0, 1)

    local data = DataStoreManager:GetData(player)
    if not data then return end

    local powerSection = nil
    for _, section in ipairs(Config.PowerBar.Sections) do
        if powerBarValue >= section.Range[1] and powerBarValue <= section.Range[2] then
            powerSection = section
            break
        end
    end
    if not powerSection then
        powerSection = Config.PowerBar.Sections[1]
    end

    local strength = data.Strength or 1
    local rebirths = data.Rebirths or 0
    local luck = data.Luck or 1

    local distance = DistanceKickServer.CalculateDistance(
        strength, rebirths, powerSection.RewardMultiplier, luck
    )

    local zone = DistanceKickServer.GetZoneForDistance(distance)
    local moneyReward = math.floor(Config.LuckyBlock.BaseMoney * zone.MoneyMult * powerSection.RewardMultiplier)
    local strengthReward = math.floor(Config.LuckyBlock.BaseStrength * powerSection.RewardMultiplier * (1 + rebirths * 0.05))

    local moneyMult = 1
    if data.Gamepasses then
        for _, gp in ipairs(data.Gamepasses) do
            if gp == "2x Money" or gp == "VIP" then moneyMult = moneyMult * 2 end
        end
    end
    moneyReward = math.floor(moneyReward * moneyMult)

    data.Money = (data.Money or 0) + moneyReward
    data.Strength = (data.Strength or 0) + strengthReward
    data.TotalKicks = (data.TotalKicks or 0) + 1

    if powerSection.Name == "Perfect" then
        data.TotalPerfects = (data.TotalPerfects or 0) + 1
    end

    local kickResultRemote = remotesFolder:FindFirstChild("KickResult")
    if kickResultRemote then
        kickResultRemote:FireClient(player, {
            Distance = distance,
            Zone = zone.Name,
            PowerSection = powerSection.Name,
            Money = moneyReward,
            Strength = strengthReward,
            FlyDuration = Config.Kick.FlyDuration,
            SpinSpeed = Config.Kick.SpinSpeed,
        })
    end

    local rewardRemote = remotesFolder:FindFirstChild("ShowReward")
    if rewardRemote then
        rewardRemote:FireClient(player, {
            Money = moneyReward,
            Strength = strengthReward,
            Source = "Kick",
            Distance = math.floor(distance),
        })
    end
end

return DistanceKickServer
