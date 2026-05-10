--[[
    AdminServer.lua  v2.0
    Complete admin panel system with commands, permissions, and secure validation.
    Admins defined in Config.AdminUserIds.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AdminServer = {}

local Config
local DataStoreManager
local remotesFolder

local bannedPlayers = {}
local adminLogs = {}

function AdminServer.Initialize(config, dsManager, remotes)
    Config = config
    DataStoreManager = dsManager
    remotesFolder = remotes

    local adminRemote = remotesFolder:FindFirstChild("AdminCommand")
    if not adminRemote then
        adminRemote = Instance.new("RemoteEvent")
        adminRemote.Name = "AdminCommand"
        adminRemote.Parent = remotesFolder
    end

    local adminResponseRemote = remotesFolder:FindFirstChild("AdminResponse")
    if not adminResponseRemote then
        adminResponseRemote = Instance.new("RemoteEvent")
        adminResponseRemote.Name = "AdminResponse"
        adminResponseRemote.Parent = remotesFolder
    end

    local isAdminFunc = remotesFolder:FindFirstChild("IsAdmin")
    if not isAdminFunc then
        isAdminFunc = Instance.new("RemoteFunction")
        isAdminFunc.Name = "IsAdmin"
        isAdminFunc.Parent = remotesFolder
    end

    isAdminFunc.OnServerInvoke = function(player)
        return AdminServer.IsAdmin(player)
    end

    adminRemote.OnServerEvent:Connect(function(player, command, args)
        AdminServer.HandleCommand(player, command, args)
    end)

    Players.PlayerAdded:Connect(function(player)
        if bannedPlayers[player.UserId] then
            player:Kick("Voce foi banido deste servidor.")
        end
    end)
end

function AdminServer.IsAdmin(player)
    for _, id in ipairs(Config.AdminUserIds) do
        if player.UserId == id then
            return true
        end
    end
    return false
end

local function logAction(admin, command, args)
    table.insert(adminLogs, {
        Admin = admin.Name,
        AdminId = admin.UserId,
        Command = command,
        Args = args,
        Time = os.time(),
    })
    if #adminLogs > 500 then
        table.remove(adminLogs, 1)
    end
end

local function sendResponse(player, success, message)
    local remote = remotesFolder:FindFirstChild("AdminResponse")
    if remote then
        remote:FireClient(player, success, message)
    end
end

local function findPlayer(nameOrPartial)
    nameOrPartial = string.lower(nameOrPartial)
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(p.Name) == nameOrPartial or string.find(string.lower(p.Name), nameOrPartial, 1, true) then
            return p
        end
    end
    return nil
end

function AdminServer.HandleCommand(player, command, args)
    if not AdminServer.IsAdmin(player) then
        sendResponse(player, false, "Sem permissao de admin.")
        return
    end

    args = args or {}
    command = string.lower(command)
    logAction(player, command, args)

    if command == "givemoney" then
        local target = findPlayer(args.Target or "")
        local amount = tonumber(args.Amount) or 0
        if target and amount > 0 then
            local data = DataStoreManager:GetData(target)
            if data then
                data.Money = (data.Money or 0) + amount
                sendResponse(player, true, "Deu $" .. amount .. " para " .. target.Name)
            end
        else
            sendResponse(player, false, "Jogador nao encontrado ou quantia invalida.")
        end

    elseif command == "givestrength" then
        local target = findPlayer(args.Target or "")
        local amount = tonumber(args.Amount) or 0
        if target and amount > 0 then
            local data = DataStoreManager:GetData(target)
            if data then
                data.Strength = (data.Strength or 0) + amount
                sendResponse(player, true, "Deu " .. amount .. " forca para " .. target.Name)
            end
        else
            sendResponse(player, false, "Jogador nao encontrado ou quantia invalida.")
        end

    elseif command == "giverebirths" then
        local target = findPlayer(args.Target or "")
        local amount = tonumber(args.Amount) or 0
        if target and amount > 0 then
            local data = DataStoreManager:GetData(target)
            if data then
                data.Rebirths = math.min((data.Rebirths or 0) + amount, Config.Rebirth.MaxRebirths)
                sendResponse(player, true, "Deu " .. amount .. " rebirths para " .. target.Name)
            end
        else
            sendResponse(player, false, "Jogador nao encontrado ou quantia invalida.")
        end

    elseif command == "teleport" then
        local target = findPlayer(args.Target or "")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(5, 0, 0)
                sendResponse(player, true, "Teleportado para " .. target.Name)
            end
        else
            sendResponse(player, false, "Jogador nao encontrado.")
        end

    elseif command == "kick" then
        local target = findPlayer(args.Target or "")
        local reason = args.Reason or "Removido por um administrador."
        if target and not AdminServer.IsAdmin(target) then
            target:Kick(reason)
            sendResponse(player, true, "Kickou " .. target.Name)
        else
            sendResponse(player, false, "Jogador nao encontrado ou e admin.")
        end

    elseif command == "ban" then
        local target = findPlayer(args.Target or "")
        local reason = args.Reason or "Banido por um administrador."
        if target and not AdminServer.IsAdmin(target) then
            bannedPlayers[target.UserId] = true
            target:Kick(reason)
            sendResponse(player, true, "Baniu " .. target.Name)
        else
            sendResponse(player, false, "Jogador nao encontrado ou e admin.")
        end

    elseif command == "spawnmeteor" then
        local meteorEvent = require(script.Parent:FindFirstChild("MeteorEventServer"))
        if meteorEvent and meteorEvent.SpawnMeteor then
            meteorEvent.SpawnMeteor()
            sendResponse(player, true, "Meteoro spawned!")
        else
            sendResponse(player, false, "Sistema de meteoro nao encontrado.")
        end

    elseif command == "startevent" then
        local meteorEvent = require(script.Parent:FindFirstChild("MeteorEventServer"))
        if meteorEvent and meteorEvent.StartEvent then
            meteorEvent.StartEvent()
            sendResponse(player, true, "Evento iniciado!")
        else
            sendResponse(player, false, "Sistema de eventos nao encontrado.")
        end

    elseif command == "spawnbrainrot" then
        local target = findPlayer(args.Target or "")
        local rarity = args.Rarity or "Basico"
        if target then
            local data = DataStoreManager:GetData(target)
            if data then
                local BrainrotDB = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BrainrotDatabase"))
                local brainrots = BrainrotDB.GetBrainrotsByRarity(rarity)
                if #brainrots > 0 then
                    local chosen = brainrots[math.random(1, #brainrots)]
                    table.insert(data.Inventory, {
                        Name = chosen.Name,
                        Rarity = rarity,
                        Mutation = args.Mutation or "None",
                        Level = 1,
                    })
                    sendResponse(player, true, "Spawnou " .. chosen.DisplayName .. " (" .. rarity .. ") para " .. target.Name)
                else
                    sendResponse(player, false, "Raridade invalida: " .. rarity)
                end
            end
        else
            sendResponse(player, false, "Jogador nao encontrado.")
        end

    elseif command == "givemutation" then
        local target = findPlayer(args.Target or "")
        local mutation = args.Mutation or "Gold"
        local index = tonumber(args.Index) or 1
        if target then
            local data = DataStoreManager:GetData(target)
            if data and data.Inventory[index] then
                data.Inventory[index].Mutation = mutation
                sendResponse(player, true, "Mutacao " .. mutation .. " aplicada ao item " .. index .. " de " .. target.Name)
            else
                sendResponse(player, false, "Inventario invalido.")
            end
        else
            sendResponse(player, false, "Jogador nao encontrado.")
        end

    elseif command == "resetplayer" then
        local target = findPlayer(args.Target or "")
        if target and not AdminServer.IsAdmin(target) then
            local data = DataStoreManager:GetData(target)
            if data then
                data.Money = Config.STARTING_MONEY
                data.Strength = Config.STARTING_STRENGTH
                data.Speed = Config.STARTING_SPEED
                data.Luck = Config.STARTING_LUCK
                data.Rebirths = Config.STARTING_REBIRTHS
                data.Inventory = {}
                data.StoredBrainrots = {}
                sendResponse(player, true, "Resetou " .. target.Name)
            end
        else
            sendResponse(player, false, "Jogador nao encontrado ou e admin.")
        end

    elseif command == "spawnboss" then
        sendResponse(player, true, "Boss spawn iniciado! (sistema em expansao)")

    else
        sendResponse(player, false, "Comando desconhecido: " .. command)
    end
end

function AdminServer.GetLogs()
    return adminLogs
end

return AdminServer
