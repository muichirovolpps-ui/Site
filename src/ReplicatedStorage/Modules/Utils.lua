--[[
    Utils.lua
    Shared utility functions used across client and server.
]]

local TweenService = game:GetService("TweenService")

local Utils = {}

function Utils.Lerp(a, b, t)
    return a + (b - a) * math.clamp(t, 0, 1)
end

function Utils.FormatNumber(n)
    if n >= 1e12 then
        return string.format("%.1fT", n / 1e12)
    elseif n >= 1e9 then
        return string.format("%.1fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.1fM", n / 1e6)
    elseif n >= 1e3 then
        return string.format("%.1fK", n / 1e3)
    else
        return tostring(math.floor(n))
    end
end

function Utils.FormatTime(seconds)
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d", m, s)
end

function Utils.TweenObject(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function Utils.Chance(probability)
    return math.random() < probability
end

function Utils.PickRandom(tbl)
    if #tbl == 0 then return nil end
    return tbl[math.random(1, #tbl)]
end

function Utils.WeightedRandom(items, weightKey)
    local totalWeight = 0
    for _, item in ipairs(items) do
        totalWeight = totalWeight + (item[weightKey] or 1)
    end
    local roll = math.random() * totalWeight
    local cumulative = 0
    for _, item in ipairs(items) do
        cumulative = cumulative + (item[weightKey] or 1)
        if roll <= cumulative then
            return item
        end
    end
    return items[#items]
end

function Utils.ShallowCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = v
    end
    return copy
end

function Utils.DeepCopy(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        copy[Utils.DeepCopy(k)] = Utils.DeepCopy(v)
    end
    return setmetatable(copy, getmetatable(tbl))
end

function Utils.CreateInstance(className, properties, parent)
    local inst = Instance.new(className)
    if properties then
        for k, v in pairs(properties) do
            inst[k] = v
        end
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

function Utils.WeldParts(part0, part1)
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.Parent = part0
    return weld
end

function Utils.CreateParticles(parent, color, rate, speed, lifetime)
    local emitter = Instance.new("ParticleEmitter")
    emitter.Color = ColorSequence.new(color or Color3.fromRGB(255, 255, 255))
    emitter.Rate = rate or 20
    emitter.Speed = NumberRange.new(speed or 5)
    emitter.Lifetime = NumberRange.new(lifetime or 1)
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    emitter.Parent = parent
    return emitter
end

function Utils.ScreenShake(camera, intensity, duration)
    local startTime = tick()
    local originalCFrame = camera.CFrame
    task.spawn(function()
        while tick() - startTime < duration do
            local elapsed = tick() - startTime
            local factor = 1 - (elapsed / duration)
            local offset = Vector3.new(
                (math.random() - 0.5) * intensity * factor,
                (math.random() - 0.5) * intensity * factor,
                (math.random() - 0.5) * intensity * factor
            )
            camera.CFrame = camera.CFrame * CFrame.new(offset)
            task.wait()
        end
    end)
end

function Utils.CreateSound(parent, soundId, volume, looped)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId or ""
    sound.Volume = volume or 0.5
    sound.Looped = looped or false
    sound.Parent = parent
    return sound
end

function Utils.SafePlayerData(player, callback)
    local success, err = pcall(callback, player)
    if not success then
        warn("[Utils] Error for player " .. player.Name .. ": " .. tostring(err))
    end
    return success
end

return Utils
