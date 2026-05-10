--[[
    MainServer.lua  v2.0
    Server initialization and orchestration.
    Initializes all game systems, builds the world, handles player lifecycle.
    MAJOR UPDATE: Admin, Meteor, Distance/Kick, Brainrot Levels, Seller NPC,
    VIP, Server Boosts, Passive Income, Advanced Anti-Cheat, 16 new arenas.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

------------------------------------------------------------
-- LOAD MODULES
------------------------------------------------------------
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Config = require(Modules:WaitForChild("Config"))
local RemoteSetup = require(Modules:WaitForChild("RemoteSetup"))
local BrainrotDatabase = require(Modules:WaitForChild("BrainrotDatabase"))

local DataStoreManager = require(script.Parent:WaitForChild("DataStoreManager"))
local LuckyBlockServer = require(script.Parent:WaitForChild("LuckyBlockServer"))
local TrainingServer = require(script.Parent:WaitForChild("TrainingServer"))
local ShopServer = require(script.Parent:WaitForChild("ShopServer"))
local RebirthServer = require(script.Parent:WaitForChild("RebirthServer"))
local BaseServer = require(script.Parent:WaitForChild("BaseServer"))
local AntiExploit = require(script.Parent:WaitForChild("AntiExploit"))
local AdminServer = require(script.Parent:WaitForChild("AdminServer"))
local MeteorEventServer = require(script.Parent:WaitForChild("MeteorEventServer"))
local DistanceKickServer = require(script.Parent:WaitForChild("DistanceKickServer"))
local BrainrotLevelServer = require(script.Parent:WaitForChild("BrainrotLevelServer"))
local SellerNPCServer = require(script.Parent:WaitForChild("SellerNPCServer"))
local PassiveIncomeServer = require(script.Parent:WaitForChild("PassiveIncomeServer"))
local VIPServer = require(script.Parent:WaitForChild("VIPServer"))
local AdvancedAntiCheat = require(script.Parent:WaitForChild("AdvancedAntiCheat"))

local LobbyBuilder = require(workspace:WaitForChild("Builders"):WaitForChild("LobbyBuilder"))
local RarityRoadBuilder = require(workspace:WaitForChild("Builders"):WaitForChild("RarityRoadBuilder"))
local BaseBuilder = require(workspace:WaitForChild("Builders"):WaitForChild("BaseBuilder"))

------------------------------------------------------------
-- INITIALIZATION
------------------------------------------------------------
print("[MainServer] v2.0 - Initializing Treine Para Chutar Lucky Block...")

-- 1. Create remotes
local remotesFolder = RemoteSetup.Initialize()
print("[MainServer] Remotes created.")

-- 2. Initialize DataStore
local dsManager = DataStoreManager.new(Config)
print("[MainServer] DataStore initialized.")

-- 3. Initialize anti-exploit
AntiExploit.Initialize(Config, remotesFolder)
print("[MainServer] AntiExploit initialized.")

-- 4. Initialize Advanced Anti-Cheat
AdvancedAntiCheat.Initialize(Config, remotesFolder)
print("[MainServer] Advanced AntiCheat initialized.")

-- 5. Initialize core game systems
LuckyBlockServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Lucky Block system initialized.")

TrainingServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Training system initialized.")

ShopServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Shop system initialized.")

RebirthServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Rebirth system initialized.")

BaseServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Base system initialized.")

-- 6. Initialize v2 systems
AdminServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Admin system initialized.")

MeteorEventServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Meteor Event system initialized.")

DistanceKickServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Distance/Kick system initialized.")

BrainrotLevelServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Brainrot Level system initialized.")

SellerNPCServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] Seller NPC system initialized.")

VIPServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer] VIP system initialized.")

PassiveIncomeServer.Initialize(Config, dsManager, remotesFolder, BrainrotLevelServer)
print("[MainServer] Passive Income system initialized.")

-- 7. Build the world
LobbyBuilder.Build(Config)
print("[MainServer] Lobby built.")

RarityRoadBuilder.Build(Config)
print("[MainServer] Rarity Road built.")

print("[MainServer] Total Brainrots: " .. BrainrotDatabase.GetTotalCount())

