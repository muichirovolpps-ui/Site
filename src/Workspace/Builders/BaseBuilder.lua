--[[
    BaseBuilder.lua (Workspace/Builders)
    Generates personal bases for players.
    Each base has display stands, upgrade terminal, animated doors.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))
local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))

local BaseBuilder = {}

local playerBases = {}
local BASE_START_X = 200
local BASE_SPACING = 60

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
    return part
end

function BaseBuilder.BuildPlayerBase(player, baseFolder, baseIndex)
    local basePos = Vector3.new(BASE_START_X + (baseIndex * BASE_SPACING), 0, 0)

    local playerBaseFolder = Instance.new("Folder")
    playerBaseFolder.Name = "Base_" .. player.Name
    playerBaseFolder.Parent = baseFolder

    local floor = createPart({
        Name = "BaseFloor",
        Size = Vector3.new(40, 1, 40),
        Position = basePos + Vector3.new(0, -0.5, 0),
        Color = Color3.fromRGB(50, 50, 70),
    })
    floor.Parent = playerBaseFolder

    local floorGlow = createPart({
        Name = "BaseFloorGlow",
        Size = Vector3.new(38, 0.1, 38),
        Position = basePos + Vector3.new(0, 0.1, 0),
        Color = Color3.fromRGB(0, 150, 255),
        Material = Enum.Material.Neon,
        Transparency = 0.7,
    })
    floorGlow.CanCollide = false
    floorGlow.Parent = playerBaseFolder

    local walls = {
        { Offset = Vector3.new(0, 4, -20), Size = Vector3.new(40, 8, 1) },
        { Offset = Vector3.new(0, 4, 20),  Size = Vector3.new(40, 8, 1) },
        { Offset = Vector3.new(-20, 4, 0), Size = Vector3.new(1, 8, 40) },
        { Offset = Vector3.new(20, 4, 0),  Size = Vector3.new(1, 8, 40) },
    }

    for i, wallData in ipairs(walls) do
        local wall = createPart({
            Name = "Wall_" .. i,
            Size = wallData.Size,
            Position = basePos + wallData.Offset,
            Color = Color3.fromRGB(40, 40, 55),
            Transparency = 0.3,
        })
        wall.Parent = playerBaseFolder
    end

    local doorFrame = createPart({
        Name = "DoorFrame",
        Size = Vector3.new(8, 8, 1.5),
        Position = basePos + Vector3.new(0, 4, 20),
        Color = Color3.fromRGB(0, 200, 255),
        Material = Enum.Material.Neon,
        Transparency = 0.5,
    })
    doorFrame.CanCollide = false
    doorFrame.Parent = playerBaseFolder

    local door = createPart({
        Name = "Door",
        Size = Vector3.new(6, 7, 0.5),
        Position = basePos + Vector3.new(0, 3.5, 20),
        Color = Color3.fromRGB(0, 100, 200),
        Material = Enum.Material.Neon,
        Transparency = 0.4,
    })
    door.CanCollide = false
    door.Parent = playerBaseFolder

    local ownerSign = Instance.new("BillboardGui")
    ownerSign.Size = UDim2.new(10, 0, 2, 0)
    ownerSign.StudsOffset = Vector3.new(0, 6, 0)
    ownerSign.Parent = doorFrame

    local ownerLabel = Instance.new("TextLabel")
    ownerLabel.Size = UDim2.new(1, 0, 1, 0)
    ownerLabel.BackgroundTransparency = 1
    ownerLabel.Text = player.Name .. "'s Base"
    ownerLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    ownerLabel.TextStrokeTransparency = 0.3
    ownerLabel.TextScaled = true
    ownerLabel.Font = Enum.Font.GothamBold
    ownerLabel.Parent = ownerSign

    BaseBuilder.CreateDisplayStands(playerBaseFolder, basePos)
    BaseBuilder.CreateUpgradeTerminal(playerBaseFolder, basePos)
    BaseBuilder.CreateTeleporter(playerBaseFolder, basePos, player)

    playerBases[player.UserId] = {
        Folder = playerBaseFolder,
        Position = basePos,
        Index = baseIndex,
    }

    return playerBaseFolder
end

