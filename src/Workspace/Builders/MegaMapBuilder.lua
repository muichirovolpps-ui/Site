--[[
    MegaMapBuilder.lua  v3.0
    Builds 10 mega map biomes: Mountains, Floating Islands, Secret Caves,
    VIP Island, Hacker Dimension, Neon City, Lava Biome, Ice Biome,
    Space Biome, Giant Portals. Each with unique terrain, lighting, particles.
]]

local Lighting = game:GetService("Lighting")

local MegaMapBuilder = {}

function MegaMapBuilder.Build(config)
    local mapFolder = workspace:FindFirstChild("MegaMap")
    if mapFolder then mapFolder:Destroy() end

    mapFolder = Instance.new("Folder")
    mapFolder.Name = "MegaMap"
    mapFolder.Parent = workspace

    for _, biome in ipairs(config.MegaMap.Biomes) do
        MegaMapBuilder.BuildBiome(biome, mapFolder)
    end

    print("[MegaMap] Built " .. #config.MegaMap.Biomes .. " biomes")
end

function MegaMapBuilder.BuildBiome(biome, parent)
    local biomeFolder = Instance.new("Folder")
    biomeFolder.Name = biome.Name
    biomeFolder.Parent = parent

    local floor = Instance.new("Part")
    floor.Name = biome.Name .. "_Floor"
    floor.Size = biome.Size
    floor.Position = biome.Position
    floor.Color = biome.FloorColor
    floor.Material = MegaMapBuilder.GetBiomeMaterial(biome.Name)
    floor.Anchored = true
    floor.Parent = biomeFolder

    local sign = Instance.new("Part")
    sign.Name = biome.Name .. "_Sign"
    sign.Size = Vector3.new(12, 8, 1)
    sign.Position = biome.Position + Vector3.new(0, biome.Size.Y / 2 + 6, biome.Size.Z / 2)
    sign.Color = biome.FloorColor
    sign.Material = Enum.Material.Neon
    sign.Anchored = true
    sign.Parent = biomeFolder

    local billboard = Instance.new("SurfaceGui")
    billboard.Face = Enum.NormalId.Front
    billboard.Parent = sign

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = biome.DisplayName
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    MegaMapBuilder.AddBiomeDecorations(biome, biomeFolder)
    MegaMapBuilder.AddBiomeParticles(biome, floor)
    MegaMapBuilder.AddBiomeLighting(biome, biomeFolder)

    if biome.Name == "Mountains" then
        MegaMapBuilder.BuildMountains(biome, biomeFolder)
    elseif biome.Name == "FloatingIslands" then
        MegaMapBuilder.BuildFloatingIslands(biome, biomeFolder)
    elseif biome.Name == "SecretCaves" then
        MegaMapBuilder.BuildCaves(biome, biomeFolder)
    elseif biome.Name == "NeonCity" then
        MegaMapBuilder.BuildNeonCity(biome, biomeFolder)
    elseif biome.Name == "LavaBiome" then
        MegaMapBuilder.BuildLavaBiome(biome, biomeFolder)
    elseif biome.Name == "IceBiome" then
        MegaMapBuilder.BuildIceBiome(biome, biomeFolder)
    elseif biome.Name == "GiantPortals" then
        MegaMapBuilder.BuildGiantPortals(biome, biomeFolder)
    elseif biome.Name == "SpaceBiome" then
        MegaMapBuilder.BuildSpaceBiome(biome, biomeFolder)
    end
end

function MegaMapBuilder.GetBiomeMaterial(biomeName)
    local materials = {
        Mountains = Enum.Material.Rock,
        FloatingIslands = Enum.Material.Grass,
        SecretCaves = Enum.Material.Slate,
        VIPIsland = Enum.Material.Neon,
        HackerDimension = Enum.Material.Neon,
        NeonCity = Enum.Material.SmoothPlastic,
        LavaBiome = Enum.Material.CrackedLava,
        IceBiome = Enum.Material.Ice,
        SpaceBiome = Enum.Material.Neon,
        GiantPortals = Enum.Material.ForceField,
    }
    return materials[biomeName] or Enum.Material.SmoothPlastic
end

function MegaMapBuilder.AddBiomeDecorations(biome, folder)
    for i = 1, 6 do
        local deco = Instance.new("Part")
        deco.Name = "Deco_" .. i
        deco.Size = Vector3.new(
            math.random(2, 6),
            math.random(3, 12),
            math.random(2, 6)
        )
        local offsetX = math.random(-math.floor(biome.Size.X / 3), math.floor(biome.Size.X / 3))
        local offsetZ = math.random(-math.floor(biome.Size.Z / 3), math.floor(biome.Size.Z / 3))
        deco.Position = biome.Position + Vector3.new(offsetX, biome.Size.Y / 2 + deco.Size.Y / 2, offsetZ)
        deco.Color = biome.FloorColor
        deco.Material = Enum.Material.Neon
        deco.Anchored = true
        deco.Parent = folder
    end
end

function MegaMapBuilder.AddBiomeParticles(biome, part)
    local particles = Instance.new("ParticleEmitter")
    particles.Color = ColorSequence.new(biome.FloorColor)
    particles.Rate = 10
    particles.Lifetime = NumberRange.new(2, 4)
    particles.Speed = NumberRange.new(1, 3)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0),
    })
    particles.SpreadAngle = Vector2.new(180, 180)
    particles.Parent = part
