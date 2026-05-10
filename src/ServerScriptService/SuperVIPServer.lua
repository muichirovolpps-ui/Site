--[[
    SuperVIPServer.lua  v3.0
    Super VIP exclusive features: zone, brainrots, 4x rewards, rainbow name,
    particles, exclusive emotes, overhead title.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local SuperVIPServer = {}

local config = nil
local remotes = nil
local dsManager = nil
local BrainrotDatabase = nil

local superVIPPlayers = {}

function SuperVIPServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder
    BrainrotDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))

    SuperVIPServer.BuildExclusiveZone()

    print("[SuperVIP] Initialized — exclusive zone + brainrots loaded")
end

function SuperVIPServer.SetupPlayer(player)
    local data = dsManager.GetData(player)
    if not data then return end

    local isSuperVIP = false
    if data.Gamepasses then
        for _, gp in ipairs(data.Gamepasses) do
            if gp == "Super VIP" or gp == "SuperVIP" then
                isSuperVIP = true
                break
            end
        end
    end

    if not isSuperVIP then return end

    superVIPPlayers[player.UserId] = true

    player.CharacterAdded:Connect(function(character)
        task.wait(1)
        SuperVIPServer.ApplyEffects(player, character)
    end)

    if player.Character then
        SuperVIPServer.ApplyEffects(player, player.Character)
    end
end

function SuperVIPServer.ApplyEffects(player, character)
    if not superVIPPlayers[player.UserId] then return end

    local head = character:FindFirstChild("Head")
    if head then
        local existing = head:FindFirstChild("SuperVIPGui")
        if existing then existing:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "SuperVIPGui"
        billboard.Size = UDim2.new(0, 250, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = false
        billboard.Parent = head

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = config.SuperVIPPerks.OverheadTitle
        titleLabel.TextColor3 = config.SuperVIPPerks.ChatTagColor
        titleLabel.TextScaled = true
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextStrokeTransparency = 0.3
        titleLabel.Parent = billboard

        if config.SuperVIPPerks.RainbowName then
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "RainbowName"
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.DisplayName
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeTransparency = 0.3
            nameLabel.Parent = billboard

            task.spawn(function()
                local hue = 0
                while nameLabel and nameLabel.Parent do
                    hue = (hue + 0.01) % 1
                    nameLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
                    task.wait(0.05)
                end
            end)
        end
    end

    if config.SuperVIPPerks.SpecialParticles then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local existingP = hrp:FindFirstChild("SuperVIPParticles")
            if existingP then existingP:Destroy() end

            local particles = Instance.new("ParticleEmitter")
            particles.Name = "SuperVIPParticles"
            particles.Rate = 15
            particles.Lifetime = NumberRange.new(1, 2)
            particles.Speed = NumberRange.new(2, 4)
            particles.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 0),
            })
            particles.Parent = hrp

            task.spawn(function()
                local hue = 0
                while particles and particles.Parent do
                    hue = (hue + 0.005) % 1
                    particles.Color = ColorSequence.new(Color3.fromHSV(hue, 1, 1))
                    task.wait(0.1)
                end
            end)
        end
    end
end

function SuperVIPServer.BuildExclusiveZone()
    local vipZone = workspace:FindFirstChild("SuperVIPZone")
    if vipZone then vipZone:Destroy() end

    vipZone = Instance.new("Folder")
    vipZone.Name = "SuperVIPZone"
    vipZone.Parent = workspace

    local platform = Instance.new("Part")
    platform.Name = "VIPPlatform"
    platform.Size = Vector3.new(100, 5, 100)
    platform.Position = Vector3.new(300, 25, 0)
    platform.Color = Color3.fromRGB(255, 215, 0)
    platform.Material = Enum.Material.Neon
    platform.Anchored = true
    platform.Parent = vipZone

    local bridge = Instance.new("Part")
    bridge.Name = "VIPBridge"
    bridge.Size = Vector3.new(8, 1, 50)
    bridge.Position = Vector3.new(250, 25, 0)
    bridge.Color = Color3.fromRGB(255, 200, 0)
    bridge.Material = Enum.Material.Neon
    bridge.Anchored = true
    bridge.Parent = vipZone

    local gate = Instance.new("Part")
    gate.Name = "VIPGate"
    gate.Size = Vector3.new(10, 15, 2)
    gate.Position = Vector3.new(225, 32, 0)
    gate.Color = Color3.fromRGB(255, 50, 255)
    gate.Material = Enum.Material.ForceField
    gate.Transparency = 0.5
    gate.Anchored = true
    gate.CanCollide = true
    gate.Parent = vipZone

    gate.Touched:Connect(function(hit)
        local player = Players:GetPlayerFromCharacter(hit.Parent)
        if player and superVIPPlayers[player.UserId] then
            gate.CanCollide = false
            task.wait(2)
            gate.CanCollide = true
        end
    end)

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 300, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 10, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = gate

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "SUPER VIP ZONE"
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0
    label.Parent = billboard

    for i = 1, 4 do
        local pillar = Instance.new("Part")
        pillar.Name = "VIPPillar" .. i
        pillar.Size = Vector3.new(5, 30, 5)
        local offset = Vector3.new(
            i <= 2 and -45 or 45,
            15,
            i % 2 == 0 and -45 or 45
        )
        pillar.Position = Vector3.new(300, 25, 0) + offset
        pillar.Color = Color3.fromRGB(255, 200, 50)
        pillar.Material = Enum.Material.Neon
        pillar.Anchored = true
        pillar.Parent = vipZone

        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 215, 0)
        light.Brightness = 2
        light.Range = 20
        light.Parent = pillar
    end
end

function SuperVIPServer.IsSuperVIP(player)
    return superVIPPlayers[player.UserId] == true
end

function SuperVIPServer.GetMultiplier()
    return config.SuperVIPPerks.MoneyMultiplier
end

return SuperVIPServer
