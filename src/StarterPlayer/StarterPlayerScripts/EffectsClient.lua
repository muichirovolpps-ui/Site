--[[
    EffectsClient.lua  v3.0 (StarterPlayerScripts)
    Handles visual effects: explosions, particles, camera shake, floating text,
    kick fly animation, meteor impacts, VIP particles, passive income popups,
    boss effects, event banners, brainrot rain, achievement sparks.
]]

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local EffectsClient = {}

function EffectsClient.LuckyBlockExplosion(data)
    local position = data.Position or Vector3.new(0, 5, 0)
    local color = data.Color or Color3.fromRGB(255, 215, 0)

    for i = 1, 16 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(math.random(5, 15) / 10, math.random(5, 15) / 10, math.random(5, 15) / 10)
        particle.Position = position
        particle.Color = color
        particle.Material = Enum.Material.Neon
        particle.Anchored = false
        particle.CanCollide = false
        particle.Parent = Workspace

        local direction = Vector3.new(
            math.random(-100, 100) / 100,
            math.random(50, 100) / 100,
            math.random(-100, 100) / 100
        ).Unit * math.random(20, 50)

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = direction
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = particle

        TweenService:Create(particle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = Vector3.new(0, 0, 0),
        }):Play()

        Debris:AddItem(particle, 1)
    end

    local flash = Instance.new("Part")
    flash.Shape = Enum.PartType.Ball
    flash.Size = Vector3.new(2, 2, 2)
    flash.Position = position
    flash.Color = Color3.fromRGB(255, 255, 255)
    flash.Material = Enum.Material.Neon
    flash.Anchored = true
    flash.CanCollide = false
    flash.Parent = Workspace

    TweenService:Create(flash, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Size = Vector3.new(15, 15, 15),
        Transparency = 1,
    }):Play()
    Debris:AddItem(flash, 0.6)

    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.2, 2, 2)
    ring.Position = position
    ring.Orientation = Vector3.new(0, 0, 90)
    ring.Color = color
    ring.Material = Enum.Material.Neon
    ring.Anchored = true
    ring.CanCollide = false
    ring.Parent = Workspace

    TweenService:Create(ring, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
        Size = Vector3.new(0.1, 25, 25),
        Transparency = 1,
    }):Play()
    Debris:AddItem(ring, 0.7)

    EffectsClient.ScreenShake(0.5, 0.4)
end

function EffectsClient.KickFlyEffect(data)
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local distance = data.Distance or 100
    local flyDuration = data.FlyDuration or 2.0
    local spinSpeed = data.SpinSpeed or 720

    local trail0 = Instance.new("Attachment")
    trail0.Position = Vector3.new(0, 1, 0)
    trail0.Parent = rootPart

    local trail1 = Instance.new("Attachment")
    trail1.Position = Vector3.new(0, -1, 0)
    trail1.Parent = rootPart

    local trail = Instance.new("Trail")
    trail.Attachment0 = trail0
    trail.Attachment1 = trail1
    trail.Color = ColorSequence.new(Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 80, 0))
    trail.Lifetime = 0.8
    trail.LightEmission = 1
    trail.MinLength = 0
    trail.Parent = rootPart

    local speedLines = Instance.new("ParticleEmitter")
    speedLines.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    speedLines.Size = NumberSequence.new(0.3, 0)
    speedLines.Lifetime = NumberRange.new(0.2, 0.4)
    speedLines.Rate = 50
    speedLines.Speed = NumberRange.new(20, 40)
    speedLines.SpreadAngle = Vector2.new(10, 10)
    speedLines.LightEmission = 1
    speedLines.Parent = rootPart

    EffectsClient.ScreenShake(data.CameraShakeIntensity or 0.5, data.CameraShakeDuration or 0.4)

    task.spawn(function()
        task.wait(flyDuration)
        trail:Destroy()
        trail0:Destroy()
        trail1:Destroy()
        speedLines:Destroy()

        EffectsClient.LandingImpact(rootPart.Position)
    end)
end

