--[[
    PassiveIncomeServer.lua  v2.0
    Offline + Online rewards system.
    Brainrots generate real passive income based on value, level, and mutations.
    Offline rewards calculated on rejoin (capped at 8 hours).
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PassiveIncomeServer = {}

local Config
local DataStoreManager
local remotesFolder
local BrainrotLevelServer

function PassiveIncomeServer.Initialize(config, dsManager, remotes, brainrotLevelSrv)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes
    BrainrotLevelServer = brainrotLevelSrv

    local passiveIncomeRemote = remotesFolder:FindFirstChild("PassiveIncomeUpdate")
    if not passiveIncomeRemote then
        passiveIncomeRemote = Instance.new("RemoteEvent")
        passiveIncomeRemote.Name = "PassiveIncomeUpdate"
        passiveIncomeRemote.Parent = remotesFolder
    end

    local offlineRewardRemote = remotesFolder:FindFirstChild("OfflineReward")
    if not offlineRewardRemote then
        offlineRewardRemote = Instance.new("RemoteEvent")
        offlineRewardRemote.Name = "OfflineReward"
        offlineRewardRemote.Parent = remotesFolder
    end

    spawn(function()
        while true do
            wait(Config.PassiveIncome.TickInterval)
            PassiveIncomeServer.TickAllPlayers()
        end
    end)
end

function PassiveIncomeServer.CalculateOfflineRewards(data)
    local lastOnline = data.LastOnlineTime or os.time()
    local offlineSeconds = os.time() - lastOnline
    local maxOfflineSeconds = Config.PassiveIncome.OfflineMaxHours * 3600

    offlineSeconds = math.min(offlineSeconds, maxOfflineSeconds)

    if offlineSeconds < 60 then
        return 0, 0
    end

    local ticksOffline = offlineSeconds / Config.PassiveIncome.TickInterval
    local incomePerTick = 0

    if BrainrotLevelServer then
        incomePerTick = BrainrotLevelServer.CalculatePassiveIncome(data)
    end

    local totalIncome = math.floor(incomePerTick * ticksOffline * Config.PassiveIncome.OfflineEfficiency)

    return totalIncome, offlineSeconds
end

function PassiveIncomeServer.ProcessPlayerJoin(player)
    local data = DataStoreManager:GetData(player)
    if not data then return end

    local offlineMoney, offlineSeconds = PassiveIncomeServer.CalculateOfflineRewards(data)

    if offlineMoney > 0 then
        data.Money = (data.Money or 0) + offlineMoney

        local offlineRewardRemote = remotesFolder:FindFirstChild("OfflineReward")
        if offlineRewardRemote then
            offlineRewardRemote:FireClient(player, {
                Money = offlineMoney,
                OfflineTime = offlineSeconds,
                Hours = math.floor(offlineSeconds / 3600),
                Minutes = math.floor((offlineSeconds % 3600) / 60),
            })
        end
    end

    data.LastOnlineTime = os.time()
end

function PassiveIncomeServer.TickAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        local data = DataStoreManager:GetData(player)
        if data then
            local income = 0

            if BrainrotLevelServer then
                income = BrainrotLevelServer.CalculatePassiveIncome(data)
            end

            if income > 0 then
                income = math.floor(income)
                data.Money = (data.Money or 0) + income
                data.LastOnlineTime = os.time()

                local passiveRemote = remotesFolder:FindFirstChild("PassiveIncomeUpdate")
                if passiveRemote then
                    passiveRemote:FireClient(player, income)
                end
            end
        end
    end
end

function PassiveIncomeServer.ProcessPlayerLeave(player)
    local data = DataStoreManager:GetData(player)
    if data then
        data.LastOnlineTime = os.time()
    end
end

return PassiveIncomeServer
