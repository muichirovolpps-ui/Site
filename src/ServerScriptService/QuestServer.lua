--[[
    QuestServer.lua  v3.0
    Daily + Weekly quest system with rewards (money, gems, brainrots, effects).
    Auto-assigns quests, tracks progress, handles completion and reset.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuestServer = {}

local config = nil
local remotes = nil
local dsManager = nil

function QuestServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder

    local getQuests = remotes:FindFirstChild("GetQuests")
    if getQuests and getQuests:IsA("RemoteFunction") then
        getQuests.OnServerInvoke = function(player)
            return QuestServer.GetPlayerQuests(player)
        end
    end

    local claimQuest = remotes:FindFirstChild("ClaimQuestReward")
    if claimQuest then
        claimQuest.OnServerEvent:Connect(function(player, questId, questType)
            QuestServer.ClaimReward(player, questId, questType)
        end)
    end

    print("[QuestServer] Initialized — daily + weekly quests active")
end

function QuestServer.SetupPlayer(player)
    local data = dsManager.GetData(player)
    if not data then return end

    if not data.Quests then
        data.Quests = { Daily = {}, Weekly = {}, LastDailyReset = 0, LastWeeklyReset = 0 }
    end

    local now = os.time()
    local todayStart = now - (now % 86400)
    local weekStart = now - (now % 604800)

    if data.Quests.LastDailyReset < todayStart then
        data.Quests.Daily = QuestServer.GenerateQuests(config.Quests.DailyPool, config.Quests.MaxDailyQuests)
        data.Quests.LastDailyReset = todayStart
    end

    if data.Quests.LastWeeklyReset < weekStart then
        data.Quests.Weekly = QuestServer.GenerateQuests(config.Quests.WeeklyPool, config.Quests.MaxWeeklyQuests)
        data.Quests.LastWeeklyReset = weekStart
    end
end

function QuestServer.GenerateQuests(pool, count)
    local quests = {}
    local available = {}
    for i, q in ipairs(pool) do
        table.insert(available, i)
    end

    for i = 1, math.min(count, #available) do
        local pick = math.random(1, #available)
        local questIndex = available[pick]
        table.remove(available, pick)

        local questDef = pool[questIndex]
        table.insert(quests, {
            Name = questDef.Name,
            Description = questDef.Description,
            Target = questDef.Target,
            Type = questDef.Type,
            Progress = 0,
            Completed = false,
            Claimed = false,
            Reward = questDef.Reward,
        })
    end

    return quests
end

function QuestServer.UpdateProgress(player, questType, amount)
    local data = dsManager.GetData(player)
    if not data or not data.Quests then return end

    amount = amount or 1

    for _, quest in ipairs(data.Quests.Daily) do
        if quest.Type == questType and not quest.Completed then
            quest.Progress = math.min(quest.Progress + amount, quest.Target)
            if quest.Progress >= quest.Target then
                quest.Completed = true
                remotes:FindFirstChild("QuestCompleted"):FireClient(player, {
                    Name = quest.Name,
                    Description = quest.Description,
                    QuestType = "Daily",
                })
            end
        end
    end

    for _, quest in ipairs(data.Quests.Weekly) do
        if quest.Type == questType and not quest.Completed then
            quest.Progress = math.min(quest.Progress + amount, quest.Target)
            if quest.Progress >= quest.Target then
                quest.Completed = true
                remotes:FindFirstChild("QuestCompleted"):FireClient(player, {
                    Name = quest.Name,
                    Description = quest.Description,
                    QuestType = "Weekly",
                })
            end
        end
    end
end

function QuestServer.ClaimReward(player, questName, questType)
    local data = dsManager.GetData(player)
    if not data or not data.Quests then return end

    local questList = questType == "Daily" and data.Quests.Daily or data.Quests.Weekly

    for _, quest in ipairs(questList) do
        if quest.Name == questName and quest.Completed and not quest.Claimed then
            quest.Claimed = true

            if quest.Reward.Money then
                data.Money = data.Money + quest.Reward.Money
            end
            if quest.Reward.Gems then
                data.Gems = (data.Gems or 0) + quest.Reward.Gems
            end
            if quest.Reward.Strength then
                data.Strength = data.Strength + quest.Reward.Strength
            end
            if quest.Reward.Luck then
                data.Luck = data.Luck + quest.Reward.Luck
            end

            remotes:FindFirstChild("QuestRewardClaimed"):FireClient(player, {
                Name = quest.Name,
                Reward = quest.Reward,
            })

            break
        end
    end
end

function QuestServer.GetPlayerQuests(player)
    local data = dsManager.GetData(player)
    if not data or not data.Quests then return { Daily = {}, Weekly = {} } end
    return { Daily = data.Quests.Daily, Weekly = data.Quests.Weekly }
end

return QuestServer
