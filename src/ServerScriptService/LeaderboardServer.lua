--[[
    LeaderboardServer.lua  v3.0
    5 global leaderboards using OrderedDataStore:
    Most Money, Most Strength, Most Rebirths, Most Brainrots, Best Distance.
    Auto-refresh, in-game display, and remote queries.
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LeaderboardServer = {}

local config = nil
local remotes = nil
local dsManager = nil

local leaderboardData = {}
local orderedStores = {}

function LeaderboardServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder

    for _, lb in ipairs(config.Leaderboards.Types) do
        local ok, store = pcall(function()
            return DataStoreService:GetOrderedDataStore("LB_" .. lb.Name .. "_v3")
        end)
        if ok then
            orderedStores[lb.Name] = store
        end
        leaderboardData[lb.Name] = {}
    end

    task.spawn(function()
        while true do
            LeaderboardServer.RefreshAll()
            task.wait(config.Leaderboards.RefreshInterval)
        end
    end)

    local getLeaderboard = remotes:FindFirstChild("GetLeaderboard")
    if getLeaderboard and getLeaderboard:IsA("RemoteFunction") then
        getLeaderboard.OnServerInvoke = function(player, lbName)
            return leaderboardData[lbName] or {}
        end
    end

    local getAllLeaderboards = remotes:FindFirstChild("GetAllLeaderboards")
    if getAllLeaderboards and getAllLeaderboards:IsA("RemoteFunction") then
        getAllLeaderboards.OnServerInvoke = function(player)
            return leaderboardData
        end
    end

    print("[LeaderboardServer] Initialized — " .. #config.Leaderboards.Types .. " leaderboards")
end

function LeaderboardServer.RefreshAll()
    for _, player in ipairs(Players:GetPlayers()) do
        LeaderboardServer.SavePlayerScores(player)
    end

    for _, lb in ipairs(config.Leaderboards.Types) do
        LeaderboardServer.FetchLeaderboard(lb.Name)
    end
end

function LeaderboardServer.SavePlayerScores(player)
    local data = dsManager:GetData(player)
    if not data then return end

    local scores = {
        TopMoney = math.floor(data.Money or 0),
        TopStrength = math.floor(data.Strength or 0),
        TopRebirths = data.Rebirths or 0,
        TopBrainrots = data.Inventory and #data.Inventory or 0,
        TopDistance = math.floor(data.BestDistance or 0),
    }

    for lbName, store in pairs(orderedStores) do
        local score = scores[lbName]
        if score and score > 0 then
            pcall(function()
                store:SetAsync(tostring(player.UserId), score)
            end)
        end
    end
end

function LeaderboardServer.FetchLeaderboard(lbName)
    local store = orderedStores[lbName]
    if not store then return end

    local ok, pages = pcall(function()
        return store:GetSortedAsync(false, config.Leaderboards.MaxEntries)
    end)

    if not ok or not pages then return end

    local entries = {}
    local pageData = pages:GetCurrentPage()

    for rank, entry in ipairs(pageData) do
        local userId = tonumber(entry.key)
        local playerName = "Player"

        local nameOk, name = pcall(function()
            return Players:GetNameFromUserIdAsync(userId)
        end)
        if nameOk then
            playerName = name
        end

        table.insert(entries, {
            Rank = rank,
            UserId = userId,
            PlayerName = playerName,
            Score = entry.value,
        })
    end

    leaderboardData[lbName] = entries
end

function LeaderboardServer.GetPlayerRank(player, lbName)
    local entries = leaderboardData[lbName]
    if not entries then return nil end

    for _, entry in ipairs(entries) do
        if entry.UserId == player.UserId then
            return entry.Rank
        end
    end
    return nil
end

return LeaderboardServer
