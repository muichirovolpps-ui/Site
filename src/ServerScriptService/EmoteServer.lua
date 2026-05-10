--[[
    EmoteServer.lua  v3.0
    Emote system with rank requirements, purchase, and animation playback.
    8 emotes: Dance, Flex, Cry, Rage, HackerPose, VictoryPose, Dab, Spin.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EmoteServer = {}

local config = nil
local remotes = nil
local dsManager = nil

function EmoteServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder

    local playEmote = remotes:FindFirstChild("PlayEmote")
    if playEmote then
        playEmote.OnServerEvent:Connect(function(player, emoteName)
            EmoteServer.PlayEmote(player, emoteName)
        end)
    end

    local buyEmote = remotes:FindFirstChild("BuyEmote")
    if buyEmote then
        buyEmote.OnServerEvent:Connect(function(player, emoteName)
            EmoteServer.BuyEmote(player, emoteName)
        end)
    end

    local getEmotes = remotes:FindFirstChild("GetEmotes")
    if getEmotes and getEmotes:IsA("RemoteFunction") then
        getEmotes.OnServerInvoke = function(player)
            return EmoteServer.GetPlayerEmotes(player)
        end
    end

    print("[EmoteServer] Initialized — " .. #config.Emotes .. " emotes loaded")
end

function EmoteServer.GetPlayerRank(player)
    local data = dsManager.GetData(player)
    if not data then return 1 end

    local rankIndex = 1
    for i, rank in ipairs(config.Ranks) do
        if data.Strength >= rank.RequiredStrength then
            rankIndex = i
        end
    end
    return rankIndex
end

function EmoteServer.PlayEmote(player, emoteName)
    local data = dsManager.GetData(player)
    if not data then return end

    if not data.OwnedEmotes then data.OwnedEmotes = {} end

    local emoteConfig = nil
    for _, e in ipairs(config.Emotes) do
        if e.Name == emoteName then
            emoteConfig = e
            break
        end
    end

    if not emoteConfig then return end

    if emoteConfig.Cost > 0 and not data.OwnedEmotes[emoteName] then
        return
    end

    local playerRank = EmoteServer.GetPlayerRank(player)
    if playerRank < emoteConfig.RequiredRank then return end

    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    local animation = Instance.new("Animation")
    animation.AnimationId = emoteConfig.AnimId

    local animTrack = animator:LoadAnimation(animation)
    animTrack:Play()
    animTrack.Looped = false

    remotes:FindFirstChild("EmotePlayed"):FireAllClients({
        Player = player.Name,
        Emote = emoteName,
        DisplayName = emoteConfig.DisplayName,
    })

    task.delay(animTrack.Length + 0.5, function()
        animation:Destroy()
    end)
end

function EmoteServer.BuyEmote(player, emoteName)
    local data = dsManager.GetData(player)
    if not data then return end

    if not data.OwnedEmotes then data.OwnedEmotes = {} end

    local emoteConfig = nil
    for _, e in ipairs(config.Emotes) do
        if e.Name == emoteName then
            emoteConfig = e
            break
        end
    end

    if not emoteConfig then return end
    if data.OwnedEmotes[emoteName] then return end

    local playerRank = EmoteServer.GetPlayerRank(player)
    if playerRank < emoteConfig.RequiredRank then
        remotes:FindFirstChild("ShowNotification"):FireClient(player, "Rank insuficiente!", "error")
        return
    end

    if data.Money < emoteConfig.Cost then
        remotes:FindFirstChild("ShowNotification"):FireClient(player, "Dinheiro insuficiente!", "error")
        return
    end

    data.Money = data.Money - emoteConfig.Cost
    data.OwnedEmotes[emoteName] = true

    remotes:FindFirstChild("ShowNotification"):FireClient(player, "Emote '" .. emoteConfig.DisplayName .. "' comprado!", "success")
end

function EmoteServer.GetPlayerEmotes(player)
    local data = dsManager.GetData(player)
    if not data then return {} end

    if not data.OwnedEmotes then data.OwnedEmotes = {} end

    local result = {}
    local playerRank = EmoteServer.GetPlayerRank(player)

    for _, emote in ipairs(config.Emotes) do
        table.insert(result, {
            Name = emote.Name,
            DisplayName = emote.DisplayName,
            Cost = emote.Cost,
            RequiredRank = emote.RequiredRank,
            Owned = data.OwnedEmotes[emote.Name] or (emote.Cost == 0),
            CanBuy = playerRank >= emote.RequiredRank and data.Money >= emote.Cost,
            Locked = playerRank < emote.RequiredRank,
        })
    end

    return result
end

return EmoteServer
