--[[
    RebirthServer.lua  v2.0
    Reworked rebirth: max 30, requires BOTH strength AND money.
    Gives permanent money multiplier, strength bonus, luck bonus.
    Unlocks better arenas and brainrots.
]]

local RebirthServer = {}

local Config
local DataStoreManager
local remotesFolder

function RebirthServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local rebirthRemote = remotesFolder:FindFirstChild("RequestRebirth")
    if rebirthRemote then
        rebirthRemote.OnServerEvent:Connect(function(player)
            RebirthServer.ProcessRebirth(player)
        end)
    end
end

function RebirthServer.GetRequirements(rebirthLevel)
    local reqs = Config.Rebirth.Requirements
    local idx = math.min(rebirthLevel + 1, #reqs)
    return reqs[idx]
end

function RebirthServer.CanRebirth(player)
    local data = DataStoreManager:GetData(player)
    if not data then return false, "Dados nao carregados." end

    local currentRebirths = data.Rebirths or 0
    if currentRebirths >= Config.Rebirth.MaxRebirths then
        return false, "Ja atingiu o rebirth maximo (" .. Config.Rebirth.MaxRebirths .. ")!"
    end

    local req = RebirthServer.GetRequirements(currentRebirths)
    if not req then return false, "Erro nos requisitos." end

    if (data.Strength or 0) < req.Strength then
        return false, "Forca insuficiente! Precisa: " .. req.Strength
    end

    if (data.Money or 0) < req.Money then
        return false, "Dinheiro insuficiente! Precisa: $" .. req.Money
    end

    return true, ""
end

function RebirthServer.ProcessRebirth(player)
    local canRebirth, reason = RebirthServer.CanRebirth(player)

    if not canRebirth then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", reason)
        end
        return
    end

    local data = DataStoreManager:GetData(player)
    if not data then return end

    local currentRebirths = data.Rebirths or 0
    local req = RebirthServer.GetRequirements(currentRebirths)

    data.Money = Config.STARTING_MONEY
    data.Strength = Config.STARTING_STRENGTH
    data.Speed = Config.STARTING_SPEED
    data.Rebirths = currentRebirths + 1
    data.EquippedWeight = 1
    data.SpeedUpgradesBought = {}
    data.LuckBoosts = {}

    data.Luck = Config.STARTING_LUCK + (data.Rebirths * Config.Rebirth.LuckBonusPerRebirth)

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "success",
            "REBIRTH " .. data.Rebirths .. "! +" ..
            Config.Rebirth.MoneyMultiplierPerRebirth .. "x Money, +" ..
            (Config.Rebirth.StrengthBonusPerRebirth * 100) .. "% Forca, +" ..
            Config.Rebirth.LuckBonusPerRebirth .. " Sorte!")
    end

    local rebirthSuccessRemote = remotesFolder:FindFirstChild("RebirthSuccess")
    if rebirthSuccessRemote then
        rebirthSuccessRemote:FireClient(player, data.Rebirths)
    end

    local statsRemote = remotesFolder:FindFirstChild("UpdatePlayerStats")
    if statsRemote then
        statsRemote:FireClient(player, {
            Money = data.Money,
            Strength = data.Strength,
            Speed = data.Speed,
            Luck = data.Luck,
            Rebirths = data.Rebirths,
        })
    end
end

function RebirthServer.GetMoneyMultiplier(data)
    local rebirths = data.Rebirths or 0
    return 1 + (rebirths * Config.Rebirth.MoneyMultiplierPerRebirth)
end

function RebirthServer.GetStrengthMultiplier(data)
    local rebirths = data.Rebirths or 0
    return 1 + (rebirths * Config.Rebirth.StrengthBonusPerRebirth)
end

return RebirthServer
