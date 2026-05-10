--[[
    RarityRoadBuilder.lua (Workspace/Builders)
    Generates the long rarity road with 8 distinct zones.
    Each zone has unique floor colors, atmosphere, particles, and Lucky Blocks.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))
local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))

local RarityRoadBuilder = {}

local function createPart(props)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = props.CanCollide ~= false
    part.Size = props.Size or Vector3.new(4, 4, 4)
    part.Position = props.Position or Vector3.new(0, 0, 0)
    part.Color = props.Color or Color3.fromRGB(200, 200, 200)
    part.Material = props.Material or Enum.Material.SmoothPlastic
    part.Name = props.Name or "Part"
    part.Transparency = props.Transparency or 0
    if props.Shape then part.Shape = props.Shape end
    return part
end

function RarityRoadBuilder.Build(roadFolder)
    local startPos = Config.RarityRoad.StartPosition
    local zoneLength = Config.RarityRoad.ZoneLength
    local zoneWidth = Config.RarityRoad.ZoneWidth
    local gap = Config.RarityRoad.GapBetweenZones

    for i, rarity in ipairs(Config.Rarities) do
        local zoneOffset = (i - 1) * (zoneLength + gap)
        local zoneCenter = startPos + Vector3.new(0, 0, -zoneOffset)

        local zoneFolder = Instance.new("Folder")
        zoneFolder.Name = "Zone_" .. rarity.Name
        zoneFolder.Parent = roadFolder

        RarityRoadBuilder.BuildZone(zoneFolder, rarity, zoneCenter, zoneWidth, zoneLength, i)
    end

    RarityRoadBuilder.BuildConnectors(roadFolder, startPos, #Config.Rarities, zoneLength, gap, zoneWidth)
end

function RarityRoadBuilder.BuildZone(folder, rarity, center, width, length, zoneIndex)
    local floor = createPart({
        Name = rarity.Name .. "_Floor",
        Size = Vector3.new(width, 1, length),
        Position = center + Vector3.new(0, -0.5, -length / 2),
        Color = rarity.FloorColor,
        Material = Enum.Material.SmoothPlastic,
    })
    floor.Parent = folder

    local floorGlow = createPart({
        Name = rarity.Name .. "_FloorGlow",
        Size = Vector3.new(width - 2, 0.1, length - 2),
        Position = center + Vector3.new(0, 0.1, -length / 2),
        Color = rarity.Color,
        Material = Enum.Material.Neon,
        Transparency = 0.6,
    })
    floorGlow.CanCollide = false
    floorGlow.Parent = folder

    local leftWall = createPart({
        Name = rarity.Name .. "_LeftWall",
        Size = Vector3.new(1, 8, length),
        Position = center + Vector3.new(-width / 2, 4, -length / 2),
        Color = rarity.Color,
        Material = Enum.Material.Neon,
        Transparency = 0.7,
    })
    leftWall.CanCollide = true
    leftWall.Parent = folder

    local rightWall = createPart({
        Name = rarity.Name .. "_RightWall",
        Size = Vector3.new(1, 8, length),
        Position = center + Vector3.new(width / 2, 4, -length / 2),
        Color = rarity.Color,
        Material = Enum.Material.Neon,
        Transparency = 0.7,
    })
    rightWall.CanCollide = true
    rightWall.Parent = folder

    local entrance = createPart({
        Name = rarity.Name .. "_EntranceSign",
        Size = Vector3.new(width, 6, 1),
        Position = center + Vector3.new(0, 3, 0),
        Color = rarity.Color,
        Material = Enum.Material.Neon,
    })
    entrance.Parent = folder

    local signBoard = createPart({
        Name = rarity.Name .. "_SignBoard",
        Size = Vector3.new(width - 4, 4, 0.5),
        Position = center + Vector3.new(0, 3, 0.8),
        Color = Color3.fromRGB(20, 20, 35),
    })
    signBoard.Parent = folder

    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.Parent = signBoard

    local signLabel = Instance.new("TextLabel")
    signLabel.Size = UDim2.new(1, 0, 0.6, 0)
    signLabel.Position = UDim2.new(0, 0, 0, 0)
    signLabel.BackgroundTransparency = 1
    signLabel.Text = rarity.DisplayName
    signLabel.TextColor3 = rarity.Color
    signLabel.TextScaled = true
    signLabel.Font = Enum.Font.GothamBold
    signLabel.Parent = surfaceGui

    local reqLabel = Instance.new("TextLabel")
    reqLabel.Size = UDim2.new(1, 0, 0.4, 0)
    reqLabel.Position = UDim2.new(0, 0, 0.6, 0)
    reqLabel.BackgroundTransparency = 1
    reqLabel.Text = "Forca: " .. rarity.RequiredStrength
    reqLabel.TextColor3 = Color3.fromRGB(255, 255, 200)
    reqLabel.TextScaled = true
    reqLabel.Font = Enum.Font.Gotham
    reqLabel.Parent = surfaceGui

    if rarity.RequiredStrength > 0 then
        local barrier = createPart({
            Name = rarity.Name .. "_Barrier",
            Size = Vector3.new(width, 10, 1),
            Position = center + Vector3.new(0, 5, 1),
            Color = Color3.fromRGB(255, 0, 0),
            Material = Enum.Material.ForceField,
            Transparency = 0.5,
        })
        barrier.CanCollide = true
        barrier.Parent = folder

        barrier.Touched:Connect(function(hit)
            local player = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent)
            if player then
                local data = player:FindFirstChild("leaderstats")
                if data then
                    local strength = data:FindFirstChild("Strength")
                    if strength and strength.Value >= rarity.RequiredStrength then
                        barrier.CanCollide = false
                        barrier.Transparency = 0.9
                        task.wait(2)
                        barrier.CanCollide = true
                        barrier.Transparency = 0.5
                    end
                end
            end
        end)
    end

    RarityRoadBuilder.CreateZoneLuckyBlocks(folder, rarity, center, width, length)
    RarityRoadBuilder.CreateZoneDecorations(folder, rarity, center, width, length, zoneIndex)
    RarityRoadBuilder.CreateZoneAtmosphere(folder, rarity, center, width, length)
