--[[
    MainUI.lua (StarterGui)
    Creates the main ScreenGui with all UI components.
    This is a LocalScript that builds the entire UI.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Config"))
local Utils = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utils"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- SCREEN GUI
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

------------------------------------------------------------
-- HELPER FUNCTIONS
------------------------------------------------------------
local function createFrame(props)
    local frame = Instance.new("Frame")
    frame.Size = props.Size or UDim2.new(0, 200, 0, 100)
    frame.Position = props.Position or UDim2.new(0.5, -100, 0.5, -50)
    frame.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    frame.BackgroundColor3 = props.Color or Config.UI.PrimaryColor
    frame.BackgroundTransparency = props.Transparency or 0
    frame.BorderSizePixel = 0
    frame.Name = props.Name or "Frame"
    frame.Visible = props.Visible ~= false
    frame.ClipsDescendants = props.ClipDescendants or false

    if props.Corner then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = props.Corner
        corner.Parent = frame
    end

    if props.Stroke then
        local stroke = Instance.new("UIStroke")
        stroke.Color = props.Stroke
        stroke.Thickness = props.StrokeThickness or 2
        stroke.Parent = frame
    end

    if props.Parent then
        frame.Parent = props.Parent
    end

    return frame
end

local function createLabel(props)
    local label = Instance.new("TextLabel")
    label.Size = props.Size or UDim2.new(1, 0, 1, 0)
    label.Position = props.Position or UDim2.new(0, 0, 0, 0)
    label.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    label.BackgroundTransparency = 1
    label.Text = props.Text or ""
    label.TextColor3 = props.TextColor or Config.UI.TextColor
    label.TextScaled = true
    label.Font = props.Font or Config.UI.FontBody
    label.Name = props.Name or "Label"

    if props.Parent then
        label.Parent = props.Parent
    end

    return label
end

local function createButton(props)
    local button = Instance.new("TextButton")
    button.Size = props.Size or UDim2.new(0, 120, 0, 40)
    button.Position = props.Position or UDim2.new(0, 0, 0, 0)
    button.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
    button.BackgroundColor3 = props.Color or Config.UI.ButtonColor
    button.BorderSizePixel = 0
    button.Text = props.Text or "Button"
    button.TextColor3 = props.TextColor or Config.UI.TextColor
    button.TextScaled = true
    button.Font = props.Font or Config.UI.FontAccent
    button.Name = props.Name or "Button"
    button.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Config.UI.CornerRadius
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Config.UI.AccentColor
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        Utils.TweenObject(button, {BackgroundColor3 = Config.UI.ButtonHoverColor}, 0.15)
        Utils.TweenObject(button, {Size = props.Size * 1.05 or UDim2.new(0, 126, 0, 42)}, 0.15)
    end)
    button.MouseLeave:Connect(function()
        Utils.TweenObject(button, {BackgroundColor3 = props.Color or Config.UI.ButtonColor}, 0.15)
        Utils.TweenObject(button, {Size = props.Size or UDim2.new(0, 120, 0, 40)}, 0.15)
    end)

    if props.Parent then
        button.Parent = props.Parent
    end

    return button
end

------------------------------------------------------------
-- BOTTOM STATS BAR
------------------------------------------------------------
local statsBar = createFrame({
    Name = "StatsBar",
    Size = UDim2.new(1, -20, 0, 50),
    Position = UDim2.new(0.5, 0, 1, -60),
    AnchorPoint = Vector2.new(0.5, 0),
    Color = Color3.fromRGB(20, 20, 35),
    Corner = UDim.new(0, 12),
    Stroke = Config.UI.AccentColor,
    Parent = screenGui,
})

local statsLayout = Instance.new("UIListLayout")
statsLayout.FillDirection = Enum.FillDirection.Horizontal
statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
statsLayout.Padding = UDim.new(0, 15)
statsLayout.Parent = statsBar

local statLabels = {}
local statDefs = {
    { Key = "Money",    Icon = "$",    Color = Color3.fromRGB(255, 215, 0) },
    { Key = "Strength", Icon = "STR",  Color = Color3.fromRGB(255, 100, 100) },
    { Key = "Speed",    Icon = "SPD",  Color = Color3.fromRGB(100, 200, 255) },
    { Key = "Luck",     Icon = "LCK",  Color = Color3.fromRGB(100, 255, 150) },
    { Key = "Rebirths", Icon = "RB",   Color = Color3.fromRGB(200, 100, 255) },
}

for _, stat in ipairs(statDefs) do
    local container = createFrame({
        Name = "Stat_" .. stat.Key,
        Size = UDim2.new(0, 150, 0, 40),
        Color = Color3.fromRGB(30, 30, 50),
        Corner = UDim.new(0, 8),
        Parent = statsBar,
    })

    local icon = createLabel({
        Name = "Icon",
        Size = UDim2.new(0.25, 0, 1, 0),
        Text = stat.Icon,
        TextColor = stat.Color,
        Font = Config.UI.FontTitle,
        Parent = container,
    })

    local value = createLabel({
        Name = "Value",
        Size = UDim2.new(0.75, 0, 1, 0),
        Position = UDim2.new(0.25, 0, 0, 0),
        Text = "0",
        TextColor = Config.UI.TextColor,
        Font = Config.UI.FontAccent,
        Parent = container,
    })

    statLabels[stat.Key] = value
end

_G.UpdateStatsBar = function(stats)
    for key, label in pairs(statLabels) do
        if stats[key] then
            local formatted = Utils.FormatNumber(stats[key])
            if label.Text ~= formatted then
                label.Text = formatted
                Utils.TweenObject(label, {TextColor3 = Color3.fromRGB(255, 255, 100)}, 0.1)
                task.delay(0.2, function()
                    Utils.TweenObject(label, {TextColor3 = Config.UI.TextColor}, 0.3)
                end)
            end
        end
    end
end

------------------------------------------------------------
-- SIDE MENU BUTTONS
------------------------------------------------------------
local menuButtons = createFrame({
    Name = "MenuButtons",
    Size = UDim2.new(0, 60, 0, 300),
    Position = UDim2.new(1, -70, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    Color = Color3.fromRGB(20, 20, 35),
    Corner = UDim.new(0, 12),
    Stroke = Config.UI.AccentColor,
    Parent = screenGui,
})

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Center
menuLayout.Padding = UDim.new(0, 8)
menuLayout.Parent = menuButtons

local menuItems = {
    { Name = "Shop",      Icon = "S",  Panel = "ShopPanel" },
    { Name = "Index",     Icon = "I",  Panel = "IndexPanel" },
    { Name = "Rebirth",   Icon = "R",  Panel = "RebirthPanel" },
    { Name = "Inventory", Icon = "Inv", Panel = "InventoryPanel" },
    { Name = "Settings",  Icon = "G",  Panel = "SettingsPanel" },
}

local panels = {}
local activePanelName = nil

for _, item in ipairs(menuItems) do
    local btn = createButton({
        Name = "Btn_" .. item.Name,
        Size = UDim2.new(0, 50, 0, 50),
        Text = item.Icon,
        Parent = menuButtons,
    })

    btn.MouseButton1Click:Connect(function()
        if activePanelName == item.Panel then
            panels[item.Panel].Visible = false
            activePanelName = nil
        else
            for pName, p in pairs(panels) do
                p.Visible = false
            end
            if panels[item.Panel] then
                panels[item.Panel].Visible = true
                panels[item.Panel].Position = UDim2.new(0.5, 0, 0.5, 0)
                Utils.TweenObject(panels[item.Panel], {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
            end
            activePanelName = item.Panel
        end
    end)
end

------------------------------------------------------------
-- PANEL TEMPLATE
------------------------------------------------------------
local function createPanel(name, title)
    local panel = createFrame({
        Name = name,
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Config.UI.PrimaryColor,
        Corner = UDim.new(0, 16),
        Stroke = Config.UI.AccentColor,
        Parent = screenGui,
        Visible = false,
        ClipDescendants = true,
    })

    local titleBar = createFrame({
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 45),
        Color = Config.UI.SecondaryColor,
        Corner = UDim.new(0, 16),
        Parent = panel,
    })

    createLabel({
        Name = "Title",
        Size = UDim2.new(0.8, 0, 1, 0),
        Position = UDim2.new(0.1, 0, 0, 0),
        Text = title,
        Font = Config.UI.FontTitle,
        TextColor = Config.UI.AccentColor,
        Parent = titleBar,
    })

    local closeBtn = createButton({
        Name = "CloseBtn",
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -40, 0, 5),
        Text = "X",
        Color = Color3.fromRGB(200, 50, 50),
        Parent = titleBar,
    })
    closeBtn.MouseButton1Click:Connect(function()
        panel.Visible = false
        activePanelName = nil
    end)

    local content = createFrame({
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -55),
        Position = UDim2.new(0, 10, 0, 50),
        Color = Color3.fromRGB(25, 25, 40),
        Corner = UDim.new(0, 8),
        Parent = panel,
        ClipDescendants = true,
    })

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollContent"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Config.UI.AccentColor
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scrollFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = scrollFrame

    panels[name] = panel
    return panel, scrollFrame
end

------------------------------------------------------------
-- SHOP PANEL
------------------------------------------------------------
local shopPanel, shopScroll = createPanel("ShopPanel", "LOJA")

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")

local function buildShopUI()
    for _, child in ipairs(shopScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local sectionTitle = createLabel({
        Name = "WeightsTitle",
        Size = UDim2.new(1, 0, 0, 30),
        Text = "PESOS",
        Font = Config.UI.FontTitle,
        TextColor = Config.UI.AccentColor,
        Parent = shopScroll,
    })

    for i, weight in ipairs(Config.Training.Weights) do
        local item = createFrame({
            Name = "Weight_" .. i,
            Size = UDim2.new(1, -10, 0, 50),
            Color = Config.UI.SecondaryColor,
            Corner = UDim.new(0, 8),
            Parent = shopScroll,
        })

        createLabel({
            Name = "Name",
            Size = UDim2.new(0.5, 0, 1, 0),
            Text = " " .. weight.Name,
            Font = Config.UI.FontAccent,
            Parent = item,
        })

        createLabel({
            Name = "Info",
            Size = UDim2.new(0.25, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Text = weight.Multiplier .. "x",
            TextColor = Color3.fromRGB(100, 255, 100),
            Font = Config.UI.FontAccent,
            Parent = item,
        })

        local buyBtn = createButton({
            Name = "Buy",
            Size = UDim2.new(0, 80, 0, 35),
            Position = UDim2.new(1, -85, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Text = "$" .. Utils.FormatNumber(weight.Cost),
            Color = Color3.fromRGB(50, 150, 50),
            Parent = item,
        })

        buyBtn.MouseButton1Click:Connect(function()
            remotesFolder:WaitForChild("BuyWeight"):FireServer(i)
        end)
    end

    createLabel({
        Name = "SpeedTitle",
        Size = UDim2.new(1, 0, 0, 30),
        Text = "VELOCIDADE",
        Font = Config.UI.FontTitle,
        TextColor = Config.UI.AccentColor,
        Parent = shopScroll,
    })

    for i, upgrade in ipairs(Config.ShopItems.SpeedUpgrades) do
        local item = createFrame({
            Name = "Speed_" .. i,
            Size = UDim2.new(1, -10, 0, 50),
            Color = Config.UI.SecondaryColor,
            Corner = UDim.new(0, 8),
            Parent = shopScroll,
        })

        createLabel({
            Name = "Name",
            Size = UDim2.new(0.5, 0, 1, 0),
            Text = " " .. upgrade.Name,
            Font = Config.UI.FontAccent,
            Parent = item,
        })

        local buyBtn = createButton({
            Name = "Buy",
            Size = UDim2.new(0, 80, 0, 35),
            Position = UDim2.new(1, -85, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Text = "$" .. Utils.FormatNumber(upgrade.Cost),
            Color = Color3.fromRGB(50, 100, 200),
            Parent = item,
        })

        buyBtn.MouseButton1Click:Connect(function()
            remotesFolder:WaitForChild("BuySpeedUpgrade"):FireServer(i)
        end)
    end

    createLabel({
        Name = "LuckTitle",
        Size = UDim2.new(1, 0, 0, 30),
        Text = "BOOSTS DE SORTE",
        Font = Config.UI.FontTitle,
        TextColor = Config.UI.AccentColor,
        Parent = shopScroll,
    })

    for i, boost in ipairs(Config.ShopItems.LuckBoosts) do
        local item = createFrame({
            Name = "Luck_" .. i,
            Size = UDim2.new(1, -10, 0, 50),
            Color = Config.UI.SecondaryColor,
            Corner = UDim.new(0, 8),
            Parent = shopScroll,
        })

        createLabel({
            Name = "Name",
            Size = UDim2.new(0.5, 0, 1, 0),
            Text = " " .. boost.Name,
            Font = Config.UI.FontAccent,
            Parent = item,
        })

        createLabel({
            Name = "Duration",
            Size = UDim2.new(0.2, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            Text = Utils.FormatTime(boost.Duration),
            TextColor = Color3.fromRGB(200, 200, 255),
            Font = Config.UI.FontBody,
            Parent = item,
        })

        local buyBtn = createButton({
            Name = "Buy",
            Size = UDim2.new(0, 80, 0, 35),
            Position = UDim2.new(1, -85, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Text = "$" .. Utils.FormatNumber(boost.Cost),
            Color = Color3.fromRGB(150, 100, 200),
            Parent = item,
        })

        buyBtn.MouseButton1Click:Connect(function()
            remotesFolder:WaitForChild("BuyLuckBoost"):FireServer(i)
        end)
    end

    createLabel({
        Name = "GamepassTitle",
        Size = UDim2.new(1, 0, 0, 30),
        Text = "GAMEPASSES",
        Font = Config.UI.FontTitle,
        TextColor = Color3.fromRGB(255, 200, 0),
        Parent = shopScroll,
    })

    for _, gp in ipairs(Config.Gamepasses) do
        local item = createFrame({
            Name = "GP_" .. gp.Name,
            Size = UDim2.new(1, -10, 0, 50),
            Color = Color3.fromRGB(40, 35, 20),
            Corner = UDim.new(0, 8),
            Stroke = Color3.fromRGB(255, 200, 0),
            Parent = shopScroll,
        })

        createLabel({
            Name = "Name",
            Size = UDim2.new(0.6, 0, 1, 0),
            Text = " " .. gp.Name,
            TextColor = Color3.fromRGB(255, 215, 0),
            Font = Config.UI.FontAccent,
            Parent = item,
        })

        createLabel({
            Name = "Price",
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0.6, 0, 0, 0),
            Text = "R$ " .. gp.Price,
            TextColor = Color3.fromRGB(100, 255, 100),
            Font = Config.UI.FontAccent,
            Parent = item,
        })
    end
end

task.spawn(buildShopUI)

------------------------------------------------------------
-- REBIRTH PANEL
------------------------------------------------------------
local rebirthPanel, rebirthScroll = createPanel("RebirthPanel", "REBIRTH")

local function buildRebirthUI()
    local infoFrame = createFrame({
        Name = "RebirthInfo",
        Size = UDim2.new(1, -10, 0, 200),
        Color = Config.UI.SecondaryColor,
        Corner = UDim.new(0, 12),
        Parent = rebirthScroll,
    })

    createLabel({
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        Text = "REBIRTH",
        Font = Config.UI.FontTitle,
        TextColor = Color3.fromRGB(200, 100, 255),
        Parent = infoFrame,
    })

    createLabel({
        Name = "Description",
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 0, 40),
        Text = "Renasca para ganhar multiplicadores permanentes!\nSua forca, velocidade e dinheiro serao resetados.\nSeus Brainrots e base sao mantidos!",
        Font = Config.UI.FontBody,
        TextColor = Color3.fromRGB(200, 200, 220),
        Parent = infoFrame,
    })

    createLabel({
        Name = "Benefits",
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 0, 105),
        Text = "Beneficios: +5% multiplicador, +0.5 sorte por rebirth",
        Font = Config.UI.FontAccent,
        TextColor = Color3.fromRGB(100, 255, 200),
        Parent = infoFrame,
    })

    local rebirthBtn = createButton({
        Name = "RebirthBtn",
        Size = UDim2.new(0.8, 0, 0, 60),
        Text = "FAZER REBIRTH",
        Color = Color3.fromRGB(150, 50, 200),
        Font = Config.UI.FontTitle,
        Parent = rebirthScroll,
    })

    rebirthBtn.MouseButton1Click:Connect(function()
        remotesFolder:WaitForChild("RequestRebirth"):FireServer()
    end)
end

task.spawn(buildRebirthUI)

------------------------------------------------------------
-- INDEX PANEL
------------------------------------------------------------
local indexPanel, indexScroll = createPanel("IndexPanel", "INDEX - COLECAO")

local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))

local function buildIndexUI()
    local totalBrainrots = BrainrotDB.GetTotalCount()

    createLabel({
        Name = "Total",
        Size = UDim2.new(1, 0, 0, 30),
        Text = "Total: 0 / " .. totalBrainrots .. " Brainrots",
        Font = Config.UI.FontTitle,
        TextColor = Config.UI.AccentColor,
        Parent = indexScroll,
    })

    for _, rarity in ipairs(Config.Rarities) do
        local brainrots = BrainrotDB.GetBrainrotsByRarity(rarity.Name)

        local rarityHeader = createFrame({
            Name = "Header_" .. rarity.Name,
            Size = UDim2.new(1, -10, 0, 35),
            Color = rarity.Color,
            Corner = UDim.new(0, 8),
            Parent = indexScroll,
        })

        createLabel({
            Name = "RarityName",
            Size = UDim2.new(0.6, 0, 1, 0),
            Text = "  " .. rarity.DisplayName,
            Font = Config.UI.FontTitle,
            Parent = rarityHeader,
        })

        createLabel({
            Name = "Count",
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0.6, 0, 0, 0),
            Text = "0/" .. #brainrots,
            Font = Config.UI.FontAccent,
            Parent = rarityHeader,
        })

        for _, brainrot in ipairs(brainrots) do
            local entry = createFrame({
                Name = "Entry_" .. brainrot.Name,
                Size = UDim2.new(1, -10, 0, 35),
                Color = Config.UI.SecondaryColor,
                Corner = UDim.new(0, 6),
                Parent = indexScroll,
            })

            createLabel({
                Name = "BrainrotName",
                Size = UDim2.new(0.5, 0, 1, 0),
                Text = "  ???",
                Font = Config.UI.FontBody,
                TextColor = Color3.fromRGB(150, 150, 150),
                Parent = entry,
            })

            createLabel({
                Name = "Value",
                Size = UDim2.new(0.25, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0, 0),
                Text = "$" .. Utils.FormatNumber(brainrot.Value),
                TextColor = Color3.fromRGB(255, 215, 0),
                Font = Config.UI.FontBody,
                Parent = entry,
            })

            createLabel({
                Name = "Effect",
                Size = UDim2.new(0.25, 0, 1, 0),
                Position = UDim2.new(0.75, 0, 0, 0),
                Text = brainrot.Effect,
                TextColor = Color3.fromRGB(150, 200, 255),
                Font = Config.UI.FontBody,
                Parent = entry,
            })
        end
    end
end

task.spawn(buildIndexUI)

------------------------------------------------------------
-- INVENTORY PANEL
------------------------------------------------------------
local invPanel, invScroll = createPanel("InventoryPanel", "INVENTARIO")

remotesFolder:WaitForChild("SyncInventory").OnClientEvent:Connect(function(inventory)
    for _, child in ipairs(invScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    if #inventory == 0 then
        createLabel({
            Name = "Empty",
            Size = UDim2.new(1, 0, 0, 40),
            Text = "Inventario vazio! Chute Lucky Blocks!",
            Font = Config.UI.FontBody,
            TextColor = Color3.fromRGB(150, 150, 150),
            Parent = invScroll,
        })
        return
    end

    for i, item in ipairs(inventory) do
        local entry = createFrame({
            Name = "InvItem_" .. i,
            Size = UDim2.new(1, -10, 0, 50),
            Color = Config.UI.SecondaryColor,
            Corner = UDim.new(0, 8),
            Parent = invScroll,
        })

        local mutColor = Config.UI.TextColor
        if item.Mutation ~= "None" then
            for _, mut in ipairs(Config.Mutations) do
                if mut.Name == item.Mutation then
                    mutColor = mut.Color
                    break
                end
            end
        end

        createLabel({
            Name = "Name",
            Size = UDim2.new(0.4, 0, 1, 0),
            Text = "  " .. item.Name,
            TextColor = mutColor,
            Font = Config.UI.FontAccent,
            Parent = entry,
        })

        createLabel({
            Name = "Rarity",
            Size = UDim2.new(0.2, 0, 1, 0),
            Position = UDim2.new(0.4, 0, 0, 0),
            Text = item.Rarity,
            Font = Config.UI.FontBody,
            Parent = entry,
        })

        if item.Mutation ~= "None" then
            createLabel({
                Name = "Mutation",
                Size = UDim2.new(0.15, 0, 1, 0),
                Position = UDim2.new(0.6, 0, 0, 0),
                Text = item.Mutation,
                TextColor = mutColor,
                Font = Config.UI.FontBody,
                Parent = entry,
            })
        end

        local storeBtn = createButton({
            Name = "Store",
            Size = UDim2.new(0, 70, 0, 30),
            Position = UDim2.new(1, -75, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Text = "Guardar",
            Color = Color3.fromRGB(50, 150, 50),
            Parent = entry,
        })

        storeBtn.MouseButton1Click:Connect(function()
            remotesFolder:WaitForChild("StoreBrainrot"):FireServer(i)
        end)
    end
end)

------------------------------------------------------------
-- SETTINGS PANEL
------------------------------------------------------------
local settingsPanel, settingsScroll = createPanel("SettingsPanel", "CONFIGURACOES")

local function buildSettingsUI()
    createLabel({
        Name = "GameInfo",
        Size = UDim2.new(1, 0, 0, 30),
        Text = Config.GAME_NAME .. " v" .. Config.VERSION,
        Font = Config.UI.FontTitle,
        TextColor = Config.UI.AccentColor,
        Parent = settingsScroll,
    })

    createLabel({
        Name = "Credits",
        Size = UDim2.new(1, 0, 0, 60),
        Text = "Jogo criado com carinho!\n128 Brainrots unicos\n8 Raridades\n4 Mutacoes",
        Font = Config.UI.FontBody,
        TextColor = Color3.fromRGB(180, 180, 200),
        Parent = settingsScroll,
    })
end

task.spawn(buildSettingsUI)

------------------------------------------------------------
-- POWER BAR UI
------------------------------------------------------------
local powerBarContainer = createFrame({
    Name = "PowerBarContainer",
    Size = UDim2.new(0, 300, 0, 40),
    Position = UDim2.new(0.5, 0, 0.8, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Color = Color3.fromRGB(20, 20, 35),
    Corner = UDim.new(0, 8),
    Stroke = Color3.fromRGB(255, 215, 0),
    Parent = screenGui,
    Visible = false,
})

local powerBarBg = createFrame({
    Name = "PowerBarBg",
    Size = UDim2.new(1, -10, 1, -10),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Color = Color3.fromRGB(40, 40, 55),
    Corner = UDim.new(0, 6),
    Parent = powerBarContainer,
})

for _, section in ipairs(Config.PowerBar.Sections) do
    local sectionFrame = createFrame({
        Name = "Section_" .. section.Name,
        Size = UDim2.new(section.Range[2] - section.Range[1], 0, 1, 0),
        Position = UDim2.new(section.Range[1], 0, 0, 0),
        Color = section.Color,
        Transparency = 0.3,
        Parent = powerBarBg,
    })

    createLabel({
        Name = "SectionLabel",
        Size = UDim2.new(1, 0, 1, 0),
        Text = section.Name,
        Font = Config.UI.FontBody,
        TextColor = Config.UI.TextColor,
        Parent = sectionFrame,
    })
end

local powerBarIndicator = createFrame({
    Name = "Indicator",
    Size = UDim2.new(0, 4, 1, 4),
    Position = UDim2.new(0, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Color = Color3.fromRGB(255, 255, 255),
    Corner = UDim.new(0, 2),
    Parent = powerBarBg,
})

local powerBarLabel = createLabel({
    Name = "PowerLabel",
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, -0.8, 0),
    Text = "Clique para parar!",
    Font = Config.UI.FontTitle,
    TextColor = Color3.fromRGB(255, 215, 0),
    Parent = powerBarContainer,
})

_G.ShowPowerBar = function(show)
    powerBarContainer.Visible = show
    if show then
        powerBarContainer.Size = UDim2.new(0, 0, 0, 40)
        Utils.TweenObject(powerBarContainer, {Size = UDim2.new(0, 300, 0, 40)}, 0.3)
    end
end

_G.UpdatePowerBar = function(value)
    powerBarIndicator.Position = UDim2.new(value, 0, 0.5, 0)

    local section = nil
    for _, s in ipairs(Config.PowerBar.Sections) do
        if value >= s.Range[1] and value < s.Range[2] then
            section = s
            break
        end
    end
    if section then
        powerBarIndicator.BackgroundColor3 = section.Color
        powerBarLabel.Text = section.Name .. "!"
        powerBarLabel.TextColor3 = section.Color
    end
end

------------------------------------------------------------
-- NOTIFICATION SYSTEM
------------------------------------------------------------
local notifContainer = createFrame({
    Name = "NotifContainer",
    Size = UDim2.new(0, 350, 0, 200),
    Position = UDim2.new(0.5, 0, 0, 10),
    AnchorPoint = Vector2.new(0.5, 0),
    Transparency = 1,
    Parent = screenGui,
})

local notifLayout = Instance.new("UIListLayout")
notifLayout.FillDirection = Enum.FillDirection.Vertical
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
notifLayout.Padding = UDim.new(0, 5)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Parent = notifContainer

_G.ShowNotification = function(message, notifType)
    local color = Config.UI.AccentColor
    if notifType == "error" then
        color = Config.UI.ErrorColor
    elseif notifType == "success" then
        color = Config.UI.SuccessColor
    elseif notifType == "warning" then
        color = Color3.fromRGB(255, 200, 50)
    end

    local notif = createFrame({
        Name = "Notif",
        Size = UDim2.new(1, 0, 0, 0),
        Color = Config.UI.PrimaryColor,
        Corner = UDim.new(0, 8),
        Stroke = color,
        Parent = notifContainer,
    })

    createLabel({
        Name = "Text",
        Size = UDim2.new(1, -10, 1, -6),
        Position = UDim2.new(0, 5, 0, 3),
        Text = message,
        TextColor = color,
        Font = Config.UI.FontAccent,
        Parent = notif,
    })

    Utils.TweenObject(notif, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)

    task.delay(3, function()
        Utils.TweenObject(notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.4)
        notif:Destroy()
    end)
end

------------------------------------------------------------
-- REWARD POPUP
------------------------------------------------------------
_G.ShowRewardPopup = function(rewardData)
    local popup = createFrame({
        Name = "RewardPopup",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Config.UI.PrimaryColor,
        Corner = UDim.new(0, 16),
        Stroke = Color3.fromRGB(rewardData.SectionColor[1], rewardData.SectionColor[2], rewardData.SectionColor[3]),
        StrokeThickness = 3,
        Parent = screenGui,
    })

    Utils.TweenObject(popup, {Size = UDim2.new(0, 280, 0, 200)}, 0.4, Enum.EasingStyle.Back)

    createLabel({
        Name = "Section",
        Size = UDim2.new(1, 0, 0, 35),
        Text = rewardData.Section .. "!",
        TextColor = Color3.fromRGB(rewardData.SectionColor[1], rewardData.SectionColor[2], rewardData.SectionColor[3]),
        Font = Config.UI.FontTitle,
        Parent = popup,
    })

    local rewardText = ""
    if rewardData.Money > 0 then rewardText = rewardText .. "+$" .. Utils.FormatNumber(rewardData.Money) .. "\n" end
    if rewardData.Strength > 0 then rewardText = rewardText .. "+" .. rewardData.Strength .. " Forca\n" end
    if rewardData.Speed > 0 then rewardText = rewardText .. "+" .. string.format("%.1f", rewardData.Speed) .. " Velocidade\n" end
    if rewardData.Luck > 0 then rewardText = rewardText .. "+" .. string.format("%.2f", rewardData.Luck) .. " Sorte\n" end

    createLabel({
        Name = "Rewards",
        Size = UDim2.new(1, -20, 0, 100),
        Position = UDim2.new(0, 10, 0, 40),
        Text = rewardText,
        Font = Config.UI.FontAccent,
        TextColor = Color3.fromRGB(255, 255, 200),
        Parent = popup,
    })

    if rewardData.Brainrot then
        createLabel({
            Name = "Brainrot",
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 145),
            Text = "BRAINROT: " .. rewardData.Brainrot.Name .. "!",
            Font = Config.UI.FontTitle,
            TextColor = Color3.fromRGB(255, 100, 255),
            Parent = popup,
        })
    end

    task.delay(2.5, function()
        Utils.TweenObject(popup, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
        }, 0.3)
        task.wait(0.4)
        popup:Destroy()
    end)
end

------------------------------------------------------------
-- BRAINROT OBTAINED POPUP
------------------------------------------------------------
_G.ShowBrainrotObtained = function(brainrotData)
    local popup = createFrame({
        Name = "BrainrotPopup",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.3, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Color3.fromRGB(40, 20, 50),
        Corner = UDim.new(0, 20),
        Stroke = Color3.fromRGB(255, 100, 255),
        StrokeThickness = 3,
        Parent = screenGui,
    })

    Utils.TweenObject(popup, {Size = UDim2.new(0, 320, 0, 180)}, 0.5, Enum.EasingStyle.Back)

    createLabel({
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 35),
        Text = "NOVO BRAINROT!",
        TextColor = Color3.fromRGB(255, 200, 0),
        Font = Config.UI.FontTitle,
        Parent = popup,
    })

    local mutText = ""
    if brainrotData.Mutation ~= "None" then
        mutText = " [" .. brainrotData.Mutation .. "]"
    end

    createLabel({
        Name = "Name",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 40),
        Text = brainrotData.Name .. mutText,
        TextColor = Color3.fromRGB(255, 100, 255),
        Font = Config.UI.FontTitle,
        Parent = popup,
    })

    createLabel({
        Name = "Info",
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 0, 85),
        Text = "Raridade: " .. brainrotData.Rarity .. "\nValor: $" .. Utils.FormatNumber(brainrotData.Value),
        Font = Config.UI.FontAccent,
        TextColor = Color3.fromRGB(200, 200, 255),
        Parent = popup,
    })

    task.delay(4, function()
        Utils.TweenObject(popup, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
        }, 0.4)
        task.wait(0.5)
        popup:Destroy()
    end)
