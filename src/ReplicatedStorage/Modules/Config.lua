--[[
    Config.lua  v2.0
    Central configuration for "Treine Para Chutar Lucky Block"
    MAJOR UPDATE: 27 weights, 30 rebirths, 16+ arenas, VIP, server boosts,
    admin system, meteor events, brainrot leveling, distance system, and more.
]]

local Config = {}

------------------------------------------------------------
-- GENERAL
------------------------------------------------------------
Config.GAME_NAME = "Treine Para Chutar Lucky Block"
Config.VERSION = "2.0.0"
Config.AUTO_SAVE_INTERVAL = 60
Config.MAX_PLAYERS = 50
Config.MAX_BASES_PER_SERVER = 5

------------------------------------------------------------
-- ADMIN
------------------------------------------------------------
Config.AdminUserIds = {}  -- Add admin UserIds here, e.g. {123456, 789012}
Config.AdminCommands = {
    "spawnbrainrot", "givemoney", "givestrength", "giverebirths",
    "teleport", "kick", "ban", "spawnmeteor", "startevent",
    "givemutation", "resetplayer", "spawnboss",
}

------------------------------------------------------------
-- CURRENCY
------------------------------------------------------------
Config.STARTING_MONEY = 100
Config.STARTING_STRENGTH = 1
Config.STARTING_SPEED = 1
Config.STARTING_LUCK = 1
Config.STARTING_REBIRTHS = 0

------------------------------------------------------------
-- TRAINING — 27 WEIGHTS
------------------------------------------------------------
Config.Training = {
    StrengthPerClick = 1,
    SpeedPerClick = 0.5,
    ClickCooldown = 0.25,
    Weights = {
        -- Basic Dumbbells (1-5)
        { Name = "Haltere de Madeira",    Cost = 0,          Multiplier = 1,      RequiredStrength = 0,       Tier = "Basic" },
        { Name = "Haltere Leve",          Cost = 200,        Multiplier = 2,      RequiredStrength = 25,      Tier = "Basic" },
        { Name = "Haltere Medio",         Cost = 800,        Multiplier = 4,      RequiredStrength = 100,     Tier = "Basic" },
        { Name = "Haltere Pesado",        Cost = 2500,       Multiplier = 7,      RequiredStrength = 300,     Tier = "Basic" },
        { Name = "Haltere de Aco",        Cost = 8000,       Multiplier = 12,     RequiredStrength = 800,     Tier = "Basic" },
        -- Giant Weights (6-10)
        { Name = "Barra de Ferro",        Cost = 20000,      Multiplier = 20,     RequiredStrength = 2000,    Tier = "Giant" },
        { Name = "Bigorna Pesada",        Cost = 50000,      Multiplier = 35,     RequiredStrength = 5000,    Tier = "Giant" },
        { Name = "Peso Titanico",         Cost = 120000,     Multiplier = 55,     RequiredStrength = 12000,   Tier = "Giant" },
        { Name = "Bloco de Chumbo",       Cost = 300000,     Multiplier = 85,     RequiredStrength = 30000,   Tier = "Giant" },
        { Name = "Esfera Colossal",       Cost = 750000,     Multiplier = 130,    RequiredStrength = 75000,   Tier = "Giant" },
        -- Neon Weights (11-15)
        { Name = "Cubo Neon",             Cost = 1500000,    Multiplier = 200,    RequiredStrength = 150000,  Tier = "Neon" },
        { Name = "Prisma Luminoso",       Cost = 3500000,    Multiplier = 320,    RequiredStrength = 350000,  Tier = "Neon" },
        { Name = "Estrela Neon",          Cost = 8000000,    Multiplier = 500,    RequiredStrength = 800000,  Tier = "Neon" },
        { Name = "Anel de Plasma",        Cost = 18000000,   Multiplier = 780,    RequiredStrength = 1800000, Tier = "Neon" },
        { Name = "Nucleo Brilhante",      Cost = 40000000,   Multiplier = 1200,   RequiredStrength = 4000000, Tier = "Neon" },
        -- Hacker Weights (16-20)
        { Name = "Virus Digital",         Cost = 90000000,   Multiplier = 1800,   RequiredStrength = 9e6,     Tier = "Hacker" },
        { Name = "Firewall Pesado",       Cost = 200000000,  Multiplier = 2800,   RequiredStrength = 2e7,     Tier = "Hacker" },
        { Name = "Servidor Colossal",     Cost = 500000000,  Multiplier = 4500,   RequiredStrength = 5e7,     Tier = "Hacker" },
        { Name = "Mainframe Maximo",      Cost = 1200000000, Multiplier = 7000,   RequiredStrength = 1.2e8,   Tier = "Hacker" },
        { Name = "Codigo Fonte",          Cost = 3000000000, Multiplier = 11000,  RequiredStrength = 3e8,     Tier = "Hacker" },
        -- Cosmic Weights (21-24)
        { Name = "Meteoro Celeste",       Cost = 7e9,        Multiplier = 17000,  RequiredStrength = 7e8,     Tier = "Cosmic" },
        { Name = "Estrela Negra",         Cost = 1.5e10,     Multiplier = 27000,  RequiredStrength = 1.5e9,   Tier = "Cosmic" },
        { Name = "Buraco Negro",          Cost = 4e10,       Multiplier = 42000,  RequiredStrength = 4e9,     Tier = "Cosmic" },
        { Name = "Supernova Compacta",    Cost = 1e11,       Multiplier = 65000,  RequiredStrength = 1e10,    Tier = "Cosmic" },
        -- Mythical Weights (25-27)
        { Name = "Essencia Divina",       Cost = 3e11,       Multiplier = 100000, RequiredStrength = 3e10,    Tier = "Mythical" },
        { Name = "Fragmento do Universo", Cost = 1e12,       Multiplier = 160000, RequiredStrength = 1e11,    Tier = "Mythical" },
        { Name = "Peso do Infinito",      Cost = 5e12,       Multiplier = 250000, RequiredStrength = 5e11,    Tier = "Mythical" },
    },
}

