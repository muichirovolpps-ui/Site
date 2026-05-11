--[[
    SellerNPCServer.lua  v2.0
    Brainrot seller NPC: sells random brainrots at discounted prices.
    Refreshes deals periodically. Animated NPC with voice lines.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SellerNPCServer = {}

local Config
local DataStoreManager
local remotesFolder

local currentDeals = {}
local lastRefresh = 0

function SellerNPCServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local buyFromSellerRemote = remotesFolder:FindFirstChild("BuyFromSeller")
    if not buyFromSellerRemote then
        buyFromSellerRemote = Instance.new("RemoteEvent")
        buyFromSellerRemote.Name = "BuyFromSeller"
        buyFromSellerRemote.Parent = remotesFolder
    end

    local getSellerDealsFunc = remotesFolder:FindFirstChild("GetSellerDeals")
    if not getSellerDealsFunc then
        getSellerDealsFunc = Instance.new("RemoteFunction")
        getSellerDealsFunc.Name = "GetSellerDeals"
        getSellerDealsFunc.Parent = remotesFolder
    end

    local sellerVoiceLine = remotesFolder:FindFirstChild("SellerVoiceLine")
    if not sellerVoiceLine then
        sellerVoiceLine = Instance.new("RemoteEvent")
        sellerVoiceLine.Name = "SellerVoiceLine"
        sellerVoiceLine.Parent = remotesFolder
    end

    SellerNPCServer.RefreshDeals()

    buyFromSellerRemote.OnServerEvent:Connect(function(player, dealIndex)
        SellerNPCServer.PurchaseDeal(player, dealIndex)
    end)

    getSellerDealsFunc.OnServerInvoke = function(player)
        if os.time() - lastRefresh >= Config.SellerNPC.RefreshInterval then
            SellerNPCServer.RefreshDeals()
        end
        return currentDeals, Config.SellerNPC.RefreshInterval - (os.time() - lastRefresh)
    end

    task.spawn(function()
        while true do
            task.wait(Config.SellerNPC.RefreshInterval)
            SellerNPCServer.RefreshDeals()
        end
    end)
end

function SellerNPCServer.RefreshDeals()
    currentDeals = {}
    lastRefresh = os.time()

    local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))
    local rarityNames = {"Basico", "Comum", "Raro", "Mitico", "Divino", "Classico", "OG", "Hacker"}

    for i = 1, Config.SellerNPC.MaxDeals do
        local rarityIdx = math.random(1, math.min(5, #rarityNames))
        local rarityName = rarityNames[rarityIdx]
        local brainrots = BrainrotDB.GetBrainrotsByRarity(rarityName)

        if #brainrots > 0 then
            local chosen = brainrots[math.random(1, #brainrots)]
            local discountMin = Config.SellerNPC.DiscountRange[1]
            local discountMax = Config.SellerNPC.DiscountRange[2]
            local discount = discountMin + math.random() * (discountMax - discountMin)
            local basePrice = chosen.Value * 10
            local finalPrice = math.floor(basePrice * discount)

            table.insert(currentDeals, {
                BrainrotName = chosen.Name,
                DisplayName = chosen.DisplayName,
                Rarity = rarityName,
                OriginalPrice = basePrice,
                Price = finalPrice,
                Discount = math.floor((1 - discount) * 100),
                VoiceLine = Config.SellerNPC.VoiceLines[math.random(1, #Config.SellerNPC.VoiceLines)],
                Sold = false,
            })
        end
    end
end

function SellerNPCServer.PurchaseDeal(player, dealIndex)
    dealIndex = tonumber(dealIndex)
    if not dealIndex or dealIndex < 1 or dealIndex > #currentDeals then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Oferta invalida!")
        end
        return
    end

    local deal = currentDeals[dealIndex]
    if deal.Sold then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Oferta ja foi comprada!")
        end
        return
    end

    local data = DataStoreManager:GetData(player)
    if not data then return end

    if (data.Money or 0) < deal.Price then
        local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
        if notifyRemote then
            notifyRemote:FireClient(player, "error", "Dinheiro insuficiente! Precisa: $" .. deal.Price)
        end
        return
    end

    data.Money = data.Money - deal.Price
    deal.Sold = true

    table.insert(data.Inventory, {
        Name = deal.BrainrotName,
        Rarity = deal.Rarity,
        Mutation = "None",
        Level = 1,
    })

    if not data.DiscoveredBrainrots then data.DiscoveredBrainrots = {} end
    local key = deal.Rarity .. "_" .. deal.BrainrotName
    if not data.DiscoveredBrainrots[key] then
        data.DiscoveredBrainrots[key] = true
    end

    local brainrotRemote = remotesFolder:FindFirstChild("BrainrotObtained")
    if brainrotRemote then
        brainrotRemote:FireClient(player, deal.DisplayName, deal.Rarity, "None")
    end

    local notifyRemote = remotesFolder:FindFirstChild("ShowNotification")
    if notifyRemote then
        notifyRemote:FireClient(player, "success", "Comprou " .. deal.DisplayName .. " por $" .. deal.Price .. "!")
    end

    local voiceRemote = remotesFolder:FindFirstChild("SellerVoiceLine")
    if voiceRemote then
        voiceRemote:FireClient(player, deal.VoiceLine)
    end
end

return SellerNPCServer
