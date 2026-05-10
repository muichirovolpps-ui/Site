--[[
    RemoteSetup.lua  v2.0 (ReplicatedStorage/Modules)
    Creates all RemoteEvents and RemoteFunctions used by the game.
    Run once on the server during initialization.
    Updated with v2 remotes: Admin, Meteor, Distance, Brainrot Levels, VIP, etc.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteSetup = {}

local REMOTE_EVENTS = {
    "KickLuckyBlock",
    "TrainStrength",
    "TrainSpeed",
    "BuyWeight",
    "BuySpeedUpgrade",
    "BuyLuckBoost",
    "RequestRebirth",
    "EquipBrainrot",
    "StoreBrainrot",
    "RemoveFromBase",
    "UpgradeBase",
    "ExpandBaseSlots",
    "UpdatePlayerStats",
    "ShowReward",
    "PlayEffect",
    "ShowNotification",
    "PowerBarResult",
    "BrainrotObtained",
    "RebirthSuccess",
    "PurchaseSuccess",
    "SyncInventory",
    "SyncBaseData",
    -- v2 remotes
    "AdminCommand",
    "AdminResponse",
    "PerformKick",
    "KickResult",
    "MeteorEvent",
    "MeteorWarning",
    "UpgradeBrainrot",
    "BuyFromSeller",
    "SellerVoiceLine",
    "PassiveIncomeUpdate",
    "OfflineReward",
    "ActivateServerBoost",
    "ServerBoostUpdate",
    "AntiCheatLog",
}

local REMOTE_FUNCTIONS = {
    "GetPlayerData",
    "GetInventory",
    "GetBaseData",
    "GetDiscoveredBrainrots",
    "GetShopData",
    "GetLeaderboardData",
    -- v2 functions
    "IsAdmin",
    "GetBrainrotLevel",
    "GetSellerDeals",
    "GetServerBoosts",
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