------------------------------------------------------------
-- POWER BAR  (reworked — faster, rainbow perfect)
------------------------------------------------------------
Config.PowerBar = {
    Speed = 3.0,
    Sections = {
        { Name = "Bad",     Range = {0.00, 0.30}, Color = Color3.fromRGB(255, 40, 40),   RewardMultiplier = 0.20 },
        { Name = "Good",    Range = {0.30, 0.60}, Color = Color3.fromRGB(255, 200, 40),  RewardMultiplier = 0.55 },
        { Name = "Great",   Range = {0.60, 0.85}, Color = Color3.fromRGB(80, 255, 80),   RewardMultiplier = 1.00 },
        { Name = "Perfect", Range = {0.85, 1.00}, Color = Color3.fromRGB(255, 100, 255), RewardMultiplier = 2.50 },
    },
}

------------------------------------------------------------
-- KICK / DISTANCE SYSTEM
------------------------------------------------------------
Config.Kick = {
    BaseDistance = 10,
    StrengthScaling = 0.002,
    RebirthScaling = 0.15,
    MaxDistance = 100000,
    FlyDuration = 2.0,
    SpinSpeed = 720,
    TrailLifetime = 0.8,
    CameraShakeIntensity = 0.5,
    CameraShakeDuration = 0.4,
}

Config.LuckyBlock = {
    BaseMoney = 50,
    BaseStrength = 5,
    BaseSpeed = 1,
    BaseLuck = 0.1,
    BrainrotChance = 0.15,
    Cooldown = 1.2,
    ExplosionDuration = 0.8,
    RespawnTime = 1.5,
}

