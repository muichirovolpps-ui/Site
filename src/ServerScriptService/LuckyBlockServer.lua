--[[
    LuckyBlockServer.lua  v3.0
    Handles Lucky Block kick logic, power bar validation, and reward distribution.
    Fixed: uses v3 Initialize(cfg, ds, remotesFolder) signature and colon method calls.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))
local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))

local LuckyBlockServer = {}

local config = nil
local dsManager = nil
local remotesFolder = nil
local playerCooldowns = {}

function LuckyBlockServer.Initialize(cfg, ds, remotes)
    config = cfg
    dsManager = ds
    remotesFolder = remotes

    local kickRemote = remotesFolder:WaitForChild("KickLuckyBlock")

    kickRemote.OnServerEvent:Connect(function(player, powerBarValue, currentZone)
        LuckyBlockServer.HandleKick(player, powerBarValue, currentZone)
    end)
end

function LuckyBlockServer.HandleKick(player, powerBarValue, currentZone)
    if not player or not player.Parent then return end

    local now = tick()
    if playerCooldowns[player.UserId] and (now - playerCooldowns[player.UserId]) < config.LuckyBlock.Cooldown then
        return
    end
    playerCooldowns[player.UserId] = now

    local barValue = math.clamp(tonumber(powerBarValue) or 0, 0, 1)

    local section = nil
    for _, s in ipairs(config.PowerBar.Sections) do
        if barValue >= s.Range[1] and barValue < s.Range[2] then
            section = s
            break
        end
    end
    if not section then
        section = config.PowerBar.Sections[1]
    end

    local playerData = dsManager:GetData(player)
    if not playerData then return end

    local zoneName = currentZone or "Basico"
    local rarityConfig = nil
    for _, r in ipairs(config.Rarities) do
        if r.Name == zoneName then
            rarityConfig = r
            break
        end
    end
    if not rarityConfig then
        rarityConfig = config.Rarities[1]
    end

    if playerData.Strength < rarityConfig.RequiredStrength then
        remotesFolder:FindFirstChild("ShowNotification"):FireClient(player, "Forca insuficiente!", "error")
        return
    end

    local rebirthBonus = 1 + (playerData.Rebirths * config.Rebirth.MoneyMultiplierPerRebirth)
    local luckMultiplier = playerData.Luck

    local moneyReward = math.floor(
        config.LuckyBlock.BaseMoney
        * section.RewardMultiplier
        * rarityConfig.MoneyMultiplier
        * rebirthBonus
    )
    local strengthReward = math.floor(
        config.LuckyBlock.BaseStrength
        * section.RewardMultiplier
        * rebirthBonus
    )
    local luckReward = config.LuckyBlock.BaseLuck * section.RewardMultiplier

    -- Apply gamepass multipliers (data.Gamepasses is an array of strings)
    if playerData.Gamepasses then
        for _, gpName in ipairs(playerData.Gamepasses) do
            for _, gp in ipairs(config.Gamepasses) do
                if gp.Name == gpName then
                    if gp.Type == "Money" then
                        moneyReward = moneyReward * (gp.Multiplier or 2)
                    elseif gp.Type == "Strength" then
                        strengthReward = strengthReward * (gp.Multiplier or 2)
                    elseif gp.Type == "Luck" then
                        luckReward = luckReward * (gp.Multiplier or 2)
                    end
                    break
                end
            end
        end
    end

    playerData.Money = (playerData.Money or 0) + moneyReward
    playerData.Strength = (playerData.Strength or 0) + strengthReward
    playerData.Luck = (playerData.Luck or 0) + luckReward
    playerData.TotalKicks = (playerData.TotalKicks or 0) + 1

    if section.Name == "Perfect" then
        playerData.TotalPerfects = (playerData.TotalPerfects or 0) + 1
    end

    local brainrotObtained = nil
    local brainrotChance = rarityConfig.BrainrotChance * luckMultiplier * section.RewardMultiplier
    if Utils.Chance(brainrotChance) then
        local brainrots = BrainrotDB.GetBrainrotsByRarity(zoneName)
        if #brainrots > 0 then
            local selected = Utils.PickRandom(brainrots)

            local mutation = "None"
            for _, mut in ipairs(config.Mutations) do
                if Utils.Chance(mut.Chance * luckMultiplier) then
                    mutation = mut.Name
                    break
                end
            end

            dsManager:AddToInventory(player, {
                Name = selected.Name,
                Rarity = zoneName,
                Mutation = mutation ~= "None" and mutation or nil,
                Level = 1,
            })

            brainrotObtained = {
                Name = selected.DisplayName,
                Rarity = zoneName,
                Mutation = mutation,
                Value = selected.Value,
            }

            remotesFolder:FindFirstChild("BrainrotObtained"):FireClient(player, brainrotObtained)
        end
    end

    local rewardData = {
        Money = moneyReward,
        Strength = strengthReward,
        Luck = luckReward,
        Section = section.Name,
        SectionColor = {section.Color.R * 255, section.Color.G * 255, section.Color.B * 255},
        Brainrot = brainrotObtained,
    }
    remotesFolder:FindFirstChild("ShowReward"):FireClient(player, rewardData)

    remotesFolder:FindFirstChild("PlayEffect"):FireClient(player, "LuckyBlockExplosion", {
        Position = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            and player.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -5) or Vector3.new(0, 5, 0),
        Color = section.Color,
    })

    LuckyBlockServer.SyncStats(player)
end

function LuckyBlockServer.SyncStats(player)
    local data = dsManager:GetData(player)
    if not data then return end

    remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
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
