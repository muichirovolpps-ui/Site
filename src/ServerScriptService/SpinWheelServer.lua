--[[
    SpinWheelServer.lua  v3.0
    Spin wheel with free spins (1h cooldown), gem-cost spins, and varied rewards.
    Weighted random selection, reward application, cooldown tracking.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpinWheelServer = {}

local config = nil
local remotes = nil
local dsManager = nil

function SpinWheelServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder

    local spinRemote = remotes:FindFirstChild("RequestSpin")
    if spinRemote then
        spinRemote.OnServerEvent:Connect(function(player, useGems)
            SpinWheelServer.ProcessSpin(player, useGems)
        end)
    end

    local getWheel = remotes:FindFirstChild("GetSpinWheel")
    if getWheel and getWheel:IsA("RemoteFunction") then
        getWheel.OnServerInvoke = function(player)
            return SpinWheelServer.GetWheelData(player)
        end
    end

    print("[SpinWheel] Initialized — " .. #config.SpinWheel.Segments .. " segments")
end

function SpinWheelServer.ProcessSpin(player, useGems)
    local data = dsManager:GetData(player)
    if not data then return end

    if not data.SpinData then
        data.SpinData = { LastFreeSpin = 0, TotalSpins = 0 }
    end

    local now = os.time()
    local canFreeSpin = config.SpinWheel.FreeSpin and
        (now - data.SpinData.LastFreeSpin >= config.SpinWheel.FreeSpinCooldown)

    if not useGems and canFreeSpin then
        data.SpinData.LastFreeSpin = now
    elseif useGems then
        local cost = config.SpinWheel.GemCost
        if (data.Gems or 0) < cost then
            remotes:FindFirstChild("SpinResult"):FireClient(player, { Error = "Gems insuficientes" })
            return
        end
        data.Gems = data.Gems - cost
    else
        local timeLeft = config.SpinWheel.FreeSpinCooldown - (now - data.SpinData.LastFreeSpin)
        remotes:FindFirstChild("SpinResult"):FireClient(player, {
            Error = "Spin gratis em " .. math.ceil(timeLeft / 60) .. " min",
        })
        return
    end

    local segment = SpinWheelServer.WeightedRandom()

    if segment.Reward.Money then
        data.Money = data.Money + segment.Reward.Money
    end
    if segment.Reward.Strength then
        data.Strength = data.Strength + segment.Reward.Strength
    end
    if segment.Reward.Luck then
        data.Luck = data.Luck + segment.Reward.Luck
    end
    if segment.Reward.Gems then
        data.Gems = (data.Gems or 0) + segment.Reward.Gems
    end
    if segment.Reward.Brainrot then
        local BrainrotDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))
        local rarityBrainrots = BrainrotDatabase.Brainrots[segment.Reward.Brainrot]
        if rarityBrainrots and #rarityBrainrots > 0 then
            local pick = rarityBrainrots[math.random(1, #rarityBrainrots)]
            table.insert(data.Inventory, {
                Name = pick.Name,
                Rarity = segment.Reward.Brainrot,
                Mutation = nil,
                Level = 1,
            })
        end
    end
    if segment.Reward.Mutation then
        if data.Inventory and #data.Inventory > 0 then
            local randomBrain = data.Inventory[math.random(1, #data.Inventory)]
            if not randomBrain.Mutation then
                randomBrain.Mutation = segment.Reward.Mutation
            end
        end
    end

    data.SpinData.TotalSpins = data.SpinData.TotalSpins + 1

    remotes:FindFirstChild("SpinResult"):FireClient(player, {
        SegmentName = segment.Name,
        SegmentColor = segment.Color,
        Reward = segment.Reward,
        SegmentIndex = segment.Index,
    })
end

function SpinWheelServer.WeightedRandom()
    local segments = config.SpinWheel.Segments
    local totalWeight = 0
    for _, seg in ipairs(segments) do
        totalWeight = totalWeight + seg.Weight
    end

    local roll = math.random() * totalWeight
    local cumulative = 0
    for i, seg in ipairs(segments) do
        cumulative = cumulative + seg.Weight
        if roll <= cumulative then
            return { Name = seg.Name, Color = seg.Color, Reward = seg.Reward, Index = i }
        end
    end

    local last = segments[#segments]
    return { Name = last.Name, Color = last.Color, Reward = last.Reward, Index = #segments }
end

function SpinWheelServer.GetWheelData(player)
    local data = dsManager:GetData(player)
    if not data then return {} end

    if not data.SpinData then
        data.SpinData = { LastFreeSpin = 0, TotalSpins = 0 }
    end

    local now = os.time()
    local canFreeSpin = config.SpinWheel.FreeSpin and
        (now - data.SpinData.LastFreeSpin >= config.SpinWheel.FreeSpinCooldown)
    local timeLeft = math.max(0, config.SpinWheel.FreeSpinCooldown - (now - data.SpinData.LastFreeSpin))

    return {
        Segments = config.SpinWheel.Segments,
        CanFreeSpin = canFreeSpin,
        TimeLeft = timeLeft,
        GemCost = config.SpinWheel.GemCost,
        TotalSpins = data.SpinData.TotalSpins,
    }
end

return SpinWheelServer
