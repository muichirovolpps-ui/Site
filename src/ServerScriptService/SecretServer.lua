--[[
    SecretServer.lua  v3.0
    Hidden buttons, secret portals, rare NPCs, secret brainrots, achievements.
    Tracks player discoveries and grants rewards.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SecretServer = {}

local config = nil
local remotes = nil
local dsManager = nil
local BrainrotDatabase = nil

function SecretServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder
    BrainrotDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))

    local claimSecret = remotes:FindFirstChild("ClaimSecret")
    if claimSecret then
        claimSecret.OnServerEvent:Connect(function(player, secretName)
            SecretServer.ClaimSecret(player, secretName)
        end)
    end

    local usePortal = remotes:FindFirstChild("UseSecretPortal")
    if usePortal then
        usePortal.OnServerEvent:Connect(function(player, portalName)
            SecretServer.UsePortal(player, portalName)
        end)
    end

    local getAchievements = remotes:FindFirstChild("GetAchievements")
    if getAchievements and getAchievements:IsA("RemoteFunction") then
        getAchievements.OnServerInvoke = function(player)
            return SecretServer.GetPlayerAchievements(player)
        end
    end

    SecretServer.BuildSecrets()

    print("[SecretServer] Initialized — " .. #config.Secrets.HiddenButtons .. " secrets, "
        .. #config.Secrets.Achievements .. " achievements")
end

function SecretServer.BuildSecrets()
    local secretsFolder = workspace:FindFirstChild("Secrets")
    if not secretsFolder then
        secretsFolder = Instance.new("Folder")
        secretsFolder.Name = "Secrets"
        secretsFolder.Parent = workspace
    end

    for _, btn in ipairs(config.Secrets.HiddenButtons) do
        local part = Instance.new("Part")
        part.Name = "Secret_" .. btn.Name
        part.Size = Vector3.new(2, 2, 2)
        part.Position = btn.Position
        part.Color = Color3.fromRGB(100, 0, 200)
        part.Material = Enum.Material.ForceField
        part.Transparency = 0.7
        part.Anchored = true
        part.CanCollide = false
        part.Parent = secretsFolder

        local clickDetector = Instance.new("ClickDetector")
        clickDetector.MaxActivationDistance = 10
        clickDetector.Parent = part

        clickDetector.MouseClick:Connect(function(player)
            SecretServer.ClaimSecret(player, btn.Name)
        end)
    end

    for _, portal in ipairs(config.Secrets.SecretPortals) do
        local portalPart = Instance.new("Part")
        portalPart.Name = "Portal_" .. portal.Name
        portalPart.Size = Vector3.new(8, 12, 1)
        portalPart.Position = portal.Position
        portalPart.Color = Color3.fromRGB(150, 0, 255)
        portalPart.Material = Enum.Material.ForceField
        portalPart.Transparency = 0.3
        portalPart.Anchored = true
        portalPart.CanCollide = false
        portalPart.Parent = secretsFolder

        local particles = Instance.new("ParticleEmitter")
        particles.Color = ColorSequence.new(Color3.fromRGB(150, 0, 255))
        particles.Rate = 20
        particles.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        })
        particles.Lifetime = NumberRange.new(1, 2)
        particles.Speed = NumberRange.new(2, 5)
        particles.Parent = portalPart

        portalPart.Touched:Connect(function(hit)
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if player then
                SecretServer.UsePortal(player, portal.Name)
            end
        end)
    end
end

