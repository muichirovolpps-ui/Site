--[[
    MainServer.lua  v3.0
    Main server orchestrator. Initializes all game systems in correct order.
    v3: Added EventSystem, Bosses, PetEffects, Quests, SpinWheel, Emotes,
    Ranks, Leaderboards, Secrets, SuperVIP, GamepassServer, MegaMap.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

------------------------------------------------------------
-- LOAD MODULES
------------------------------------------------------------
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Config = require(Modules:WaitForChild("Config"))
local RemoteSetup = require(Modules:WaitForChild("RemoteSetup"))
local BrainrotDatabase = require(Modules:WaitForChild("BrainrotDatabase"))

-- Server modules
local DataStoreManager = require(ServerScriptService:WaitForChild("DataStoreManager"))
local AntiExploit = require(ServerScriptService:WaitForChild("AntiExploit"))
local AdvancedAntiCheat = require(ServerScriptService:WaitForChild("AdvancedAntiCheat"))
local LuckyBlockServer = require(ServerScriptService:WaitForChild("LuckyBlockServer"))
local TrainingServer = require(ServerScriptService:WaitForChild("TrainingServer"))
local ShopServer = require(ServerScriptService:WaitForChild("ShopServer"))
local RebirthServer = require(ServerScriptService:WaitForChild("RebirthServer"))
local BaseServer = require(ServerScriptService:WaitForChild("BaseServer"))
local AdminServer = require(ServerScriptService:WaitForChild("AdminServer"))
local MeteorEventServer = require(ServerScriptService:WaitForChild("MeteorEventServer"))
local DistanceKickServer = require(ServerScriptService:WaitForChild("DistanceKickServer"))
local BrainrotLevelServer = require(ServerScriptService:WaitForChild("BrainrotLevelServer"))
local SellerNPCServer = require(ServerScriptService:WaitForChild("SellerNPCServer"))
local PassiveIncomeServer = require(ServerScriptService:WaitForChild("PassiveIncomeServer"))
local VIPServer = require(ServerScriptService:WaitForChild("VIPServer"))
local EventSystemServer = require(ServerScriptService:WaitForChild("EventSystemServer"))
local BossServer = require(ServerScriptService:WaitForChild("BossServer"))
local PetEffectsServer = require(ServerScriptService:WaitForChild("PetEffectsServer"))
local QuestServer = require(ServerScriptService:WaitForChild("QuestServer"))
local SpinWheelServer = require(ServerScriptService:WaitForChild("SpinWheelServer"))
local EmoteServer = require(ServerScriptService:WaitForChild("EmoteServer"))
local RankServer = require(ServerScriptService:WaitForChild("RankServer"))
local LeaderboardServer = require(ServerScriptService:WaitForChild("LeaderboardServer"))
local SecretServer = require(ServerScriptService:WaitForChild("SecretServer"))
local SuperVIPServer = require(ServerScriptService:WaitForChild("SuperVIPServer"))
local GamepassServer = require(ServerScriptService:WaitForChild("GamepassServer"))

-- Builders
local Builders = workspace:WaitForChild("Builders")
local LobbyBuilder = require(Builders:WaitForChild("LobbyBuilder"))
local RarityRoadBuilder = require(Builders:WaitForChild("RarityRoadBuilder"))
local BaseBuilder = require(Builders:WaitForChild("BaseBuilder"))
local MegaMapBuilder = require(Builders:WaitForChild("MegaMapBuilder"))

------------------------------------------------------------
-- INITIALIZATION
------------------------------------------------------------
print("[MainServer v3] Starting initialization...")

-- 1. Remotes
local remotesFolder = RemoteSetup.Initialize()
print("[MainServer v3] Remotes initialized")

-- 2. Data Store
local dsManager = DataStoreManager.new(Config)
print("[MainServer v3] DataStore initialized")

-- 3. Anti-exploit
AntiExploit.Initialize(Config, remotesFolder)
AdvancedAntiCheat.Initialize(Config, remotesFolder)
print("[MainServer v3] Anti-cheat initialized")

-- 4. Core gameplay
LuckyBlockServer.Initialize(Config, dsManager, remotesFolder)
TrainingServer.Initialize(Config, dsManager, remotesFolder)
ShopServer.Initialize(Config, dsManager, remotesFolder)
RebirthServer.Initialize(Config, dsManager, remotesFolder)
BaseServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer v3] Core systems initialized")

-- 5. v2 systems
AdminServer.Initialize(Config, dsManager, remotesFolder)
DistanceKickServer.Initialize(Config, dsManager, remotesFolder)
BrainrotLevelServer.Initialize(Config, dsManager, remotesFolder)
SellerNPCServer.Initialize(Config, dsManager, remotesFolder)
VIPServer.Initialize(Config, dsManager, remotesFolder)
PassiveIncomeServer.Initialize(Config, dsManager, remotesFolder, BrainrotLevelServer)
print("[MainServer v3] v2 systems initialized")

-- 6. v3 systems
BossServer.Initialize(Config, dsManager, remotesFolder)
EventSystemServer.Initialize(Config, dsManager, remotesFolder, BossServer)
MeteorEventServer.Initialize(Config, dsManager, remotesFolder)
PetEffectsServer.Initialize(Config, dsManager, remotesFolder)
QuestServer.Initialize(Config, dsManager, remotesFolder)
SpinWheelServer.Initialize(Config, dsManager, remotesFolder)
EmoteServer.Initialize(Config, dsManager, remotesFolder)
RankServer.Initialize(Config, dsManager, remotesFolder)
LeaderboardServer.Initialize(Config, dsManager, remotesFolder)
SecretServer.Initialize(Config, dsManager, remotesFolder)
SuperVIPServer.Initialize(Config, dsManager, remotesFolder)
GamepassServer.Initialize(Config, dsManager, remotesFolder)
print("[MainServer v3] v3 systems initialized")

-- 7. Build world
LobbyBuilder.Build(Config)
RarityRoadBuilder.Build(Config)
MegaMapBuilder.Build(Config)
print("[MainServer v3] World built — lobby + rarity road + mega map")

------------------------------------------------------------
-- PLAYER LIFECYCLE
------------------------------------------------------------
Players.PlayerAdded:Connect(function(player)
    dsManager:LoadData(player)

    task.wait(1)

    local data = dsManager:GetData(player)
    if data then
        -- v2 setup
        PassiveIncomeServer.ProcessPlayerJoin(player)
        VIPServer.SetupVIPPlayer(player)

        -- v3 setup
        GamepassServer.SetupPlayer(player)
        SuperVIPServer.SetupPlayer(player)
        QuestServer.SetupPlayer(player)
        RankServer.SetupPlayer(player)

        -- Build base
        BaseBuilder.BuildForPlayer(player, Config, data)

        -- Send initial data
        remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
            Money = data.Money,
            Strength = data.Strength,
            Speed = data.Speed,
            Luck = data.Luck,
            Rebirths = data.Rebirths,
            Gems = data.Gems or 0,
            Rank = data.Rank or "Noob",
        })
    end

    print("[MainServer v3] Player setup complete: " .. player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    local data = dsManager:GetData(player)
    if data then
        data.LastOnlineTime = os.time()
    end
    dsManager:SaveData(player)
end)