end

------------------------------------------------------------
-- ZONE CHANGE BANNER
------------------------------------------------------------
_G.ShowZoneChange = function(rarity)
    local banner = createFrame({
        Name = "ZoneBanner",
        Size = UDim2.new(0.6, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.15, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Config.UI.PrimaryColor,
        Corner = UDim.new(0, 16),
        Stroke = rarity.Color,
        StrokeThickness = 3,
        Parent = screenGui,
    })

    Utils.TweenObject(banner, {Size = UDim2.new(0.6, 0, 0, 70)}, 0.4, Enum.EasingStyle.Back)

    createLabel({
        Name = "ZoneName",
        Size = UDim2.new(1, 0, 0.6, 0),
        Text = "ZONA: " .. rarity.DisplayName,
        TextColor = rarity.Color,
        Font = Config.UI.FontTitle,
        Parent = banner,
    })

    createLabel({
        Name = "Req",
        Size = UDim2.new(1, 0, 0.4, 0),
        Position = UDim2.new(0, 0, 0.6, 0),
        Text = "Forca requerida: " .. rarity.RequiredStrength .. " | " .. rarity.MoneyMultiplier .. "x Money",
        TextColor = Color3.fromRGB(200, 200, 220),
        Font = Config.UI.FontBody,
        Parent = banner,
    })

    task.delay(3, function()
        Utils.TweenObject(banner, {
            Size = UDim2.new(0.6, 0, 0, 0),
            BackgroundTransparency = 1,
        }, 0.3)
        task.wait(0.4)
        banner:Destroy()
    end)
end

------------------------------------------------------------
-- REBIRTH EFFECT
------------------------------------------------------------
_G.ShowRebirthEffect = function(rebirthData)
    local overlay = createFrame({
        Name = "RebirthOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        Color = Color3.fromRGB(200, 100, 255),
        Transparency = 1,
        Parent = screenGui,
    })

    Utils.TweenObject(overlay, {BackgroundTransparency = 0.3}, 0.3)

    local infoFrame = createFrame({
        Name = "RebirthInfoFrame",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Config.UI.PrimaryColor,
        Corner = UDim.new(0, 20),
        Stroke = Color3.fromRGB(200, 100, 255),
        StrokeThickness = 4,
        Parent = overlay,
    })

    Utils.TweenObject(infoFrame, {Size = UDim2.new(0, 400, 0, 250)}, 0.5, Enum.EasingStyle.Back)

    createLabel({
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 50),
        Text = "REBIRTH #" .. rebirthData.Rebirths .. "!",
        TextColor = Color3.fromRGB(255, 200, 0),
        Font = Config.UI.FontTitle,
        Parent = infoFrame,
    })

    createLabel({
        Name = "Multiplier",
        Size = UDim2.new(1, -20, 0, 80),
        Position = UDim2.new(0, 10, 0, 55),
        Text = "Multiplicador: " .. string.format("%.1fx", rebirthData.Multiplier) ..
            "\nBonus Sorte: +" .. string.format("%.1f", rebirthData.LuckBonus) ..
            "\nProximo Rebirth: " .. Utils.FormatNumber(rebirthData.NextRequirement) .. " Forca",
        TextColor = Config.UI.TextColor,
        Font = Config.UI.FontAccent,
        Parent = infoFrame,
    })

    task.delay(4, function()
        Utils.TweenObject(overlay, {BackgroundTransparency = 1}, 0.5)
        Utils.TweenObject(infoFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.6)
        overlay:Destroy()
    end)
