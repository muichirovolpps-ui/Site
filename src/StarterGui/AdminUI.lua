--[[
    AdminUI.lua  v2.0
    Client-side admin panel with command console (F3 key).
    Animated UI with permission validation.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")

local AdminUI = {}
local isAdmin = false
local panelOpen = false
local logMessages = {}

local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Admin button (top-right)
    local adminBtn = Instance.new("TextButton")
    adminBtn.Name = "AdminButton"
    adminBtn.Size = UDim2.new(0, 120, 0, 40)
    adminBtn.Position = UDim2.new(1, -130, 0, 10)
    adminBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    adminBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    adminBtn.Text = "ADMIN"
    adminBtn.Font = Enum.Font.GothamBold
    adminBtn.TextSize = 16
    adminBtn.Visible = false
    adminBtn.Parent = screenGui

    local adminBtnCorner = Instance.new("UICorner")
    adminBtnCorner.CornerRadius = UDim.new(0, 8)
    adminBtnCorner.Parent = adminBtn

    local adminBtnStroke = Instance.new("UIStroke")
    adminBtnStroke.Color = Color3.fromRGB(255, 100, 100)
    adminBtnStroke.Thickness = 2
    adminBtnStroke.Parent = adminBtn

    -- Admin panel
    local panel = Instance.new("Frame")
    panel.Name = "AdminPanel"
    panel.Size = UDim2.new(0, 500, 0, 400)
    panel.Position = UDim2.new(0.5, -250, 0.5, -200)
    panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    panel.BackgroundTransparency = 0.05
    panel.Visible = false
    panel.Parent = screenGui

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = panel

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(200, 50, 50)
    panelStroke.Thickness = 2
    panelStroke.Parent = panel

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    titleBar.Parent = panel

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 12)
    titleBarCorner.Parent = titleBar

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Text = "ADMIN CONSOLE"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0, 2)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = titleBar

    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn

    -- Log area
    local logFrame = Instance.new("ScrollingFrame")
    logFrame.Name = "LogFrame"
    logFrame.Size = UDim2.new(1, -20, 1, -120)
    logFrame.Position = UDim2.new(0, 10, 0, 50)
    logFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    logFrame.BorderSizePixel = 0
    logFrame.ScrollBarThickness = 6
    logFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 50, 50)
    logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    logFrame.Parent = panel

    local logCorner = Instance.new("UICorner")
    logCorner.CornerRadius = UDim.new(0, 8)
    logCorner.Parent = logFrame

    local logLayout = Instance.new("UIListLayout")
    logLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logLayout.Padding = UDim.new(0, 2)
    logLayout.Parent = logFrame

    -- Command input
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.Size = UDim2.new(1, -20, 0, 40)
    inputFrame.Position = UDim2.new(0, 10, 1, -55)
    inputFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    inputFrame.Parent = panel

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputFrame

    local prefix = Instance.new("TextLabel")
    prefix.Size = UDim2.new(0, 25, 1, 0)
    prefix.Position = UDim2.new(0, 5, 0, 0)
    prefix.BackgroundTransparency = 1
    prefix.TextColor3 = Color3.fromRGB(200, 50, 50)
    prefix.Text = ">"
    prefix.Font = Enum.Font.Code
    prefix.TextSize = 18
    prefix.Parent = inputFrame

    local inputBox = Instance.new("TextBox")
    inputBox.Name = "CommandInput"
    inputBox.Size = UDim2.new(1, -40, 1, 0)
    inputBox.Position = UDim2.new(0, 30, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.TextColor3 = Color3.fromRGB(0, 255, 0)
    inputBox.PlaceholderText = "Digite um comando (ex: givemoney Player 1000)"
    inputBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
    inputBox.Font = Enum.Font.Code
    inputBox.TextSize = 14
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputFrame

    -- Help text
    local helpText = Instance.new("TextLabel")
    helpText.Size = UDim2.new(1, -20, 0, 20)
    helpText.Position = UDim2.new(0, 10, 1, -20)
    helpText.BackgroundTransparency = 1
    helpText.TextColor3 = Color3.fromRGB(100, 100, 100)
    helpText.Text = "Comandos: givemoney, givestrength, giverebirths, teleport, kick, ban, spawnmeteor, startevent, spawnbrainrot, givemutation, resetplayer, spawnboss"
    helpText.Font = Enum.Font.Gotham
    helpText.TextSize = 10
    helpText.TextXAlignment = Enum.TextXAlignment.Left
    helpText.TextTruncate = Enum.TextTruncate.AtEnd
    helpText.Parent = panel

    -- Quick command buttons
    local quickFrame = Instance.new("Frame")
    quickFrame.Name = "QuickButtons"
    quickFrame.Size = UDim2.new(1, -20, 0, 35)
    quickFrame.Position = UDim2.new(0, 10, 0, 45)
    quickFrame.BackgroundTransparency = 1
    quickFrame.Visible = false
    quickFrame.Parent = panel

    return {
        ScreenGui = screenGui,
        AdminButton = adminBtn,
        Panel = panel,
        CloseButton = closeBtn,
        LogFrame = logFrame,
        LogLayout = logLayout,
        InputBox = inputBox,
    }
end

local function addLogMessage(ui, message, color)
    color = color or Color3.fromRGB(200, 200, 200)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 18)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.Text = " " .. message
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.LayoutOrder = #logMessages + 1
    label.Parent = ui.LogFrame

    table.insert(logMessages, label)
    ui.LogFrame.CanvasSize = UDim2.new(0, 0, 0, ui.LogLayout.AbsoluteContentSize.Y + 10)
    ui.LogFrame.CanvasPosition = Vector2.new(0, ui.LogFrame.CanvasSize.Y.Offset)
