--[[
    GamepassServer.lua  v3.0
    Manages all 23 gamepasses + developer products + server boosts.
    Purchase prompts, ownership checks, effect application, multiplier calculation.
]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GamepassServer = {}

local config = nil
local remotes = nil
local dsManager = nil

local playerGamepasses = {}
local activeServerBoosts = {}

function GamepassServer.Initialize(cfg, ds, remotesFolder)
    config = cfg
    dsManager = ds
    remotes = remotesFolder

    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, purchased)
        if purchased then
            GamepassServer.OnGamepassPurchased(player, gamepassId)
        end
    end)

    MarketplaceService.ProcessReceipt = function(receiptInfo)
        return GamepassServer.ProcessReceipt(receiptInfo)
    end

    local buyGamepass = remotes:FindFirstChild("BuyGamepass")
    if buyGamepass then
        buyGamepass.OnServerEvent:Connect(function(player, gamepassId)
            MarketplaceService:PromptGamePassPurchase(player, gamepassId)
        end)
    end

    local buyProduct = remotes:FindFirstChild("BuyProduct")
    if buyProduct then
        buyProduct.OnServerEvent:Connect(function(player, productId)
            MarketplaceService:PromptProductPurchase(player, productId)
        end)
    end

    local activateBoost = remotes:FindFirstChild("ActivateServerBoost")
    if activateBoost then
        activateBoost.OnServerEvent:Connect(function(player, boostIndex)
            GamepassServer.ActivateServerBoost(player, boostIndex)
        end)
    end

    local getGamepasses = remotes:FindFirstChild("GetGamepassData")
    if getGamepasses and getGamepasses:IsA("RemoteFunction") then
        getGamepasses.OnServerInvoke = function(player)
            return GamepassServer.GetGamepassInfo(player)
        end
    end

    task.spawn(function()
        while true do
            task.wait(1)
            GamepassServer.UpdateBoosts()
        end
    end)

    print("[GamepassServer] Initialized — " .. #config.Gamepasses .. " gamepasses, "
        .. #config.DeveloperProducts .. " products")
end

function GamepassServer.SetupPlayer(player)
    local data = dsManager.GetData(player)
    if not data then return end

    if not data.Gamepasses then data.Gamepasses = {} end
    playerGamepasses[player.UserId] = {}

    for _, gp in ipairs(config.Gamepasses) do
        local owned = false
        local ok, hasPass = pcall(function()
            return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gp.Id)
        end)

        if ok and hasPass then
            owned = true
        end

        for _, savedGp in ipairs(data.Gamepasses) do
            if savedGp == gp.Name then
                owned = true
                break
            end
        end

        if owned then
            playerGamepasses[player.UserId][gp.Name] = true
            GamepassServer.ApplyGamepassEffect(player, gp)
        end
    end
end

function GamepassServer.OnGamepassPurchased(player, gamepassId)
    local data = dsManager.GetData(player)
    if not data then return end

    for _, gp in ipairs(config.Gamepasses) do
        if gp.Id == gamepassId then
            if not data.Gamepasses then data.Gamepasses = {} end

            local alreadyOwned = false
            for _, saved in ipairs(data.Gamepasses) do
                if saved == gp.Name then alreadyOwned = true break end
            end
            if not alreadyOwned then
                table.insert(data.Gamepasses, gp.Name)
            end

            playerGamepasses[player.UserId] = playerGamepasses[player.UserId] or {}
            playerGamepasses[player.UserId][gp.Name] = true

            GamepassServer.ApplyGamepassEffect(player, gp)

            remotes:FindFirstChild("GamepassPurchased"):FireClient(player, {
                Name = gp.Name,
                Description = gp.Description,
                Type = gp.Type,
            })

            remotes:FindFirstChild("ShowNotification"):FireClient(player,
                gp.Name .. " comprado!", "legendary")

            break
        end
    end
end

function GamepassServer.ApplyGamepassEffect(player, gp)
    local data = dsManager.GetData(player)
    if not data then return end

    if gp.Type == "StarterPack" then
        data.Money = data.Money + 10000
        data.Strength = data.Strength + 500
    elseif gp.Type == "UltraPack" then
        data.Money = data.Money + 100000
        data.Strength = data.Strength + 5000
        data.Gems = (data.Gems or 0) + 50
    elseif gp.Type == "CosmicPack" then
        data.Money = data.Money + 1000000
        data.Strength = data.Strength + 50000
        data.Gems = (data.Gems or 0) + 200
    end

    if gp.Type == "Cosmetic" then
        remotes:FindFirstChild("ApplyCosmeticEffect"):FireClient(player, {
            Effect = gp.Effect,
            Name = gp.Name,
        })
    end
end