------------------------------------------------------------
-- RARITIES (original 8)
------------------------------------------------------------
Config.Rarities = {
    {
        Name = "Basico", DisplayName = "Básico",
        Color = Color3.fromRGB(180, 180, 180), FloorColor = Color3.fromRGB(200, 200, 200),
        RequiredStrength = 0, MoneyMultiplier = 1, LuckMultiplier = 1,
        BrainrotChance = 0.20, Order = 1,
    },
    {
        Name = "Comum", DisplayName = "Comum",
        Color = Color3.fromRGB(100, 200, 100), FloorColor = Color3.fromRGB(120, 220, 120),
        RequiredStrength = 100, MoneyMultiplier = 2, LuckMultiplier = 1.5,
        BrainrotChance = 0.18, Order = 2,
    },
    {
        Name = "Raro", DisplayName = "Raro",
        Color = Color3.fromRGB(80, 130, 255), FloorColor = Color3.fromRGB(100, 150, 255),
        RequiredStrength = 500, MoneyMultiplier = 5, LuckMultiplier = 2,
        BrainrotChance = 0.15, Order = 3,
    },
    {
        Name = "Mitico", DisplayName = "Mítico",
        Color = Color3.fromRGB(200, 60, 255), FloorColor = Color3.fromRGB(180, 80, 255),
        RequiredStrength = 2000, MoneyMultiplier = 12, LuckMultiplier = 3,
        BrainrotChance = 0.12, Order = 4,
    },
    {
        Name = "Divino", DisplayName = "Divino",
        Color = Color3.fromRGB(255, 215, 0), FloorColor = Color3.fromRGB(255, 225, 50),
        RequiredStrength = 8000, MoneyMultiplier = 30, LuckMultiplier = 5,
        BrainrotChance = 0.10, Order = 5,
    },
    {
        Name = "Classico", DisplayName = "Clássico",
        Color = Color3.fromRGB(255, 100, 50), FloorColor = Color3.fromRGB(255, 120, 70),
        RequiredStrength = 25000, MoneyMultiplier = 75, LuckMultiplier = 8,
        BrainrotChance = 0.08, Order = 6,
    },
    {
        Name = "OG", DisplayName = "OG",
        Color = Color3.fromRGB(0, 255, 200), FloorColor = Color3.fromRGB(50, 255, 220),
        RequiredStrength = 80000, MoneyMultiplier = 200, LuckMultiplier = 15,
        BrainrotChance = 0.05, Order = 7,
    },
    {
        Name = "Hacker", DisplayName = "Hacker",
        Color = Color3.fromRGB(0, 255, 0), FloorColor = Color3.fromRGB(0, 200, 0),
        RequiredStrength = 250000, MoneyMultiplier = 500, LuckMultiplier = 30,
        BrainrotChance = 0.03, Order = 8,
    },
}

