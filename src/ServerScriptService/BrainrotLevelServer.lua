--[[
    BrainrotLevelServer.lua  v2.0
    Brainrot leveling system: upgrade brainrots with money.
    Higher level = better passive income, stronger multipliers, better effects.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BrainrotLevelServer = {}

local Config
local DataStoreManager
local remotesFolder

function BrainrotLevelServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local upgradeRemote = remotesFolder:FindFirstChild("UpgradeBrainrot")
    if not upgradeRemote then
        upgradeRemote = Instance.new("RemoteEvent")
        upgradeRemote.Name = "UpgradeBrainrot"
        upgradeRemote.Parent = remotesFolder
    end

    local getBrainrotLevelFunc = remotesFolder:FindFirstChild("GetBrainrotLevel")
    if not getBrainrotLevelFunc then
        getBrainrotLevelFunc = Instance.new("RemoteFunction")
        getBrainrotLevelFunc.Name = "GetBrainrotLevel"
        getBrainrotLevelFunc.Parent = remotesFolder
    end

    upgradeRemote.OnServerEvent:Connect(function(player, inventoryIndex)
        BrainrotLevelServer.UpgradeBrainrot(player, inventoryIndex)
    end)

    getBrainrotLevelFunc.OnServerInvoke = function(player, inventoryIndex)
        return BrainrotLevelServer.GetLevelInfo(player, inventoryIndex)
    end
end

function BrainrotLevelServer.GetUpgradeCost(currentLevel)
    return math.floor(Config.BrainrotLeveling.BaseCost * (Config.BrainrotLeveling.CostMultiplier ^ (currentLevel - 1)))
end

function BrainrotLevelServer.GetIncomeMultiplier(level)
    return 1 + (level - 1) * Config.BrainrotLeveling.IncomePerLevel
end

function BrainrotLevelServer.GetStatMultiplier(level)
    return 1 + (level - 1) * Config.BrainrotLeveling.MultiplierPerLevel
end

function BrainrotLevelServer.GetLevelInfo(player, inventoryIndex)
    local data = DataStoreManager:GetData(player)
    if not data or not data.Inventory then return nil end

    inventoryIndex = tonumber(inventoryIndex)
    if not inventoryIndex or inventoryIndex < 1 or inventoryIndex > #data.Inventory then return nil end

    local item = data.Inventory[inventoryIndex]
    local level = item.Level or 1
    local cost = BrainrotLevelServer.GetUpgradeCost(level)
    local incomeMultiplier = BrainrotLevelServer.GetIncomeMultiplier(level)
    local statMultiplier = BrainrotLevelServer.GetStatMultiplier(level)
    local maxLevel = Config.BrainrotLeveling.MaxLevel

    return {
        Level = level,
        Cost = cost,
        IncomeMultiplier = incomeMultiplier,
        StatMultiplier = statMultiplier,
        MaxLevel = maxLevel,
        IsMaxed = level >= maxLevel,
    }
end

function BrainrotLevelServer.UpgradeBrainrot(player, inventoryIndex)
    local data = DataStoreManager:GetData(player)
    if not data or not data.Inventory then return end

    inventoryIndex = tonumber(inventoryIndex)
    if not inventoryIndex or inventoryIndex < 1 or inventoryIndex > #data.Inventory then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Item invalido!")
        end
        return
    end

    local item = data.Inventory[inventoryIndex]
    local currentLevel = item.Level or 1

    if currentLevel >= Config.BrainrotLeveling.MaxLevel then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Brainrot ja esta no nivel maximo!")
        end
        return
    end

    local cost = BrainrotLevelServer.GetUpgradeCost(currentLevel)

    if (data.Money or 0) < cost then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Dinheiro insuficiente! Precisa: $" .. cost)
        end
        return
    end

    data.Money = data.Money - cost
    item.Level = currentLevel + 1

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "success", item.Name .. " subiu para nivel " .. item.Level .. "!")
    end

    local purchaseRemote = remotesFolder:FindFirstChild("PurchaseSuccess")
    if purchaseRemote then
        purchaseRemote:FireClient(player, "BrainrotUpgrade", item.Name, item.Level)
    end
end

function BrainrotLevelServer.CalculatePassiveIncome(data)
    local totalIncome = 0

    if data.Inventory then
        local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))
        for _, item in ipairs(data.Inventory) do
            local brainrotData = BrainrotDB.GetBrainrot(item.Rarity or "Basico", item.Name)
            if brainrotData then
                local level = item.Level or 1
                local baseValue = brainrotData.Value or 1
                local incomeMultiplier = BrainrotLevelServer.GetIncomeMultiplier(level)
                local mutationMult = 1

                if item.Mutation and item.Mutation ~= "None" then
                    for _, mut in ipairs(Config.Mutations) do
                        if mut.Name == item.Mutation then
                            mutationMult = mut.ValueMultiplier
                            break
                        end
                    end
                end

                totalIncome = totalIncome + (baseValue * incomeMultiplier * mutationMult * 0.1)
            end
        end
    end

    if data.StoredBrainrots then
        local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))
        for _, item in ipairs(data.StoredBrainrots) do
            local brainrotData = BrainrotDB.GetBrainrot(item.Rarity or "Basico", item.Name)
            if brainrotData then
                local level = item.Level or 1
                local baseValue = brainrotData.Value or 1
                local incomeMultiplier = BrainrotLevelServer.GetIncomeMultiplier(level)
                totalIncome = totalIncome + (baseValue * incomeMultiplier * 0.05)
            end
        end
    end

    return totalIncome
end

return BrainrotLevelServer
