--[[
    RebirthServer.lua (ServerScriptService)
    Handles rebirth logic: requirements, reset, and permanent bonuses.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))

local RebirthServer = {}

function RebirthServer.Initialize(remotes, dataStore)
    local rebirthRemote = remotes:WaitForChild("RequestRebirth")

    rebirthRemote.OnServerEvent:Connect(function(player)
        RebirthServer.HandleRebirth(player, dataStore, remotes)
    end)
end

function RebirthServer.GetRequirement(currentRebirths)
    return math.floor(Config.Rebirth.BaseRequirement * (Config.Rebirth.RequirementMultiplier ^ currentRebirths))
end

function RebirthServer.HandleRebirth(player, dataStore, remotes)
    local data = dataStore.GetData(player)
    if not data then return end

    if data.Rebirths >= Config.Rebirth.MaxRebirths then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Rebirth maximo atingido!", "error")
        return
    end

    local requirement = RebirthServer.GetRequirement(data.Rebirths)

    if data.Strength < requirement then
        remotes:WaitForChild("ShowNotification"):FireClient(player,
            "Precisa de " .. requirement .. " de forca para rebirth!", "error")
        return
    end

    local newRebirths = data.Rebirths + 1

    dataStore.SetValue(player, "Money", Config.STARTING_MONEY)
    dataStore.SetValue(player, "Strength", Config.STARTING_STRENGTH)
    dataStore.SetValue(player, "Speed", Config.STARTING_SPEED)
    dataStore.SetValue(player, "Luck", Config.STARTING_LUCK + (newRebirths * Config.Rebirth.LuckBonus))
    dataStore.SetValue(player, "Rebirths", newRebirths)
    dataStore.SetValue(player, "EquippedWeight", 1)
    data.SpeedUpgradesBought = {}

    remotes:WaitForChild("RebirthSuccess"):FireClient(player, {
        Rebirths = newRebirths,
        Multiplier = 1 + (newRebirths * Config.Rebirth.RewardMultiplier),
        LuckBonus = newRebirths * Config.Rebirth.LuckBonus,
        NextRequirement = RebirthServer.GetRequirement(newRebirths),
    })

    remotes:WaitForChild("ShowNotification"):FireClient(player,
        "REBIRTH #" .. newRebirths .. "! Multiplicador: " ..
        string.format("%.1fx", 1 + (newRebirths * Config.Rebirth.RewardMultiplier)), "success")

    remotes:WaitForChild("PlayEffect"):FireClient(player, "RebirthExplosion", {})

    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Money = Config.STARTING_MONEY,
        Strength = Config.STARTING_STRENGTH,
        Speed = Config.STARTING_SPEED,
        Luck = Config.STARTING_LUCK + (newRebirths * Config.Rebirth.LuckBonus),
        Rebirths = newRebirths,
    })
end

return RebirthServer
