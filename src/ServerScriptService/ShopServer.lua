--[[
    ShopServer.lua (ServerScriptService)
    Handles shop purchases: speed upgrades, luck boosts, and gamepass validation.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))

local ShopServer = {}

function ShopServer.Initialize(remotes, dataStore)
    local buySpeed = remotes:WaitForChild("BuySpeedUpgrade")
    local buyLuck = remotes:WaitForChild("BuyLuckBoost")

    buySpeed.OnServerEvent:Connect(function(player, upgradeIndex)
        ShopServer.HandleBuySpeed(player, upgradeIndex, dataStore, remotes)
    end)

    buyLuck.OnServerEvent:Connect(function(player, boostIndex)
        ShopServer.HandleBuyLuck(player, boostIndex, dataStore, remotes)
    end)

    local getShopData = remotes:WaitForChild("GetShopData")
    getShopData.OnServerInvoke = function(player)
        return ShopServer.GetShopInfo(player, dataStore)
    end

    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, purchased)
        if purchased then
            ShopServer.HandleGamepassPurchased(player, gamePassId, dataStore, remotes)
        end
    end)
end

function ShopServer.HandleBuySpeed(player, upgradeIndex, dataStore, remotes)
    if type(upgradeIndex) ~= "number" then return end
    upgradeIndex = math.floor(upgradeIndex)

    local upgrade = Config.ShopItems.SpeedUpgrades[upgradeIndex]
    if not upgrade then return end

    local data = dataStore.GetData(player)
    if not data then return end

    if data.SpeedUpgradesBought[tostring(upgradeIndex)] then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Ja comprado!", "error")
        return
    end

    if data.Money < upgrade.Cost then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    dataStore.IncrementValue(player, "Money", -upgrade.Cost)
    dataStore.IncrementValue(player, "Speed", upgrade.Bonus)
    data.SpeedUpgradesBought[tostring(upgradeIndex)] = true

    remotes:WaitForChild("ShowNotification"):FireClient(player, "Comprou " .. upgrade.Name .. "!", "success")
    remotes:WaitForChild("PurchaseSuccess"):FireClient(player, {
        Type = "SpeedUpgrade",
        Index = upgradeIndex,
        Name = upgrade.Name,
    })

    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Money = dataStore.GetData(player).Money,
        Speed = dataStore.GetData(player).Speed,
    })
end

function ShopServer.HandleBuyLuck(player, boostIndex, dataStore, remotes)
    if type(boostIndex) ~= "number" then return end
    boostIndex = math.floor(boostIndex)

    local boost = Config.ShopItems.LuckBoosts[boostIndex]
    if not boost then return end

    local data = dataStore.GetData(player)
    if not data then return end

    if data.Money < boost.Cost then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    dataStore.IncrementValue(player, "Money", -boost.Cost)

    local currentLuck = data.Luck or Config.STARTING_LUCK
    dataStore.SetValue(player, "Luck", currentLuck + boost.Bonus)

    table.insert(data.LuckBoosts, {
        Index = boostIndex,
        Bonus = boost.Bonus,
        ExpiresAt = os.time() + boost.Duration,
    })

    remotes:WaitForChild("ShowNotification"):FireClient(player,
        boost.Name .. " ativado por " .. math.floor(boost.Duration / 60) .. " minutos!", "success")

    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Money = dataStore.GetData(player).Money,
        Luck = dataStore.GetData(player).Luck,
    })

    task.delay(boost.Duration, function()
        if player.Parent then
            local latestData = dataStore.GetData(player)
            if latestData then
                local newLuck = math.max(Config.STARTING_LUCK, (latestData.Luck or Config.STARTING_LUCK) - boost.Bonus)
                dataStore.SetValue(player, "Luck", newLuck)
                remotes:WaitForChild("ShowNotification"):FireClient(player, boost.Name .. " expirou!", "warning")
                remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
                    Luck = newLuck,
                })
            end
        end
    end)
end

function ShopServer.HandleGamepassPurchased(player, gamePassId, dataStore, remotes)
    local data = dataStore.GetData(player)
    if not data then return end

    for _, gp in ipairs(Config.Gamepasses) do
        if gp.Id == gamePassId then
            data.Gamepasses[gp.Name] = true
            remotes:WaitForChild("ShowNotification"):FireClient(player,
                "Gamepass " .. gp.Name .. " ativado!", "success")
            break
        end
    end
end

function ShopServer.GetShopInfo(player, dataStore)
    local data = dataStore.GetData(player)
    if not data then return {} end

    return {
        SpeedUpgrades = Config.ShopItems.SpeedUpgrades,
        LuckBoosts = Config.ShopItems.LuckBoosts,
        Gamepasses = Config.Gamepasses,
        BoughtSpeedUpgrades = data.SpeedUpgradesBought,
        ActiveLuckBoosts = data.LuckBoosts,
        OwnedGamepasses = data.Gamepasses,
        Weights = Config.Training.Weights,
        EquippedWeight = data.EquippedWeight,
    }
end

return ShopServer
