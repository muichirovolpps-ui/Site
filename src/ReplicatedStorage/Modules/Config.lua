--[[
    Config.lua
    Central configuration for "Treine Para Chutar Lucky Block"
    All game constants, balancing, and settings in one place.
]]

local Config = {}

------------------------------------------------------------
-- GENERAL
------------------------------------------------------------
Config.GAME_NAME = "Treine Para Chutar Lucky Block"
Config.VERSION = "1.0.0"
Config.AUTO_SAVE_INTERVAL = 60
Config.MAX_PLAYERS = 50

------------------------------------------------------------
-- CURRENCY
------------------------------------------------------------
Config.STARTING_MONEY = 100
Config.STARTING_STRENGTH = 1
Config.STARTING_SPEED = 1
Config.STARTING_LUCK = 1
Config.STARTING_REBIRTHS = 0

------------------------------------------------------------
-- TRAINING
------------------------------------------------------------
Config.Training = {
    StrengthPerClick = 1,
    SpeedPerClick = 0.5,
    ClickCooldown = 0.3,
    Weights = {
        { Name = "Haltere Leve",       Cost = 0,       Multiplier = 1,   RequiredStrength = 0 },
        { Name = "Haltere Medio",      Cost = 500,     Multiplier = 2,   RequiredStrength = 50 },
        { Name = "Haltere Pesado",     Cost = 2000,    Multiplier = 4,   RequiredStrength = 200 },
        { Name = "Barra de Ferro",     Cost = 8000,    Multiplier = 8,   RequiredStrength = 500 },
        { Name = "Bigorna",            Cost = 25000,   Multiplier = 16,  RequiredStrength = 1500 },
        { Name = "Meteoro",            Cost = 80000,   Multiplier = 32,  RequiredStrength = 5000 },
        { Name = "Estrela Negra",      Cost = 250000,  Multiplier = 64,  RequiredStrength = 15000 },
        { Name = "Buraco Negro",       Cost = 1000000, Multiplier = 128, RequiredStrength = 50000 },
    },
}

------------------------------------------------------------
-- POWER BAR
------------------------------------------------------------
Config.PowerBar = {
    Speed = 2.0,
    Sections = {
        { Name = "Bad",     Range = {0.0, 0.25}, Color = Color3.fromRGB(255, 60, 60),   RewardMultiplier = 0.25 },
        { Name = "Good",    Range = {0.25, 0.50}, Color = Color3.fromRGB(255, 200, 60),  RewardMultiplier = 0.60 },
        { Name = "Great",   Range = {0.50, 0.75}, Color = Color3.fromRGB(100, 255, 100), RewardMultiplier = 1.00 },
        { Name = "Perfect", Range = {0.75, 1.00}, Color = Color3.fromRGB(120, 80, 255),  RewardMultiplier = 2.00 },
    },
}

------------------------------------------------------------
-- LUCKY BLOCK REWARDS
------------------------------------------------------------
Config.LuckyBlock = {
    BaseMoney = 50,
    BaseStrength = 5,
    BaseSpeed = 1,
    BaseLuck = 0.1,
    BrainrotChance = 0.15,
    Cooldown = 1.5,
    ExplosionDuration = 0.8,
    RespawnTime = 2.0,
}