end

function MegaMapBuilder.AddBiomeLighting(biome, folder)
    local light = Instance.new("PointLight")
    light.Color = biome.FloorColor
    light.Brightness = 2
    light.Range = 60
    light.Parent = folder:FindFirstChild(biome.Name .. "_Floor") or folder
end

function MegaMapBuilder.BuildMountains(biome, folder)
    for i = 1, 5 do
        local mountain = Instance.new("Part")
        mountain.Name = "Mountain_" .. i
        mountain.Shape = Enum.PartType.Ball
        mountain.Size = Vector3.new(40, 60, 40) * (0.5 + math.random() * 0.5)
        local offsetX = math.random(-60, 60)
        local offsetZ = math.random(-60, 60)
        mountain.Position = biome.Position + Vector3.new(offsetX, 20, offsetZ)
        mountain.Color = Color3.fromRGB(100 + math.random(0, 40), 90 + math.random(0, 30), 70 + math.random(0, 30))
        mountain.Material = Enum.Material.Rock
        mountain.Anchored = true
        mountain.Parent = folder

        local snow = Instance.new("Part")
        snow.Name = "Snow_" .. i
        snow.Shape = Enum.PartType.Ball
        snow.Size = mountain.Size * 0.4
        snow.Position = mountain.Position + Vector3.new(0, mountain.Size.Y * 0.3, 0)
        snow.Color = Color3.fromRGB(255, 255, 255)
        snow.Material = Enum.Material.Ice
        snow.Anchored = true
        snow.Parent = folder
    end
end

function MegaMapBuilder.BuildFloatingIslands(biome, folder)
    for i = 1, 6 do
        local island = Instance.new("Part")
        island.Name = "Island_" .. i
        island.Size = Vector3.new(20 + math.random(0, 15), 5, 20 + math.random(0, 15))
        local offsetX = math.random(-50, 50)
        local offsetY = math.random(-10, 30)
        local offsetZ = math.random(-50, 50)
        island.Position = biome.Position + Vector3.new(offsetX, offsetY, offsetZ)
        island.Color = Color3.fromRGB(80 + math.random(0, 40), 180 + math.random(0, 40), 80 + math.random(0, 40))
        island.Material = Enum.Material.Grass
        island.Anchored = true
        island.Parent = folder

        local tree = Instance.new("Part")
        tree.Name = "Tree_" .. i
        tree.Size = Vector3.new(3, 8, 3)
        tree.Position = island.Position + Vector3.new(0, island.Size.Y / 2 + 4, 0)
        tree.Color = Color3.fromRGB(60, 130, 60)
        tree.Material = Enum.Material.Grass
        tree.Anchored = true
        tree.Parent = folder
    end
end

function MegaMapBuilder.BuildCaves(biome, folder)
    local entrance = Instance.new("Part")
    entrance.Name = "CaveEntrance"
    entrance.Size = Vector3.new(15, 15, 5)
    entrance.Position = biome.Position + Vector3.new(0, biome.Size.Y / 2 + 5, biome.Size.Z / 2)
    entrance.Color = Color3.fromRGB(40, 30, 20)
    entrance.Material = Enum.Material.Slate
    entrance.Anchored = true
    entrance.Parent = folder

    for i = 1, 8 do
        local crystal = Instance.new("Part")
        crystal.Name = "Crystal_" .. i
        crystal.Size = Vector3.new(2, math.random(3, 8), 2)
        crystal.Position = biome.Position + Vector3.new(
            math.random(-40, 40), math.random(0, 15), math.random(-40, 40)
        )
        crystal.Color = Color3.fromHSV(math.random() * 0.3 + 0.5, 0.8, 1)
        crystal.Material = Enum.Material.Neon
        crystal.Transparency = 0.3
        crystal.Anchored = true
        crystal.Parent = folder

        local glow = Instance.new("PointLight")
        glow.Color = crystal.Color
        glow.Brightness = 2
        glow.Range = 15
        glow.Parent = crystal
    end
end

function MegaMapBuilder.BuildNeonCity(biome, folder)
    for i = 1, 12 do
        local building = Instance.new("Part")
        building.Name = "Building_" .. i
        local height = math.random(20, 60)
        building.Size = Vector3.new(10, height, 10)
        local offsetX = math.random(-80, 80)
        local offsetZ = math.random(-80, 80)
        building.Position = biome.Position + Vector3.new(offsetX, height / 2, offsetZ)
        building.Color = Color3.fromHSV(math.random(), 0.8, 0.3)
        building.Material = Enum.Material.SmoothPlastic
        building.Anchored = true
        building.Parent = folder

        local neonStrip = Instance.new("Part")
        neonStrip.Name = "Neon_" .. i
        neonStrip.Size = Vector3.new(10.5, 1, 10.5)
        neonStrip.Position = building.Position + Vector3.new(0, height / 2 - 1, 0)
        neonStrip.Color = Color3.fromHSV(math.random(), 1, 1)
        neonStrip.Material = Enum.Material.Neon
        neonStrip.Anchored = true
        neonStrip.Parent = folder
    end
