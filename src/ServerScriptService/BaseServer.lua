--[[
    BaseServer.lua  v2.0
    Personal base system: level 30 max, 5 bases per server.
    Each level adds floors, storage, decorations, neon lights.
    Upgrade terminal, display stands, teleporter.
]]

local Players = game:GetService("Players")

local BaseServer = {}

local Config
local DataStoreManager
local remotesFolder

local activeBases = {}

function BaseServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local storeRemote = remotesFolder:FindFirstChild("StoreBrainrot")
    if storeRemote then
        storeRemote.OnServerEvent:Connect(function(player, inventoryIndex)
            BaseServer.StoreBrainrot(player, inventoryIndex)
        end)
    end

    local removeRemote = remotesFolder:FindFirstChild("RemoveFromBase")
    if removeRemote then
        removeRemote.OnServerEvent:Connect(function(player, storageIndex)
            BaseServer.RemoveFromBase(player, storageIndex)
        end)
    end

    local upgradeRemote = remotesFolder:FindFirstChild("UpgradeBase")
    if upgradeRemote then
        upgradeRemote.OnServerEvent:Connect(function(player, upgradeType)
            if upgradeType == "level" then
                BaseServer.LevelUpBase(player)
            else
                BaseServer.PurchaseUpgrade(player, upgradeType)
            end
        end)
    end

    local expandRemote = remotesFolder:FindFirstChild("ExpandBaseSlots")
    if expandRemote then
        expandRemote.OnServerEvent:Connect(function(player)
            BaseServer.ExpandSlots(player)
        end)
    end
end

function BaseServer.GetBaseCount()
    local count = 0
    for _ in pairs(activeBases) do count = count + 1 end
    return count
end

function BaseServer.CanClaimBase(player)
    if activeBases[player.UserId] then return true end
    return BaseServer.GetBaseCount() < Config.MAX_BASES_PER_SERVER
end

function BaseServer.ClaimBase(player)
    if not BaseServer.CanClaimBase(player) then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Servidor cheio! Max " .. Config.MAX_BASES_PER_SERVER .. " bases.")
        end
        return false
    end

    activeBases[player.UserId] = true
    return true
end

function BaseServer.ReleaseBase(player)
    activeBases[player.UserId] = nil
end

function BaseServer.GetBaseLevel(player)
    local data = DataStoreManager:GetData(player)
    if not data then return 1 end
    return data.BaseLevel or 1
end

function BaseServer.GetMaxSlots(player)
    local data = DataStoreManager:GetData(player)
    if not data then return Config.Base.StartingSlots end
    local level = data.BaseLevel or 1
    return Config.Base.StartingSlots + ((level - 1) * Config.Base.SlotsPerLevel)
end

function BaseServer.LevelUpBase(player)
    local data = DataStoreManager:GetData(player)
    if not data then return end

    local currentLevel = data.BaseLevel or 1

    if currentLevel >= Config.Base.MaxLevel then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Base ja esta no nivel maximo!")
        end
        return
    end

    local cost = Config.Base.LevelCosts[currentLevel]
    if not cost then return end

    if (data.Money or 0) < cost then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Dinheiro insuficiente! Precisa: $" .. cost)
        end
        return
    end

    data.Money = data.Money - cost
    data.BaseLevel = currentLevel + 1

    local maxSlots = BaseServer.GetMaxSlots(player)

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "success",
            "Base subiu para nivel " .. data.BaseLevel .. "! Slots: " .. maxSlots)
    end

    local syncRemote = remotesFolder:FindFirstChild("SyncBaseData")
    if syncRemote then
        syncRemote:FireClient(player, {
            Level = data.BaseLevel,
            MaxSlots = maxSlots,
            StoredBrainrots = data.StoredBrainrots,
            Upgrades = data.BaseUpgrades,
        })
    end
end

function BaseServer.StoreBrainrot(player, inventoryIndex)
    local data = DataStoreManager:GetData(player)
    if not data then return end

    inventoryIndex = tonumber(inventoryIndex)
    if not inventoryIndex or inventoryIndex < 1 then return end
    if not data.Inventory or inventoryIndex > #data.Inventory then return end

    if not data.StoredBrainrots then data.StoredBrainrots = {} end

    local maxSlots = BaseServer.GetMaxSlots(player)
    if #data.StoredBrainrots >= maxSlots then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Base cheia! Max " .. maxSlots .. " slots.")
        end
        return
    end

    local item = table.remove(data.Inventory, inventoryIndex)
    table.insert(data.StoredBrainrots, item)

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "success", item.Name .. " armazenado na base!")
    end

    local syncRemote = remotesFolder:FindFirstChild("SyncBaseData")
    if syncRemote then
        syncRemote:FireClient(player, {
            Level = data.BaseLevel or 1,
            MaxSlots = maxSlots,
            StoredBrainrots = data.StoredBrainrots,
            Upgrades = data.BaseUpgrades,
        })
    end
end

function BaseServer.RemoveFromBase(player, storageIndex)
    local data = DataStoreManager:GetData(player)
    if not data then return end

    storageIndex = tonumber(storageIndex)
    if not storageIndex or storageIndex < 1 then return end
    if not data.StoredBrainrots or storageIndex > #data.StoredBrainrots then return end

    local item = table.remove(data.StoredBrainrots, storageIndex)
    if not data.Inventory then data.Inventory = {} end
    table.insert(data.Inventory, item)

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "success", item.Name .. " movido para inventario!")
    end
end

function BaseServer.PurchaseUpgrade(player, upgradeName)
    local data = DataStoreManager:GetData(player)
    if not data then return end

    local upgradeConfig = nil
    for _, upg in ipairs(Config.Base.Upgrades) do
        if upg.Name == upgradeName then
            upgradeConfig = upg
            break
        end
    end

    if not upgradeConfig then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Upgrade invalido!")
        end
        return
    end

    local baseLevel = data.BaseLevel or 1
    if baseLevel < (upgradeConfig.MinLevel or 1) then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Base precisa estar no nivel " .. upgradeConfig.MinLevel .. "!")
        end
        return
    end

    if not data.BaseUpgrades then data.BaseUpgrades = {} end
    if data.BaseUpgrades[upgradeName] then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Upgrade ja comprado!")
        end
        return
    end

    if (data.Money or 0) < upgradeConfig.Cost then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Dinheiro insuficiente! Precisa: $" .. upgradeConfig.Cost)
        end
        return
    end

    data.Money = data.Money - upgradeConfig.Cost
    data.BaseUpgrades[upgradeName] = true

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "success", "Upgrade '" .. upgradeName .. "' comprado!")
    end
end

function BaseServer.ExpandSlots(player)
    local data = DataStoreManager:GetData(player)
    if not data then return end

    local maxSlots = BaseServer.GetMaxSlots(player)
    local currentSlots = data.BaseSlots or Config.Base.StartingSlots

    if currentSlots >= maxSlots then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Ja atingiu o maximo de slots para este nivel! Suba de nivel para mais.")
        end
        return
    end
end

return BaseServer
