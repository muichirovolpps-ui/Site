--[[
    TrainingServer.lua (ServerScriptService)
    Handles strength and speed training, weight purchasing.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))

local TrainingServer = {}

local playerClickTimestamps = {}

function TrainingServer.Initialize(remotes, dataStore)
    local trainStrength = remotes:WaitForChild("TrainStrength")
    local trainSpeed = remotes:WaitForChild("TrainSpeed")
    local buyWeight = remotes:WaitForChild("BuyWeight")

    trainStrength.OnServerEvent:Connect(function(player)
        TrainingServer.HandleTrainStrength(player, dataStore, remotes)
    end)

    trainSpeed.OnServerEvent:Connect(function(player)
        TrainingServer.HandleTrainSpeed(player, dataStore, remotes)
    end)

    buyWeight.OnServerEvent:Connect(function(player, weightIndex)
        TrainingServer.HandleBuyWeight(player, weightIndex, dataStore, remotes)
    end)
end

function TrainingServer.HandleTrainStrength(player, dataStore, remotes)
    local now = tick()
    local lastClick = playerClickTimestamps[player.UserId]
    if lastClick and (now - lastClick) < Config.Training.ClickCooldown then
        return
    end
    playerClickTimestamps[player.UserId] = now

    local data = dataStore.GetData(player)
    if not data then return end

    local weightIndex = data.EquippedWeight or 1
    local weight = Config.Training.Weights[weightIndex]
    if not weight then
        weight = Config.Training.Weights[1]
    end

    local rebirthBonus = 1 + (data.Rebirths * Config.Rebirth.RewardMultiplier)
    local strengthGain = math.floor(Config.Training.StrengthPerClick * weight.Multiplier * rebirthBonus)

    for _, gp in ipairs(Config.Gamepasses) do
        if data.Gamepasses[gp.Name] and gp.Type == "Strength" then
            strengthGain = strengthGain * gp.Multiplier
        end
    end

    dataStore.IncrementValue(player, "Strength", strengthGain)

    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Strength = dataStore.GetData(player).Strength,
    })

    remotes:WaitForChild("PlayEffect"):FireClient(player, "TrainPunch", {
        Amount = strengthGain,
    })
end

function TrainingServer.HandleTrainSpeed(player, dataStore, remotes)
    local now = tick()
    local lastClick = playerClickTimestamps[player.UserId]
    if lastClick and (now - lastClick) < Config.Training.ClickCooldown then
        return
    end
    playerClickTimestamps[player.UserId] = now

    local data = dataStore.GetData(player)
    if not data then return end

    local rebirthBonus = 1 + (data.Rebirths * Config.Rebirth.RewardMultiplier)
    local speedGain = Config.Training.SpeedPerClick * rebirthBonus

    dataStore.IncrementValue(player, "Speed", speedGain)

    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Speed = dataStore.GetData(player).Speed,
    })
end

function TrainingServer.HandleBuyWeight(player, weightIndex, dataStore, remotes)
    if type(weightIndex) ~= "number" then return end
    weightIndex = math.floor(weightIndex)

    local weight = Config.Training.Weights[weightIndex]
    if not weight then return end

    local data = dataStore.GetData(player)
    if not data then return end

    if data.Strength < weight.RequiredStrength then
        remotes:WaitForChild("ShowNotification"):FireClient(player,
            "Precisa de " .. weight.RequiredStrength .. " de forca!", "error")
        return
    end

    if data.Money < weight.Cost then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    dataStore.IncrementValue(player, "Money", -weight.Cost)
    dataStore.SetValue(player, "EquippedWeight", weightIndex)

    remotes:WaitForChild("ShowNotification"):FireClient(player,
        "Comprou " .. weight.Name .. "!", "success")
    remotes:WaitForChild("PurchaseSuccess"):FireClient(player, {
        Type = "Weight",
        Index = weightIndex,
        Name = weight.Name,
    })

    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Money = dataStore.GetData(player).Money,
    })
end

function TrainingServer.CleanupPlayer(player)
    playerClickTimestamps[player.UserId] = nil
end

return TrainingServer
