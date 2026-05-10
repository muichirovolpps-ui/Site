--[[
    RemoteSetup.lua  v3.0 (ReplicatedStorage/Modules)
    Creates all RemoteEvents and RemoteFunctions used by the game.
    v3: Added events, bosses, quests, spin, emotes, ranks, leaderboards, secrets, pets.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteSetup = {}

local REMOTE_EVENTS = {
    -- Core gameplay
    "KickLuckyBlock", "TrainStrength", "TrainSpeed",
    "BuyWeight", "BuySpeedUpgrade", "BuyLuckBoost",
    "RequestRebirth", "EquipBrainrot", "StoreBrainrot",
    "RemoveFromBase", "UpgradeBase", "ExpandBaseSlots",
    "UpdatePlayerStats", "ShowReward", "PlayEffect",
    "ShowNotification", "PowerBarResult", "BrainrotObtained",
    "RebirthSuccess", "PurchaseSuccess", "SyncInventory", "SyncBaseData",
    -- Admin
    "AdminCommand", "AdminResponse", "ForceEvent",
    -- Kick/Distance
    "PerformKick", "KickResult",
    -- Events
    "EventStarted", "EventEnded", "MeteorEvent", "MeteorWarning",
    "BrainrotRainDrop",
    -- Bosses
    "AttackBoss", "BossSpawned", "BossDamaged", "BossDefeated", "BossReward",
    -- Brainrot leveling
    "UpgradeBrainrot",
    -- Seller
    "BuyFromSeller", "SellerVoiceLine",
    -- Passive income
    "PassiveIncomeUpdate", "OfflineReward",
    -- Server boosts
    "ActivateServerBoost", "ServerBoostUpdate",
    -- Anti-cheat
    "AntiCheatLog",
    -- Pets
    "EquipPet", "UnequipPet", "PetEquipped",
    -- Quests
    "ClaimQuestReward", "QuestCompleted", "QuestRewardClaimed",
    -- Spin wheel
    "RequestSpin", "SpinResult",
    -- Emotes
    "PlayEmote", "BuyEmote", "EmotePlayed",
    -- Ranks
    "RankUp",
    -- Secrets
    "ClaimSecret", "UseSecretPortal", "SecretFound", "AchievementUnlocked",
    -- Gamepasses
    "BuyGamepass", "BuyProduct", "GamepassPurchased", "ApplyCosmeticEffect",
}

local REMOTE_FUNCTIONS = {
    "GetPlayerData", "GetInventory", "GetBaseData",
    "GetDiscoveredBrainrots", "GetShopData", "GetLeaderboardData",
    -- v3 functions
    "IsAdmin", "GetBrainrotLevel", "GetSellerDeals", "GetServerBoosts",
    "GetQuests", "GetSpinWheel", "GetEmotes", "GetRank",
    "GetAchievements", "GetLeaderboard", "GetAllLeaderboards",
    "GetGamepassData",
}

function RemoteSetup.Initialize()
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotesFolder then
        remotesFolder = Instance.new("Folder")
        remotesFolder.Name = "Remotes"
        remotesFolder.Parent = ReplicatedStorage
    end

    for _, name in ipairs(REMOTE_EVENTS) do
        if not remotesFolder:FindFirstChild(name) then
            local remote = Instance.new("RemoteEvent")
            remote.Name = name
            remote.Parent = remotesFolder
        end
    end

    for _, name in ipairs(REMOTE_FUNCTIONS) do
        if not remotesFolder:FindFirstChild(name) then
            local remote = Instance.new("RemoteFunction")
            remote.Name = name
            remote.Parent = remotesFolder
        end
    end

    return remotesFolder
end

return RemoteSetup
