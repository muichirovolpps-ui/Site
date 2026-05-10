--[[
    LobbyBuilder.lua (Workspace/Builders)
    Generates the interactive lobby with neon decorations, signs, NPCs, portals.
    Run once on server initialization.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))
local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))

local LobbyBuilder = {}

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

local function createNeonPart(props)
    local part = createPart(props)
    part.Material = Enum.Material.Neon
    return part
end

local function createText(parent, text, size, color, face)
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = face or Enum.NormalId.Front
    surfaceGui.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = surfaceGui

    return surfaceGui
end

local function createFloatingText(parent, text, position, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(8, 0, 2, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = false
    billboard.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    return billboard
end

function LobbyBuilder.Build(lobbyFolder)
    local floor = createPart({
        Name = "LobbyFloor",
        Size = Config.Lobby.Size,
        Position = Vector3.new(0, 0, 0),
        Color = Config.Lobby.FloorColor,
        Material = Enum.Material.SmoothPlastic,
    })
    floor.Parent = lobbyFolder

    local spawnPart = createPart({
        Name = "SpawnLocation",
        Size = Vector3.new(12, 1, 12),
        Position = Config.Lobby.SpawnPosition,
        Color = Color3.fromRGB(0, 200, 255),
        Material = Enum.Material.Neon,
    })
    spawnPart.Parent = lobbyFolder

    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "MainSpawn"
    spawn.Size = Vector3.new(12, 1, 12)
    spawn.Position = Config.Lobby.SpawnPosition
    spawn.Anchored = true
    spawn.CanCollide = true
    spawn.Transparency = 0.5
    spawn.Color = Color3.fromRGB(0, 200, 255)
    spawn.Material = Enum.Material.Neon
    spawn.Parent = lobbyFolder

    LobbyBuilder.CreateNeonArch(lobbyFolder, Vector3.new(0, 0, -15), "TREINE PARA CHUTAR LUCKY BLOCK")
    LobbyBuilder.CreateNeonArch(lobbyFolder, Vector3.new(0, 0, -50), "ZONA DE TREINO")

    LobbyBuilder.CreateTutorialSigns(lobbyFolder)
    LobbyBuilder.CreateNPCs(lobbyFolder)
    LobbyBuilder.CreatePortals(lobbyFolder)
    LobbyBuilder.CreateDecorations(lobbyFolder)
    LobbyBuilder.CreateTrainingArea(lobbyFolder)
    LobbyBuilder.CreateLuckyBlockArea(lobbyFolder)
    LobbyBuilder.CreateShowcase(lobbyFolder)
end

function LobbyBuilder.CreateNeonArch(parent, position, text)
    local archFolder = Instance.new("Folder")
    archFolder.Name = "NeonArch_" .. text:sub(1, 10)
    archFolder.Parent = parent

    local leftPillar = createNeonPart({
        Name = "LeftPillar",
        Size = Vector3.new(2, 20, 2),
        Position = position + Vector3.new(-15, 10, 0),
        Color = Config.Lobby.NeonColor,
    })
    leftPillar.Parent = archFolder

    local rightPillar = createNeonPart({
        Name = "RightPillar",
        Size = Vector3.new(2, 20, 2),
        Position = position + Vector3.new(15, 10, 0),
        Color = Config.Lobby.NeonColor,
    })
    rightPillar.Parent = archFolder

    local topBar = createNeonPart({
        Name = "TopBar",
        Size = Vector3.new(32, 3, 2),
        Position = position + Vector3.new(0, 21, 0),
        Color = Config.Lobby.NeonColor,
    })
    topBar.Parent = archFolder

    local textBoard = createPart({
        Name = "TextBoard",
        Size = Vector3.new(28, 4, 0.5),
        Position = position + Vector3.new(0, 17, 1),
        Color = Color3.fromRGB(20, 20, 30),
    })
    textBoard.Parent = archFolder
    createText(textBoard, text, 48, Color3.fromRGB(255, 255, 100))

    Utils.CreateParticles(topBar, Config.Lobby.NeonColor, 15, 3, 1.5)

    return archFolder
end

function LobbyBuilder.CreateTutorialSigns(parent)
    local signs = {
        { Text = "1. Treine sua FORCA clicando nos pesos!", Pos = Vector3.new(-30, 8, -30) },
        { Text = "2. Chute o LUCKY BLOCK para ganhar recompensas!", Pos = Vector3.new(-30, 8, -40) },
        { Text = "3. Colete BRAINROTS raros e guarde na sua BASE!", Pos = Vector3.new(-30, 8, -50) },
        { Text = "4. Faca REBIRTH para multiplicadores permanentes!", Pos = Vector3.new(-30, 8, -60) },
        { Text = "5. Avance pela ESTRADA DAS RARIDADES!", Pos = Vector3.new(-30, 8, -70) },
    }

    local signFolder = Instance.new("Folder")
    signFolder.Name = "TutorialSigns"
    signFolder.Parent = parent

    for i, signData in ipairs(signs) do
        local sign = createPart({
            Name = "TutorialSign_" .. i,
            Size = Vector3.new(12, 5, 0.5),
            Position = signData.Pos,
            Color = Color3.fromRGB(40, 40, 60),
            Material = Enum.Material.SmoothPlastic,
        })
        sign.Parent = signFolder

        local frame = createNeonPart({
            Name = "SignFrame_" .. i,
            Size = Vector3.new(12.5, 5.5, 0.3),
            Position = signData.Pos + Vector3.new(0, 0, -0.2),
            Color = Color3.fromRGB(0, 200, 255),
        })
        frame.Parent = signFolder

        createText(sign, signData.Text, 24, Color3.fromRGB(255, 255, 255))
    end
end

function LobbyBuilder.CreateNPCs(parent)
    local npcFolder = Instance.new("Folder")
    npcFolder.Name = "NPCs"
    npcFolder.Parent = parent

    local npcData = {
        { Name = "Treinador", Pos = Vector3.new(10, 5.5, -35), Dialog = "Clique nos pesos para ficar mais forte!" },
        { Name = "Lojista", Pos = Vector3.new(25, 5.5, -20), Dialog = "Compre upgrades na loja!" },
        { Name = "Mestre Rebirth", Pos = Vector3.new(-25, 5.5, -20), Dialog = "Faca rebirth para ficar mais poderoso!" },
        { Name = "Colecionador", Pos = Vector3.new(0, 5.5, -80), Dialog = "Colete todos os 128 Brainrots!" },
    }

    for _, npc in ipairs(npcData) do
        local npcBody = createPart({
            Name = npc.Name,
            Size = Vector3.new(2, 4, 2),
            Position = npc.Pos,
            Color = Color3.fromRGB(255, 200, 150),
            Material = Enum.Material.SmoothPlastic,
        })
        npcBody.Shape = Enum.PartType.Block
        npcBody.Parent = npcFolder

        local head = createPart({
            Name = npc.Name .. "_Head",
            Size = Vector3.new(1.5, 1.5, 1.5),
            Position = npc.Pos + Vector3.new(0, 3, 0),
            Color = Color3.fromRGB(255, 200, 150),
            Material = Enum.Material.SmoothPlastic,
        })
        head.Shape = Enum.PartType.Ball
        head.Parent = npcFolder

        createFloatingText(npcBody, npc.Name, npc.Pos + Vector3.new(0, 6, 0), Color3.fromRGB(0, 255, 200))

        local dialogBoard = Instance.new("BillboardGui")
        dialogBoard.Size = UDim2.new(10, 0, 2, 0)
        dialogBoard.StudsOffset = Vector3.new(0, 5, 0)
        dialogBoard.AlwaysOnTop = false
        dialogBoard.Parent = npcBody

        local dialogLabel = Instance.new("TextLabel")
        dialogLabel.Size = UDim2.new(1, 0, 1, 0)
        dialogLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        dialogLabel.BackgroundTransparency = 0.3
        dialogLabel.Text = npc.Dialog
        dialogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        dialogLabel.TextScaled = true
        dialogLabel.Font = Enum.Font.Gotham
        dialogLabel.Parent = dialogBoard

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = dialogLabel
    end
end

function LobbyBuilder.CreatePortals(parent)
    local portalFolder = Instance.new("Folder")
    portalFolder.Name = "Portals"
    portalFolder.Parent = parent

    local portals = {
        { Name = "Portal Treino",    Pos = Vector3.new(0, 5, -30),  Color = Color3.fromRGB(0, 200, 255), Target = "Training" },
        { Name = "Portal Raridades", Pos = Vector3.new(0, 5, -100), Color = Color3.fromRGB(255, 100, 255), Target = "RarityRoad" },
        { Name = "Portal Base",      Pos = Vector3.new(30, 5, -50), Color = Color3.fromRGB(100, 255, 100), Target = "Base" },
    }

    for _, portalData in ipairs(portals) do
        local ring = createNeonPart({
            Name = portalData.Name,
            Size = Vector3.new(10, 10, 1),
            Position = portalData.Pos,
            Color = portalData.Color,
        })
        ring.Shape = Enum.PartType.Cylinder
        ring.Orientation = Vector3.new(0, 0, 90)
        ring.Parent = portalFolder

        local inner = createPart({
            Name = portalData.Name .. "_Inner",
            Size = Vector3.new(8, 8, 0.5),
            Position = portalData.Pos,
            Color = portalData.Color,
            Material = Enum.Material.ForceField,
            Transparency = 0.3,
        })
        inner.CanCollide = false
        inner.Parent = portalFolder

        Utils.CreateParticles(inner, portalData.Color, 30, 5, 2)
        createFloatingText(ring, portalData.Name, portalData.Pos, portalData.Color)

        inner.Touched:Connect(function(hit)
            local player = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent)
            if player and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if portalData.Target == "Training" then
                        hrp.CFrame = CFrame.new(0, 5, -45)
                    elseif portalData.Target == "RarityRoad" then
                        hrp.CFrame = CFrame.new(Config.RarityRoad.StartPosition + Vector3.new(0, 5, 0))
                    elseif portalData.Target == "Base" then
                        hrp.CFrame = CFrame.new(50 + player.UserId % 100, 5, -50)
                    end
                end
            end
        end)
    end
end

function LobbyBuilder.CreateDecorations(parent)
    local decoFolder = Instance.new("Folder")
    decoFolder.Name = "Decorations"
    decoFolder.Parent = parent

    local neonColors = {
        Color3.fromRGB(255, 0, 100),
        Color3.fromRGB(0, 255, 200),
        Color3.fromRGB(255, 200, 0),
        Color3.fromRGB(100, 100, 255),
        Color3.fromRGB(255, 100, 255),
    }

    for i = 1, 20 do
        local angle = (i / 20) * math.pi * 2
        local radius = 80
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius

        local pillar = createNeonPart({
            Name = "DecoPillar_" .. i,
            Size = Vector3.new(2, 15, 2),
            Position = Vector3.new(x, 7.5, z),
            Color = neonColors[(i % #neonColors) + 1],
        })
        pillar.Parent = decoFolder

        local orb = createNeonPart({
            Name = "DecoOrb_" .. i,
            Size = Vector3.new(3, 3, 3),
            Position = Vector3.new(x, 16, z),
            Color = neonColors[(i % #neonColors) + 1],
        })
        orb.Shape = Enum.PartType.Ball
        orb.Parent = decoFolder

        Utils.CreateParticles(orb, neonColors[(i % #neonColors) + 1], 5, 2, 2)
    end

    for i = 1, 10 do
        local floatingCube = createNeonPart({
            Name = "FloatingCube_" .. i,
            Size = Vector3.new(3, 3, 3),
            Position = Vector3.new(
                math.random(-60, 60),
                math.random(15, 30),
                math.random(-60, 60)
            ),
            Color = neonColors[(i % #neonColors) + 1],
        })
        floatingCube.CanCollide = false
        floatingCube.Parent = decoFolder
        Utils.CreateParticles(floatingCube, neonColors[(i % #neonColors) + 1], 3, 1, 3)
    end
end

function LobbyBuilder.CreateTrainingArea(parent)
    local trainingFolder = Instance.new("Folder")
    trainingFolder.Name = "TrainingArea"
    trainingFolder.Parent = parent

    local platform = createPart({
        Name = "TrainingPlatform",
        Size = Vector3.new(30, 1, 30),
        Position = Vector3.new(0, 0.5, -45),
        Color = Color3.fromRGB(50, 50, 70),
        Material = Enum.Material.SmoothPlastic,
    })
    platform.Parent = trainingFolder

    local border = createNeonPart({
        Name = "TrainingBorder",
        Size = Vector3.new(32, 0.5, 32),
        Position = Vector3.new(0, 0.2, -45),
        Color = Color3.fromRGB(0, 200, 255),
    })
    border.Parent = trainingFolder

    for i, weight in ipairs(Config.Training.Weights) do
        local col = ((i - 1) % 4)
        local row = math.floor((i - 1) / 4)
        local weightPart = createPart({
            Name = "Weight_" .. weight.Name,
            Size = Vector3.new(3, 2 + (i * 0.3), 3),
            Position = Vector3.new(-10 + col * 7, 1.5 + (i * 0.15), -38 - row * 7),
            Color = Color3.fromHSV((i - 1) / #Config.Training.Weights, 0.8, 0.9),
            Material = Enum.Material.Metal,
        })
        weightPart.Parent = trainingFolder

        createFloatingText(weightPart, weight.Name .. "\n$" .. weight.Cost, nil, Color3.fromRGB(255, 255, 100))

        local clickDetector = Instance.new("ClickDetector")
        clickDetector.MaxActivationDistance = 15
        clickDetector.Parent = weightPart
    end
end

function LobbyBuilder.CreateLuckyBlockArea(parent)
    local lbFolder = Instance.new("Folder")
    lbFolder.Name = "LuckyBlockArea"
    lbFolder.Parent = parent

    local platform = createPart({
        Name = "LBPlatform",
        Size = Vector3.new(20, 1, 20),
        Position = Vector3.new(0, 0.5, -80),
        Color = Color3.fromRGB(60, 50, 20),
        Material = Enum.Material.SmoothPlastic,
    })
    platform.Parent = lbFolder

    local luckyBlock = createPart({
        Name = "LuckyBlock",
        Size = Vector3.new(6, 6, 6),
        Position = Vector3.new(0, 4, -80),
        Color = Color3.fromRGB(255, 215, 0),
        Material = Enum.Material.Neon,
    })
    luckyBlock.Parent = lbFolder

    createText(luckyBlock, "?", 72, Color3.fromRGB(255, 255, 255), Enum.NormalId.Front)
    createText(luckyBlock, "?", 72, Color3.fromRGB(255, 255, 255), Enum.NormalId.Back)
    createText(luckyBlock, "?", 72, Color3.fromRGB(255, 255, 255), Enum.NormalId.Left)
    createText(luckyBlock, "?", 72, Color3.fromRGB(255, 255, 255), Enum.NormalId.Right)

    Utils.CreateParticles(luckyBlock, Color3.fromRGB(255, 215, 0), 25, 4, 1.5)

    local barrier = createPart({
        Name = "LBBarrier",
        Size = Vector3.new(20, 10, 1),
        Position = Vector3.new(0, 5, -87),
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.8,
        Material = Enum.Material.ForceField,
    })
    barrier.Parent = lbFolder

    local groundText = createPart({
        Name = "GroundText",
        Size = Vector3.new(15, 0.1, 5),
        Position = Vector3.new(0, 0.6, -73),
        Color = Color3.fromRGB(255, 215, 0),
        Material = Enum.Material.Neon,
    })
    groundText.Parent = lbFolder
    createText(groundText, "CHUTE O LUCKY BLOCK!", 36, Color3.fromRGB(255, 255, 100), Enum.NormalId.Top)

    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 20
    clickDetector.Parent = luckyBlock

    createFloatingText(luckyBlock, "LUCKY BLOCK", nil, Color3.fromRGB(255, 215, 0))
end

function LobbyBuilder.CreateShowcase(parent)
    local showcaseFolder = Instance.new("Folder")
    showcaseFolder.Name = "BrainrotShowcase"
    showcaseFolder.Parent = parent

    local platform = createPart({
        Name = "ShowcasePlatform",
        Size = Vector3.new(40, 1, 15),
        Position = Vector3.new(40, 0.5, 0),
        Color = Color3.fromRGB(30, 30, 50),
        Material = Enum.Material.SmoothPlastic,
    })
    platform.Parent = showcaseFolder

    local backWall = createPart({
        Name = "ShowcaseWall",
        Size = Vector3.new(40, 12, 1),
        Position = Vector3.new(40, 6.5, -7),
        Color = Color3.fromRGB(20, 20, 35),
    })
    backWall.Parent = showcaseFolder
    createText(backWall, "COLECAO BRAINROT", 48, Color3.fromRGB(255, 200, 0))

    for i, rarity in ipairs(Config.Rarities) do
        local col = ((i - 1) % 4)
        local row = math.floor((i - 1) / 4)

        local display = createPart({
            Name = "Display_" .. rarity.Name,
            Size = Vector3.new(4, 4, 4),
            Position = Vector3.new(25 + col * 10, 3 + row * 6, 0),
            Color = rarity.Color,
            Material = Enum.Material.Neon,
        })
        display.Parent = showcaseFolder

        createFloatingText(display, rarity.DisplayName, nil, rarity.Color)
        Utils.CreateParticles(display, rarity.Color, 8, 2, 2)
    end
end

return LobbyBuilder