function SecretServer.ClaimSecret(player, secretName)
    local data = dsManager.GetData(player)
    if not data then return end

    if not data.FoundSecrets then data.FoundSecrets = {} end
    if data.FoundSecrets[secretName] then return end

    local secretConfig = nil
    for _, btn in ipairs(config.Secrets.HiddenButtons) do
        if btn.Name == secretName then
            secretConfig = btn
            break
        end
    end

    if not secretConfig then return end

    data.FoundSecrets[secretName] = true

    if secretConfig.Reward.Money then
        data.Money = data.Money + secretConfig.Reward.Money
    end
    if secretConfig.Reward.Gems then
        data.Gems = (data.Gems or 0) + secretConfig.Reward.Gems
    end
    if secretConfig.Reward.Mutation then
        if data.Inventory and #data.Inventory > 0 then
            local randomBrain = data.Inventory[math.random(1, #data.Inventory)]
            if not randomBrain.Mutation then
                randomBrain.Mutation = secretConfig.Reward.Mutation
            end
        end
    end

    local secretCount = 0
    for _ in pairs(data.FoundSecrets) do secretCount = secretCount + 1 end

    SecretServer.CheckAchievements(player, "Secrets", secretCount)

    remotes:FindFirstChild("SecretFound"):FireClient(player, {
        Name = secretName,
        Reward = secretConfig.Reward,
    })

    local secretBrainrots = config.Secrets.SecretBrainrots
    if secretBrainrots and secretCount >= 3 then
        local brainName = secretBrainrots[math.random(1, #secretBrainrots)]
        local brainInfo = BrainrotDatabase.FindBrainrot(brainName)
        if brainInfo then
            local alreadyHas = false
            for _, inv in ipairs(data.Inventory) do
                if inv.Name == brainName then alreadyHas = true break end
            end
            if not alreadyHas then
                table.insert(data.Inventory, {
                    Name = brainName,
                    Rarity = "Secret",
                    Mutation = nil,
                    Level = 1,
                })
                remotes:FindFirstChild("ShowNotification"):FireClient(player,
                    "Brainrot secreto: " .. brainInfo.DisplayName .. "!", "legendary")
            end
        end
    end
end

function SecretServer.UsePortal(player, portalName)
    local data = dsManager.GetData(player)
    if not data then return end

    local portalConfig = nil
    for _, portal in ipairs(config.Secrets.SecretPortals) do
        if portal.Name == portalName then
            portalConfig = portal
            break
        end
    end

    if not portalConfig then return end

    if portalConfig.RequiredRank then
        local rankIndex = 1
        for i, rank in ipairs(config.Ranks) do
            if data.Strength >= rank.RequiredStrength then rankIndex = i end
        end
        if rankIndex < portalConfig.RequiredRank then
            remotes:FindFirstChild("ShowNotification"):FireClient(player,
                "Rank " .. config.Ranks[portalConfig.RequiredRank].DisplayName .. " necessario!", "error")
            return
        end
    end

    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(portalConfig.Destination)
        end
    end
end

function SecretServer.CheckAchievements(player, achieveType, value)
    local data = dsManager.GetData(player)
    if not data then return end

    if not data.Achievements then data.Achievements = {} end

    for _, ach in ipairs(config.Secrets.Achievements) do
        if ach.Type == achieveType and not data.Achievements[ach.Name] then
            if value >= ach.Target then
                data.Achievements[ach.Name] = true

                if ach.Reward.Money then
                    data.Money = data.Money + ach.Reward.Money
                end
                if ach.Reward.Gems then
                    data.Gems = (data.Gems or 0) + ach.Reward.Gems
                end

                remotes:FindFirstChild("AchievementUnlocked"):FireClient(player, {
                    Name = ach.Name,
                    Description = ach.Description,
                    Reward = ach.Reward,
                })
            end
        end
    end
end

function SecretServer.GetPlayerAchievements(player)
    local data = dsManager.GetData(player)
    if not data then return {} end

    if not data.Achievements then data.Achievements = {} end

    local result = {}
    for _, ach in ipairs(config.Secrets.Achievements) do
        table.insert(result, {
            Name = ach.Name,
            Description = ach.Description,
            Completed = data.Achievements[ach.Name] or false,
            Reward = ach.Reward,
        })
    end
    return result
end

return SecretServer