------------------------------------------------------------
-- 16 EXTRA ARENAS (beyond the 8 rarity zones)
------------------------------------------------------------
Config.Arenas = {
    { Name = "Vulcao",       DisplayName = "Vulcão",       Color = Color3.fromRGB(255, 80, 0),   FloorColor = Color3.fromRGB(200, 50, 0),   RequiredStrength = 5e5,   MoneyMultiplier = 800,   Theme = "Lava",      Order = 9 },
    { Name = "Abismo",       DisplayName = "Abismo",       Color = Color3.fromRGB(30, 0, 80),    FloorColor = Color3.fromRGB(20, 0, 60),    RequiredStrength = 1e6,   MoneyMultiplier = 1200,  Theme = "Void",      Order = 10 },
    { Name = "Cristal",      DisplayName = "Cristal",      Color = Color3.fromRGB(180, 230, 255),FloorColor = Color3.fromRGB(200, 240, 255),RequiredStrength = 2.5e6, MoneyMultiplier = 1800,  Theme = "Crystal",   Order = 11 },
    { Name = "Tundra",       DisplayName = "Tundra",       Color = Color3.fromRGB(200, 230, 255),FloorColor = Color3.fromRGB(220, 240, 255),RequiredStrength = 5e6,   MoneyMultiplier = 2800,  Theme = "Ice",       Order = 12 },
    { Name = "Tempestade",   DisplayName = "Tempestade",   Color = Color3.fromRGB(100, 100, 180),FloorColor = Color3.fromRGB(80, 80, 150),  RequiredStrength = 1e7,   MoneyMultiplier = 4500,  Theme = "Storm",     Order = 13 },
    { Name = "Nebulosa",     DisplayName = "Nebulosa",     Color = Color3.fromRGB(150, 50, 200), FloorColor = Color3.fromRGB(120, 30, 180), RequiredStrength = 2.5e7, MoneyMultiplier = 7000,  Theme = "Nebula",    Order = 14 },
    { Name = "Inferno",      DisplayName = "Inferno",      Color = Color3.fromRGB(200, 0, 0),    FloorColor = Color3.fromRGB(150, 0, 0),    RequiredStrength = 5e7,   MoneyMultiplier = 11000, Theme = "Inferno",   Order = 15 },
    { Name = "Quantico",     DisplayName = "Quântico",     Color = Color3.fromRGB(0, 255, 255),  FloorColor = Color3.fromRGB(0, 200, 200),  RequiredStrength = 1e8,   MoneyMultiplier = 17000, Theme = "Quantum",   Order = 16 },
    { Name = "Dimensional",  DisplayName = "Dimensional",  Color = Color3.fromRGB(255, 0, 255),  FloorColor = Color3.fromRGB(200, 0, 200),  RequiredStrength = 2.5e8, MoneyMultiplier = 27000, Theme = "Dimension", Order = 17 },
    { Name = "Celestial",    DisplayName = "Celestial",    Color = Color3.fromRGB(255, 255, 200),FloorColor = Color3.fromRGB(255, 255, 180),RequiredStrength = 5e8,   MoneyMultiplier = 42000, Theme = "Heaven",    Order = 18 },
    { Name = "Sombrio",      DisplayName = "Sombrio",      Color = Color3.fromRGB(40, 0, 40),    FloorColor = Color3.fromRGB(30, 0, 30),    RequiredStrength = 1e9,   MoneyMultiplier = 65000, Theme = "Shadow",    Order = 19 },
    { Name = "Cosmico",      DisplayName = "Cósmico",      Color = Color3.fromRGB(0, 50, 150),   FloorColor = Color3.fromRGB(0, 30, 100),   RequiredStrength = 2.5e9, MoneyMultiplier = 1e5,   Theme = "Cosmic",    Order = 20 },
    { Name = "Eterno",       DisplayName = "Eterno",       Color = Color3.fromRGB(255, 200, 100),FloorColor = Color3.fromRGB(255, 180, 80), RequiredStrength = 5e9,   MoneyMultiplier = 1.5e5, Theme = "Eternal",   Order = 21 },
    { Name = "Supremo",      DisplayName = "Supremo",      Color = Color3.fromRGB(255, 50, 50),  FloorColor = Color3.fromRGB(200, 30, 30),  RequiredStrength = 1e10,  MoneyMultiplier = 2.5e5, Theme = "Supreme",   Order = 22 },
    { Name = "Omni",         DisplayName = "Omni",         Color = Color3.fromRGB(255, 255, 255),FloorColor = Color3.fromRGB(240, 240, 255),RequiredStrength = 5e10,  MoneyMultiplier = 5e5,   Theme = "Omni",      Order = 23 },
    { Name = "Infinito",     DisplayName = "Infinito",     Color = Color3.fromRGB(0, 0, 0),      FloorColor = Color3.fromRGB(10, 10, 20),   RequiredStrength = 1e11,  MoneyMultiplier = 1e6,   Theme = "Infinite",  Order = 24 },
}

------------------------------------------------------------
-- MUTATIONS (added Meteor)
------------------------------------------------------------
Config.Mutations = {
    { Name = "Gold",    DisplayName = "Gold",    Color = Color3.fromRGB(255, 215, 0),   ValueMultiplier = 2,  Chance = 0.10, ParticleColor = Color3.fromRGB(255, 215, 0) },
    { Name = "Diamond", DisplayName = "Diamond", Color = Color3.fromRGB(185, 242, 255), ValueMultiplier = 5,  Chance = 0.04, ParticleColor = Color3.fromRGB(185, 242, 255) },
    { Name = "Rainbow", DisplayName = "Rainbow", Color = Color3.fromRGB(255, 100, 200), ValueMultiplier = 10, Chance = 0.01, ParticleColor = Color3.fromRGB(255, 255, 255) },
    { Name = "Pink",    DisplayName = "Pink",    Color = Color3.fromRGB(255, 105, 180), ValueMultiplier = 3,  Chance = 0.06, ParticleColor = Color3.fromRGB(255, 105, 180) },
    { Name = "Meteor",  DisplayName = "Meteor",  Color = Color3.fromRGB(255, 120, 0),   ValueMultiplier = 8,  Chance = 0.00, ParticleColor = Color3.fromRGB(255, 100, 0) },
}