end

local function parseCommand(input)
    local parts = {}
    for word in string.gmatch(input, "%S+") do
        table.insert(parts, word)
    end
    if #parts == 0 then return nil, {} end

    local cmd = string.lower(parts[1])
    local args = {}

    if cmd == "givemoney" or cmd == "givestrength" or cmd == "giverebirths" then
        args.Target = parts[2] or ""
        args.Amount = parts[3] or "0"
    elseif cmd == "teleport" then
        args.Target = parts[2] or ""
    elseif cmd == "kick" then
        args.Target = parts[2] or ""
        args.Reason = table.concat(parts, " ", 3) or "Removido pelo admin."
    elseif cmd == "ban" then
        args.Target = parts[2] or ""
        args.Reason = table.concat(parts, " ", 3) or "Banido pelo admin."
    elseif cmd == "spawnbrainrot" then
        args.Target = parts[2] or ""
        args.Rarity = parts[3] or "Basico"
        args.Mutation = parts[4] or "None"
    elseif cmd == "givemutation" then
        args.Target = parts[2] or ""
        args.Index = parts[3] or "1"
        args.Mutation = parts[4] or "Gold"
    elseif cmd == "resetplayer" then
        args.Target = parts[2] or ""
    end

    return cmd, args
end

local function togglePanel(ui)
    panelOpen = not panelOpen
    if panelOpen then
        ui.Panel.Visible = true
        ui.Panel.Size = UDim2.new(0, 0, 0, 0)
        ui.Panel.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(ui.Panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 400),
            Position = UDim2.new(0.5, -250, 0.5, -200),
        }):Play()
    else
        local tween = TweenService:Create(ui.Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        tween:Play()
        tween.Completed:Connect(function()
            ui.Panel.Visible = false
        end)
    end
end

function AdminUI.Initialize()
    local isAdminFunc = remotesFolder:WaitForChild("IsAdmin", 5)
    if isAdminFunc then
        local success, result = pcall(function()
            return isAdminFunc:InvokeServer()
        end)
        isAdmin = success and result
    end

    if not isAdmin then return end

    local ui = createUI()
    ui.AdminButton.Visible = true

    addLogMessage(ui, "[SISTEMA] Admin panel iniciado. Bem-vindo, " .. player.Name, Color3.fromRGB(0, 255, 0))
    addLogMessage(ui, "[SISTEMA] Use F3 ou clique no botao ADMIN para abrir/fechar.", Color3.fromRGB(255, 200, 50))

    ui.AdminButton.MouseButton1Click:Connect(function()
        togglePanel(ui)
    end)

    ui.CloseButton.MouseButton1Click:Connect(function()
        if panelOpen then togglePanel(ui) end
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F3 then
            togglePanel(ui)
        end
    end)

    ui.InputBox.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end
        local text = ui.InputBox.Text
        if text == "" then return end

        addLogMessage(ui, "> " .. text, Color3.fromRGB(0, 200, 255))
        ui.InputBox.Text = ""

        if text == "help" then
            addLogMessage(ui, "Comandos disponiveis:", Color3.fromRGB(255, 200, 50))
            addLogMessage(ui, "  givemoney <player> <amount>", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  givestrength <player> <amount>", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  giverebirths <player> <amount>", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  teleport <player>", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  kick <player> [motivo]", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  ban <player> [motivo]", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  spawnmeteor", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  startevent", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  spawnbrainrot <player> <rarity> [mutation]", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  givemutation <player> <index> <mutation>", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  resetplayer <player>", Color3.fromRGB(200, 200, 200))
            addLogMessage(ui, "  spawnboss", Color3.fromRGB(200, 200, 200))
            return
        end

        if text == "clear" then
            for _, msg in ipairs(logMessages) do msg:Destroy() end
            logMessages = {}
            ui.LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            return
        end

        local cmd, args = parseCommand(text)
        if cmd then
            local adminRemote = remotesFolder:FindFirstChild("AdminCommand")
            if adminRemote then
                adminRemote:FireServer(cmd, args)
            end
        else
            addLogMessage(ui, "[ERRO] Comando invalido.", Color3.fromRGB(255, 60, 60))
        end
    end)

    local adminResponse = remotesFolder:WaitForChild("AdminResponse", 5)
    if adminResponse then
        adminResponse.OnClientEvent:Connect(function(success, message)
            local color = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 60, 60)
            local prefix = success and "[OK] " or "[ERRO] "
            addLogMessage(ui, prefix .. message, color)
        end)
    end
end

return AdminUI