end

function MegaMapBuilder.BuildLavaBiome(biome, folder)
    for i = 1, 6 do
        local lavaPool = Instance.new("Part")
        lavaPool.Name = "LavaPool_" .. i
        lavaPool.Size = Vector3.new(math.random(10, 25), 1, math.random(10, 25))
        lavaPool.Position = biome.Position + Vector3.new(
            math.random(-60, 60), biome.Size.Y / 2 + 0.5, math.random(-60, 60)
        )
        lavaPool.Color = Color3.fromRGB(255, math.random(50, 100), 0)
        lavaPool.Material = Enum.Material.Neon
        lavaPool.Anchored = true
        lavaPool.Parent = folder

        local fire = Instance.new("Fire")
        fire.Size = 8
        fire.Color = Color3.fromRGB(255, 100, 0)
        fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
        fire.Parent = lavaPool
    end
end

function MegaMapBuilder.BuildIceBiome(biome, folder)
    for i = 1, 8 do
        local iceberg = Instance.new("Part")
        iceberg.Name = "Iceberg_" .. i
        iceberg.Size = Vector3.new(
            math.random(5, 15), math.random(5, 20), math.random(5, 15)
        )
        iceberg.Position = biome.Position + Vector3.new(
            math.random(-60, 60), math.random(0, 10), math.random(-60, 60)
        )
        iceberg.Color = Color3.fromRGB(200 + math.random(0, 55), 230 + math.random(0, 25), 255)
        iceberg.Material = Enum.Material.Ice
        iceberg.Transparency = 0.2
        iceberg.Anchored = true
        iceberg.Parent = folder
    end
end

function MegaMapBuilder.BuildSpaceBiome(biome, folder)
    for i = 1, 10 do
        local asteroid = Instance.new("Part")
        asteroid.Name = "Asteroid_" .. i
        asteroid.Shape = Enum.PartType.Ball
        asteroid.Size = Vector3.one * math.random(3, 10)
        asteroid.Position = biome.Position + Vector3.new(
            math.random(-100, 100), math.random(-20, 20), math.random(-100, 100)
        )
        asteroid.Color = Color3.fromRGB(80 + math.random(0, 40), 70 + math.random(0, 30), 60 + math.random(0, 20))
        asteroid.Material = Enum.Material.Rock
        asteroid.Anchored = true
        asteroid.Parent = folder
    end

    for i = 1, 15 do
        local star = Instance.new("Part")
        star.Name = "Star_" .. i
        star.Size = Vector3.one * math.random(1, 3)
        star.Position = biome.Position + Vector3.new(
            math.random(-120, 120), math.random(-30, 30), math.random(-120, 120)
        )
        star.Color = Color3.fromRGB(255, 255, math.random(200, 255))
        star.Material = Enum.Material.Neon
        star.Anchored = true
        star.CanCollide = false
        star.Parent = folder

        local glow = Instance.new("PointLight")
        glow.Color = star.Color
        glow.Brightness = 3
        glow.Range = 10
        glow.Parent = star
    end
end

function MegaMapBuilder.BuildGiantPortals(biome, folder)
    local portalColors = {
        Color3.fromRGB(255, 0, 100),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(150, 0, 255),
        Color3.fromRGB(255, 200, 0),
    }

    for i = 1, 4 do
        local portalRing = Instance.new("Part")
        portalRing.Name = "Portal_" .. i
        portalRing.Size = Vector3.new(20, 25, 3)
        local angle = (i - 1) * (math.pi / 2)
        portalRing.Position = biome.Position + Vector3.new(
            math.cos(angle) * 30, 15, math.sin(angle) * 30
        )
        portalRing.Color = portalColors[i]
        portalRing.Material = Enum.Material.ForceField
        portalRing.Transparency = 0.3
        portalRing.Anchored = true
        portalRing.CanCollide = false
        portalRing.Parent = folder

        local particles = Instance.new("ParticleEmitter")
        particles.Color = ColorSequence.new(portalColors[i])
        particles.Rate = 30
        particles.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        })
        particles.Lifetime = NumberRange.new(1, 3)
        particles.Speed = NumberRange.new(3, 8)
        particles.SpreadAngle = Vector2.new(360, 360)
        particles.Parent = portalRing

        local light = Instance.new("PointLight")
        light.Color = portalColors[i]
        light.Brightness = 4
        light.Range = 30
        light.Parent = portalRing
    end
end

return MegaMapBuilder