------------------------------------------------------------
-- RARITIES
------------------------------------------------------------
Config.Rarities = {
    {
        Name = "Basico",
        DisplayName = "Básico",
        Color = Color3.fromRGB(180, 180, 180),
        FloorColor = Color3.fromRGB(200, 200, 200),
        RequiredStrength = 0,
        MoneyMultiplier = 1,
        LuckMultiplier = 1,
        BrainrotChance = 0.20,
        Order = 1,
    },
    {
        Name = "Comum",
        DisplayName = "Comum",
        Color = Color3.fromRGB(100, 200, 100),
        FloorColor = Color3.fromRGB(120, 220, 120),
        RequiredStrength = 100,
        MoneyMultiplier = 2,
        LuckMultiplier = 1.5,
        BrainrotChance = 0.18,
        Order = 2,
    },
    {
        Name = "Raro",
        DisplayName = "Raro",
        Color = Color3.fromRGB(80, 130, 255),
        FloorColor = Color3.fromRGB(100, 150, 255),
        RequiredStrength = 500,
        MoneyMultiplier = 5,
        LuckMultiplier = 2,
        BrainrotChance = 0.15,
        Order = 3,
    },
    {
        Name = "Mitico",
        DisplayName = "Mítico",
        Color = Color3.fromRGB(200, 60, 255),
        FloorColor = Color3.fromRGB(180, 80, 255),
        RequiredStrength = 2000,
        MoneyMultiplier = 12,
        LuckMultiplier = 3,
        BrainrotChance = 0.12,
        Order = 4,
    },
    {
        Name = "Divino",
        DisplayName = "Divino",
        Color = Color3.fromRGB(255, 215, 0),
        FloorColor = Color3.fromRGB(255, 225, 50),
        RequiredStrength = 8000,
        MoneyMultiplier = 30,
        LuckMultiplier = 5,
        BrainrotChance = 0.10,
        Order = 5,
    },
    {
        Name = "Classico",
        DisplayName = "Clássico",
        Color = Color3.fromRGB(255, 100, 50),
        FloorColor = Color3.fromRGB(255, 120, 70),
        RequiredStrength = 25000,
        MoneyMultiplier = 75,
        LuckMultiplier = 8,
        BrainrotChance = 0.08,
        Order = 6,
    },
    {
        Name = "OG",
        DisplayName = "OG",
        Color = Color3.fromRGB(0, 255, 200),
        FloorColor = Color3.fromRGB(50, 255, 220),
        RequiredStrength = 80000,
        MoneyMultiplier = 200,
        LuckMultiplier = 15,
        BrainrotChance = 0.05,
        Order = 7,
    },
    {
        Name = "Hacker",
        DisplayName = "Hacker",
        Color = Color3.fromRGB(0, 255, 0),
        FloorColor = Color3.fromRGB(0, 200, 0),
        RequiredStrength = 250000,
        MoneyMultiplier = 500,
        LuckMultiplier = 30,
        BrainrotChance = 0.03,
        Order = 8,
    },
}

------------------------------------------------------------
-- MUTATIONS
------------------------------------------------------------
Config.Mutations = {
    {
        Name = "Gold",
        DisplayName = "Gold",
        Color = Color3.fromRGB(255, 215, 0),
        ValueMultiplier = 2,
        Chance = 0.10,
        ParticleColor = Color3.fromRGB(255, 215, 0),
    },
    {
        Name = "Diamond",
        DisplayName = "Diamond",
        Color = Color3.fromRGB(185, 242, 255),
        ValueMultiplier = 5,
        Chance = 0.04,
        ParticleColor = Color3.fromRGB(185, 242, 255),
    },
    {
        Name = "Rainbow",
        DisplayName = "Rainbow",
        Color = Color3.fromRGB(255, 100, 200),
        ValueMultiplier = 10,
        Chance = 0.01,
        ParticleColor = Color3.fromRGB(255, 255, 255),
    },
    {
        Name = "Pink",
        DisplayName = "Pink",
        Color = Color3.fromRGB(255, 105, 180),
        ValueMultiplier = 3,
        Chance = 0.06,
        ParticleColor = Color3.fromRGB(255, 105, 180),
    },
}

------------------------------------------------------------
-- REBIRTH
------------------------------------------------------------
Config.Rebirth = {
    BaseRequirement = 1000,
    RequirementMultiplier = 2.5,
    RewardMultiplier = 0.05,
    LuckBonus = 0.5,
    MaxRebirths = 100,
}