------------------------------------------------------------
-- AUTO SAVE
------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(Config.AUTO_SAVE_INTERVAL)
        for _, player in ipairs(Players:GetPlayers()) do
            dsManager:SaveData(player)
        end
    end
end)

------------------------------------------------------------
-- STAT UPDATES
------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(2)
        for _, player in ipairs(Players:GetPlayers()) do
            local data = dsManager:GetData(player)
            if data then
                remotesFolder:FindFirstChild("UpdatePlayerStats"):FireClient(player, {
                    Money = data.Money,
                    Strength = data.Strength,
                    Speed = data.Speed,
                    Luck = data.Luck,
                    Rebirths = data.Rebirths,
                    Gems = data.Gems or 0,
                    Rank = data.Rank or "Noob",
                })
            end
        end
    end
end)

------------------------------------------------------------
-- SHUTDOWN
------------------------------------------------------------
game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        local data = dsManager:GetData(player)
        if data then
            data.LastOnlineTime = os.time()
        end
        dsManager:SaveData(player)
    end
    task.wait(3)
end)

print("[MainServer v3] ===== GAME READY — v" .. Config.VERSION .. " =====")
print("[MainServer v3] " .. BrainrotDatabase.GetTotalCount() .. " brainrots loaded")
print("[MainServer v3] " .. #Config.Gamepasses .. " gamepasses configured")
print("[MainServer v3] " .. #Config.Events.Types .. " event types active")
print("[MainServer v3] " .. #Config.Bosses .. " boss types loaded")