end

------------------------------------------------------------
-- BASE UPGRADE UI
------------------------------------------------------------
local baseUpgradeOpen = false

_G.ToggleBaseUpgradeUI = function()
    if baseUpgradeOpen then
        if panels["BaseUpgradePanel"] then
            panels["BaseUpgradePanel"].Visible = false
        end
        baseUpgradeOpen = false
        return
    end

    baseUpgradeOpen = true

    if not panels["BaseUpgradePanel"] then
        local basePanel, baseScroll = createPanel("BaseUpgradePanel", "UPGRADES DA BASE")

        createLabel({
            Name = "ExpandTitle",
            Size = UDim2.new(1, 0, 0, 25),
            Text = "EXPANDIR SLOTS",
            Font = Config.UI.FontTitle,
            TextColor = Config.UI.AccentColor,
            Parent = baseScroll,
        })

        local expandBtn = createButton({
            Name = "ExpandBtn",
            Size = UDim2.new(0.8, 0, 0, 45),
            Text = "Expandir +4 Slots",
            Color = Color3.fromRGB(50, 150, 50),
            Font = Config.UI.FontAccent,
            Parent = baseScroll,
        })

        expandBtn.MouseButton1Click:Connect(function()
            remotesFolder:WaitForChild("ExpandBaseSlots"):FireServer()
        end)

        createLabel({
            Name = "UpgradesTitle",
            Size = UDim2.new(1, 0, 0, 25),
            Text = "DECORACOES",
            Font = Config.UI.FontTitle,
            TextColor = Config.UI.AccentColor,
            Parent = baseScroll,
        })

        for i, upgrade in ipairs(Config.Base.Upgrades) do
            local item = createFrame({
                Name = "Upgrade_" .. i,
                Size = UDim2.new(1, -10, 0, 55),
                Color = Config.UI.SecondaryColor,
                Corner = UDim.new(0, 8),
                Parent = baseScroll,
            })

            createLabel({
                Name = "Name",
                Size = UDim2.new(0.4, 0, 0.5, 0),
                Text = "  " .. upgrade.Name,
                Font = Config.UI.FontAccent,
                Parent = item,
            })

            createLabel({
                Name = "Desc",
                Size = UDim2.new(0.4, 0, 0.5, 0),
                Position = UDim2.new(0, 0, 0.5, 0),
                Text = "  " .. upgrade.Description,
                TextColor = Color3.fromRGB(180, 180, 200),
                Font = Config.UI.FontBody,
                Parent = item,
            })

            local buyBtn = createButton({
                Name = "Buy",
                Size = UDim2.new(0, 90, 0, 35),
                Position = UDim2.new(1, -95, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Text = "$" .. Utils.FormatNumber(upgrade.Cost),
                Color = Color3.fromRGB(50, 100, 200),
                Parent = item,
            })

            buyBtn.MouseButton1Click:Connect(function()
                remotesFolder:WaitForChild("UpgradeBase"):FireServer(i)
            end)
        end
    end

    panels["BaseUpgradePanel"].Visible = true
end

print("[Client] MainUI initialized")
