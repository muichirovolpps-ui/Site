--[[
    TrainingServer.lua  v3.0
    Handles strength and speed training, weight purchasing.
    Fixed: uses v3 Initialize(cfg, ds, remotesFolder) signature and direct data mutation.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TrainingServer = {}

local config = nil
local dsManager = nil
local remotesFolder = nil
local playerClickTimestamps = {}

function TrainingServer.Initialize(cfg, ds, remotes)
    config = cfg
    dsManager = ds
    remotesFolder = remotes

    local trainStrength = remotesFolder:WaitForChild("TrainStrength")
    local trainSpeed = remotesFolder:WaitForChild("TrainSpeed")
    local buyWeight = remotesFolder:WaitForChild("BuyWeight")

    trainStrength.OnServerEvent:Connect(function(player)
        TrainingServer.HandleTrainStrength(player)
    end)

    trainSpeed.OnServerEvent:Connect(function(player)
        TrainingServer.HandleTrainSpeed(player)
    end)

    buyWeight.OnServerEvent:Connect(function(player, weightIndex)
        TrainingServer.HandleBuyWeight(player, weightIndex)
    end)
end

function TrainingServer.HandleTrainStrength(player)
    local now = tick()
    local lastClick = playerClickTimestamps[player.UserId]
    if lastClick and (now - lastClick) < config.Training.ClickCooldown then
        return
    end
    playerClickTimestamps[player.UserId] = now

    local data = dsManager:GetData(player)
    if not data then return end

    local weightIndex = data.EquippedWeight or 1
    local weight = config.Training.Weights[weightIndex]
    if not weight then
        weight = config.Training.Weights[1]
    end

    local rebirthBonus = 1 + ((data.Rebirths or 0) * config.Rebirth.StrengthBonusPerRebirth)
    local strengthGain = math.floor(config.Training.StrengthPerClick * weight.Multiplier * rebirthBonus)

    -- Apply gamepass multipliers (data.Gamepasses is an array of strings)
    if data.Gamepasses then
        for _, gpName in ipairs(data.Gamepasses) do
            for _, gp in ipairs(config.Gamepasses) do
                if gp.Name == gpName and gp.Type == "Strength" then
                    strengthGain = strengthGain * (gp.Multiplier or 2)
                    break
                end
            end
        end
    end

    data.Strength = (data.Strength or 0) + strengthGain

    remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
        Strength = data.Strength,
    })

    remotesFolder:FindFirstChild("PlayEffect"):FireClient(player, "TrainPunch", {
        Amount = strengthGain,
    })
end

function TrainingServer.HandleTrainSpeed(player)
    local now = tick()
    local lastClick = playerClickTimestamps[player.UserId]
    if lastClick and (now - lastClick) < config.Training.ClickCooldown then
        return
    end
    playerClickTimestamps[player.UserId] = now

    local data = dsManager:GetData(player)
    if not data then return end

    local rebirthBonus = 1 + ((data.Rebirths or 0) * config.Rebirth.StrengthBonusPerRebirth)
    local speedGain = config.Training.SpeedPerClick * rebirthBonus

    data.Speed = (data.Speed or 0) + speedGain

    remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
        Speed = data.Speed,
    })
end

function TrainingServer.HandleBuyWeight(player, weightIndex)
    if type(weightIndex) ~= "number" then return end
    weightIndex = math.floor(weightIndex)

    local weight = config.Training.Weights[weightIndex]
    if not weight then return end

    local data = dsManager:GetData(player)
    if not data then return end

    if (data.Strength or 0) < weight.RequiredStrength then
        remotesFolder:FindFirstChild("ShowNotification"):FireClient(player,
            "Precisa de " .. weight.RequiredStrength .. " de forca!", "error")
        return
    end

    if (data.Money or 0) < weight.Cost then
        remotesFolder:FindFirstChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    data.Money = data.Money - weight.Cost
    data.EquippedWeight = weightIndex

    remotesFolder:FindFirstChild("ShowNotification"):FireClient(player,
        "Comprou " .. weight.Name .. "!", "success")
    remotesFolder:FindFirstChild("PurchaseSuccess"):FireClient(player, {
        Type = "Weight",
        Index = weightIndex,
        Name = weight.Name,
    })

    remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
        Money = data.Money,
    })
end

function TrainingServer.CleanupPlayer(player)
    playerClickTimestamps[player.UserId] = nil
end

return TrainingServer
