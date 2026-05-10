--[[
    DataStoreManager.lua (ServerScriptService)
    Handles all player data saving/loading with retry and auto-save.
    Uses ProfileService-style patterns for reliability.
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))

local DataStoreManager = {}
DataStoreManager.__index = DataStoreManager

local DATA_STORE_NAME = "TreineLuckyBlockData_v1"
local MAX_RETRIES = 3
local RETRY_DELAY = 1

local playerDataStore = DataStoreService:GetDataStore(DATA_STORE_NAME)
local playerDataCache = {}

local DEFAULT_DATA = {
    Money = Config.STARTING_MONEY,
    Strength = Config.STARTING_STRENGTH,
    Speed = Config.STARTING_SPEED,
    Luck = Config.STARTING_LUCK,
    Rebirths = Config.STARTING_REBIRTHS,
    EquippedWeight = 1,
    Inventory = {},
    EquippedBrainrot = "",
    DiscoveredBrainrots = {},
    BaseSlots = Config.Base.StartingSlots,
    BaseUpgrades = {},
    StoredBrainrots = {},
    SpeedUpgradesBought = {},
    LuckBoosts = {},
    TotalKicks = 0,
    TotalPerfects = 0,
    PlayTime = 0,
    Gamepasses = {},
}

local function deepCopyDefault()
    local copy = {}
    for k, v in pairs(DEFAULT_DATA) do
        if type(v) == "table" then
            copy[k] = {}
            for kk, vv in pairs(v) do
                copy[kk] = vv
            end
        else
            copy[k] = v
        end
    end
    return copy
end

local function reconcileData(saved)
    local data = deepCopyDefault()
    if saved then
        for k, v in pairs(saved) do
            data[k] = v
        end
    end
    return data
end

function DataStoreManager.LoadData(player)
    local key = "Player_" .. player.UserId
    local data = nil

    for attempt = 1, MAX_RETRIES do
        local success, result = pcall(function()
            return playerDataStore:GetAsync(key)
        end)

        if success then
            data = result
            break
        else
            warn("[DataStore] Load attempt " .. attempt .. " failed for " .. player.Name .. ": " .. tostring(result))
            if attempt < MAX_RETRIES then
                task.wait(RETRY_DELAY)
            end
        end
    end

    local playerData = reconcileData(data)
    playerDataCache[player.UserId] = playerData

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local moneyStat = Instance.new("IntValue")
    moneyStat.Name = "Money"
    moneyStat.Value = playerData.Money
    moneyStat.Parent = leaderstats

    local strengthStat = Instance.new("IntValue")
    strengthStat.Name = "Strength"
    strengthStat.Value = playerData.Strength
    strengthStat.Parent = leaderstats

    local rebirthStat = Instance.new("IntValue")
    rebirthStat.Name = "Rebirths"
    rebirthStat.Value = playerData.Rebirths
    rebirthStat.Parent = leaderstats

    return playerData
end

function DataStoreManager.SaveData(player)
    local data = playerDataCache[player.UserId]
    if not data then return false end

    local key = "Player_" .. player.UserId

    for attempt = 1, MAX_RETRIES do
        local success, err = pcall(function()
            playerDataStore:SetAsync(key, data)
        end)

        if success then
            return true
        else
            warn("[DataStore] Save attempt " .. attempt .. " failed for " .. player.Name .. ": " .. tostring(err))
            if attempt < MAX_RETRIES then
                task.wait(RETRY_DELAY)
            end
        end
    end

    return false
end

function DataStoreManager.GetData(player)
    return playerDataCache[player.UserId]
end

function DataStoreManager.SetValue(player, key, value)
    local data = playerDataCache[player.UserId]
    if not data then return end
    data[key] = value

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local stat = leaderstats:FindFirstChild(key)
        if stat then
            stat.Value = value
        end
    end
end

function DataStoreManager.IncrementValue(player, key, amount)
    local data = playerDataCache[player.UserId]
    if not data then return end
    data[key] = (data[key] or 0) + amount

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local stat = leaderstats:FindFirstChild(key)
        if stat then
            stat.Value = data[key]
        end
    end

    return data[key]
end

function DataStoreManager.AddToInventory(player, brainrotName, rarity, mutation)
    local data = playerDataCache[player.UserId]
    if not data then return end

    local entry = {
        Name = brainrotName,
        Rarity = rarity,
        Mutation = mutation or "None",
        ObtainedAt = os.time(),
    }
    table.insert(data.Inventory, entry)

    if not data.DiscoveredBrainrots[rarity] then
        data.DiscoveredBrainrots[rarity] = {}
    end
    data.DiscoveredBrainrots[rarity][brainrotName] = true

    return entry
end

function DataStoreManager.StoreBrainrotInBase(player, inventoryIndex)
    local data = playerDataCache[player.UserId]
    if not data then return false end
    if #data.StoredBrainrots >= data.BaseSlots then return false end

    local item = data.Inventory[inventoryIndex]
    if not item then return false end

    table.remove(data.Inventory, inventoryIndex)
    table.insert(data.StoredBrainrots, item)
    return true
end

function DataStoreManager.RemoveFromBase(player, storedIndex)
    local data = playerDataCache[player.UserId]
    if not data then return false end

    local item = data.StoredBrainrots[storedIndex]
    if not item then return false end

    table.remove(data.StoredBrainrots, storedIndex)
    table.insert(data.Inventory, item)
    return true
end

function DataStoreManager.ClearPlayerCache(player)
    playerDataCache[player.UserId] = nil
end

function DataStoreManager.Initialize()
    Players.PlayerAdded:Connect(function(player)
        DataStoreManager.LoadData(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        DataStoreManager.SaveData(player)
        DataStoreManager.ClearPlayerCache(player)
    end)

    task.spawn(function()
        while true do
            task.wait(Config.AUTO_SAVE_INTERVAL)
            for _, player in ipairs(Players:GetPlayers()) do
                task.spawn(function()
                    DataStoreManager.SaveData(player)
                end)
            end
        end
    end)

    game:BindToClose(function()
        for _, player in ipairs(Players:GetPlayers()) do
            DataStoreManager.SaveData(player)
        end
    end)
end

return DataStoreManager
