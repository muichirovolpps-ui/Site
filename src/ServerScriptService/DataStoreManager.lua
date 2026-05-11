--[[
    DataStoreManager.lua  v3.0
    Handles all player data persistence with DataStore.
    Auto-save, data reconciliation, retry logic.
    v3: Added Gems, Quests, SpinData, OwnedEmotes, Rank, Achievements, etc.
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local DataStoreManager = {}
DataStoreManager.__index = DataStoreManager

local MAX_RETRIES = 3
local dataStore

local DEFAULT_DATA = {
    Money = 100,
    Strength = 1,
    Speed = 1,
    Luck = 1,
    Rebirths = 0,
    Gems = 0,
    EquippedWeight = 1,
    Inventory = {},
    EquippedBrainrot = "",
    DiscoveredBrainrots = {},
    BaseSlots = 4,
    BaseLevel = 1,
    BaseUpgrades = {},
    StoredBrainrots = {},
    SpeedUpgradesBought = {},
    LuckBoosts = {},
    TotalKicks = 0,
    TotalPerfects = 0,
    PlayTime = 0,
    Gamepasses = {},
    LastOnlineTime = 0,
    TotalDistance = 0,
    BestDistance = 0,
    Rank = "Noob",
    OwnedEmotes = {},
    Quests = { Daily = {}, Weekly = {}, LastDailyReset = 0, LastWeeklyReset = 0 },
    SpinData = { LastFreeSpin = 0, TotalSpins = 0 },
    FoundSecrets = {},
    Achievements = {},
    BossKills = 0,
    EventsCompleted = 0,
    FreeSpins = 0,
}

function DataStoreManager.new(config)
    local self = setmetatable({}, DataStoreManager)
    self.Config = config
    self.PlayerData = {}
    self.SaveInterval = config.AUTO_SAVE_INTERVAL or 60

    local success, store = pcall(function()
        return DataStoreService:GetDataStore("TreineParaChutar_v3")
    end)

    if success then
        dataStore = store
    else
        warn("[DataStore] Failed to get DataStore: " .. tostring(store))
    end

    self:StartAutoSave()
    return self
end

function DataStoreManager:Reconcile(data)
    for key, defaultValue in pairs(DEFAULT_DATA) do
        if data[key] == nil then
            if type(defaultValue) == "table" then
                data[key] = {}
            else
                data[key] = defaultValue
            end
        end
    end
    return data
end

function DataStoreManager:LoadData(player)
    if not dataStore then
        self.PlayerData[player.UserId] = self:Reconcile({})
        return self.PlayerData[player.UserId]
    end

    local data
    for attempt = 1, MAX_RETRIES do
        local success, result = pcall(function()
            return dataStore:GetAsync("Player_" .. player.UserId)
        end)

        if success then
            data = result
            break
        else
            warn("[DataStore] Load attempt " .. attempt .. " failed for " .. player.Name .. ": " .. tostring(result))
            if attempt < MAX_RETRIES then task.wait(1) end
        end
    end

    if not data then
        data = {}
    end

    data = self:Reconcile(data)
    self.PlayerData[player.UserId] = data

    self:CreateLeaderStats(player, data)

    return data
end

function DataStoreManager:SaveData(player)
    if not dataStore then return false end

    local data = self.PlayerData[player.UserId]
    if not data then return false end

    for attempt = 1, MAX_RETRIES do
        local success, err = pcall(function()
            dataStore:SetAsync("Player_" .. player.UserId, data)
        end)

        if success then
            return true
        else
            warn("[DataStore] Save attempt " .. attempt .. " failed for " .. player.Name .. ": " .. tostring(err))
            if attempt < MAX_RETRIES then task.wait(1) end
        end
    end

    return false
end

function DataStoreManager:GetData(player)
    return self.PlayerData[player.UserId]
end

function DataStoreManager:RemoveData(player)
    local data = self.PlayerData[player.UserId]
    if data then
        data.LastOnlineTime = os.time()
        self:SaveData(player)
    end
    self.PlayerData[player.UserId] = nil
end

function DataStoreManager:CreateLeaderStats(player, data)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end

    local money = leaderstats:FindFirstChild("Money")
    if not money then
        money = Instance.new("NumberValue")
        money.Name = "Money"
        money.Parent = leaderstats
    end
    money.Value = data.Money or 0

    local strength = leaderstats:FindFirstChild("Strength")
    if not strength then
        strength = Instance.new("NumberValue")
        strength.Name = "Strength"
        strength.Parent = leaderstats
    end
    strength.Value = data.Strength or 0

    local rebirths = leaderstats:FindFirstChild("Rebirths")
    if not rebirths then
        rebirths = Instance.new("NumberValue")
        rebirths.Name = "Rebirths"
        rebirths.Parent = leaderstats
    end
    rebirths.Value = data.Rebirths or 0
end

function DataStoreManager:UpdateLeaderStats(player)
    local data = self.PlayerData[player.UserId]
    if not data then return end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local money = leaderstats:FindFirstChild("Money")
    if money then money.Value = data.Money or 0 end

    local strength = leaderstats:FindFirstChild("Strength")
    if strength then strength.Value = data.Strength or 0 end

    local rebirths = leaderstats:FindFirstChild("Rebirths")
    if rebirths then rebirths.Value = data.Rebirths or 0 end
end

function DataStoreManager:StartAutoSave()
    task.spawn(function()
        while true do
            task.wait(self.SaveInterval)
            for _, player in ipairs(Players:GetPlayers()) do
                self:UpdateLeaderStats(player)
                self:SaveData(player)
            end
        end
    end)
end

function DataStoreManager:SaveAllAndClose()
    for _, player in ipairs(Players:GetPlayers()) do
        local data = self.PlayerData[player.UserId]
        if data then
            data.LastOnlineTime = os.time()
        end
        self:SaveData(player)
    end
end

function DataStoreManager:AddToInventory(player, brainrotData)
    local data = self.PlayerData[player.UserId]
    if not data then return false end
    if not data.Inventory then data.Inventory = {} end

    table.insert(data.Inventory, brainrotData)
    return true
end

function DataStoreManager:RemoveFromInventory(player, index)
    local data = self.PlayerData[player.UserId]
    if not data or not data.Inventory then return nil end
    if index < 1 or index > #data.Inventory then return nil end

    return table.remove(data.Inventory, index)
end

return DataStoreManager
