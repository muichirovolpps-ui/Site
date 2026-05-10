--[[
    EventSystemServer.lua  v3.0
    Manages 10 live events: MeteorShower, BrainrotRain, LuckyHour, RainbowEvent,
    HackerInvasion, AlienEvent, GoldenStorm, SpeedFrenzy, DoubleRebirth, BossEvent.
    Random events with server-wide effects, rewards, and announcements.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EventSystemServer = {}

local config = nil
local remotes = nil
local dsManager = nil
local bossServer = nil

local activeEvent = nil
local activeModifiers = {}
local nextEventTime = 0
local eventLog = {}

function EventSystemServer.Initialize(cfg, ds, remotesFolder, bossRef)
    config = cfg
    dsManager = ds
    remotes = remotesFolder
    bossServer = bossRef

    nextEventTime = os.time() + math.random(config.Events.MinInterval, config.Events.MaxInterval)

    task.spawn(function()
        while true do
            task.wait(5)
            if os.time() >= nextEventTime and not activeEvent then
                local eventIndex = math.random(1, #config.Events.Types)
                EventSystemServer.StartEvent(config.Events.Types[eventIndex])
            end
        end
    end)

    local forceEvent = remotes:FindFirstChild("ForceEvent")
    if forceEvent then
        forceEvent.OnServerEvent:Connect(function(player, eventName)
            local isAdmin = false
            for _, uid in ipairs(config.AdminUserIds) do
                if player.UserId == uid then isAdmin = true break end
            end
            if not isAdmin then return end
            for _, ev in ipairs(config.Events.Types) do
                if ev.Name == eventName then
                    EventSystemServer.StartEvent(ev)
                    break
                end
            end
        end)
    end

    print("[EventSystem] Initialized — 10 event types loaded")
end

function EventSystemServer.StartEvent(eventData)
    if activeEvent then return end
    activeEvent = eventData

    table.insert(eventLog, { Event = eventData.Name, Time = os.time() })

    remotes:FindFirstChild("EventStarted"):FireAllClients({
        Name = eventData.Name,
        DisplayName = eventData.DisplayName,
        Duration = eventData.Duration,
        Color = eventData.Color,
    })

    activeModifiers = {}
    if eventData.MoneyMultiplier then activeModifiers.MoneyMultiplier = eventData.MoneyMultiplier end
    if eventData.LuckMultiplier then activeModifiers.LuckMultiplier = eventData.LuckMultiplier end
    if eventData.StrengthMultiplier then activeModifiers.StrengthMultiplier = eventData.StrengthMultiplier end
    if eventData.SpeedMultiplier then activeModifiers.SpeedMultiplier = eventData.SpeedMultiplier end
    if eventData.CooldownReduction then activeModifiers.CooldownReduction = eventData.CooldownReduction end
    if eventData.RebirthMultiplier then activeModifiers.RebirthMultiplier = eventData.RebirthMultiplier end
    if eventData.RequirementReduction then activeModifiers.RequirementReduction = eventData.RequirementReduction end
    if eventData.MutationChance then activeModifiers.MutationChance = eventData.MutationChance end
    if eventData.RarityBoost then activeModifiers.RarityBoost = eventData.RarityBoost end

    if eventData.Name == "MeteorShower" then
        task.spawn(function()
            EventSystemServer.RunMeteorShower(eventData)
        end)
    elseif eventData.Name == "BrainrotRain" then
        task.spawn(function()
            EventSystemServer.RunBrainrotRain(eventData)
        end)
    elseif eventData.Name == "BossEvent" then
        if bossServer then
            bossServer.SpawnRandomBoss()
        end
    elseif eventData.Name == "GoldenStorm" then
        task.spawn(function()
            EventSystemServer.RunGoldenStorm(eventData)
        end)
    elseif eventData.Name == "AlienEvent" then
        for _, player in ipairs(Players:GetPlayers()) do
            local data = dsManager.GetData(player)
            if data then
                data.Gems = (data.Gems or 0) + (eventData.GemsReward or 10)
            end
        end
    end

    task.delay(eventData.Duration, function()
        activeEvent = nil
        activeModifiers = {}

        remotes:FindFirstChild("EventEnded"):FireAllClients({
            Name = eventData.Name,
            DisplayName = eventData.DisplayName,
        })

        nextEventTime = os.time() + math.random(config.Events.MinInterval, config.Events.MaxInterval)
    end)
end

function EventSystemServer.RunMeteorShower(eventData)
    local meteorCount = config.MeteorEvent.MeteorCount or 5
    for i = 1, meteorCount do
        task.wait(eventData.Duration / meteorCount)
        local x = math.random(-150, 150)
        local z = math.random(-300, -50)
        local impactPos = Vector3.new(x, 0, z)

        remotes:FindFirstChild("MeteorEvent"):FireAllClients(impactPos)

        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - impactPos).Magnitude < (config.MeteorEvent.ExplosionRadius or 15) then
                    local data = dsManager.GetData(player)
                    if data then
                        data.Money = data.Money + (eventData.MoneyBonus or 500)
                        data.Strength = data.Strength + (eventData.StrengthBonus or 100)
                    end
                end
            end
        end
    end
end

function EventSystemServer.RunBrainrotRain(eventData)
    local count = eventData.BrainrotCount or 10
    for i = 1, count do
        task.wait(eventData.Duration / count)
        remotes:FindFirstChild("BrainrotRainDrop"):FireAllClients({
            Position = Vector3.new(math.random(-100, 100), 80, math.random(-200, 0)),
            RarityBoost = eventData.RarityBoost or 2,
        })
    end
end

function EventSystemServer.RunGoldenStorm(eventData)
    local ticks = math.floor(eventData.Duration / 3)
    for i = 1, ticks do
        task.wait(3)
        for _, player in ipairs(Players:GetPlayers()) do
            local data = dsManager.GetData(player)
            if data then
                local bonus = math.floor(data.Money * 0.01 * (eventData.MoneyMultiplier or 10))
                data.Money = data.Money + math.max(bonus, 100)
            end
        end
    end
end

function EventSystemServer.GetActiveEvent()
    return activeEvent
end

function EventSystemServer.GetActiveModifiers()
    return activeModifiers
end

function EventSystemServer.IsEventActive()
    return activeEvent ~= nil
end

function EventSystemServer.GetModifier(stat)
    return activeModifiers[stat] or 1
end

return EventSystemServer
