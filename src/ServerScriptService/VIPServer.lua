--[[
    VIPServer.lua  v2.0
    VIP gamepass system + Server Boost system.
    VIP: chat tag, overhead tag, multipliers, special effects.
    Server Boosts: temporary luck multiplier for ALL players.
]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Chat = game:GetService("Chat")

local VIPServer = {}

local Config
local DataStoreManager
local remotesFolder

local activeServerBoosts = {}

function VIPServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local serverBoostRemote = remotesFolder:FindFirstChild("ActivateServerBoost")
    if not serverBoostRemote then
        serverBoostRemote = Instance.new("RemoteEvent")
        serverBoostRemote.Name = "ActivateServerBoost"
        serverBoostRemote.Parent = remotesFolder
    end

    local serverBoostUpdate = remotesFolder:FindFirstChild("ServerBoostUpdate")
    if not serverBoostUpdate then
        serverBoostUpdate = Instance.new("RemoteEvent")
        serverBoostUpdate.Name = "ServerBoostUpdate"
        serverBoostUpdate.Parent = remotesFolder
    end

    local getServerBoosts = remotesFolder:FindFirstChild("GetServerBoosts")
    if not getServerBoosts then
        getServerBoosts = Instance.new("RemoteFunction")
        getServerBoosts.Name = "GetServerBoosts"
        getServerBoosts.Parent = remotesFolder
    end

    getServerBoosts.OnServerInvoke = function(player)
        return VIPServer.GetActiveBoosts()
    end

    task.spawn(function()
        while true do
            task.wait(1)
            VIPServer.UpdateBoosts()
        end
    end)
end

function VIPServer.IsVIP(player)
    local data = DataStoreManager:GetData(player)
    if not data or not data.Gamepasses then return false end
    for _, gp in ipairs(data.Gamepasses) do
        if gp == "VIP" then return true end
    end
    return false
end

function VIPServer.SetupVIPPlayer(player)
    if not VIPServer.IsVIP(player) then return end

    local character = player.Character or player.CharacterAdded:Wait()

    local head = character:WaitForChild("Head", 5)
    if head then
        local existingTag = head:FindFirstChild("VIPTag")
        if not existingTag then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "VIPTag"
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local tagLabel = Instance.new("TextLabel")
            tagLabel.Size = UDim2.new(1, 0, 1, 0)
            tagLabel.BackgroundTransparency = 1
            tagLabel.TextColor3 = Config.VIPPerks.ChatTagColor
            tagLabel.Text = Config.VIPPerks.ChatTag
            tagLabel.Font = Enum.Font.GothamBold
            tagLabel.TextSize = 14
            tagLabel.TextStrokeTransparency = 0
            tagLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            tagLabel.Parent = billboard
        end
    end

    if Config.VIPPerks.SpecialEffects then
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        if rootPart then
            local existingParticle = rootPart:FindFirstChild("VIPParticle")
            if not existingParticle then
                local particle = Instance.new("ParticleEmitter")
                particle.Name = "VIPParticle"
                particle.Color = ColorSequence.new(Config.VIPPerks.ChatTagColor)
                particle.Size = NumberSequence.new(0.3, 0)
                particle.Lifetime = NumberRange.new(0.5, 1)
                particle.Rate = 10
                particle.Speed = NumberRange.new(1, 2)
                particle.SpreadAngle = Vector2.new(360, 360)
                particle.LightEmission = 1
                particle.Parent = rootPart
            end
        end
    end
end

function VIPServer.GetMoneyMultiplier(player)
    local mult = 1
    local data = DataStoreManager:GetData(player)
    if not data or not data.Gamepasses then return mult end

    for _, gp in ipairs(data.Gamepasses) do
        if gp == "VIP" then
            mult = mult * Config.VIPPerks.MoneyMultiplier
        end
        if gp == "2x Money" then
            mult = mult * 2
        end
    end

    return mult
end

function VIPServer.GetStrengthMultiplier(player)
    local mult = 1
    local data = DataStoreManager:GetData(player)
    if not data or not data.Gamepasses then return mult end

    for _, gp in ipairs(data.Gamepasses) do
        if gp == "VIP" then
            mult = mult * Config.VIPPerks.StrengthMultiplier
        end
        if gp == "2x Strength" then
            mult = mult * 2
        end
    end

    return mult
end

function VIPServer.GetLuckMultiplier(player)
    local mult = 1
    local data = DataStoreManager:GetData(player)
    if not data or not data.Gamepasses then return mult end

    for _, gp in ipairs(data.Gamepasses) do
        if gp == "VIP" then
            mult = mult * Config.VIPPerks.LuckMultiplier
        end
        for _, gpConfig in ipairs(Config.Gamepasses) do
            if gpConfig.Name == gp and gpConfig.Type == "Luck" then
                mult = mult * gpConfig.Multiplier
            end
        end
    end

    for _, boost in ipairs(activeServerBoosts) do
        if boost.Type == "Luck" then
            mult = mult * boost.Multiplier
        end
    end

    return mult
end

function VIPServer.ActivateServerBoost(player, boostIndex)
    boostIndex = tonumber(boostIndex)
    if not boostIndex or boostIndex < 1 or boostIndex > #Config.ServerBoosts then return end

    local boostConfig = Config.ServerBoosts[boostIndex]

    table.insert(activeServerBoosts, {
        Name = boostConfig.Name,
        Type = boostConfig.Type,
        Multiplier = boostConfig.Multiplier,
        Duration = boostConfig.Duration,
        ActivatedBy = player.Name,
        StartTime = os.time(),
        EndTime = os.time() + boostConfig.Duration,
    })

    local boostUpdateRemote = remotesFolder:FindFirstChild("ServerBoostUpdate")
    if boostUpdateRemote then
        boostUpdateRemote:FireAllClients("activated", {
            Name = boostConfig.Name,
            Multiplier = boostConfig.Multiplier,
            Duration = boostConfig.Duration,
            ActivatedBy = player.Name,
        })
    end

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        for _, p in ipairs(Players:GetPlayers()) do
            notifyRemote:FireClient(p, "success",
                player.Name .. " ativou " .. boostConfig.Name .. " para o servidor!")
        end
    end
end

function VIPServer.UpdateBoosts()
    local now = os.time()
    local removed = false

    for i = #activeServerBoosts, 1, -1 do
        if now >= activeServerBoosts[i].EndTime then
            local expired = table.remove(activeServerBoosts, i)
            removed = true

            local boostUpdateRemote = remotesFolder:FindFirstChild("ServerBoostUpdate")
            if boostUpdateRemote then
                boostUpdateRemote:FireAllClients("expired", { Name = expired.Name })
            end
        end
    end
end

function VIPServer.GetActiveBoosts()
    local boosts = {}
    local now = os.time()
    for _, boost in ipairs(activeServerBoosts) do
        table.insert(boosts, {
            Name = boost.Name,
            Multiplier = boost.Multiplier,
            RemainingTime = boost.EndTime - now,
            ActivatedBy = boost.ActivatedBy,
        })
    end
    return boosts
end

return VIPServer
