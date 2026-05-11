--[[
    PetEffectsServer.lua  v3.0
    Brainrots now float behind the player as pets with animations, trails, and sounds.
    Handles equip/unequip, positioning, and visual state sync.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PetEffectsServer = {}

local config = nil
local remotes = nil
local dsManager = nil
local BrainrotDatabase = nil

local equippedPets = {}

function PetEffectsServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder
    BrainrotDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))

    local equipRemote = remotes:FindFirstChild("EquipPet")
    if equipRemote then
        equipRemote.OnServerEvent:Connect(function(player, inventoryIndex)
            PetEffectsServer.EquipPet(player, inventoryIndex)
        end)
    end

    local unequipRemote = remotes:FindFirstChild("UnequipPet")
    if unequipRemote then
        unequipRemote.OnServerEvent:Connect(function(player)
            PetEffectsServer.UnequipPet(player)
        end)
    end

    Players.PlayerRemoving:Connect(function(player)
        PetEffectsServer.UnequipPet(player)
    end)

    RunService.Heartbeat:Connect(function(dt)
        PetEffectsServer.UpdateAllPets(dt)
    end)

    print("[PetEffects] Initialized — pet system active")
end

function PetEffectsServer.EquipPet(player, inventoryIndex)
    local data = dsManager:GetData(player)
    if not data then return end
    if not data.Inventory[inventoryIndex] then return end

    PetEffectsServer.UnequipPet(player)

    local brainrotData = data.Inventory[inventoryIndex]
    local brainrotInfo = BrainrotDatabase.FindBrainrot(brainrotData.Name)
    if not brainrotInfo then return end

    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local petModel = Instance.new("Model")
    petModel.Name = "Pet_" .. brainrotData.Name

    local petSize = (brainrotInfo.Size or 2) * 0.6
    local body = Instance.new("Part")
    body.Name = "PetBody"
    body.Size = Vector3.new(petSize, petSize, petSize)
    body.Shape = Enum.PartType.Ball
    body.Material = Enum.Material.Neon
    body.Anchored = true
    body.CanCollide = false

    local rarityColor = Color3.fromRGB(200, 200, 200)
    if brainrotData.Mutation then
        for _, mut in ipairs(config.Mutations) do
            if mut.Name == brainrotData.Mutation then
                rarityColor = mut.Color
                break
            end
        end
    else
        for _, rar in ipairs(config.Rarities) do
            if rar.Name == brainrotData.Rarity then
                rarityColor = rar.Color
                break
            end
        end
    end
    body.Color = rarityColor
    body.Parent = petModel

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, petSize / 2 + 1, 0)
    billboard.AlwaysOnTop = false
    billboard.Parent = body

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = brainrotInfo.DisplayName
    nameLabel.TextColor3 = rarityColor
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard

    if config.PetEffects.TrailEnabled then
        local att0 = Instance.new("Attachment")
        att0.Position = Vector3.new(0, petSize / 2, 0)
        att0.Parent = body
        local att1 = Instance.new("Attachment")
        att1.Position = Vector3.new(0, -petSize / 2, 0)
        att1.Parent = body
        local trail = Instance.new("Trail")
        trail.Attachment0 = att0
        trail.Attachment1 = att1
        trail.Lifetime = config.PetEffects.TrailLifetime
        trail.Color = ColorSequence.new(rarityColor)
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1),
        })
        trail.Parent = body
    end

    local glow = Instance.new("PointLight")
    glow.Color = rarityColor
    glow.Brightness = 1.5
    glow.Range = 8
    glow.Parent = body

    local particles = Instance.new("ParticleEmitter")
    particles.Color = ColorSequence.new(rarityColor)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 0),
    })
    particles.Rate = 5
    particles.Lifetime = NumberRange.new(0.5, 1)
    particles.Speed = NumberRange.new(1, 2)
    particles.Parent = body

    petModel.PrimaryPart = body
    petModel.Parent = workspace

    equippedPets[player.UserId] = {
        Model = petModel,
        Player = player,
        Angle = 0,
        BrainrotData = brainrotData,
    }

    remotes:FindFirstChild("PetEquipped"):FireClient(player, {
        Name = brainrotData.Name,
        DisplayName = brainrotInfo.DisplayName,
    })
end

function PetEffectsServer.UnequipPet(player)
    local petInfo = equippedPets[player.UserId]
    if petInfo then
        if petInfo.Model then
            petInfo.Model:Destroy()
        end
        equippedPets[player.UserId] = nil
    end
end

function PetEffectsServer.UpdateAllPets(dt)
    local petConfig = config.PetEffects
    for userId, petInfo in pairs(equippedPets) do
        local player = petInfo.Player
        if not player or not player.Parent then
            if petInfo.Model then petInfo.Model:Destroy() end
            equippedPets[userId] = nil
        else
            local character = player.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp and petInfo.Model and petInfo.Model.PrimaryPart then
                    petInfo.Angle = petInfo.Angle + dt * petConfig.FloatSpeed
                    local offset = Vector3.new(
                        math.cos(petInfo.Angle) * petConfig.FloatRadius,
                        petConfig.FloatHeight + math.sin(petInfo.Angle * 2) * petConfig.BobAmplitude,
                        math.sin(petInfo.Angle) * petConfig.FloatRadius
                    )
                    pcall(function()
                        petInfo.Model.PrimaryPart.CFrame = CFrame.new(hrp.Position + offset)
                    end)
                end
            end
        end
    end
end

return PetEffectsServer