function BaseBuilder.CreateDisplayStands(folder, basePos)
    local standsFolder = Instance.new("Folder")
    standsFolder.Name = "DisplayStands"
    standsFolder.Parent = folder

    local maxDisplays = 16
    local cols = 4
    local spacing = 8

    for i = 1, maxDisplays do
        local col = ((i - 1) % cols)
        local row = math.floor((i - 1) / cols)

        local stand = createPart({
            Name = "Stand_" .. i,
            Size = Vector3.new(4, 2, 4),
            Position = basePos + Vector3.new(-12 + col * spacing, 1, -12 + row * spacing),
            Color = Color3.fromRGB(60, 60, 80),
            Material = Enum.Material.SmoothPlastic,
        })
        stand.Parent = standsFolder

        local standGlow = createPart({
            Name = "StandGlow_" .. i,
            Size = Vector3.new(3.5, 0.1, 3.5),
            Position = basePos + Vector3.new(-12 + col * spacing, 2.1, -12 + row * spacing),
            Color = Color3.fromRGB(0, 200, 255),
            Material = Enum.Material.Neon,
            Transparency = 0.5,
        })
        standGlow.CanCollide = false
        standGlow.Parent = standsFolder

        local slotLabel = Instance.new("BillboardGui")
        slotLabel.Size = UDim2.new(3, 0, 1, 0)
        slotLabel.StudsOffset = Vector3.new(0, 2, 0)
        slotLabel.Parent = stand

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "Slot " .. i
        label.TextColor3 = Color3.fromRGB(150, 150, 180)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = slotLabel
    end
end

function BaseBuilder.CreateUpgradeTerminal(folder, basePos)
    local terminal = createPart({
        Name = "UpgradeTerminal",
        Size = Vector3.new(4, 5, 2),
        Position = basePos + Vector3.new(15, 2.5, -15),
        Color = Color3.fromRGB(0, 180, 255),
        Material = Enum.Material.Neon,
    })
    terminal.Parent = folder

    local screen = createPart({
        Name = "TerminalScreen",
        Size = Vector3.new(3.5, 3, 0.2),
        Position = basePos + Vector3.new(15, 3.5, -14),
        Color = Color3.fromRGB(20, 20, 35),
    })
    screen.Parent = folder

    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Front
    gui.Parent = screen

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.3, 0)
    title.BackgroundTransparency = 1
    title.Text = "UPGRADE TERMINAL"
    title.TextColor3 = Color3.fromRGB(0, 255, 200)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = gui

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0.7, 0)
    info.Position = UDim2.new(0, 0, 0.3, 0)
    info.BackgroundTransparency = 1
    info.Text = "Toque para\nabrir upgrades"
    info.TextColor3 = Color3.fromRGB(200, 200, 255)
    info.TextScaled = true
    info.Font = Enum.Font.Gotham
    info.Parent = gui

    local click = Instance.new("ClickDetector")
    click.MaxActivationDistance = 12
    click.Parent = terminal

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(6, 0, 1.5, 0)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Parent = terminal

    local floatLabel = Instance.new("TextLabel")
    floatLabel.Size = UDim2.new(1, 0, 1, 0)
    floatLabel.BackgroundTransparency = 1
    floatLabel.Text = "UPGRADES"
    floatLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    floatLabel.TextStrokeTransparency = 0.3
    floatLabel.TextScaled = true
    floatLabel.Font = Enum.Font.GothamBold
    floatLabel.Parent = billboard

    Utils.CreateParticles(terminal, Color3.fromRGB(0, 200, 255), 8, 2, 2)
end

function BaseBuilder.CreateTeleporter(folder, basePos, player)
    local teleporter = createPart({
        Name = "BaseTeleporter",
        Size = Vector3.new(6, 0.5, 6),
        Position = basePos + Vector3.new(0, 0.25, 17),
        Color = Color3.fromRGB(100, 255, 100),
        Material = Enum.Material.Neon,
    })
    teleporter.Parent = folder

    local ring = createPart({
        Name = "TeleporterRing",
        Size = Vector3.new(7, 7, 0.5),
        Position = basePos + Vector3.new(0, 3.5, 17),
        Color = Color3.fromRGB(100, 255, 100),
        Material = Enum.Material.Neon,
        Transparency = 0.5,
    })
    ring.Shape = Enum.PartType.Cylinder
    ring.Orientation = Vector3.new(0, 0, 90)
    ring.CanCollide = false
    ring.Parent = folder

    Utils.CreateParticles(teleporter, Color3.fromRGB(100, 255, 100), 20, 5, 1.5)

    local label = Instance.new("BillboardGui")
    label.Size = UDim2.new(6, 0, 1.5, 0)
    label.StudsOffset = Vector3.new(0, 5, 0)
    label.Parent = teleporter

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Voltar ao Lobby"
    text.TextColor3 = Color3.fromRGB(100, 255, 100)
    text.TextStrokeTransparency = 0.3
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = label

    teleporter.Touched:Connect(function(hit)
        local touchPlayer = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent)
        if touchPlayer and touchPlayer == player then
            local hrp = touchPlayer.Character and touchPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(Config.Lobby.SpawnPosition + Vector3.new(0, 3, 0))
            end
        end
    end)
end

function BaseBuilder.GetPlayerBase(player)
    return playerBases[player.UserId]
end

function BaseBuilder.RemovePlayerBase(player)
    local base = playerBases[player.UserId]
    if base and base.Folder then
        base.Folder:Destroy()
    end
    playerBases[player.UserId] = nil
end

return BaseBuilder