------------------------------------------------------------
-- BASE SYSTEM
------------------------------------------------------------
Config.Base = {
    StartingSlots = 4,
    MaxSlots = 64,
    SlotUpgradeCost = 1000,
    SlotCostMultiplier = 1.8,
    Upgrades = {
        { Name = "Piso Neon",        Cost = 5000,    Description = "Piso brilhante neon" },
        { Name = "Paredes Premium",  Cost = 15000,   Description = "Paredes com brilho especial" },
        { Name = "Trofeu Central",   Cost = 30000,   Description = "Exibe seu melhor Brainrot" },
        { Name = "Luzes RGB",        Cost = 50000,   Description = "Luzes animadas RGB" },
        { Name = "Portal Pessoal",   Cost = 100000,  Description = "Portal de teletransporte" },
        { Name = "Base Dourada",     Cost = 500000,  Description = "Base toda dourada" },
        { Name = "Base Diamante",    Cost = 2000000, Description = "Base de diamante" },
    },
}

------------------------------------------------------------
-- SHOP / GAMEPASSES
------------------------------------------------------------
Config.Gamepasses = {
    { Name = "2x Money",     Id = 0, Price = 99,   Multiplier = 2,  Type = "Money" },
    { Name = "2x Strength",  Id = 0, Price = 99,   Multiplier = 2,  Type = "Strength" },
    { Name = "2x Luck",      Id = 0, Price = 149,  Multiplier = 2,  Type = "Luck" },
    { Name = "4x Luck",      Id = 0, Price = 299,  Multiplier = 4,  Type = "Luck" },
    { Name = "8x Luck",      Id = 0, Price = 499,  Multiplier = 8,  Type = "Luck" },
    { Name = "16x Luck",     Id = 0, Price = 799,  Multiplier = 16, Type = "Luck" },
}

Config.ShopItems = {
    SpeedUpgrades = {
        { Name = "Velocidade +10%",  Cost = 500,    Bonus = 0.10 },
        { Name = "Velocidade +25%",  Cost = 2000,   Bonus = 0.25 },
        { Name = "Velocidade +50%",  Cost = 8000,   Bonus = 0.50 },
        { Name = "Velocidade +100%", Cost = 25000,  Bonus = 1.00 },
        { Name = "Velocidade +200%", Cost = 100000, Bonus = 2.00 },
    },
    LuckBoosts = {
        { Name = "Sorte +5%",   Cost = 1000,   Bonus = 0.05, Duration = 300 },
        { Name = "Sorte +10%",  Cost = 3000,   Bonus = 0.10, Duration = 300 },
        { Name = "Sorte +25%",  Cost = 10000,  Bonus = 0.25, Duration = 300 },
        { Name = "Sorte +50%",  Cost = 30000,  Bonus = 0.50, Duration = 300 },
        { Name = "Sorte +100%", Cost = 100000, Bonus = 1.00, Duration = 600 },
    },
}

------------------------------------------------------------
-- LOBBY DIMENSIONS
------------------------------------------------------------
Config.Lobby = {
    SpawnPosition = Vector3.new(0, 5, 0),
    Size = Vector3.new(200, 1, 200),
    FloorColor = Color3.fromRGB(40, 40, 50),
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
    PrimaryColor = Color3.fromRGB(30, 30, 45),
    SecondaryColor = Color3.fromRGB(45, 45, 65),
    AccentColor = Color3.fromRGB(0, 200, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    ButtonColor = Color3.fromRGB(60, 60, 90),
    ButtonHoverColor = Color3.fromRGB(80, 80, 120),
    SuccessColor = Color3.fromRGB(100, 255, 100),
    ErrorColor = Color3.fromRGB(255, 80, 80),
    CornerRadius = UDim.new(0, 12),
    FontTitle = Enum.Font.GothamBold,
    FontBody = Enum.Font.Gotham,
    FontAccent = Enum.Font.GothamMedium,
}

return Config