function EffectsClient.LandingImpact(position)
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.3, 1, 1)
    ring.Position = position
    ring.Orientation = Vector3.new(0, 0, 90)
    ring.Color = Color3.fromRGB(255, 200, 50)
    ring.Material = Enum.Material.Neon
    ring.Anchored = true
    ring.CanCollide = false
    ring.Parent = Workspace

    TweenService:Create(ring, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Size = Vector3.new(0.1, 30, 30),
        Transparency = 1,
    }):Play()
    Debris:AddItem(ring, 0.6)

    EffectsClient.ScreenShake(0.3, 0.3)
end

function EffectsClient.MeteorImpact(position)
    EffectsClient.ScreenShake(1.0, 0.8)

    for i = 1, 20 do
        local debris = Instance.new("Part")
        debris.Size = Vector3.new(math.random(10, 30) / 10, math.random(10, 30) / 10, math.random(10, 30) / 10)
        debris.Position = position + Vector3.new(math.random(-5, 5), math.random(0, 3), math.random(-5, 5))
        debris.Color = Color3.fromRGB(math.random(100, 200), math.random(40, 80), 0)
        debris.Material = Enum.Material.Neon
        debris.Anchored = false
        debris.CanCollide = false
        debris.Parent = Workspace

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(math.random(-40, 40), math.random(30, 80), math.random(-40, 40))
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = debris

        TweenService:Create(debris, TweenInfo.new(1.5), { Transparency = 1 }):Play()
        Debris:AddItem(debris, 2)
    end

    local shockwave = Instance.new("Part")
    shockwave.Shape = Enum.PartType.Cylinder
    shockwave.Size = Vector3.new(0.5, 3, 3)
    shockwave.Position = position
    shockwave.Orientation = Vector3.new(0, 0, 90)
    shockwave.Color = Color3.fromRGB(255, 120, 0)
    shockwave.Material = Enum.Material.Neon
    shockwave.Anchored = true
    shockwave.CanCollide = false
    shockwave.Parent = Workspace

    TweenService:Create(shockwave, TweenInfo.new(0.8), {
        Size = Vector3.new(0.1, 50, 50),
        Transparency = 1,
    }):Play()
    Debris:AddItem(shockwave, 1)
end