end

function RarityRoadBuilder.CreateZoneLuckyBlocks(folder, rarity, center, width, length)
    local lbCount = 4
    local spacing = length / (lbCount + 1)

    for i = 1, lbCount do
        local xOffset = (i % 2 == 0) and (width / 4) or -(width / 4)
        local zOffset = -spacing * i

        local luckyBlock = createPart({
            Name = rarity.Name .. "_LuckyBlock_" .. i,
            Size = Vector3.new(5, 5, 5),
            Position = center + Vector3.new(xOffset, 3, zOffset),
            Color = Color3.fromRGB(255, 215, 0),
            Material = Enum.Material.Neon,
        })
        luckyBlock.Parent = folder

        local surfaceGui = Instance.new("SurfaceGui")
        surfaceGui.Face = Enum.NormalId.Front
        surfaceGui.Parent = luckyBlock

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "?"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = surfaceGui

        Utils.CreateParticles(luckyBlock, rarity.Color, 15, 3, 1.5)

        local click = Instance.new("ClickDetector")
        click.MaxActivationDistance = 15
        click.Parent = luckyBlock

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(6, 0, 1.5, 0)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.Parent = luckyBlock

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = rarity.DisplayName .. " Lucky Block"
        nameLabel.TextColor3 = rarity.Color
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = billboard

        local zoneValue = Instance.new("StringValue")
        zoneValue.Name = "Zone"
        zoneValue.Value = rarity.Name
        zoneValue.Parent = luckyBlock
    end
end

function RarityRoadBuilder.CreateZoneDecorations(folder, rarity, center, width, length, zoneIndex)
    for side = -1, 1, 2 do
        for i = 1, 4 do
            local spacing = length / 5
            local pillar = createPart({
                Name = rarity.Name .. "_Pillar_" .. side .. "_" .. i,
                Size = Vector3.new(1.5, 12, 1.5),
                Position = center + Vector3.new(side * (width / 2 + 2), 6, -spacing * i),
                Color = rarity.Color,
                Material = Enum.Material.Neon,
            })
            pillar.Parent = folder

            local orb = createPart({
                Name = rarity.Name .. "_Orb_" .. side .. "_" .. i,
                Size = Vector3.new(2, 2, 2),
                Position = center + Vector3.new(side * (width / 2 + 2), 13, -spacing * i),
                Color = rarity.Color,
                Material = Enum.Material.Neon,
            })
            orb.Shape = Enum.PartType.Ball
            orb.Parent = folder

            Utils.CreateParticles(orb, rarity.Color, 5, 1.5, 2)
        end
    end

    for i = 1, 3 do
        local floatingText = createPart({
            Name = rarity.Name .. "_FloatText_" .. i,
            Size = Vector3.new(0.1, 0.1, 0.1),
            Position = center + Vector3.new(
                math.random(-math.floor(width / 3), math.floor(width / 3)),
                math.random(10, 18),
                -math.random(10, math.floor(length - 10))
            ),
            Transparency = 1,
        })
        floatingText.CanCollide = false
        floatingText.Parent = folder

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(8, 0, 2, 0)
        billboard.Parent = floatingText

        local texts = {
            rarity.DisplayName .. "!",
            rarity.MoneyMultiplier .. "x Money!",
            "Zona " .. zoneIndex,
        }

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = texts[i]
        label.TextColor3 = rarity.Color
        label.TextStrokeTransparency = 0.3
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard
    end
end

function RarityRoadBuilder.CreateZoneAtmosphere(folder, rarity, center, width, length)
    local atmospherePart = createPart({
        Name = rarity.Name .. "_Atmosphere",
        Size = Vector3.new(width, 20, length),
        Position = center + Vector3.new(0, 10, -length / 2),
        Transparency = 1,
    })
    atmospherePart.CanCollide = false
    atmospherePart.Parent = folder

    local emitter = Instance.new("ParticleEmitter")
    emitter.Color = ColorSequence.new(rarity.Color)
    emitter.Rate = 10
    emitter.Speed = NumberRange.new(0.5, 2)
    emitter.Lifetime = NumberRange.new(3, 5)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 0.8),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    emitter.LightEmission = 0.5
    emitter.Parent = atmospherePart
end

function RarityRoadBuilder.BuildConnectors(roadFolder, startPos, numZones, zoneLength, gap, zoneWidth)
    for i = 1, numZones - 1 do
        local zoneOffset = (i - 1) * (zoneLength + gap)
        local connectorPos = startPos + Vector3.new(0, 0, -zoneOffset - zoneLength - gap / 2)

        local connector = createPart({
            Name = "Connector_" .. i,
            Size = Vector3.new(zoneWidth / 2, 0.5, gap),
            Position = connectorPos + Vector3.new(0, -0.25, 0),
            Color = Color3.fromRGB(60, 60, 80),
            Material = Enum.Material.Neon,
        })
        connector.Parent = roadFolder

        local arrow = createPart({
            Name = "Arrow_" .. i,
            Size = Vector3.new(3, 0.1, 3),
            Position = connectorPos + Vector3.new(0, 0.1, 0),
            Color = Color3.fromRGB(255, 255, 100),
            Material = Enum.Material.Neon,
        })
        arrow.CanCollide = false
        arrow.Parent = roadFolder
    end
end

return RarityRoadBuilder