------------------------------------------------------------
-- REBIRTH (reworked — max 30, dual requirement)
------------------------------------------------------------
Config.Rebirth = {
    MaxRebirths = 30,
    MoneyMultiplierPerRebirth = 0.5,
    StrengthBonusPerRebirth = 0.10,
    LuckBonusPerRebirth = 0.5,
    Requirements = {
        { Strength = 1e3,   Money = 500 },
        { Strength = 1e4,   Money = 5000 },
        { Strength = 5e4,   Money = 25000 },
        { Strength = 1e5,   Money = 80000 },
        { Strength = 5e5,   Money = 300000 },
        { Strength = 1e6,   Money = 1e6 },
        { Strength = 2e6,   Money = 3e6 },
        { Strength = 5e6,   Money = 8e6 },
        { Strength = 1e7,   Money = 2e7 },
        { Strength = 2.5e7, Money = 5e7 },
        { Strength = 5e7,   Money = 1e8 },
        { Strength = 1e8,   Money = 3e8 },
        { Strength = 2.5e8, Money = 8e8 },
        { Strength = 5e8,   Money = 2e9 },
        { Strength = 1e9,   Money = 5e9 },
        { Strength = 2.5e9, Money = 1.2e10 },
        { Strength = 5e9,   Money = 3e10 },
        { Strength = 1e10,  Money = 8e10 },
        { Strength = 2.5e10,Money = 2e11 },
        { Strength = 5e10,  Money = 5e11 },
        { Strength = 1e11,  Money = 1.2e12 },
        { Strength = 2.5e11,Money = 3e12 },
        { Strength = 5e11,  Money = 8e12 },
        { Strength = 1e12,  Money = 2e13 },
        { Strength = 2.5e12,Money = 5e13 },
        { Strength = 5e12,  Money = 1.2e14 },
        { Strength = 1e13,  Money = 3e14 },
        { Strength = 2.5e13,Money = 8e14 },
        { Strength = 5e13,  Money = 2e15 },
        { Strength = 1e14,  Money = 5e15 },
    },
}

------------------------------------------------------------
-- BASE SYSTEM (reworked — level 30, 5 per server)
------------------------------------------------------------
Config.Base = {
    MaxLevel = 30,
    StartingSlots = 4,
    MaxSlots = 128,
    SlotsPerLevel = 4,
    LevelCosts = {},
    Upgrades = {
        { Name = "Piso Neon",        Cost = 5000,     Description = "Piso brilhante neon",           MinLevel = 1 },
        { Name = "Paredes Premium",  Cost = 15000,    Description = "Paredes com brilho especial",   MinLevel = 3 },
        { Name = "Trofeu Central",   Cost = 30000,    Description = "Exibe seu melhor Brainrot",     MinLevel = 5 },
        { Name = "Luzes RGB",        Cost = 50000,    Description = "Luzes animadas RGB",            MinLevel = 7 },
        { Name = "Portal Pessoal",   Cost = 100000,   Description = "Portal de teletransporte",      MinLevel = 10 },
        { Name = "Andar Extra",      Cost = 200000,   Description = "Segundo andar na base",         MinLevel = 12 },
        { Name = "Maquina Upgrade",  Cost = 350000,   Description = "Maquina de upgrade de Brainrots", MinLevel = 15 },
        { Name = "Base Dourada",     Cost = 500000,   Description = "Base toda dourada",             MinLevel = 18 },
        { Name = "Jardim Neon",      Cost = 1000000,  Description = "Jardim com plantas neon",       MinLevel = 20 },
        { Name = "Sala VIP",         Cost = 2000000,  Description = "Sala VIP exclusiva",            MinLevel = 22 },
        { Name = "Base Diamante",    Cost = 5000000,  Description = "Base de diamante",              MinLevel = 25 },
        { Name = "Base Infinita",    Cost = 20000000, Description = "Base final com tudo",           MinLevel = 30 },
    },
}

