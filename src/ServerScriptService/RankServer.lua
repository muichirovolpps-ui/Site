--[[
    RankServer.lua  v3.0
    8 ranks: Noob, Pro, Mega, Mythic, God, Hacker, Cosmic, Void King.
    Automatic rank-up based on strength, with overhead display and perks.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RankServer = {}

local config = nil
local remotes = nil
local dsManager = nil

local playerRanks = {}

function RankServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder

    task.spawn(function()
        while true do
            task.wait(5)
            for _, player in ipairs(Players:GetPlayers()) do
                RankServer.UpdatePlayerRank(player)
            end
        end
    end)

    local getRank = remotes:FindFirstChild("GetRank")
    if getRank and getRank:IsA("RemoteFunction") then
        getRank.OnServerInvoke = function(player)
            return RankServer.GetPlayerRankData(player)
        end
    end

    print("[RankServer] Initialized — " .. #config.Ranks .. " ranks loaded")
end

function RankServer.CalculateRank(strength)
    local rankIndex = 1
    for i, rank in ipairs(config.Ranks) do
        if strength >= rank.RequiredStrength then
            rankIndex = i
        end
    end
    return rankIndex
end

function RankServer.UpdatePlayerRank(player)
    local data = dsManager.GetData(player)
    if not data then return end

    local newRankIndex = RankServer.CalculateRank(data.Strength)
    local oldRankIndex = playerRanks[player.UserId] or 1

    if newRankIndex > oldRankIndex then
        playerRanks[player.UserId] = newRankIndex
        local rankConfig = config.Ranks[newRankIndex]

        data.Rank = rankConfig.Name

        RankServer.UpdateOverhead(player, rankConfig)

        remotes:FindFirstChild("RankUp"):FireClient(player, {
            RankName = rankConfig.DisplayName,
            RankColor = rankConfig.Color,
            RankIndex = newRankIndex,
            Perks = rankConfig.Perks,
        })

        remotes:FindFirstChild("ShowNotification"):FireClient(player,
            "RANK UP! " .. rankConfig.DisplayName, "success")

    elseif newRankIndex ~= oldRankIndex then
        playerRanks[player.UserId] = newRankIndex
    end
end

function RankServer.UpdateOverhead(player, rankConfig)
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    local existing = head:FindFirstChild("RankGui")
    if existing then existing:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RankGui"
    billboard.Size = UDim2.new(0, 200, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = false
    billboard.Parent = head

    local rankLabel = Instance.new("TextLabel")
    rankLabel.Size = UDim2.new(1, 0, 1, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = "[" .. rankConfig.DisplayName .. "]"
    rankLabel.TextColor3 = rankConfig.Color
    rankLabel.TextScaled = true
    rankLabel.Font = Enum.Font.GothamBold
    rankLabel.TextStrokeTransparency = 0.5
    rankLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    rankLabel.Parent = billboard
end

function RankServer.SetupPlayer(player)
    local data = dsManager.GetData(player)
    if not data then return end

    local rankIndex = RankServer.CalculateRank(data.Strength)
    playerRanks[player.UserId] = rankIndex
    data.Rank = config.Ranks[rankIndex].Name

    player.CharacterAdded:Connect(function()
        task.wait(1)
        local ri = playerRanks[player.UserId] or 1
        RankServer.UpdateOverhead(player, config.Ranks[ri])
    end)

    if player.Character then
        RankServer.UpdateOverhead(player, config.Ranks[rankIndex])
    end
end

function RankServer.GetPlayerRankData(player)
    local data = dsManager.GetData(player)
    if not data then return {} end

    local rankIndex = playerRanks[player.UserId] or 1
    local rankConfig = config.Ranks[rankIndex]
    local nextRank = config.Ranks[rankIndex + 1]

    return {
        CurrentRank = rankConfig.DisplayName,
        CurrentColor = rankConfig.Color,
        RankIndex = rankIndex,
        Perks = rankConfig.Perks,
        NextRank = nextRank and nextRank.DisplayName or "MAX",
        NextRequirement = nextRank and nextRank.RequiredStrength or 0,
        CurrentStrength = data.Strength,
    }
end

function RankServer.GetRankPerks(player)
    local rankIndex = playerRanks[player.UserId] or 1
    return config.Ranks[rankIndex].Perks or {}
end

return RankServer
