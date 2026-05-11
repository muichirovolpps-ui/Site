--[[
    ShopServer.lua  v3.0
    Handles shop purchases: speed upgrades, luck boosts, and gamepass validation.
    Fixed: uses v3 Initialize(cfg, ds, remotesFolder) signature and direct data mutation.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local ShopServer = {}

local config = nil
local dsManager = nil
local remotesFolder = nil

function ShopServer.Initialize(cfg, ds, remotes)
    config = cfg
    dsManager = ds
    remotesFolder = remotes

    local buySpeed = remotesFolder:WaitForChild("BuySpeedUpgrade")
    local buyLuck = remotesFolder:WaitForChild("BuyLuckBoost")

    buySpeed.OnServerEvent:Connect(function(player, upgradeIndex)
        ShopServer.HandleBuySpeed(player, upgradeIndex)
    end)

    buyLuck.OnServerEvent:Connect(function(player, boostIndex)
        ShopServer.HandleBuyLuck(player, boostIndex)
    end)

    local getShopData = remotesFolder:WaitForChild("GetShopData")
    getShopData.OnServerInvoke = function(player)
        return ShopServer.GetShopInfo(player)
    end

    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, purchased)
        if purchased then
            ShopServer.HandleGamepassPurchased(player, gamePassId)
        end
    end)
end

function ShopServer.HandleBuySpeed(player, upgradeIndex)
    if type(upgradeIndex) ~= "number" then return end
    upgradeIndex = math.floor(upgradeIndex)

    local upgrade = config.ShopItems.SpeedUpgrades[upgradeIndex]
    if not upgrade then return end

    local data = dsManager:GetData(player)
    if not data then return end

    if not data.SpeedUpgradesBought then data.SpeedUpgradesBought = {} end

    if data.SpeedUpgradesBought[tostring(upgradeIndex)] then
        remotesFolder:FindFirstChild("ShowNotification"):FireClient(player, "Ja comprado!", "error")
        return
    end

    if (data.Money or 0) < upgrade.Cost then
        remotesFolder:FindFirstChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    data.Money = data.Money - upgrade.Cost
    data.Speed = (data.Speed or 0) + upgrade.SpeedBoost
    data.SpeedUpgradesBought[tostring(upgradeIndex)] = true

    remotesFolder:FindFirstChild("ShowNotification"):FireClient(player, "Comprou " .. upgrade.Name .. "!", "success")
    remotesFolder:FindFirstChild("PurchaseSuccess"):FireClient(player, {
        Type = "SpeedUpgrade",
        Index = upgradeIndex,
        Name = upgrade.Name,
    })

    remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
        Money = data.Money,
        Speed = data.Speed,
    })
end

function ShopServer.HandleBuyLuck(player, boostIndex)
    if type(boostIndex) ~= "number" then return end
    boostIndex = math.floor(boostIndex)

    local boost = config.ShopItems.LuckBoosts[boostIndex]
    if not boost then return end

    local data = dsManager:GetData(player)
    if not data then return end

    if (data.Money or 0) < boost.Cost then
        remotesFolder:FindFirstChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    data.Money = data.Money - boost.Cost
    data.Luck = (data.Luck or config.STARTING_LUCK) + boost.LuckBoost

    if not data.LuckBoosts then data.LuckBoosts = {} end
    table.insert(data.LuckBoosts, {
        Index = boostIndex,
        Bonus = boost.LuckBoost,
        BoughtAt = os.time(),
    })

    remotesFolder:FindFirstChild("ShowNotification"):FireClient(player,
        boost.Name .. " ativado!", "success")

    remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
        Money = data.Money,
        Luck = data.Luck,
    })
end

function ShopServer.HandleGamepassPurchased(player, gamePassId)
    local data = dsManager:GetData(player)
    if not data then return end

    if not data.Gamepasses then data.Gamepasses = {} end

    for _, gp in ipairs(config.Gamepasses) do
        if gp.Id == gamePassId then
            local alreadyOwned = false
            for _, saved in ipairs(data.Gamepasses) do
                if saved == gp.Name then alreadyOwned = true break end
            end
            if not alreadyOwned then
                table.insert(data.Gamepasses, gp.Name)
            end
            remotesFolder:FindFirstChild("ShowNotification"):FireClient(player,
                "Gamepass " .. gp.Name .. " ativado!", "success")
            break
        end
    end
end

function ShopServer.GetShopInfo(player)
    local data = dsManager:GetData(player)
    if not data then return {} end

    return {
        SpeedUpgrades = config.ShopItems.SpeedUpgrades,
        LuckBoosts = config.ShopItems.LuckBoosts,
        Gamepasses = config.Gamepasses,
        BoughtSpeedUpgrades = data.SpeedUpgradesBought or {},
        ActiveLuckBoosts = data.LuckBoosts or {},
        OwnedGamepasses = data.Gamepasses or {},
        Weights = config.Training.Weights,
        EquippedWeight = data.EquippedWeight or 1,
    }
end

return ShopServer