-- Generate level costs (exponential scaling)
for i = 1, Config.Base.MaxLevel do
    Config.Base.LevelCosts[i] = math.floor(1000 * (2.2 ^ (i - 1)))
end

------------------------------------------------------------
-- BRAINROT LEVELING
------------------------------------------------------------
Config.BrainrotLeveling = {
    MaxLevel = 50,
    BaseCost = 100,
    CostMultiplier = 1.35,
    IncomePerLevel = 0.10,
    MultiplierPerLevel = 0.02,
}

------------------------------------------------------------
-- PASSIVE INCOME
------------------------------------------------------------
Config.PassiveIncome = {
    TickInterval = 10,
    OfflineMaxHours = 8,
    OfflineEfficiency = 0.5,
}

------------------------------------------------------------
-- METEOR EVENT
------------------------------------------------------------
Config.MeteorEvent = {
    MinInterval = 180,
    MaxInterval = 420,
    Duration = 30,
    MeteorCount = 5,
    BaseMoney = 5000,
    BaseStrength = 500,
    MeteorMutationChance = 0.25,
    WarningTime = 10,
    ExplosionRadius = 20,
}

------------------------------------------------------------
-- SELLER NPC
------------------------------------------------------------
Config.SellerNPC = {
    RefreshInterval = 300,
    MaxDeals = 4,
    DiscountRange = {0.3, 0.7},
    VoiceLines = {
        "Olha essas ofertas!",
        "So hoje! Preco especial!",
        "Brainrots fresquinhos!",
        "Compra ai chefe!",
        "Ta barato demais!",
        "Melhor preco da cidade!",
        "Nao vai encontrar mais barato!",
        "Oferta relampago!",
    },
}

------------------------------------------------------------
-- SHOP / GAMEPASSES (reworked + VIP + Server Boosts)
------------------------------------------------------------
Config.Gamepasses = {
    { Name = "VIP",          Id = 0, Price = 399,  Type = "VIP",      Multiplier = 1 },
    { Name = "2x Money",     Id = 0, Price = 99,   Type = "Money",    Multiplier = 2 },
    { Name = "2x Strength",  Id = 0, Price = 99,   Type = "Strength", Multiplier = 2 },
    { Name = "2x Luck",      Id = 0, Price = 149,  Type = "Luck",     Multiplier = 2 },
    { Name = "4x Luck",      Id = 0, Price = 299,  Type = "Luck",     Multiplier = 4 },
}

Config.VIPPerks = {
    MoneyMultiplier = 2,
    StrengthMultiplier = 2,
    LuckMultiplier = 2,
    ChatTag = "[VIP]",
    ChatTagColor = Color3.fromRGB(255, 215, 0),
    OverheadTag = true,
    SpecialEffects = true,
}

Config.ServerBoosts = {
    { Name = "2x Luck Server",  Id = 0, Price = 49,  Type = "Luck",  Multiplier = 2,  Duration = 600 },
    { Name = "4x Luck Server",  Id = 0, Price = 99,  Type = "Luck",  Multiplier = 4,  Duration = 600 },
    { Name = "8x Luck Server",  Id = 0, Price = 199, Type = "Luck",  Multiplier = 8,  Duration = 600 },
    { Name = "16x Luck Server", Id = 0, Price = 399, Type = "Luck",  Multiplier = 16, Duration = 600 },
}

