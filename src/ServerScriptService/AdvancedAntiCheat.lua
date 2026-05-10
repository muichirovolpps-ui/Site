--[[
    AdvancedAntiCheat.lua  v3.0
    Advanced anti-cheat with 6 detection types:
    Flying, Speed hacks, Teleport abuse, Auto-farm, Infinite Jump, Noclip, Remote Spam.
    Warning system, rollback, auto-kick, logging.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local AdvancedAntiCheat = {}

local Config
local remotesFolder

local playerData = {}
local remoteCallCounts = {}

function AdvancedAntiCheat.Initialize(config, remotes)
    Config = config
    remotesFolder = remotes

    if not Config.AntiCheat.Enabled then
        print("[AntiCheat v3] Disabled in config")
        return
    end

    Players.PlayerAdded:Connect(function(player)
        playerData[player.UserId] = {
            Warnings = 0,
            LastValidPosition = Vector3.new(0, 5, 0),
            LastPosition = Vector3.new(0, 5, 0),
            LastCheckTime = os.clock(),
            FlyDetections = 0,
            SpeedDetections = 0,
            TeleportDetections = 0,
            JumpDetections = 0,
            NoclipDetections = 0,
            ActionCount = 0,
            LastActionReset = os.time(),
            WarningLog = {},
        }
        remoteCallCounts[player.UserId] = { Count = 0, LastReset = os.time() }
    end)

    Players.PlayerRemoving:Connect(function(player)
        playerData[player.UserId] = nil
        remoteCallCounts[player.UserId] = nil
    end)

    RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            AdvancedAntiCheat.CheckPlayer(player)
        end
    end)

    if Config.AntiCheat.DetectRemoteSpam then
        AdvancedAntiCheat.SetupRemoteMonitoring()
    end

    task.spawn(function()
        while true do
            task.wait(1)
            local now = os.time()
            for userId, rc in pairs(remoteCallCounts) do
                if now - rc.LastReset >= 1 then
                    rc.Count = 0
                    rc.LastReset = now
                end
            end
            for userId, pd in pairs(playerData) do
                if now - pd.LastActionReset >= 60 then
                    pd.ActionCount = 0
                    pd.LastActionReset = now
                end
            end
        end
    end)

    print("[AntiCheat v3] Initialized — 6 detection types active")
end

function AdvancedAntiCheat.CheckPlayer(player)
    local pd = playerData[player.UserId]
    if not pd then return end

    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local now = os.clock()
    if now - pd.LastCheckTime < (Config.AntiCheat.CheckInterval or 1) then return end
    pd.LastCheckTime = now

    local currentPos = hrp.Position

    AdvancedAntiCheat.CheckFlying(player, pd, humanoid, hrp, currentPos)
    AdvancedAntiCheat.CheckSpeed(player, pd, humanoid, currentPos)
    AdvancedAntiCheat.CheckTeleport(player, pd, currentPos)

    if Config.AntiCheat.DetectInfiniteJump then
        AdvancedAntiCheat.CheckInfiniteJump(player, pd, humanoid, hrp)
    end

    if Config.AntiCheat.DetectNoclip then
        AdvancedAntiCheat.CheckNoclip(player, pd, hrp)
    end

    if Config.AntiCheat.DetectAutoFarm then
        AdvancedAntiCheat.CheckAutoFarm(player, pd)
    end

    local onGround = false
    local rayResult = workspace:Raycast(currentPos, Vector3.new(0, -10, 0))
    if rayResult then onGround = true end

    if onGround then
        pd.LastValidPosition = currentPos
    end

    pd.LastPosition = currentPos
end

function AdvancedAntiCheat.CheckFlying(player, pd, humanoid, hrp, currentPos)
    if currentPos.Y > 50 then
        local state = humanoid:GetState()
        local isJumping = state == Enum.HumanoidStateType.Jumping or
                         state == Enum.HumanoidStateType.Freefall

        if not isJumping then
            local rayResult = workspace:Raycast(currentPos, Vector3.new(0, -60, 0))
            if not rayResult then
                pd.FlyDetections = pd.FlyDetections + 1
                if pd.FlyDetections >= 3 then
                    AdvancedAntiCheat.AddWarning(player, "Flying", "Y=" .. math.floor(currentPos.Y))
                    AdvancedAntiCheat.ReturnToValid(player, pd)
                    pd.FlyDetections = 0
                end
            else
                pd.FlyDetections = math.max(pd.FlyDetections - 1, 0)
            end
        end
    end
end

function AdvancedAntiCheat.CheckSpeed(player, pd, humanoid, currentPos)
    local dist = (currentPos - pd.LastPosition).Magnitude
    local maxSpeed = Config.AntiCheat.MaxWalkSpeed * 2

    if dist > maxSpeed then
        pd.SpeedDetections = pd.SpeedDetections + 1
        if pd.SpeedDetections >= 3 then
            AdvancedAntiCheat.AddWarning(player, "SpeedHack", "Speed=" .. math.floor(dist))
            AdvancedAntiCheat.ReturnToValid(player, pd)
            pd.SpeedDetections = 0
        end
    else
        pd.SpeedDetections = math.max(pd.SpeedDetections - 1, 0)
    end
end

function AdvancedAntiCheat.CheckTeleport(player, pd, currentPos)
    local dist = (currentPos - pd.LastPosition).Magnitude
    if dist > Config.AntiCheat.TeleportThreshold then
        pd.TeleportDetections = pd.TeleportDetections + 1
        if pd.TeleportDetections >= 2 then
            AdvancedAntiCheat.AddWarning(player, "TeleportAbuse", "Dist=" .. math.floor(dist))
            AdvancedAntiCheat.ReturnToValid(player, pd)
            pd.TeleportDetections = 0
        end
    end
end

function AdvancedAntiCheat.CheckInfiniteJump(player, pd, humanoid, hrp)
    local state = humanoid:GetState()
    if state == Enum.HumanoidStateType.Jumping then
        local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0, -5, 0))
        if not rayResult then
            pd.JumpDetections = pd.JumpDetections + 1
            if pd.JumpDetections >= 5 then
                AdvancedAntiCheat.AddWarning(player, "InfiniteJump", "JumpCount=" .. pd.JumpDetections)
                pd.JumpDetections = 0
            end
        else
            pd.JumpDetections = 0
        end
    end