function GamepassServer.ProcessReceipt(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

    local data = dsManager.GetData(player)
    if not data then return Enum.ProductPurchaseDecision.NotProcessedYet end

    for _, product in ipairs(config.DeveloperProducts) do
        if product.Id == receiptInfo.ProductId then
            if product.Gems then
                data.Gems = (data.Gems or 0) + product.Gems
            end
            if product.Money then
                data.Money = data.Money + product.Money
            end
            if product.Spins then
                data.FreeSpins = (data.FreeSpins or 0) + product.Spins
            end

            remotes:FindFirstChild("ShowNotification"):FireClient(player,
                product.Name .. " recebido!", "success")

            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
    end

    for _, boost in ipairs(config.ServerBoosts) do
        if boost.Id == receiptInfo.ProductId then
            GamepassServer.ApplyServerBoost(boost)
            remotes:FindFirstChild("ShowNotification"):FireClient(player,
                boost.Name .. " ativado para TODOS!", "legendary")
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end

function GamepassServer.ApplyServerBoost(boostConfig)
    table.insert(activeServerBoosts, {
        Name = boostConfig.Name,
        Type = boostConfig.Type,
        Multiplier = boostConfig.Multiplier,
        ExpiresAt = os.time() + boostConfig.Duration,
    })

    remotes:FindFirstChild("ServerBoostUpdate"):FireAllClients({
        Name = boostConfig.Name,
        Multiplier = boostConfig.Multiplier,
        Duration = boostConfig.Duration,
    })
end

function GamepassServer.ActivateServerBoost(player, boostIndex)
    local boost = config.ServerBoosts[boostIndex]
    if not boost then return end
    MarketplaceService:PromptProductPurchase(player, boost.Id)
end

function GamepassServer.UpdateBoosts()
    local now = os.time()
    for i = #activeServerBoosts, 1, -1 do
        if activeServerBoosts[i].ExpiresAt <= now then
            table.remove(activeServerBoosts, i)
        end
    end
end

function GamepassServer.GetMoneyMultiplier(player)
    local mult = 1
    local gps = playerGamepasses[player.UserId] or {}

    for _, gp in ipairs(config.Gamepasses) do
        if gps[gp.Name] then
            if gp.Type == "Money" then mult = mult * (gp.Multiplier or 1) end
            if gp.Type == "VIP" then mult = mult * config.VIPPerks.MoneyMultiplier end
            if gp.Type == "SuperVIP" then mult = mult * config.SuperVIPPerks.MoneyMultiplier end
        end
    end

    return mult
end

function GamepassServer.GetStrengthMultiplier(player)
    local mult = 1
    local gps = playerGamepasses[player.UserId] or {}

    for _, gp in ipairs(config.Gamepasses) do
        if gps[gp.Name] then
            if gp.Type == "Strength" then mult = mult * (gp.Multiplier or 1) end
            if gp.Type == "VIP" then mult = mult * config.VIPPerks.StrengthMultiplier end
            if gp.Type == "SuperVIP" then mult = mult * config.SuperVIPPerks.StrengthMultiplier end
        end
    end

    return mult
end

function GamepassServer.GetLuckMultiplier(player)
    local mult = 1
    local gps = playerGamepasses[player.UserId] or {}

    for _, gp in ipairs(config.Gamepasses) do
        if gps[gp.Name] then
            if gp.Type == "Luck" then mult = mult * (gp.Multiplier or 1) end
            if gp.Type == "VIP" then mult = mult * config.VIPPerks.LuckMultiplier end
            if gp.Type == "SuperVIP" then mult = mult * config.SuperVIPPerks.LuckMultiplier end
        end
    end

    for _, boost in ipairs(activeServerBoosts) do
        if boost.Type == "Luck" then
            mult = mult * boost.Multiplier
        end
    end

    return mult
end

function GamepassServer.HasGamepass(player, gamepassName)
    local gps = playerGamepasses[player.UserId] or {}
    return gps[gamepassName] == true
end

function GamepassServer.HasAutoTrain(player)
    return GamepassServer.HasGamepass(player, "Auto Train")
end

function GamepassServer.HasAutoKick(player)
    return GamepassServer.HasGamepass(player, "Auto Kick")
end

function GamepassServer.GetGamepassInfo(player)
    local gps = playerGamepasses[player.UserId] or {}
    local result = {}
    for _, gp in ipairs(config.Gamepasses) do
        table.insert(result, {
            Id = gp.Id,
            Name = gp.Name,
            Price = gp.Price,
            Type = gp.Type,
            Description = gp.Description,
            Owned = gps[gp.Name] or false,
        })
    end
    return result
end

function GamepassServer.GetActiveBoosts()
    return activeServerBoosts
end

return GamepassServer