Config.ShopItems = {
    SpeedUpgrades = {
        { Name = "Velocidade +10%",  Cost = 500,     Bonus = 0.10 },
        { Name = "Velocidade +25%",  Cost = 2000,    Bonus = 0.25 },
        { Name = "Velocidade +50%",  Cost = 8000,    Bonus = 0.50 },
        { Name = "Velocidade +100%", Cost = 25000,   Bonus = 1.00 },
        { Name = "Velocidade +200%", Cost = 100000,  Bonus = 2.00 },
        { Name = "Velocidade +500%", Cost = 500000,  Bonus = 5.00 },
        { Name = "Velocidade MAX",   Cost = 2000000, Bonus = 10.00 },
    },
    LuckBoosts = {
        { Name = "Sorte +5%",   Cost = 1000,    Bonus = 0.05, Duration = 300 },
        { Name = "Sorte +10%",  Cost = 3000,    Bonus = 0.10, Duration = 300 },
        { Name = "Sorte +25%",  Cost = 10000,   Bonus = 0.25, Duration = 300 },
        { Name = "Sorte +50%",  Cost = 30000,   Bonus = 0.50, Duration = 300 },
        { Name = "Sorte +100%", Cost = 100000,  Bonus = 1.00, Duration = 600 },
        { Name = "Sorte +250%", Cost = 500000,  Bonus = 2.50, Duration = 600 },
        { Name = "Mega Sorte",  Cost = 2000000, Bonus = 5.00, Duration = 900 },
    },
}

------------------------------------------------------------
-- DISTANCE MAP ZONES
------------------------------------------------------------
Config.DistanceZones = {
    { Name = "Inicio",      MinDist = 0,      MaxDist = 100,    Color = Color3.fromRGB(180, 180, 180), MoneyMult = 1 },
    { Name = "Pasto",       MinDist = 100,    MaxDist = 500,    Color = Color3.fromRGB(100, 200, 100), MoneyMult = 2 },
    { Name = "Deserto",     MinDist = 500,    MaxDist = 2000,   Color = Color3.fromRGB(230, 200, 100), MoneyMult = 5 },
    { Name = "Floresta",    MinDist = 2000,   MaxDist = 5000,   Color = Color3.fromRGB(50, 150, 50),   MoneyMult = 10 },
    { Name = "Montanha",    MinDist = 5000,   MaxDist = 15000,  Color = Color3.fromRGB(150, 130, 100), MoneyMult = 25 },
    { Name = "Nuvens",      MinDist = 15000,  MaxDist = 50000,  Color = Color3.fromRGB(200, 220, 255), MoneyMult = 60 },
    { Name = "Espaco",      MinDist = 50000,  MaxDist = 100000, Color = Color3.fromRGB(20, 20, 60),    MoneyMult = 150 },
}

------------------------------------------------------------
-- ANTI-CHEAT
------------------------------------------------------------
Config.AntiCheat = {
    MaxWalkSpeed = 120,
    MaxJumpPower = 100,
    TeleportThreshold = 200,
    CheckInterval = 1.0,
    MaxWarnings = 3,
    BanDuration = 86400,
    LogExploits = true,
}

------------------------------------------------------------
-- LOBBY DIMENSIONS
------------------------------------------------------------
Config.Lobby = {
    SpawnPosition = Vector3.new(0, 5, 0),
    Size = Vector3.new(250, 1, 250),
    FloorColor = Color3.fromRGB(30, 30, 40),
    NeonColor = Color3.fromRGB(0, 200, 255),
}

------------------------------------------------------------
-- RARITY ROAD
------------------------------------------------------------
Config.RarityRoad = {
    StartPosition = Vector3.new(0, 0, -120),
    ZoneLength = 80,
    ZoneWidth = 40,
    GapBetweenZones = 10,
}

------------------------------------------------------------
-- UI COLORS
------------------------------------------------------------
Config.UI = {
    PrimaryColor = Color3.fromRGB(25, 25, 40),
    SecondaryColor = Color3.fromRGB(40, 40, 60),
    AccentColor = Color3.fromRGB(0, 200, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    ButtonColor = Color3.fromRGB(55, 55, 85),
    ButtonHoverColor = Color3.fromRGB(75, 75, 115),
    SuccessColor = Color3.fromRGB(80, 255, 80),
    ErrorColor = Color3.fromRGB(255, 60, 60),
    WarningColor = Color3.fromRGB(255, 200, 50),
    VIPColor = Color3.fromRGB(255, 215, 0),
    CornerRadius = UDim.new(0, 12),
    FontTitle = Enum.Font.GothamBold,
    FontBody = Enum.Font.Gotham,
    FontAccent = Enum.Font.GothamMedium,
}

return Config