------------------------------------------------------------
-- PLAYER LIFECYCLE
------------------------------------------------------------
local function onPlayerAdded(player)
    local data = dsManager:LoadData(player)
    print("[MainServer] Loaded data for " .. player.Name)

    -- Claim base if available
    if BaseServer.CanClaimBase(player) then
        BaseServer.ClaimBase(player)
        local baseIndex = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p == player then break end
            baseIndex = baseIndex + 1
        end
        BaseBuilder.BuildBase(player, Config, baseIndex)
        print("[MainServer] Built base for " .. player.Name)
    end

    -- Process offline rewards
    PassiveIncomeServer.ProcessPlayerJoin(player)

    -- Setup VIP
    VIPServer.SetupVIPPlayer(player)

    player.CharacterAdded:Connect(function(character)
        VIPServer.SetupVIPPlayer(player)
    end)
end

local function onPlayerRemoving(player)
    PassiveIncomeServer.ProcessPlayerLeave(player)
    BaseServer.ReleaseBase(player)
    dsManager:RemoveData(player)
    print("[MainServer] Saved and cleaned data for " .. player.Name)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
    spawn(function()
        onPlayerAdded(player)
    end)
end

------------------------------------------------------------
-- REMOTE FUNCTION HANDLERS
------------------------------------------------------------
local getPlayerDataFunc = remotesFolder:FindFirstChild("GetPlayerData")
if getPlayerDataFunc then
    getPlayerDataFunc.OnServerInvoke = function(player)
        return dsManager:GetData(player)
    end
end

local getInventoryFunc = remotesFolder:FindFirstChild("GetInventory")
if getInventoryFunc then
    getInventoryFunc.OnServerInvoke = function(player)
        local data = dsManager:GetData(player)
        return data and data.Inventory or {}
    end
end

local getBaseDataFunc = remotesFolder:FindFirstChild("GetBaseData")
if getBaseDataFunc then
    getBaseDataFunc.OnServerInvoke = function(player)
        local data = dsManager:GetData(player)
        if not data then return {} end
        return {
            Level = data.BaseLevel or 1,
            MaxSlots = BaseServer.GetMaxSlots(player),
            StoredBrainrots = data.StoredBrainrots or {},
            Upgrades = data.BaseUpgrades or {},
            Slots = data.BaseSlots or Config.Base.StartingSlots,
        }
    end
end

local getDiscoveredFunc = remotesFolder:FindFirstChild("GetDiscoveredBrainrots")
if getDiscoveredFunc then
    getDiscoveredFunc.OnServerInvoke = function(player)
        local data = dsManager:GetData(player)
        return data and data.DiscoveredBrainrots or {}
    end
end

local getShopDataFunc = remotesFolder:FindFirstChild("GetShopData")
if getShopDataFunc then
    getShopDataFunc.OnServerInvoke = function(player)
        return {
            Weights = Config.Training.Weights,
            SpeedUpgrades = Config.ShopItems.SpeedUpgrades,
            LuckBoosts = Config.ShopItems.LuckBoosts,
            Gamepasses = Config.Gamepasses,
            ServerBoosts = Config.ServerBoosts,
        }
    end
end

local getLeaderboardFunc = remotesFolder:FindFirstChild("GetLeaderboardData")
if getLeaderboardFunc then
    getLeaderboardFunc.OnServerInvoke = function(player)
        local leaderboard = {}
        for _, p in ipairs(Players:GetPlayers()) do
            local data = dsManager:GetData(p)
            if data then
                table.insert(leaderboard, {
                    Name = p.Name,
                    Strength = data.Strength or 0,
                    Money = data.Money or 0,
                    Rebirths = data.Rebirths or 0,
                    TotalKicks = data.TotalKicks or 0,
                    BestDistance = data.BestDistance or 0,
                })
            end
        end
        table.sort(leaderboard, function(a, b) return a.Strength > b.Strength end)
        return leaderboard
    end
end

------------------------------------------------------------
-- BIND TO CLOSE
------------------------------------------------------------
game:BindToClose(function()
    dsManager:SaveAllAndClose()
end)

print("[MainServer] v2.0 - All systems initialized! Game ready.")
