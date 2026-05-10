--[[
    BossServer.lua  v3.0
    World boss spawning, damage tracking, reward distribution.
    5 bosses: Giant Brainrot, Hacker Cube, Golden Monster, Meteor Titan, Corrupted Lucky Block.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BossServer = {}

local config = nil
local remotes = nil
local dsManager = nil
local BrainrotDatabase = nil

local activeBoss = nil
local bossDamage = {}
local bossHealth = 0

function BossServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder
    BrainrotDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))

    local attackRemote = remotes:FindFirstChild("AttackBoss")
    if attackRemote then
        attackRemote.OnServerEvent:Connect(function(player)
            BossServer.ProcessAttack(player)
        end)
    end

    print("[BossServer] Initialized — 5 boss types loaded")
end

function BossServer.SpawnBoss(bossIndex)
    if activeBoss then return false end

    local bossConfig = config.Bosses[bossIndex]
    if not bossConfig then return false end

    activeBoss = {
        Config = bossConfig,
        MaxHealth = bossConfig.Health,
        CurrentHealth = bossConfig.Health,
        SpawnTime = os.time(),
    }
    bossHealth = bossConfig.Health
    bossDamage = {}

    local bossModel = Instance.new("Model")
    bossModel.Name = "Boss_" .. bossConfig.Name

    local part = Instance.new("Part")
    part.Name = "BossBody"
    part.Size = Vector3.new(bossConfig.Size, bossConfig.Size, bossConfig.Size)
    part.Position = Vector3.new(0, bossConfig.Size / 2 + 5, -100)
    part.Color = bossConfig.Color
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.CanCollide = false
    part.Parent = bossModel

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BossInfo"
    billboard.Size = UDim2.new(0, 300, 0, 60)
    billboard.StudsOffset = Vector3.new(0, bossConfig.Size / 2 + 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "BossName"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = bossConfig.DisplayName
    nameLabel.TextColor3 = bossConfig.Color
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard

    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBarBG"
    healthBar.Size = UDim2.new(0.8, 0, 0.3, 0)
    healthBar.Position = UDim2.new(0.1, 0, 0.6, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = billboard

    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar

    local fire = Instance.new("Fire")
    fire.Size = bossConfig.Size * 2
    fire.Color = bossConfig.Color
    fire.Parent = part

    local light = Instance.new("PointLight")
    light.Color = bossConfig.Color
    light.Brightness = 3
    light.Range = bossConfig.Size * 3
    light.Parent = part

    bossModel.PrimaryPart = part
    bossModel.Parent = workspace

    activeBoss.Model = bossModel

    remotes:FindFirstChild("BossSpawned"):FireAllClients({
        Name = bossConfig.Name,
        DisplayName = bossConfig.DisplayName,
        Health = bossConfig.Health,
        Color = bossConfig.Color,
        Position = part.Position,
    })

    task.spawn(function()
        while activeBoss and activeBoss.CurrentHealth > 0 do
            task.wait(0.5)
            local healthPct = activeBoss.CurrentHealth / activeBoss.MaxHealth
            pcall(function()
                local fill = bossModel:FindFirstChild("BossBody")
                if fill then
                    local bg = fill:FindFirstChild("BossInfo")
                    if bg then
                        local bar = bg:FindFirstChild("HealthBarBG")
                        if bar then
                            local f = bar:FindFirstChild("HealthFill")
                            if f then
                                f.Size = UDim2.new(math.max(healthPct, 0), 0, 1, 0)
                            end
                        end
                    end
                end
            end)
        end
    end)

    return true
end

function BossServer.SpawnRandomBoss()
    local index = math.random(1, #config.Bosses)
    return BossServer.SpawnBoss(index)
end

function BossServer.ProcessAttack(player)
    if not activeBoss then return end

    local data = dsManager.GetData(player)
    if not data then return end

    local damage = math.floor(data.Strength * 0.1)
    damage = math.max(damage, 1)

    local playerId = tostring(player.UserId)
    bossDamage[playerId] = (bossDamage[playerId] or 0) + damage

    activeBoss.CurrentHealth = activeBoss.CurrentHealth - damage

    remotes:FindFirstChild("BossDamaged"):FireAllClients({
        Damage = damage,
        PlayerName = player.Name,
        RemainingHealth = math.max(activeBoss.CurrentHealth, 0),
        MaxHealth = activeBoss.MaxHealth,
    })

    if activeBoss.CurrentHealth <= 0 then
        BossServer.DefeatBoss()
    end
end

function BossServer.DefeatBoss()
    if not activeBoss then return end

    local bossConfig = activeBoss.Config
    local totalDamage = 0
    for _, dmg in pairs(bossDamage) do
        totalDamage = totalDamage + dmg
    end

    for _, player in ipairs(Players:GetPlayers()) do
        local playerId = tostring(player.UserId)
        local playerDmg = bossDamage[playerId] or 0
        if playerDmg > 0 then
            local data = dsManager.GetData(player)
            if data then
                local share = playerDmg / math.max(totalDamage, 1)
                local moneyReward = math.floor(bossConfig.MoneyReward * share)
                local strengthReward = math.floor(bossConfig.StrengthReward * share)
                local gemsReward = math.floor(bossConfig.GemsReward * share)

                data.Money = data.Money + math.max(moneyReward, 100)
                data.Strength = data.Strength + math.max(strengthReward, 10)
                data.Gems = (data.Gems or 0) + math.max(gemsReward, 1)
                data.BossKills = (data.BossKills or 0) + 1

                local gotDrop = math.random() < (bossConfig.DropChance or 0.05)
                if gotDrop and bossConfig.SpecialDrop then
                    local brainrotEntry = BrainrotDatabase.FindBrainrot(bossConfig.SpecialDrop)
                    if brainrotEntry then
                        local mutation = nil
                        if math.random() < (bossConfig.MutationChance or 0.30) then
                            local mutIndex = math.random(1, #config.Mutations)
                            mutation = config.Mutations[mutIndex].Name
                        end
                        table.insert(data.Inventory, {
                            Name = brainrotEntry.Name,
                            Rarity = "Boss",
                            Mutation = mutation,
                            Level = 1,
                        })
                    end
                end

                remotes:FindFirstChild("BossReward"):FireClient(player, {
                    Money = moneyReward,
                    Strength = strengthReward,
                    Gems = gemsReward,
                    GotDrop = gotDrop,
                    DropName = gotDrop and bossConfig.SpecialDrop or nil,
                    BossName = bossConfig.DisplayName,
                    Share = share,
                })
            end
        end
    end

    remotes:FindFirstChild("BossDefeated"):FireAllClients({
        Name = bossConfig.Name,
        DisplayName = bossConfig.DisplayName,
    })

    if activeBoss.Model then
        activeBoss.Model:Destroy()
    end

    activeBoss = nil
    bossDamage = {}
    bossHealth = 0
end

function BossServer.GetActiveBoss()
    return activeBoss
end

return BossServer
