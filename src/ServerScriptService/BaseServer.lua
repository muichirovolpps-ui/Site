--[[
    BaseServer.lua (ServerScriptService)
    Handles personal base system: storage, upgrades, slot expansion.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))

local BaseServer = {}

function BaseServer.Initialize(remotes, dataStore)
    local storeRemote = remotes:WaitForChild("StoreBrainrot")
    local removeRemote = remotes:WaitForChild("RemoveFromBase")
    local upgradeRemote = remotes:WaitForChild("UpgradeBase")
    local expandRemote = remotes:WaitForChild("ExpandBaseSlots")
    local getBaseData = remotes:WaitForChild("GetBaseData")

    storeRemote.OnServerEvent:Connect(function(player, inventoryIndex)
        BaseServer.HandleStore(player, inventoryIndex, dataStore, remotes)
    end)

    removeRemote.OnServerEvent:Connect(function(player, storedIndex)
        BaseServer.HandleRemove(player, storedIndex, dataStore, remotes)
    end)

    upgradeRemote.OnServerEvent:Connect(function(player, upgradeIndex)
        BaseServer.HandleUpgrade(player, upgradeIndex, dataStore, remotes)
    end)

    expandRemote.OnServerEvent:Connect(function(player)
        BaseServer.HandleExpand(player, dataStore, remotes)
    end)

    getBaseData.OnServerInvoke = function(player)
        return BaseServer.GetBaseInfo(player, dataStore)
    end
end

function BaseServer.HandleStore(player, inventoryIndex, dataStore, remotes)
    if type(inventoryIndex) ~= "number" then return end
    inventoryIndex = math.floor(inventoryIndex)

    local success = dataStore.StoreBrainrotInBase(player, inventoryIndex)
    if success then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Brainrot armazenado na base!", "success")
        remotes:WaitForChild("SyncBaseData"):FireClient(player, BaseServer.GetBaseInfo(player, dataStore))
        remotes:WaitForChild("SyncInventory"):FireClient(player, dataStore.GetData(player).Inventory)
    else
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Base cheia! Expanda seus slots.", "error")
    end
end

function BaseServer.HandleRemove(player, storedIndex, dataStore, remotes)
    if type(storedIndex) ~= "number" then return end
    storedIndex = math.floor(storedIndex)

    local success = dataStore.RemoveFromBase(player, storedIndex)
    if success then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Brainrot removido da base!", "success")
        remotes:WaitForChild("SyncBaseData"):FireClient(player, BaseServer.GetBaseInfo(player, dataStore))
        remotes:WaitForChild("SyncInventory"):FireClient(player, dataStore.GetData(player).Inventory)
    end
end

function BaseServer.HandleUpgrade(player, upgradeIndex, dataStore, remotes)
    if type(upgradeIndex) ~= "number" then return end
    upgradeIndex = math.floor(upgradeIndex)

    local upgrade = Config.Base.Upgrades[upgradeIndex]
    if not upgrade then return end

    local data = dataStore.GetData(player)
    if not data then return end

    if data.BaseUpgrades[tostring(upgradeIndex)] then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Ja comprado!", "error")
        return
    end

    if data.Money < upgrade.Cost then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    dataStore.IncrementValue(player, "Money", -upgrade.Cost)
    data.BaseUpgrades[tostring(upgradeIndex)] = true

    remotes:WaitForChild("ShowNotification"):FireClient(player,
        "Comprou " .. upgrade.Name .. "!", "success")

    remotes:WaitForChild("SyncBaseData"):FireClient(player, BaseServer.GetBaseInfo(player, dataStore))
    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Money = dataStore.GetData(player).Money,
    })
end

function BaseServer.HandleExpand(player, dataStore, remotes)
    local data = dataStore.GetData(player)
    if not data then return end

    if data.BaseSlots >= Config.Base.MaxSlots then
        remotes:WaitForChild("ShowNotification"):FireClient(player, "Slots no maximo!", "error")
        return
    end

    local expansions = data.BaseSlots - Config.Base.StartingSlots
    local cost = math.floor(Config.Base.SlotUpgradeCost * (Config.Base.SlotCostMultiplier ^ expansions))

    if data.Money < cost then
        remotes:WaitForChild("ShowNotification"):FireClient(player,
            "Precisa de $" .. cost .. " para expandir!", "error")
        return
    end

    dataStore.IncrementValue(player, "Money", -cost)
    dataStore.SetValue(player, "BaseSlots", data.BaseSlots + 4)

    remotes:WaitForChild("ShowNotification"):FireClient(player,
        "Base expandida! Agora tem " .. (data.BaseSlots + 4) .. " slots!", "success")

    remotes:WaitForChild("SyncBaseData"):FireClient(player, BaseServer.GetBaseInfo(player, dataStore))
    remotes:WaitForChild("UpdatePlayerStats"):FireClient(player, {
        Money = dataStore.GetData(player).Money,
    })
end

function BaseServer.GetBaseInfo(player, dataStore)
    local data = dataStore.GetData(player)
    if not data then return {} end

    local expansions = data.BaseSlots - Config.Base.StartingSlots
    local nextExpandCost = math.floor(Config.Base.SlotUpgradeCost * (Config.Base.SlotCostMultiplier ^ expansions))

    return {
        Slots = data.BaseSlots,
        MaxSlots = Config.Base.MaxSlots,
        StoredBrainrots = data.StoredBrainrots,
        Upgrades = data.BaseUpgrades,
        AvailableUpgrades = Config.Base.Upgrades,
        NextExpandCost = nextExpandCost,
    }
end

return BaseServer
