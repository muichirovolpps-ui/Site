--[[
    LuckyBlockServer.lua (ServerScriptService)
    Handles Lucky Block kick logic, power bar validation, and reward distribution.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))
local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))
local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))

local LuckyBlockServer = {}

local playerCooldowns = {}
local remotesFolder = nil

function LuckyBlockServer.Initialize(remotes, dataStore)
    remotesFolder = remotes

    local kickRemote = remotesFolder:WaitForChild("KickLuckyBlock")
    local powerBarRemote = remotesFolder:WaitForChild("PowerBarResult")

    kickRemote.OnServerEvent:Connect(function(player, powerBarValue, currentZone)
        LuckyBlockServer.HandleKick(player, powerBarValue, currentZone, dataStore)
    end)
end

function LuckyBlockServer.HandleKick(player, powerBarValue, currentZone, dataStore)
    if not player or not player.Parent then return end

    local now = tick()
    if playerCooldowns[player.UserId] and (now - playerCooldowns[player.UserId]) < Config.LuckyBlock.Cooldown then
        return
    end
    playerCooldowns[player.UserId] = now

    local barValue = math.clamp(tonumber(powerBarValue) or 0, 0, 1)

    local section = nil
    for _, s in ipairs(Config.PowerBar.Sections) do
        if barValue >= s.Range[1] and barValue < s.Range[2] then
            section = s
            break
        end
    end
    if not section then
        section = Config.PowerBar.Sections[1]
    end

    local playerData = dataStore.GetData(player)
    if not playerData then return end

    local zoneName = currentZone or "Basico"
    local rarityConfig = nil
    for _, r in ipairs(Config.Rarities) do
        if r.Name == zoneName then
            rarityConfig = r
            break
        end
    end
    if not rarityConfig then
        rarityConfig = Config.Rarities[1]
    end

    if playerData.Strength < rarityConfig.RequiredStrength then
        remotesFolder:WaitForChild("ShowNotification"):FireClient(player, "Forca insuficiente!", "error")
        return
    end

    local rebirthBonus = 1 + (playerData.Rebirths * Config.Rebirth.RewardMultiplier)
    local luckMultiplier = playerData.Luck

    local moneyReward = math.floor(
        Config.LuckyBlock.BaseMoney
        * section.RewardMultiplier
        * rarityConfig.MoneyMultiplier
        * rebirthBonus
    )
    local strengthReward = math.floor(
        Config.LuckyBlock.BaseStrength
        * section.RewardMultiplier
        * rebirthBonus
    )
    local speedReward = Config.LuckyBlock.BaseSpeed * section.RewardMultiplier
    local luckReward = Config.LuckyBlock.BaseLuck * section.RewardMultiplier

    for _, gp in ipairs(Config.Gamepasses) do
        if playerData.Gamepasses[gp.Name] then
            if gp.Type == "Money" then
                moneyReward = moneyReward * gp.Multiplier
            elseif gp.Type == "Strength" then
                strengthReward = strengthReward * gp.Multiplier
            elseif gp.Type == "Luck" then
                luckReward = luckReward * gp.Multiplier
            end
        end
    end

    dataStore.IncrementValue(player, "Money", moneyReward)
    dataStore.IncrementValue(player, "Strength", strengthReward)
    dataStore.IncrementValue(player, "Speed", speedReward)
    dataStore.IncrementValue(player, "Luck", luckReward)
    dataStore.IncrementValue(player, "TotalKicks", 1)

    if section.Name == "Perfect" then
        dataStore.IncrementValue(player, "TotalPerfects", 1)
    end

    local brainrotObtained = nil
    local brainrotChance = rarityConfig.BrainrotChance * luckMultiplier * section.RewardMultiplier
    if Utils.Chance(brainrotChance) then
        local brainrots = BrainrotDB.GetBrainrotsByRarity(zoneName)
        if #brainrots > 0 then
            local selected = Utils.PickRandom(brainrots)

            local mutation = "None"
            for _, mut in ipairs(Config.Mutations) do
                if Utils.Chance(mut.Chance * luckMultiplier) then
                    mutation = mut.Name
                    break
                end
            end

            local entry = dataStore.AddToInventory(player, selected.Name, zoneName, mutation)
            brainrotObtained = {
                Name = selected.DisplayName,
                Rarity = zoneName,
                Mutation = mutation,
                Value = selected.Value,
            }

            remotesFolder:WaitForChild("BrainrotObtained"):FireClient(player, brainrotObtained)
        end
    end

    local rewardData = {
        Money = moneyReward,
        Strength = strengthReward,
        Speed = speedReward,
        Luck = luckReward,
        Section = section.Name,
        SectionColor = {section.Color.R * 255, section.Color.G * 255, section.Color.B * 255},
        Brainrot = brainrotObtained,
    }
    remotesFolder:WaitForChild("ShowReward"):FireClient(player, rewardData)

    remotesFolder:WaitForChild("PlayEffect"):FireClient(player, "LuckyBlockExplosion", {
        Position = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            and player.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -5) or Vector3.new(0, 5, 0),
        Color = section.Color,
    })

    LuckyBlockServer.SyncStats(player, dataStore)
end

function LuckyBlockServer.SyncStats(player, dataStore)
    local data = dataStore.GetData(player)
    if not data then return end

    remotesFolder:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Money = data.Money,
        Strength = data.Strength,
        Speed = data.Speed,
        Luck = data.Luck,
        Rebirths = data.Rebirths,
    })
end

function LuckyBlockServer.CleanupPlayer(player)
    playerCooldowns[player.UserId] = nil
end

return LuckyBlockServer