function EffectsClient.MeteorWarning()
    local warningPart = Instance.new("Part")
    warningPart.Size = Vector3.new(0.1, 0.1, 0.1)
    warningPart.Position = (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position) or Vector3.new(0, 10, 0)
    warningPart.Transparency = 1
    warningPart.Anchored = true
    warningPart.CanCollide = false
    warningPart.Parent = Workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 300, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 15, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = warningPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "CHUVA DE METEOROS!"
    label.TextColor3 = Color3.fromRGB(255, 100, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 32
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(100, 30, 0)
    label.Parent = billboard

    task.spawn(function()
        for i = 1, 6 do
            label.TextTransparency = 0
            task.wait(0.4)
            label.TextTransparency = 0.5
            task.wait(0.4)
        end
        warningPart:Destroy()
    end)
end

function EffectsClient.TrainPunch(data)
    local position = data.Position or Vector3.new(0, 5, 0)
    local value = data.Value or 1
    local color = data.Color or Color3.fromRGB(255, 200, 50)

    EffectsClient.FloatingText({
        Position = position + Vector3.new(math.random(-2, 2), 2, math.random(-2, 2)),
        Text = "+" .. value,
        Color = color,
        Duration = 0.6,
        Size = 24,
    })
end

function EffectsClient.RebirthExplosion(data)
    local rebirthLevel = data.Level or 1
    local character = player.Character
    local position = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or Vector3.new(0, 5, 0)

    for r = 1, 5 do
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.3, 2, 2)
        ring.Position = position + Vector3.new(0, r * 2, 0)
        ring.Orientation = Vector3.new(0, 0, 90)
        ring.Color = Color3.fromHSV(r / 5, 1, 1)
        ring.Material = Enum.Material.Neon
        ring.Anchored = true
        ring.CanCollide = false
        ring.Parent = Workspace

        task.spawn(function()
            task.wait(r * 0.1)
            TweenService:Create(ring, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                Size = Vector3.new(0.1, 40 + r * 5, 40 + r * 5),
                Transparency = 1,
            }):Play()
            Debris:AddItem(ring, 1.2)
        end)
    end

    for i = 1, 30 do
        local star = Instance.new("Part")
        star.Size = Vector3.new(0.5, 0.5, 0.5)
        star.Position = position
        star.Color = Color3.fromHSV(math.random() , 1, 1)
        star.Material = Enum.Material.Neon
        star.Anchored = false
        star.CanCollide = false
        star.Parent = Workspace

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(math.random(-60, 60), math.random(40, 100), math.random(-60, 60))
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = star

        TweenService:Create(star, TweenInfo.new(1.5), { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
        Debris:AddItem(star, 2)
    end

    EffectsClient.ScreenShake(1.5, 1.0)
end

function EffectsClient.FloatingText(data)
    local position = data.Position or Vector3.new(0, 10, 0)
    local text = data.Text or ""
    local color = data.Color or Color3.fromRGB(255, 255, 255)
    local duration = data.Duration or 1.0
    local textSize = data.Size or 20

    local part = Instance.new("Part")
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Position = position
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.Parent = Workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 0, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextScaled = false
    label.TextSize = textSize
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    TweenService:Create(part, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = position + Vector3.new(0, 5, 0),
    }):Play()

    TweenService:Create(label, TweenInfo.new(duration * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1,
        TextStrokeTransparency = 1,
    }):Play()

    Debris:AddItem(part, duration + 0.1)
end

function EffectsClient.FloatingReward(data)
    local position = data.Position or Vector3.new(0, 5, 0)
    local yOffset = 0

    if data.Money and data.Money > 0 then
        EffectsClient.FloatingText({
            Position = position + Vector3.new(0, yOffset, 0),
            Text = "+$" .. Utils.FormatNumber(data.Money),
            Color = Color3.fromRGB(80, 255, 80),
            Duration = 1.2,
            Size = 22,
        })
        yOffset = yOffset + 2
    end

    if data.Strength and data.Strength > 0 then
        EffectsClient.FloatingText({
            Position = position + Vector3.new(0, yOffset, 0),
            Text = "+" .. Utils.FormatNumber(data.Strength) .. " STR",
            Color = Color3.fromRGB(255, 100, 100),
            Duration = 1.2,
            Size = 20,
        })
        yOffset = yOffset + 2
    end

    if data.Distance and data.Distance > 0 then
        EffectsClient.FloatingText({
            Position = position + Vector3.new(0, yOffset, 0),
            Text = Utils.FormatNumber(data.Distance) .. "m",
            Color = Color3.fromRGB(255, 200, 50),
            Duration = 1.5,
            Size = 26,
        })
    end
end

function EffectsClient.PassiveIncomePopup(amount)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    EffectsClient.FloatingText({
        Position = character.HumanoidRootPart.Position + Vector3.new(math.random(-3, 3), 4, math.random(-3, 3)),
        Text = "+$" .. Utils.FormatNumber(amount),
        Color = Color3.fromRGB(150, 255, 150),
        Duration = 1.0,
        Size = 16,
    })
end

function EffectsClient.ScreenShake(intensity, duration)
    intensity = intensity or 0.5
    duration = duration or 0.3

    task.spawn(function()
        local startTime = tick()
        while tick() - startTime < duration do
            local elapsed = tick() - startTime
            local fadeOut = 1 - (elapsed / duration)
            local offset = CFrame.new(
                math.random(-100, 100) / 100 * intensity * fadeOut,
                math.random(-100, 100) / 100 * intensity * fadeOut,
                0
            )
            camera.CFrame = camera.CFrame * offset
            RunService.RenderStepped:Wait()
        end
    end)
end

function EffectsClient.CreateSound(soundId, volume, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId or ""
    sound.Volume = volume or 0.5
    sound.Parent = parent or Workspace
    sound:Play()
    Debris:AddItem(sound, sound.TimeLength + 1)
    return sound
end

function EffectsClient.Initialize()
    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")

    local playEffect = remotesFolder:FindFirstChild("PlayEffect")
    if playEffect then
        playEffect.OnClientEvent:Connect(function(effectName, data)
            if EffectsClient[effectName] then
                EffectsClient[effectName](data)
            end
        end)
    end

    local meteorEvent = remotesFolder:FindFirstChild("MeteorEvent")
    if meteorEvent then
        meteorEvent.OnClientEvent:Connect(function(eventType, data)
            if eventType == "impact" then
                EffectsClient.MeteorImpact(data)
            end
        end)
    end

    local meteorWarning = remotesFolder:FindFirstChild("MeteorWarning")
    if meteorWarning then
        meteorWarning.OnClientEvent:Connect(function(warningType, _)
            if warningType == "start" then
                EffectsClient.MeteorWarning()
            end
        end)
    end

    local kickResult = remotesFolder:FindFirstChild("KickResult")
    if kickResult then
        kickResult.OnClientEvent:Connect(function(data)
            EffectsClient.KickFlyEffect(data)
        end)
    end

    local passiveIncome = remotesFolder:FindFirstChild("PassiveIncomeUpdate")
    if passiveIncome then
        passiveIncome.OnClientEvent:Connect(function(amount)
            EffectsClient.PassiveIncomePopup(amount)
        end)
    end

    -- V3: Boss damage flash
    local bossDamaged = remotesFolder:FindFirstChild("BossDamaged")
    if bossDamaged then
        bossDamaged.OnClientEvent:Connect(function(data)
            EffectsClient.BossDamageFlash(data)
        end)
    end

    -- V3: Boss defeated celebration
    local bossDefeated = remotesFolder:FindFirstChild("BossDefeated")
    if bossDefeated then
        bossDefeated.OnClientEvent:Connect(function(data)
            EffectsClient.BossDefeatCelebration(data)
        end)
    end

    -- V3: Brainrot rain visual
    local brainrotRain = remotesFolder:FindFirstChild("BrainrotRainDrop")
    if brainrotRain then
        brainrotRain.OnClientEvent:Connect(function(data)
            EffectsClient.BrainrotRainDrop(data)
        end)
    end

    -- V3: Achievement sparkle
    local achieveUnlocked = remotesFolder:FindFirstChild("AchievementUnlocked")
    if achieveUnlocked then
        achieveUnlocked.OnClientEvent:Connect(function(data)
            EffectsClient.AchievementSparkle()
        end)
    end
end

------------------------------------------------------------
-- V3: BOSS DAMAGE FLASH
------------------------------------------------------------
function EffectsClient.BossDamageFlash(data)
    EffectsClient.CameraShake(0.3, 2)
    EffectsClient.FloatingText("+" .. Utils.FormatNumber(data.Damage) .. " DMG",
        Vector3.new(0, 10, -100), Color3.fromRGB(255, 50, 50))
end

------------------------------------------------------------
-- V3: BOSS DEFEAT CELEBRATION
------------------------------------------------------------
function EffectsClient.BossDefeatCelebration(data)
    EffectsClient.CameraShake(1, 8)

    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i = 1, 20 do
        local confetti = Instance.new("Part")
        confetti.Size = Vector3.new(0.3, 0.3, 0.3)
        confetti.Position = hrp.Position + Vector3.new(
            math.random(-10, 10), math.random(5, 15), math.random(-10, 10)
        )
        confetti.Color = Color3.fromHSV(math.random(), 1, 1)
        confetti.Material = Enum.Material.Neon
        confetti.Anchored = false
        confetti.CanCollide = false
        confetti.Parent = workspace
        Debris:AddItem(confetti, 3)
    end
end

------------------------------------------------------------
-- V3: BRAINROT RAIN DROP
------------------------------------------------------------
function EffectsClient.BrainrotRainDrop(data)
    local drop = Instance.new("Part")
    drop.Size = Vector3.new(2, 2, 2)
    drop.Shape = Enum.PartType.Ball
    drop.Position = data.Position
    drop.Color = Color3.fromHSV(math.random(), 0.8, 1)
    drop.Material = Enum.Material.Neon
    drop.Anchored = false
    drop.CanCollide = true
    drop.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = drop.Color
    light.Brightness = 2
    light.Range = 10
    light.Parent = drop

    Debris:AddItem(drop, 5)
end

------------------------------------------------------------
-- V3: ACHIEVEMENT SPARKLE
------------------------------------------------------------
function EffectsClient.AchievementSparkle()
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local emitter = Instance.new("ParticleEmitter")
    emitter.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))
    emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
    emitter.Rate = 50
    emitter.Lifetime = NumberRange.new(0.5, 1)
    emitter.Speed = NumberRange.new(5, 10)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Parent = hrp

    task.delay(2, function()
        emitter:Destroy()
    end)

    EffectsClient.CameraShake(0.5, 4)
end

return EffectsClient
