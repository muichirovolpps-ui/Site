--[[
    EffectsClient.lua (StarterPlayerScripts)
    Handles visual effects: explosions, particles, camera shake, floating text.
]]

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local EffectsClient = {}

function EffectsClient.LuckyBlockExplosion(data)
    local position = data.Position or Vector3.new(0, 5, 0)
    local color = data.Color or Color3.fromRGB(255, 215, 0)

    for i = 1, 12 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(1, 1, 1)
        particle.Position = position
        particle.Color = color
        particle.Material = Enum.Material.Neon
        particle.Anchored = false
        particle.CanCollide = false
        particle.Parent = Workspace

        local direction = Vector3.new(
            (math.random() - 0.5) * 2,
            math.random() * 1.5,
            (math.random() - 0.5) * 2
        ).Unit * math.random(20, 40)

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = direction
        bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bodyVelocity.Parent = particle

        Utils.CreateParticles(particle, color, 20, 5, 0.5)

        task.spawn(function()
            task.wait(0.3)
            bodyVelocity:Destroy()
            Utils.TweenObject(particle, {
                Transparency = 1,
                Size = Vector3.new(0.1, 0.1, 0.1),
            }, 0.5)
            task.wait(0.6)
            particle:Destroy()
        end)
    end

    local flash = Instance.new("Part")
    flash.Size = Vector3.new(2, 2, 2)
    flash.Position = position
    flash.Color = Color3.fromRGB(255, 255, 255)
    flash.Material = Enum.Material.Neon
    flash.Anchored = true
    flash.CanCollide = false
    flash.Shape = Enum.PartType.Ball
    flash.Parent = Workspace

    Utils.TweenObject(flash, {
        Size = Vector3.new(15, 15, 15),
        Transparency = 1,
    }, 0.4)

    task.delay(0.5, function()
        flash:Destroy()
    end)

    Utils.ScreenShake(camera, 0.3, 0.3)
end

function EffectsClient.TrainPunch(data)
    local amount = data.Amount or 1

    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    EffectsClient.FloatingText(
        hrp.Position + Vector3.new(0, 3, 0),
        "+" .. amount .. " Forca",
        Color3.fromRGB(255, 100, 100),
        1.5
    )
end

function EffectsClient.RebirthExplosion()
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i = 1, 20 do
        local ring = Instance.new("Part")
        ring.Size = Vector3.new(1, 1, 1)
        ring.Position = hrp.Position
        ring.Color = Color3.fromHSV(i / 20, 1, 1)
        ring.Material = Enum.Material.Neon
        ring.Anchored = true
        ring.CanCollide = false
        ring.Shape = Enum.PartType.Ball
        ring.Parent = Workspace

        task.spawn(function()
            task.wait(i * 0.05)
            Utils.TweenObject(ring, {
                Size = Vector3.new(20 + i * 3, 20 + i * 3, 20 + i * 3),
                Transparency = 1,
            }, 0.8)
            task.wait(1)
            ring:Destroy()
        end)
    end

    Utils.ScreenShake(camera, 1.0, 0.8)
end

function EffectsClient.FloatingText(position, text, color, duration)
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Parent = Workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(6, 0, 1.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    local startPos = position
    local endPos = position + Vector3.new(0, 5, 0)

    task.spawn(function()
        local elapsed = 0
        local dur = duration or 1.5

        while elapsed < dur do
            local dt = task.wait()
            elapsed = elapsed + dt
            local t = elapsed / dur
            part.Position = startPos:Lerp(endPos, t)
            label.TextTransparency = t * 1.5
            label.TextStrokeTransparency = 0.3 + (t * 0.7)
        end
        part:Destroy()
    end)
end

function EffectsClient.FloatingReward(position, rewardData)
    local yOffset = 0
    if rewardData.Money and rewardData.Money > 0 then
        EffectsClient.FloatingText(
            position + Vector3.new(0, yOffset, 0),
            "+$" .. Utils.FormatNumber(rewardData.Money),
            Color3.fromRGB(255, 215, 0),
            2
        )
        yOffset = yOffset + 1.5
    end
    if rewardData.Strength and rewardData.Strength > 0 then
        EffectsClient.FloatingText(
            position + Vector3.new(0, yOffset, 0),
            "+" .. Utils.FormatNumber(rewardData.Strength) .. " Forca",
            Color3.fromRGB(255, 100, 100),
            2
        )
        yOffset = yOffset + 1.5
    end
    if rewardData.Luck and rewardData.Luck > 0 then
        EffectsClient.FloatingText(
            position + Vector3.new(0, yOffset, 0),
            "+" .. string.format("%.1f", rewardData.Luck) .. " Sorte",
            Color3.fromRGB(100, 255, 200),
            2
        )
    end
end

------------------------------------------------------------
-- GLOBAL EFFECT DISPATCHER
------------------------------------------------------------
_G.PlayEffect = function(effectName, effectData)
    if effectName == "LuckyBlockExplosion" then
        EffectsClient.LuckyBlockExplosion(effectData)
    elseif effectName == "TrainPunch" then
        EffectsClient.TrainPunch(effectData)
    elseif effectName == "RebirthExplosion" then
        EffectsClient.RebirthExplosion()
    end
end

_G.PlayKickAnimation = function()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local kickAnim = Instance.new("Animation")
    kickAnim.AnimationId = "rbxassetid://0"
    -- Placeholder animation ID; replace with actual kick animation asset

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        EffectsClient.FloatingText(
            hrp.Position + Vector3.new(0, 2, -2),
            "CHUTE!",
            Color3.fromRGB(255, 200, 0),
            1
        )
    end
end

print("[Client] EffectsClient initialized")

return EffectsClient
