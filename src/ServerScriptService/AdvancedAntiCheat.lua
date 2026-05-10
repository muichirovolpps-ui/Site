--[[
    AdvancedAntiCheat.lua  v2.0
    Advanced anti-cheat: flying, speed hacks, wall clipping, teleport abuse.
    Warning system with auto-rollback to last valid position.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local AdvancedAntiCheat = {}

local Config
local remotesFolder

local playerData = {}

function AdvancedAntiCheat.Initialize(config, remotes)
    Config = config
    remotesFolder = remotes

    local antiCheatLog = remotesFolder:FindFirstChild("AntiCheatLog")
    if not antiCheatLog then
        antiCheatLog = Instance.new("RemoteEvent")
        antiCheatLog.Name = "AntiCheatLog"
        antiCheatLog.Parent = remotesFolder
    end

    Players.PlayerAdded:Connect(function(player)
        AdvancedAntiCheat.SetupPlayer(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        playerData[player.UserId] = nil
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        AdvancedAntiCheat.SetupPlayer(player)
    end

    spawn(function()
        while true do
            wait(Config.AntiCheat.CheckInterval)
            AdvancedAntiCheat.CheckAllPlayers()
        end
    end)
end

function AdvancedAntiCheat.SetupPlayer(player)
    playerData[player.UserId] = {
        Warnings = 0,
        LastValidPosition = nil,
        LastCheckTime = os.time(),
        LastPosition = nil,
        FlyDetections = 0,
        SpeedDetections = 0,
        TeleportDetections = 0,
    }

    player.CharacterAdded:Connect(function(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        if humanoidRootPart then
            local pData = playerData[player.UserId]
            if pData then
                pData.LastValidPosition = humanoidRootPart.Position
                pData.LastPosition = humanoidRootPart.Position
            end
        end

        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if humanoid.WalkSpeed > Config.AntiCheat.MaxWalkSpeed then
                    humanoid.WalkSpeed = 16
                    AdvancedAntiCheat.AddWarning(player, "SpeedHack", "WalkSpeed modificado: " .. humanoid.WalkSpeed)
                end
            end)

            humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                if humanoid.JumpPower > Config.AntiCheat.MaxJumpPower then
                    humanoid.JumpPower = 50
                    AdvancedAntiCheat.AddWarning(player, "JumpHack", "JumpPower modificado: " .. humanoid.JumpPower)
                end
            end)
        end
    end)
end

function AdvancedAntiCheat.CheckAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        AdvancedAntiCheat.CheckPlayer(player)
    end
end

function AdvancedAntiCheat.CheckPlayer(player)
    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then return end

    local pData = playerData[player.UserId]
    if not pData then return end

    local currentPos = humanoidRootPart.Position
    local now = os.time()

    -- Flying detection
    if currentPos.Y > 50 and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping
        and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {character}
        local rayResult = workspace:Raycast(currentPos, Vector3.new(0, -100, 0), rayParams)
        if not rayResult then
            pData.FlyDetections = (pData.FlyDetections or 0) + 1
            if pData.FlyDetections >= 3 then
                AdvancedAntiCheat.AddWarning(player, "Flying", "Voando detectado em Y=" .. math.floor(currentPos.Y))
                AdvancedAntiCheat.ReturnToValid(player)
                pData.FlyDetections = 0
            end
        else
            pData.FlyDetections = 0
        end
    end

    -- Teleport detection
    if pData.LastPosition then
        local distance = (currentPos - pData.LastPosition).Magnitude
        local timeDelta = math.max(now - (pData.LastCheckTime or now), 1)
        local maxAllowedDistance = Config.AntiCheat.TeleportThreshold

        if distance > maxAllowedDistance then
            pData.TeleportDetections = (pData.TeleportDetections or 0) + 1
            if pData.TeleportDetections >= 2 then
                AdvancedAntiCheat.AddWarning(player, "Teleport", "Teleporte detectado: " .. math.floor(distance) .. " studs")
                AdvancedAntiCheat.ReturnToValid(player)
                pData.TeleportDetections = 0
            end
        else
            pData.TeleportDetections = 0
            pData.LastValidPosition = currentPos
        end
    end

    -- Speed detection
    if pData.LastPosition then
        local distance = (currentPos - pData.LastPosition).Magnitude
        local timeDelta = math.max(now - (pData.LastCheckTime or now), 1)
        local speed = distance / timeDelta

        if speed > Config.AntiCheat.MaxWalkSpeed * 2 then
            pData.SpeedDetections = (pData.SpeedDetections or 0) + 1
            if pData.SpeedDetections >= 3 then
                AdvancedAntiCheat.AddWarning(player, "SpeedHack", "Velocidade: " .. math.floor(speed) .. " studs/s")
                AdvancedAntiCheat.ReturnToValid(player)
                pData.SpeedDetections = 0
            end
        else
            pData.SpeedDetections = 0
        end
    end

    pData.LastPosition = currentPos
    pData.LastCheckTime = now
end

function AdvancedAntiCheat.ReturnToValid(player)
    local pData = playerData[player.UserId]
    if not pData or not pData.LastValidPosition then return end

    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(pData.LastValidPosition)
    end
end

function AdvancedAntiCheat.AddWarning(player, cheatType, details)
    local pData = playerData[player.UserId]
    if not pData then return end

    pData.Warnings = (pData.Warnings or 0) + 1

    if Config.AntiCheat.LogExploits then
        local logRemote = remotesFolder:FindFirstChild("AntiCheatLog")
        if logRemote then
            logRemote:FireAllClients(player.Name, cheatType, details)
        end
        warn("[ANTI-CHEAT] " .. player.Name .. " | " .. cheatType .. " | " .. details .. " | Avisos: " .. pData.Warnings)
    end

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "warning", "Anti-Cheat: comportamento suspeito detectado. Aviso " .. pData.Warnings .. "/" .. Config.AntiCheat.MaxWarnings)
    end

    if pData.Warnings >= Config.AntiCheat.MaxWarnings then
        player:Kick("Removido pelo Anti-Cheat: multiplas violacoes detectadas.")
    end
end

function AdvancedAntiCheat.GetPlayerWarnings(player)
    local pData = playerData[player.UserId]
    return pData and pData.Warnings or 0
end

return AdvancedAntiCheat
