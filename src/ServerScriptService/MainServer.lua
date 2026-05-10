--[[
    MainServer.lua (ServerScriptService)
    Main server initialization script.
    Sets up all game systems, remotes, and world builders.
    This is the PRIMARY server Script that runs on game start.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RemoteSetup = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RemoteSetup"))
local DataStoreManager = require(ServerScriptService:WaitForChild("DataStoreManager"))
local LuckyBlockServer = require(ServerScriptService:WaitForChild("LuckyBlockServer"))
local TrainingServer = require(ServerScriptService:WaitForChild("TrainingServer"))
local ShopServer = require(ServerScriptService:WaitForChild("ShopServer"))
local RebirthServer = require(ServerScriptService:WaitForChild("RebirthServer"))
local BaseServer = require(ServerScriptService:WaitForChild("BaseServer"))
local AntiExploit = require(ServerScriptService:WaitForChild("AntiExploit"))

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))

local LobbyBuilder = require(script.Parent.Parent:WaitForChild("Workspace"):WaitForChild("Builders"):WaitForChild("LobbyBuilder"))
local RarityRoadBuilder = require(script.Parent.Parent:WaitForChild("Workspace"):WaitForChild("Builders"):WaitForChild("RarityRoadBuilder"))
local BaseBuilder = require(script.Parent.Parent:WaitForChild("Workspace"):WaitForChild("Builders"):WaitForChild("BaseBuilder"))

print("[Server] Initializing " .. Config.GAME_NAME .. " v" .. Config.VERSION)

------------------------------------------------------------
-- STEP 1: Create Remotes
------------------------------------------------------------
local remotesFolder = RemoteSetup.Initialize()
print("[Server] Remotes initialized")

------------------------------------------------------------
-- STEP 2: Initialize Systems
------------------------------------------------------------
DataStoreManager.Initialize()
print("[Server] DataStore initialized")

AntiExploit.Initialize()
print("[Server] Anti-exploit initialized")

LuckyBlockServer.Initialize(remotesFolder, DataStoreManager)
print("[Server] Lucky Block system initialized")

TrainingServer.Initialize(remotesFolder, DataStoreManager)
print("[Server] Training system initialized")

ShopServer.Initialize(remotesFolder, DataStoreManager)
print("[Server] Shop system initialized")

RebirthServer.Initialize(remotesFolder, DataStoreManager)
print("[Server] Rebirth system initialized")

BaseServer.Initialize(remotesFolder, DataStoreManager)
print("[Server] Base system initialized")

------------------------------------------------------------
-- STEP 3: Build World
------------------------------------------------------------
local worldFolder = Instance.new("Folder")
worldFolder.Name = "GameWorld"
worldFolder.Parent = workspace

local lobbyFolder = Instance.new("Folder")
lobbyFolder.Name = "Lobby"
lobbyFolder.Parent = worldFolder

local roadFolder = Instance.new("Folder")
roadFolder.Name = "RarityRoad"
roadFolder.Parent = worldFolder

local basesFolder = Instance.new("Folder")
basesFolder.Name = "PlayerBases"
basesFolder.Parent = worldFolder

LobbyBuilder.Build(lobbyFolder)
print("[Server] Lobby built")

RarityRoadBuilder.Build(roadFolder)
print("[Server] Rarity Road built")

------------------------------------------------------------
-- STEP 4: Player Connections
------------------------------------------------------------
local baseCount = 0

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local data = DataStoreManager.GetData(player)

        if data then
            local baseSpeed = 16 + (data.Speed * 0.5)
            humanoid.WalkSpeed = math.min(baseSpeed, 80)
        end
    end)

    task.wait(1)

    baseCount = baseCount + 1
    BaseBuilder.BuildPlayerBase(player, basesFolder, baseCount)
    print("[Server] Base built for " .. player.Name)

    LuckyBlockServer.SyncStats(player, DataStoreManager)
end

local function onPlayerRemoving(player)
    LuckyBlockServer.CleanupPlayer(player)
    TrainingServer.CleanupPlayer(player)
    BaseBuilder.RemovePlayerBase(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(onPlayerAdded, player)
end

------------------------------------------------------------
-- STEP 5: Remote Function Handlers
------------------------------------------------------------
local getPlayerData = remotesFolder:WaitForChild("GetPlayerData")
getPlayerData.OnServerInvoke = function(player)
    return DataStoreManager.GetData(player)
end

local getInventory = remotesFolder:WaitForChild("GetInventory")
getInventory.OnServerInvoke = function(player)
    local data = DataStoreManager.GetData(player)
    return data and data.Inventory or {}
end

local getDiscovered = remotesFolder:WaitForChild("GetDiscoveredBrainrots")
getDiscovered.OnServerInvoke = function(player)
    local data = DataStoreManager.GetData(player)
    return data and data.DiscoveredBrainrots or {}
end

print("[Server] " .. Config.GAME_NAME .. " fully loaded!")
