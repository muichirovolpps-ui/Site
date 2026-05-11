--[[
    MeteorEventServer.lua  v2.0
    Meteor event system: random meteors fall, explode, give special rewards.
    Includes Meteor Mutation (fire particles, orange glow, higher value).
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local MeteorEventServer = {}

local Config
local DataStoreManager
local remotesFolder

local eventActive = false
local lastEventTime = 0
local nextEventTime = 0

function MeteorEventServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local meteorRemote = remotesFolder:FindFirstChild("MeteorEvent")
    if not meteorRemote then
        meteorRemote = Instance.new("RemoteEvent")
        meteorRemote.Name = "MeteorEvent"
        meteorRemote.Parent = remotesFolder
    end

    local meteorWarning = remotesFolder:FindFirstChild("MeteorWarning")
    if not meteorWarning then
        meteorWarning = Instance.new("RemoteEvent")
        meteorWarning.Name = "MeteorWarning"
        meteorWarning.Parent = remotesFolder
    end

    nextEventTime = os.time() + math.random(Config.MeteorEvent.MinInterval, Config.MeteorEvent.MaxInterval)

    task.spawn(function()
        while true do
            task.wait(10)
            if os.time() >= nextEventTime and not eventActive then
                MeteorEventServer.StartEvent()
            end
        end
    end)
end

function MeteorEventServer.StartEvent()
    if eventActive then return end
    eventActive = true
    lastEventTime = os.time()

    local warningRemote = remotesFolder:FindFirstChild("MeteorWarning")
    if warningRemote then
        warningRemote:FireAllClients("start", Config.MeteorEvent.WarningTime)
    end

    task.wait(Config.MeteorEvent.WarningTime)

    for i = 1, Config.MeteorEvent.MeteorCount do
        MeteorEventServer.SpawnMeteor()
        task.wait(Config.MeteorEvent.Duration / Config.MeteorEvent.MeteorCount)
    end

    eventActive = false
    nextEventTime = os.time() + math.random(Config.MeteorEvent.MinInterval, Config.MeteorEvent.MaxInterval)

    if warningRemote then
        warningRemote:FireAllClients("end", 0)
    end
end

function MeteorEventServer.SpawnMeteor()
    local spawnX = math.random(-150, 150)
    local spawnZ = math.random(-300, -130)
    local targetPos = Vector3.new(spawnX, 5, spawnZ)

    local meteor = Instance.new("Part")
    meteor.Name = "Meteor"
    meteor.Shape = Enum.PartType.Ball
    meteor.Size = Vector3.new(8, 8, 8)
    meteor.Position = targetPos + Vector3.new(0, 200, 0)
    meteor.Anchored = false
    meteor.CanCollide = false
    meteor.Color = Color3.fromRGB(255, 100, 0)
    meteor.Material = Enum.Material.Neon
    meteor.Parent = workspace

    local fire = Instance.new("Fire")
    fire.Size = 10
    fire.Heat = 15
    fire.Color = Color3.fromRGB(255, 150, 0)
    fire.SecondaryColor = Color3.fromRGB(255, 50, 0)
    fire.Parent = meteor

    local trail = Instance.new("Trail")
    local a0 = Instance.new("Attachment")
    a0.Position = Vector3.new(0, 2, 0)
    a0.Parent = meteor
    local a1 = Instance.new("Attachment")
    a1.Position = Vector3.new(0, -2, 0)
    a1.Parent = meteor
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Color = ColorSequence.new(Color3.fromRGB(255, 150, 0), Color3.fromRGB(255, 0, 0))
    trail.Lifetime = 1
    trail.LightEmission = 1
    trail.Parent = meteor

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 120, 0)
    light.Brightness = 3
    light.Range = 30
    light.Parent = meteor

    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.new(0, -80, 0)
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Parent = meteor

    Debris:AddItem(meteor, 10)

    local meteorRemote = remotesFolder:FindFirstChild("MeteorEvent")

    task.spawn(function()
        task.wait(2.5)

        if meteor and meteor.Parent then
            local impactPos = meteor.Position

            meteor:Destroy()

            local explosion = Instance.new("Explosion")
            explosion.Position = impactPos
            explosion.BlastRadius = Config.MeteorEvent.ExplosionRadius
            explosion.BlastPressure = 0
            explosion.DestroyJointRadiusPercent = 0
            explosion.Parent = workspace
            Debris:AddItem(explosion, 3)

            local crater = Instance.new("Part")
            crater.Name = "MeteorCrater"
            crater.Shape = Enum.PartType.Cylinder
            crater.Size = Vector3.new(2, Config.MeteorEvent.ExplosionRadius * 2, Config.MeteorEvent.ExplosionRadius * 2)
            crater.Position = Vector3.new(impactPos.X, 1, impactPos.Z)
            crater.Orientation = Vector3.new(0, 0, 90)
            crater.Anchored = true
            crater.CanCollide = false
            crater.Color = Color3.fromRGB(80, 40, 0)
            crater.Material = Enum.Material.Slate
            crater.Parent = workspace
            Debris:AddItem(crater, 30)

            local craterGlow = Instance.new("PointLight")
            craterGlow.Color = Color3.fromRGB(255, 100, 0)
            craterGlow.Brightness = 2
            craterGlow.Range = 20
            craterGlow.Parent = crater

            if meteorRemote then
                meteorRemote:FireAllClients("impact", impactPos)
            end

            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - impactPos).Magnitude
                    if dist <= Config.MeteorEvent.ExplosionRadius * 2 then
                        local data = DataStoreManager:GetData(p)
                        if data then
                            local moneyReward = Config.MeteorEvent.BaseMoney * (1 + (data.Rebirths or 0) * 0.1)
                            local strengthReward = Config.MeteorEvent.BaseStrength * (1 + (data.Rebirths or 0) * 0.1)
                            data.Money = (data.Money or 0) + moneyReward
                            data.Strength = (data.Strength or 0) + strengthReward

                            if math.random() < Config.MeteorEvent.MeteorMutationChance then
                                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                                local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))
                                local rarityNames = {"Basico", "Comum", "Raro", "Mitico", "Divino", "Classico", "OG", "Hacker"}
                                local maxRarityIdx = math.min(math.floor((data.Strength or 1) / 1000) + 1, #rarityNames)
                                local chosenRarity = rarityNames[math.random(1, maxRarityIdx)]
                                local brainrots = BrainrotDB.GetBrainrotsByRarity(chosenRarity)
                                if #brainrots > 0 then
                                    local chosen = brainrots[math.random(1, #brainrots)]
                                    table.insert(data.Inventory, {
                                        Name = chosen.Name,
                                        Rarity = chosenRarity,
                                        Mutation = "Meteor",
                                        Level = 1,
                                    })
                                    local brainrotRemote = remotesFolder:FindFirstChild("BrainrotObtained")
                                    if brainrotRemote then
                                        brainrotRemote:FireClient(p, chosen.DisplayName, chosenRarity, "Meteor")
                                    end
                                end
                            end

                            local rewardRemote = remotesFolder:FindFirstChild("ShowReward")
                            if rewardRemote then
                                rewardRemote:FireClient(p, {
                                    Money = moneyReward,
                                    Strength = strengthReward,
                                    Source = "Meteor",
                                })
                            end
                        end
                    end
                end
            end
        end
    end)
end

return MeteorEventServer