end

function AdvancedAntiCheat.CheckNoclip(player, pd, hrp)
    local pos = hrp.Position
    local rayResult = workspace:Raycast(pos, Vector3.new(0, -2, 0))

    if not rayResult and pos.Y < -10 then
        pd.NoclipDetections = pd.NoclipDetections + 1
        if pd.NoclipDetections >= 3 then
            AdvancedAntiCheat.AddWarning(player, "Noclip", "Below ground Y=" .. math.floor(pos.Y))
            AdvancedAntiCheat.ReturnToValid(player, pd)
            pd.NoclipDetections = 0
        end
    else
        pd.NoclipDetections = math.max(pd.NoclipDetections - 1, 0)
    end
end

function AdvancedAntiCheat.CheckAutoFarm(player, pd)
    local threshold = Config.AntiCheat.AutoFarmThreshold or 50
    if pd.ActionCount > threshold then
        AdvancedAntiCheat.AddWarning(player, "AutoFarm", "Actions=" .. pd.ActionCount .. "/min")
        pd.ActionCount = 0
    end
end

function AdvancedAntiCheat.RecordAction(player)
    local pd = playerData[player.UserId]
    if pd then
        pd.ActionCount = pd.ActionCount + 1
    end
end

function AdvancedAntiCheat.SetupRemoteMonitoring()
    task.spawn(function()
        task.wait(3)
        local remotesFolder2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if not remotesFolder2 then return end

        for _, remote in ipairs(remotesFolder2:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                remote.OnServerEvent:Connect(function(player)
                    local rc = remoteCallCounts[player.UserId]
                    if rc then
                        rc.Count = rc.Count + 1
                        if rc.Count > (Config.AntiCheat.MaxRemotesPerSecond or 30) then
                            AdvancedAntiCheat.AddWarning(player, "RemoteSpam",
                                "Calls=" .. rc.Count .. "/s on " .. remote.Name)
                        end
                    end
                end)
            end
        end
    end)
end

function AdvancedAntiCheat.AddWarning(player, cheatType, details)
    local pd = playerData[player.UserId]
    if not pd then return end

    pd.Warnings = pd.Warnings + 1

    table.insert(pd.WarningLog, {
        Type = cheatType,
        Details = details,
        Time = os.time(),
        Warning = pd.Warnings,
    })

    if Config.AntiCheat.LogExploits then
        warn("[AntiCheat v3] " .. player.Name .. " | " .. cheatType .. " | " .. details
            .. " | Warning " .. pd.Warnings .. "/" .. Config.AntiCheat.MaxWarnings)
    end

    local logRemote = remotesFolder:FindFirstChild("AntiCheatLog")
    if logRemote then
        logRemote:FireClient(player, {
            Type = cheatType,
            Warning = pd.Warnings,
            MaxWarnings = Config.AntiCheat.MaxWarnings,
        })
    end

    if pd.Warnings >= Config.AntiCheat.MaxWarnings then
        player:Kick("Anti-Cheat: Detectado comportamento irregular. [" .. cheatType .. "]")
    end
end

function AdvancedAntiCheat.ReturnToValid(player, pd)
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp and pd.LastValidPosition then
            hrp.CFrame = CFrame.new(pd.LastValidPosition)
        end
    end
end

function AdvancedAntiCheat.GetPlayerWarnings(player)
    local pd = playerData[player.UserId]
    if pd then
        return pd.Warnings, pd.WarningLog
    end
    return 0, {}
end

return AdvancedAntiCheat
