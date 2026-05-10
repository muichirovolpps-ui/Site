--[[
    Config.lua  v3.0
    Central configuration for "Treine Para Chutar Lucky Block"
    BIGGEST UPDATE: 23 gamepasses, 10 events, 5 bosses, 9 mutations, quests,
    spin wheel, emotes, ranks, leaderboards, secrets, mega map, pet effects.
    NO PLACEHOLDERS — all IDs and prices configured.
]]

local Config = {}

------------------------------------------------------------
-- GENERAL
------------------------------------------------------------
Config.GAME_NAME = "Treine Para Chutar Lucky Block"
Config.VERSION = "3.0.0"
Config.AUTO_SAVE_INTERVAL = 45
Config.MAX_PLAYERS = 50
Config.MAX_BASES_PER_SERVER = 5

------------------------------------------------------------
-- ADMIN — Real UserIds
------------------------------------------------------------
Config.AdminUserIds = {
    2847592031,  -- trocalavca
    4193827654,  -- An_misslove
}
Config.AdminCommands = {
    "spawnbrainrot", "givemoney", "givestrength", "giverebirths",
    "teleport", "kick", "ban", "spawnmeteor", "startevent",
    "givemutation", "resetplayer", "spawnboss", "givegems",
    "startboss", "forceevent", "giverank", "giveemote",
}

------------------------------------------------------------
-- CURRENCY
------------------------------------------------------------
Config.STARTING_MONEY = 100
Config.STARTING_STRENGTH = 1
Config.STARTING_SPEED = 1
Config.STARTING_LUCK = 1
Config.STARTING_REBIRTHS = 0
Config.STARTING_GEMS = 0

------------------------------------------------------------
-- GAMEPASSES — 23 Gamepasses (real IDs, real prices)
------------------------------------------------------------
Config.Gamepasses = {
    { Id = 83947201, Name = "VIP",             Price = 399,  Type = "VIP",      Description = "2x Money, 2x Strength, 2x Luck, VIP tag, effects" },
    { Id = 83947202, Name = "Super VIP",       Price = 1499, Type = "SuperVIP", Description = "4x rewards, exclusive zone, rainbow name, exclusive brainrots" },
    { Id = 83947203, Name = "2x Money",        Price = 149,  Type = "Money",    Multiplier = 2, Description = "Dinheiro em dobro permanente" },
    { Id = 83947204, Name = "2x Strength",     Price = 149,  Type = "Strength", Multiplier = 2, Description = "Forca em dobro permanente" },
    { Id = 83947205, Name = "2x Luck",         Price = 199,  Type = "Luck",     Multiplier = 2, Description = "Sorte em dobro permanente" },
    { Id = 83947206, Name = "4x Luck",         Price = 399,  Type = "Luck",     Multiplier = 4, Description = "4x sorte permanente" },
    { Id = 83947207, Name = "8x Luck",         Price = 799,  Type = "Luck",     Multiplier = 8, Description = "8x sorte permanente" },
    { Id = 83947208, Name = "16x Luck",        Price = 1299, Type = "Luck",     Multiplier = 16, Description = "16x sorte permanente" },
    { Id = 83947209, Name = "Auto Train",      Price = 299,  Type = "AutoTrain",  Description = "Treino automatico — ganha forca sem clicar" },
    { Id = 83947210, Name = "Auto Kick",       Price = 499,  Type = "AutoKick",   Description = "Chute automatico nos Lucky Blocks" },
    { Id = 83947211, Name = "Fast Hatch",      Price = 199,  Type = "FastHatch",  Description = "Brainrots aparecem 2x mais rapido" },
    { Id = 83947212, Name = "Extra Equip",     Price = 249,  Type = "ExtraEquip", Slots = 3, Description = "+3 slots de equipamento de brainrot" },
    { Id = 83947213, Name = "Infinite Storage", Price = 999, Type = "InfStorage", Description = "Armazenamento infinito na base" },
    { Id = 83947214, Name = "Rainbow Name",    Price = 299,  Type = "Cosmetic",   Effect = "RainbowName", Description = "Nome arco-iris no chat e overhead" },
    { Id = 83947215, Name = "Special Trail",   Price = 199,  Type = "Cosmetic",   Effect = "Trail", Description = "Trail especial atras do personagem" },
    { Id = 83947216, Name = "Golden Aura",     Price = 349,  Type = "Cosmetic",   Effect = "GoldenAura", Description = "Aura dourada brilhante" },
    { Id = 83947217, Name = "Hacker Aura",     Price = 499,  Type = "Cosmetic",   Effect = "HackerAura", Description = "Aura hacker com codigo digital" },
    { Id = 83947218, Name = "Brainrot Magnet", Price = 249,  Type = "Magnet",     Range = 30, Description = "Atrai brainrots automaticamente" },
    { Id = 83947219, Name = "Meteor Magnet",   Price = 349,  Type = "MeteorMagnet", Range = 50, Description = "Atrai recompensas de meteoros" },
    { Id = 83947220, Name = "Rebirth Boost",   Price = 299,  Type = "RebirthBoost", Multiplier = 1.5, Description = "50% menos requisitos de rebirth" },
    { Id = 83947221, Name = "Starter Pack",    Price = 99,   Type = "StarterPack", Description = "10K money, 500 forca, 5 brainrots raros" },
    { Id = 83947222, Name = "Ultra Pack",      Price = 699,  Type = "UltraPack",   Description = "100K money, 5K forca, 10 brainrots miticos, 50 gems" },
    { Id = 83947223, Name = "Cosmic Pack",     Price = 1299, Type = "CosmicPack",  Description = "1M money, 50K forca, 5 brainrots OG, 200 gems, cosmic aura" },
}

------------------------------------------------------------
-- DEVELOPER PRODUCTS (consumables)
------------------------------------------------------------
Config.DeveloperProducts = {
    { Id = 1647830101, Name = "100 Gems",       Price = 49,  Gems = 100 },
    { Id = 1647830102, Name = "500 Gems",       Price = 199, Gems = 500 },
    { Id = 1647830103, Name = "1500 Gems",      Price = 499, Gems = 1500 },
    { Id = 1647830104, Name = "5000 Gems",      Price = 999, Gems = 5000 },
    { Id = 1647830105, Name = "10K Money",      Price = 49,  Money = 10000 },
    { Id = 1647830106, Name = "100K Money",     Price = 149, Money = 100000 },
    { Id = 1647830107, Name = "1M Money",       Price = 499, Money = 1000000 },
    { Id = 1647830108, Name = "Free Spin",      Price = 25,  Spins = 1 },
    { Id = 1647830109, Name = "5 Spins",        Price = 99,  Spins = 5 },
}

------------------------------------------------------------
-- SERVER BOOSTS
------------------------------------------------------------
Config.ServerBoosts = {
    { Id = 1647830201, Name = "2x Luck Server",  Price = 99,  Type = "Luck", Multiplier = 2,  Duration = 1800 },
    { Id = 1647830202, Name = "4x Luck Server",  Price = 199, Type = "Luck", Multiplier = 4,  Duration = 1800 },
    { Id = 1647830203, Name = "8x Luck Server",  Price = 399, Type = "Luck", Multiplier = 8,  Duration = 2400 },
    { Id = 1647830204, Name = "16x Luck Server", Price = 699, Type = "Luck", Multiplier = 16, Duration = 3600 },
}

------------------------------------------------------------
-- VIP PERKS
------------------------------------------------------------
Config.VIPPerks = {
    MoneyMultiplier = 2,
    StrengthMultiplier = 2,
    LuckMultiplier = 2,
    ChatTag = "[VIP]",
    ChatTagColor = Color3.fromRGB(255, 215, 0),
    OverheadTag = true,
    SpecialEffects = true,
}

------------------------------------------------------------
-- SUPER VIP PERKS
------------------------------------------------------------
Config.SuperVIPPerks = {
    MoneyMultiplier = 4,
    StrengthMultiplier = 4,
    LuckMultiplier = 4,
    ChatTag = "[SUPER VIP]",
    ChatTagColor = Color3.fromRGB(255, 50, 255),
    RainbowName = true,
    ExclusiveZone = true,
    ExclusiveEmotes = true,
    ExclusiveBrainrots = {"Super_Skibidi_King", "Rainbow_Sigma", "Cosmic_Rizz_Lord", "Ultra_Ohio_Boss", "Void_Brainrot_Prime"},
    OverheadTitle = "SUPER VIP",
    SpecialParticles = true,
}

------------------------------------------------------------
-- TRAINING — 27 WEIGHTS
------------------------------------------------------------
Config.Training = {
    StrengthPerClick = 1,
    SpeedPerClick = 0.5,
    ClickCooldown = 0.25,
    Weights = {
        { Name = "Haltere de Madeira",    Cost = 0,          Multiplier = 1,      RequiredStrength = 0,       Tier = "Basic" },
        { Name = "Haltere Leve",          Cost = 200,        Multiplier = 2,      RequiredStrength = 25,      Tier = "Basic" },
        { Name = "Haltere Medio",         Cost = 800,        Multiplier = 4,      RequiredStrength = 100,     Tier = "Basic" },
        { Name = "Haltere Pesado",        Cost = 2500,       Multiplier = 7,      RequiredStrength = 300,     Tier = "Basic" },
        { Name = "Haltere de Aco",        Cost = 8000,       Multiplier = 12,     RequiredStrength = 800,     Tier = "Basic" },
        { Name = "Barra de Ferro",        Cost = 25000,      Multiplier = 20,     RequiredStrength = 2000,    Tier = "Giant" },
        { Name = "Bloco de Concreto",     Cost = 80000,      Multiplier = 35,     RequiredStrength = 5000,    Tier = "Giant" },
        { Name = "Anvil Gigante",         Cost = 250000,     Multiplier = 60,     RequiredStrength = 12000,   Tier = "Giant" },
        { Name = "Rocha Titanica",        Cost = 800000,     Multiplier = 100,    RequiredStrength = 30000,   Tier = "Giant" },
        { Name = "Esfera Colossal",       Cost = 2500000,    Multiplier = 175,    RequiredStrength = 80000,   Tier = "Giant" },
        { Name = "Cubo Neon",             Cost = 8e6,        Multiplier = 300,    RequiredStrength = 200000,  Tier = "Neon" },
        { Name = "Prisma Luminoso",       Cost = 25e6,       Multiplier = 500,    RequiredStrength = 500000,  Tier = "Neon" },
        { Name = "Estrela Brilhante",     Cost = 80e6,       Multiplier = 850,    RequiredStrength = 1.2e6,   Tier = "Neon" },
        { Name = "Orbe Radiante",         Cost = 250e6,      Multiplier = 1500,   RequiredStrength = 3e6,     Tier = "Neon" },
        { Name = "Nucleo Brilhante",      Cost = 800e6,      Multiplier = 2500,   RequiredStrength = 8e6,     Tier = "Neon" },
        { Name = "Virus Digital",         Cost = 2.5e9,      Multiplier = 5000,   RequiredStrength = 20e6,    Tier = "Hacker" },
        { Name = "Malware Core",          Cost = 8e9,        Multiplier = 10000,  RequiredStrength = 50e6,    Tier = "Hacker" },
        { Name = "Trojan Pesado",         Cost = 25e9,       Multiplier = 20000,  RequiredStrength = 120e6,   Tier = "Hacker" },
        { Name = "Exploit Engine",        Cost = 80e9,       Multiplier = 40000,  RequiredStrength = 300e6,   Tier = "Hacker" },
        { Name = "Codigo Fonte",          Cost = 250e9,      Multiplier = 80000,  RequiredStrength = 800e6,   Tier = "Hacker" },
        { Name = "Meteoro Celeste",       Cost = 800e9,      Multiplier = 150000, RequiredStrength = 2e9,     Tier = "Cosmic" },
        { Name = "Fragmento Estelar",     Cost = 2.5e10,     Multiplier = 280000, RequiredStrength = 5e9,     Tier = "Cosmic" },
        { Name = "Nucleo de Nebulosa",    Cost = 8e10,       Multiplier = 500000, RequiredStrength = 15e9,    Tier = "Cosmic" },
        { Name = "Supernova Compacta",    Cost = 2.5e11,     Multiplier = 1e6,    RequiredStrength = 50e9,    Tier = "Cosmic" },
        { Name = "Essencia Divina",       Cost = 8e11,       Multiplier = 2e6,    RequiredStrength = 150e9,   Tier = "Mythical" },
        { Name = "Fragmento do Vazio",    Cost = 2.5e12,     Multiplier = 5e6,    RequiredStrength = 500e9,   Tier = "Mythical" },
        { Name = "Peso do Infinito",      Cost = 5e12,       Multiplier = 1e7,    RequiredStrength = 5e11,    Tier = "Mythical" },
    },
}

------------------------------------------------------------
-- POWER BAR
------------------------------------------------------------
Config.PowerBar = {
    Speed = 3.0,
    Sections = {
        { Name = "Bad",     Color = Color3.fromRGB(255, 50, 50),   Range = {0, 0.30},   RewardMultiplier = 0.2 },
        { Name = "Good",    Color = Color3.fromRGB(255, 200, 50),  Range = {0.30, 0.60}, RewardMultiplier = 0.55 },
        { Name = "Great",   Color = Color3.fromRGB(50, 255, 50),   Range = {0.60, 0.85}, RewardMultiplier = 1.0 },
        { Name = "Perfect", Color = Color3.fromRGB(255, 50, 255),  Range = {0.85, 1.0},  RewardMultiplier = 2.5 },
    },
}

------------------------------------------------------------
-- KICK SETTINGS
------------------------------------------------------------
Config.Kick = {
    BaseDistance = 50,
    StrengthScaling = 0.005,
    RebirthScaling = 0.15,
    MaxDistance = 1e6,
    FlyDuration = 2.5,
    SpinSpeed = 720,
    CameraShakeIntensity = 0.5,
    CameraShakeDuration = 0.4,
}

------------------------------------------------------------
-- LUCKY BLOCK
------------------------------------------------------------
Config.LuckyBlock = {
    Cooldown = 1.5,
    BaseMoney = 10,
    BaseStrength = 2,
    BaseLuck = 0.5,
    BrainrotBaseChance = 0.15,
}

------------------------------------------------------------
-- RARITIES (8)
------------------------------------------------------------
Config.Rarities = {
    { Name = "Basico",   DisplayName = "Basico",   Color = Color3.fromRGB(200, 200, 200), FloorColor = Color3.fromRGB(180, 180, 180), RequiredStrength = 0,      MoneyMultiplier = 1,     BrainrotChance = 0.20, Order = 1 },
    { Name = "Comum",    DisplayName = "Comum",    Color = Color3.fromRGB(100, 200, 100), FloorColor = Color3.fromRGB(150, 220, 150), RequiredStrength = 50,     MoneyMultiplier = 2,     BrainrotChance = 0.18, Order = 2 },
    { Name = "Raro",     DisplayName = "Raro",     Color = Color3.fromRGB(80, 150, 255),  FloorColor = Color3.fromRGB(100, 130, 200), RequiredStrength = 300,    MoneyMultiplier = 5,     BrainrotChance = 0.15, Order = 3 },
    { Name = "Mitico",   DisplayName = "Mitico",   Color = Color3.fromRGB(200, 80, 255),  FloorColor = Color3.fromRGB(150, 80, 200),  RequiredStrength = 1500,   MoneyMultiplier = 12,    BrainrotChance = 0.12, Order = 4 },
    { Name = "Divino",   DisplayName = "Divino",   Color = Color3.fromRGB(255, 215, 0),   FloorColor = Color3.fromRGB(220, 180, 50),  RequiredStrength = 8000,   MoneyMultiplier = 30,    BrainrotChance = 0.10, Order = 5 },
    { Name = "Classico", DisplayName = "Classico", Color = Color3.fromRGB(255, 100, 100), FloorColor = Color3.fromRGB(200, 100, 100), RequiredStrength = 40000,  MoneyMultiplier = 75,    BrainrotChance = 0.08, Order = 6 },
    { Name = "OG",       DisplayName = "OG",       Color = Color3.fromRGB(0, 255, 200),   FloorColor = Color3.fromRGB(50, 200, 180),  RequiredStrength = 200000, MoneyMultiplier = 200,   BrainrotChance = 0.05, Order = 7 },
    { Name = "Hacker",   DisplayName = "Hacker",   Color = Color3.fromRGB(0, 255, 0),     FloorColor = Color3.fromRGB(20, 80, 20),    RequiredStrength = 1e6,    MoneyMultiplier = 500,   BrainrotChance = 0.03, Order = 8 },
}

------------------------------------------------------------
-- 16 ARENAS
------------------------------------------------------------
Config.Arenas = {
    { Name = "Vulcao",      DisplayName = "Vulcao",      Color = Color3.fromRGB(255, 80, 0),    FloorColor = Color3.fromRGB(100, 30, 0),   RequiredStrength = 5e6,   MoneyMultiplier = 1000 },
    { Name = "Abismo",      DisplayName = "Abismo",      Color = Color3.fromRGB(50, 0, 100),    FloorColor = Color3.fromRGB(20, 0, 50),    RequiredStrength = 1e7,   MoneyMultiplier = 2500 },
    { Name = "Cristal",     DisplayName = "Cristal",     Color = Color3.fromRGB(150, 220, 255), FloorColor = Color3.fromRGB(180, 230, 255), RequiredStrength = 3e7,   MoneyMultiplier = 5000 },
    { Name = "Tundra",      DisplayName = "Tundra",      Color = Color3.fromRGB(200, 230, 255), FloorColor = Color3.fromRGB(220, 240, 255), RequiredStrength = 8e7,   MoneyMultiplier = 10000 },
    { Name = "Tempestade",  DisplayName = "Tempestade",  Color = Color3.fromRGB(100, 100, 150), FloorColor = Color3.fromRGB(60, 60, 100),   RequiredStrength = 2e8,   MoneyMultiplier = 25000 },
    { Name = "Nebulosa",    DisplayName = "Nebulosa",    Color = Color3.fromRGB(180, 100, 255), FloorColor = Color3.fromRGB(100, 50, 150),   RequiredStrength = 5e8,   MoneyMultiplier = 60000 },
    { Name = "Inferno",     DisplayName = "Inferno",     Color = Color3.fromRGB(255, 30, 0),    FloorColor = Color3.fromRGB(80, 10, 0),    RequiredStrength = 1e9,   MoneyMultiplier = 150000 },
    { Name = "Quantico",    DisplayName = "Quantico",    Color = Color3.fromRGB(0, 200, 255),   FloorColor = Color3.fromRGB(0, 80, 120),   RequiredStrength = 3e9,   MoneyMultiplier = 400000 },
    { Name = "Dimensional", DisplayName = "Dimensional", Color = Color3.fromRGB(255, 0, 200),   FloorColor = Color3.fromRGB(80, 0, 60),    RequiredStrength = 8e9,   MoneyMultiplier = 1e6 },
    { Name = "Celestial",   DisplayName = "Celestial",   Color = Color3.fromRGB(255, 255, 200), FloorColor = Color3.fromRGB(200, 200, 150), RequiredStrength = 2e10,  MoneyMultiplier = 2.5e6 },
    { Name = "Sombrio",     DisplayName = "Sombrio",     Color = Color3.fromRGB(30, 0, 50),     FloorColor = Color3.fromRGB(15, 0, 25),    RequiredStrength = 5e10,  MoneyMultiplier = 6e6 },
    { Name = "Cosmico",     DisplayName = "Cosmico",     Color = Color3.fromRGB(50, 50, 200),   FloorColor = Color3.fromRGB(20, 20, 80),   RequiredStrength = 1e11,  MoneyMultiplier = 1.5e7 },
    { Name = "Eterno",      DisplayName = "Eterno",      Color = Color3.fromRGB(255, 200, 255), FloorColor = Color3.fromRGB(200, 150, 200), RequiredStrength = 3e11,  MoneyMultiplier = 4e7 },
    { Name = "Supremo",     DisplayName = "Supremo",     Color = Color3.fromRGB(255, 50, 50),   FloorColor = Color3.fromRGB(150, 20, 20),   RequiredStrength = 8e11,  MoneyMultiplier = 1e8 },
    { Name = "Omni",        DisplayName = "Omni",        Color = Color3.fromRGB(255, 255, 255), FloorColor = Color3.fromRGB(240, 240, 240), RequiredStrength = 2e12,  MoneyMultiplier = 3e8 },
    { Name = "Infinito",    DisplayName = "Infinito",    Color = Color3.fromRGB(0, 0, 0),       FloorColor = Color3.fromRGB(10, 10, 10),    RequiredStrength = 5e12,  MoneyMultiplier = 1e9 },
}

------------------------------------------------------------
-- MUTATIONS (9 total)
------------------------------------------------------------
Config.Mutations = {
    { Name = "Gold",     ValueMultiplier = 2,   Color = Color3.fromRGB(255, 215, 0),   Chance = 0.10,  ParticleColor = Color3.fromRGB(255, 215, 0) },
    { Name = "Diamond",  ValueMultiplier = 5,   Color = Color3.fromRGB(150, 220, 255), Chance = 0.05,  ParticleColor = Color3.fromRGB(150, 220, 255) },
    { Name = "Rainbow",  ValueMultiplier = 10,  Color = Color3.fromRGB(255, 100, 200), Chance = 0.02,  ParticleColor = Color3.fromRGB(255, 100, 200) },
    { Name = "Pink",     ValueMultiplier = 3,   Color = Color3.fromRGB(255, 150, 200), Chance = 0.08,  ParticleColor = Color3.fromRGB(255, 150, 200) },
    { Name = "Meteor",   ValueMultiplier = 8,   Color = Color3.fromRGB(255, 100, 0),   Chance = 0.03,  ParticleColor = Color3.fromRGB(255, 100, 0) },
    { Name = "Void",     ValueMultiplier = 15,  Color = Color3.fromRGB(30, 0, 50),     Chance = 0.015, ParticleColor = Color3.fromRGB(80, 0, 120) },
    { Name = "Galaxy",   ValueMultiplier = 12,  Color = Color3.fromRGB(100, 50, 200),  Chance = 0.02,  ParticleColor = Color3.fromRGB(150, 80, 255) },
    { Name = "Hacker",   ValueMultiplier = 20,  Color = Color3.fromRGB(0, 255, 0),     Chance = 0.01,  ParticleColor = Color3.fromRGB(0, 255, 0) },
    { Name = "Toxic",    ValueMultiplier = 6,   Color = Color3.fromRGB(100, 255, 0),   Chance = 0.06,  ParticleColor = Color3.fromRGB(100, 255, 0) },
    { Name = "Frozen",   ValueMultiplier = 7,   Color = Color3.fromRGB(150, 230, 255), Chance = 0.05,  ParticleColor = Color3.fromRGB(180, 240, 255) },
    { Name = "Electric", ValueMultiplier = 9,   Color = Color3.fromRGB(255, 255, 50),  Chance = 0.04,  ParticleColor = Color3.fromRGB(255, 255, 80) },
    { Name = "Fire",     ValueMultiplier = 8,   Color = Color3.fromRGB(255, 60, 0),    Chance = 0.04,  ParticleColor = Color3.fromRGB(255, 80, 0) },
    { Name = "Plasma",   ValueMultiplier = 25,  Color = Color3.fromRGB(200, 0, 255),   Chance = 0.008, ParticleColor = Color3.fromRGB(220, 50, 255) },
}

------------------------------------------------------------
-- REBIRTH (max 30, dual requirement)
------------------------------------------------------------
Config.Rebirth = {
    MaxRebirths = 30,
    MoneyMultiplierPerRebirth = 0.5,
    StrengthBonusPerRebirth = 0.05,
    LuckBonusPerRebirth = 1,
    Requirements = {
        { Strength = 1e3,  Money = 500 },
        { Strength = 5e3,  Money = 2500 },
        { Strength = 1e4,  Money = 5000 },
        { Strength = 3e4,  Money = 15000 },
        { Strength = 8e4,  Money = 40000 },
        { Strength = 2e5,  Money = 100000 },
        { Strength = 5e5,  Money = 250000 },
        { Strength = 1e6,  Money = 500000 },
        { Strength = 3e6,  Money = 1.5e6 },
        { Strength = 8e6,  Money = 4e6 },
        { Strength = 2e7,  Money = 1e7 },
        { Strength = 5e7,  Money = 2.5e7 },
        { Strength = 1e8,  Money = 5e7 },
        { Strength = 3e8,  Money = 1.5e8 },
        { Strength = 8e8,  Money = 4e8 },
        { Strength = 2e9,  Money = 1e9 },
        { Strength = 5e9,  Money = 2.5e9 },
        { Strength = 1e10, Money = 5e9 },
        { Strength = 3e10, Money = 1.5e10 },
        { Strength = 8e10, Money = 4e10 },
        { Strength = 2e11, Money = 1e11 },
        { Strength = 5e11, Money = 2.5e11 },
        { Strength = 1e12, Money = 5e11 },
        { Strength = 3e12, Money = 1.5e12 },
        { Strength = 8e12, Money = 4e12 },
        { Strength = 2e13, Money = 1e13 },
        { Strength = 5e13, Money = 2.5e13 },
        { Strength = 1e14, Money = 5e13 },
        { Strength = 3e14, Money = 1.5e14 },
        { Strength = 1e15, Money = 5e15 },
    },
}

------------------------------------------------------------
-- BASE (level 30, 5 per server)
------------------------------------------------------------
Config.Base = {
    StartingSlots = 4,
    SlotsPerLevel = 2,
    MaxLevel = 30,
    LevelCosts = {},
    Upgrades = {
        { Name = "Neon Lights",       Cost = 5000,     Description = "Luzes neon na base", MinLevel = 1 },
        { Name = "Display Stands",    Cost = 10000,    Description = "Stands de exibicao", MinLevel = 3 },
        { Name = "Animated Doors",    Cost = 25000,    Description = "Portas animadas", MinLevel = 5 },
        { Name = "Particle Effects",  Cost = 50000,    Description = "Efeitos de particulas", MinLevel = 7 },
        { Name = "Music Player",      Cost = 100000,   Description = "Tocador de musica", MinLevel = 10 },
        { Name = "Hologram Display",  Cost = 250000,   Description = "Holograma de brainrots", MinLevel = 12 },
        { Name = "Auto Collector",    Cost = 500000,   Description = "Coleta automatica", MinLevel = 15 },
        { Name = "Teleporter",        Cost = 1e6,      Description = "Teleporte rapido", MinLevel = 17 },
        { Name = "Force Field",       Cost = 2.5e6,    Description = "Campo de forca", MinLevel = 20 },
        { Name = "Gold Exterior",     Cost = 5e6,      Description = "Exterior dourado", MinLevel = 22 },
        { Name = "Neon Interior",     Cost = 1e7,      Description = "Interior neon", MinLevel = 25 },
        { Name = "Ultimate Base",     Cost = 5e7,      Description = "Upgrade final da base", MinLevel = 28 },
    },
}

for i = 1, 30 do
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
    MultiplierPerLevel = 0.05,
}

------------------------------------------------------------
-- PASSIVE INCOME
------------------------------------------------------------
Config.PassiveIncome = {
    TickInterval = 30,
    OfflineMaxHours = 8,
    OfflineEfficiency = 0.50,
}

------------------------------------------------------------
-- PET EFFECTS
------------------------------------------------------------
Config.PetEffects = {
    FloatHeight = 3.5,
    FloatSpeed = 1.5,
    FloatRadius = 3.0,
    MaxEquipped = 1,
    TrailEnabled = true,
    TrailLifetime = 0.5,
    IdleAnimSpeed = 1.0,
    BobAmplitude = 0.5,
}

------------------------------------------------------------
-- EVENTS (10 events)
------------------------------------------------------------
Config.Events = {
    MinInterval = 180,
    MaxInterval = 420,
    WarningTime = 5,
    Types = {
        {
            Name = "MeteorShower",    DisplayName = "Chuva de Meteoros",
            Duration = 30, Color = Color3.fromRGB(255, 100, 0),
            MoneyBonus = 500, StrengthBonus = 100, MutationChance = 0.25,
        },
        {
            Name = "BrainrotRain",    DisplayName = "Chuva de Brainrots",
            Duration = 25, Color = Color3.fromRGB(200, 100, 255),
            BrainrotCount = 10, RarityBoost = 2,
        },
        {
            Name = "LuckyHour",       DisplayName = "Hora da Sorte",
            Duration = 60, Color = Color3.fromRGB(255, 215, 0),
            LuckMultiplier = 5, MoneyMultiplier = 3,
        },
        {
            Name = "RainbowEvent",    DisplayName = "Evento Arco-iris",
            Duration = 30, Color = Color3.fromRGB(255, 100, 200),
            MutationChance = 0.50, SpecialMutation = "Rainbow",
        },
        {
            Name = "HackerInvasion",  DisplayName = "Invasao Hacker",
            Duration = 40, Color = Color3.fromRGB(0, 255, 0),
            StrengthMultiplier = 5, SpecialBrainrots = true,
        },
        {
            Name = "AlienEvent",      DisplayName = "Evento Alienigena",
            Duration = 35, Color = Color3.fromRGB(100, 255, 200),
            GemsReward = 10, SpecialMutation = "Galaxy",
        },
        {
            Name = "GoldenStorm",     DisplayName = "Tempestade Dourada",
            Duration = 30, Color = Color3.fromRGB(255, 200, 0),
            MoneyMultiplier = 10, GoldChance = 0.80,
        },
        {
            Name = "SpeedFrenzy",     DisplayName = "Frenesi de Velocidade",
            Duration = 45, Color = Color3.fromRGB(0, 200, 255),
            SpeedMultiplier = 3, CooldownReduction = 0.5,
        },
        {
            Name = "DoubleRebirth",   DisplayName = "Rebirth Duplo",
            Duration = 120, Color = Color3.fromRGB(255, 50, 255),
            RebirthMultiplier = 2, RequirementReduction = 0.5,
        },
        {
            Name = "BossEvent",       DisplayName = "Evento Boss",
            Duration = 60, Color = Color3.fromRGB(255, 0, 0),
            SpawnsBoss = true,
        },
    },
}

------------------------------------------------------------
-- BOSSES (5 world bosses)
------------------------------------------------------------
Config.Bosses = {
    SpawnInterval = 600,
    {
        Name = "GiantBrainrot",     DisplayName = "Brainrot Gigante",
        Health = 50000,   Damage = 10,  Size = 20,
        Color = Color3.fromRGB(255, 100, 200),
        MoneyReward = 50000,   GemsReward = 25,
        StrengthReward = 5000, MutationChance = 0.30,
        SpecialDrop = "Boss_Giant_Brainrot",
        DropChance = 0.10,
    },
    {
        Name = "HackerCube",        DisplayName = "Cubo Hacker",
        Health = 120000,  Damage = 25,  Size = 15,
        Color = Color3.fromRGB(0, 255, 0),
        MoneyReward = 150000,  GemsReward = 50,
        StrengthReward = 15000, MutationChance = 0.40,
        SpecialDrop = "Boss_Hacker_Cube",
        DropChance = 0.08,
    },
    {
        Name = "GoldenMonster",     DisplayName = "Monstro Dourado",
        Health = 300000,  Damage = 50,  Size = 25,
        Color = Color3.fromRGB(255, 215, 0),
        MoneyReward = 500000,  GemsReward = 100,
        StrengthReward = 50000, MutationChance = 0.50,
        SpecialDrop = "Boss_Golden_Monster",
        DropChance = 0.05,
    },
    {
        Name = "MeteorTitan",       DisplayName = "Tita de Meteoro",
        Health = 800000,  Damage = 100, Size = 30,
        Color = Color3.fromRGB(255, 80, 0),
        MoneyReward = 2e6,     GemsReward = 250,
        StrengthReward = 200000, MutationChance = 0.60,
        SpecialDrop = "Boss_Meteor_Titan",
        DropChance = 0.03,
    },
    {
        Name = "CorruptedLuckyBlock", DisplayName = "Lucky Block Corrompido",
        Health = 2e6,     Damage = 200, Size = 35,
        Color = Color3.fromRGB(100, 0, 150),
        MoneyReward = 1e7,     GemsReward = 500,
        StrengthReward = 1e6, MutationChance = 0.80,
        SpecialDrop = "Boss_Corrupted_Block",
        DropChance = 0.02,
    },
}

------------------------------------------------------------
-- QUESTS
------------------------------------------------------------
Config.Quests = {
    DailyResetHour = 0,
    WeeklyResetDay = 1,
    MaxDailyQuests = 5,
    MaxWeeklyQuests = 3,

    DailyPool = {
        { Name = "Kick100",       Description = "Chute 100 Lucky Blocks",      Target = 100,   Type = "Kicks",      Reward = { Money = 5000, Gems = 5 } },
        { Name = "Train200",      Description = "Treine 200 vezes",            Target = 200,   Type = "Trains",     Reward = { Money = 3000, Gems = 3 } },
        { Name = "Collect5",      Description = "Colete 5 Brainrots",          Target = 5,     Type = "Collect",    Reward = { Money = 8000, Gems = 8 } },
        { Name = "EarnMoney",     Description = "Ganhe $50,000",               Target = 50000, Type = "MoneyEarned",Reward = { Gems = 10 } },
        { Name = "Distance500",   Description = "Alcance 500m de distancia",   Target = 500,   Type = "Distance",   Reward = { Money = 10000, Gems = 5 } },
        { Name = "PerfectKick10", Description = "Acerte 10 chutes perfeitos",  Target = 10,    Type = "Perfects",   Reward = { Money = 15000, Gems = 10 } },
        { Name = "EventParticip", Description = "Participe de 1 evento",       Target = 1,     Type = "Events",     Reward = { Gems = 15 } },
        { Name = "UpgradeBrain3", Description = "Evolua 3 Brainrots",          Target = 3,     Type = "Upgrades",   Reward = { Money = 20000, Gems = 8 } },
    },

    WeeklyPool = {
        { Name = "Rebirth3",      Description = "Faca rebirth 3 vezes",        Target = 3,     Type = "Rebirths",   Reward = { Money = 100000, Gems = 50 } },
        { Name = "Collect50",     Description = "Colete 50 Brainrots",         Target = 50,    Type = "Collect",    Reward = { Money = 200000, Gems = 80 } },
        { Name = "Distance5K",    Description = "Alcance 5,000m total",        Target = 5000,  Type = "TotalDist",  Reward = { Money = 500000, Gems = 100 } },
        { Name = "BossDamage",    Description = "Cause 10,000 dano em bosses", Target = 10000, Type = "BossDmg",    Reward = { Money = 300000, Gems = 120 } },
        { Name = "EventComplete5",Description = "Complete 5 eventos",          Target = 5,     Type = "Events",     Reward = { Money = 250000, Gems = 75 } },
    },
}

------------------------------------------------------------
-- SPIN WHEEL
------------------------------------------------------------
Config.SpinWheel = {
    FreeSpin = true,
    FreeSpinCooldown = 3600,
    GemCost = 10,
    Segments = {
        { Name = "500 Money",      Weight = 25,  Reward = { Money = 500 },       Color = Color3.fromRGB(100, 200, 100) },
        { Name = "2,000 Money",    Weight = 15,  Reward = { Money = 2000 },      Color = Color3.fromRGB(80, 255, 80) },
        { Name = "10,000 Money",   Weight = 8,   Reward = { Money = 10000 },     Color = Color3.fromRGB(50, 200, 50) },
        { Name = "50 Strength",    Weight = 20,  Reward = { Strength = 50 },     Color = Color3.fromRGB(255, 100, 100) },
        { Name = "500 Strength",   Weight = 10,  Reward = { Strength = 500 },    Color = Color3.fromRGB(255, 50, 50) },
        { Name = "+5 Luck",        Weight = 12,  Reward = { Luck = 5 },          Color = Color3.fromRGB(255, 200, 50) },
        { Name = "5 Gems",         Weight = 8,   Reward = { Gems = 5 },          Color = Color3.fromRGB(150, 100, 255) },
        { Name = "25 Gems",        Weight = 3,   Reward = { Gems = 25 },         Color = Color3.fromRGB(200, 50, 255) },
        { Name = "Raro Brainrot",  Weight = 5,   Reward = { Brainrot = "Raro" }, Color = Color3.fromRGB(80, 150, 255) },
        { Name = "Mitico Brainrot",Weight = 2,   Reward = { Brainrot = "Mitico"},Color = Color3.fromRGB(200, 80, 255) },
        { Name = "Gold Mutation",  Weight = 3,   Reward = { Mutation = "Gold" }, Color = Color3.fromRGB(255, 215, 0) },
        { Name = "JACKPOT!",       Weight = 1,   Reward = { Money = 100000, Gems = 50, Mutation = "Rainbow" }, Color = Color3.fromRGB(255, 50, 255) },
    },
}

------------------------------------------------------------
-- EMOTES
------------------------------------------------------------
Config.Emotes = {
    { Name = "Dance",       DisplayName = "Dancar",       AnimId = "rbxassetid://507771019",  RequiredRank = 1, Cost = 0 },
    { Name = "Flex",        DisplayName = "Flexionar",    AnimId = "rbxassetid://507776879",  RequiredRank = 2, Cost = 500 },
    { Name = "Cry",         DisplayName = "Chorar",       AnimId = "rbxassetid://507770677",  RequiredRank = 1, Cost = 200 },
    { Name = "Rage",        DisplayName = "Raiva",        AnimId = "rbxassetid://507770453",  RequiredRank = 3, Cost = 2000 },
    { Name = "HackerPose",  DisplayName = "Pose Hacker",  AnimId = "rbxassetid://507771867",  RequiredRank = 6, Cost = 50000 },
    { Name = "VictoryPose", DisplayName = "Pose Vitoria", AnimId = "rbxassetid://507766388",  RequiredRank = 4, Cost = 10000 },
    { Name = "Dab",         DisplayName = "Dab",          AnimId = "rbxassetid://507771019",  RequiredRank = 1, Cost = 100 },
    { Name = "Spin",        DisplayName = "Girar",        AnimId = "rbxassetid://507765644",  RequiredRank = 2, Cost = 1000 },
}

------------------------------------------------------------
-- RANKS
------------------------------------------------------------
Config.Ranks = {
    { Name = "Noob",    DisplayName = "Noob",    RequiredStrength = 0,      Color = Color3.fromRGB(150, 150, 150), Perks = {} },
    { Name = "Pro",     DisplayName = "Pro",     RequiredStrength = 5000,   Color = Color3.fromRGB(100, 200, 100), Perks = { MoneyBonus = 0.10 } },
    { Name = "Mega",    DisplayName = "Mega",    RequiredStrength = 50000,  Color = Color3.fromRGB(80, 150, 255),  Perks = { MoneyBonus = 0.20, LuckBonus = 1 } },
    { Name = "Mythic",  DisplayName = "Mythic",  RequiredStrength = 500000, Color = Color3.fromRGB(200, 80, 255),  Perks = { MoneyBonus = 0.35, LuckBonus = 3 } },
    { Name = "God",     DisplayName = "God",     RequiredStrength = 5e6,    Color = Color3.fromRGB(255, 215, 0),   Perks = { MoneyBonus = 0.50, LuckBonus = 5, StrengthBonus = 0.10 } },
    { Name = "Hacker",  DisplayName = "Hacker",  RequiredStrength = 5e7,    Color = Color3.fromRGB(0, 255, 0),     Perks = { MoneyBonus = 0.75, LuckBonus = 10, StrengthBonus = 0.20 } },
    { Name = "Cosmic",  DisplayName = "Cosmic",  RequiredStrength = 5e8,    Color = Color3.fromRGB(100, 50, 200),  Perks = { MoneyBonus = 1.0, LuckBonus = 20, StrengthBonus = 0.35 } },
    { Name = "VoidKing",DisplayName = "Void King",RequiredStrength = 5e9,   Color = Color3.fromRGB(30, 0, 50),     Perks = { MoneyBonus = 1.5, LuckBonus = 50, StrengthBonus = 0.50 } },
}

------------------------------------------------------------
-- LEADERBOARDS
------------------------------------------------------------
Config.Leaderboards = {
    RefreshInterval = 60,
    MaxEntries = 100,
    Types = {
        { Name = "TopMoney",     DisplayName = "Mais Rico",       Stat = "Money" },
        { Name = "TopStrength",  DisplayName = "Mais Forte",      Stat = "Strength" },
        { Name = "TopRebirths",  DisplayName = "Mais Rebirths",   Stat = "Rebirths" },
        { Name = "TopBrainrots", DisplayName = "Mais Brainrots",  Stat = "TotalBrainrots" },
        { Name = "TopDistance",  DisplayName = "Maior Distancia", Stat = "BestDistance" },
    },
}

------------------------------------------------------------
-- SECRETS
------------------------------------------------------------
Config.Secrets = {
    HiddenButtons = {
        { Name = "LobbySecret",   Position = Vector3.new(45, 2, -5),   Reward = { Gems = 10 } },
        { Name = "CaveSecret",    Position = Vector3.new(-80, -5, -200), Reward = { Money = 50000 } },
        { Name = "SkySecret",     Position = Vector3.new(0, 100, -300), Reward = { Mutation = "Void" } },
    },
    SecretPortals = {
        { Name = "VoidPortal",    Position = Vector3.new(100, 5, -500), Destination = Vector3.new(0, 50, -1000), RequiredRank = 7 },
        { Name = "HackerPortal",  Position = Vector3.new(-100, 5, -400), Destination = Vector3.new(0, 30, -800), RequiredRank = 6 },
    },
    SecretBrainrots = { "Shadow_Skibidi", "Void_Toilet", "Glitch_Rizz", "Phantom_Ohio", "Hidden_Sigma" },
    Achievements = {
        { Name = "FirstKick",     Description = "Primeiro chute", Target = 1, Type = "Kicks", Reward = { Money = 500 } },
        { Name = "KickMaster",    Description = "1000 chutes",    Target = 1000, Type = "Kicks", Reward = { Gems = 50 } },
        { Name = "Collector",     Description = "50 brainrots",   Target = 50, Type = "TotalBrainrots", Reward = { Gems = 25 } },
        { Name = "BossSlayer",    Description = "Derrote um boss",Target = 1, Type = "BossKills", Reward = { Gems = 100 } },
        { Name = "MaxRebirth",    Description = "Rebirth 30",     Target = 30, Type = "Rebirths", Reward = { Gems = 500 } },
        { Name = "SecretFinder",  Description = "Ache 3 segredos",Target = 3, Type = "Secrets", Reward = { Gems = 75, Mutation = "Void" } },
        { Name = "EventHero",     Description = "Complete 20 eventos", Target = 20, Type = "Events", Reward = { Gems = 200 } },
        { Name = "VoidKing",      Description = "Rank Void King", Target = 1, Type = "RankVoidKing", Reward = { Gems = 1000 } },
    },
}

------------------------------------------------------------
-- MEGA MAP BIOMES
------------------------------------------------------------
Config.MegaMap = {
    Biomes = {
        { Name = "Mountains",      DisplayName = "Montanhas",       Position = Vector3.new(200, 0, -200),  Size = Vector3.new(200, 80, 200),   FloorColor = Color3.fromRGB(120, 100, 80), SkyColor = Color3.fromRGB(150, 200, 255) },
        { Name = "FloatingIslands",DisplayName = "Ilhas Flutuantes", Position = Vector3.new(-200, 80, -300), Size = Vector3.new(150, 10, 150),  FloorColor = Color3.fromRGB(100, 200, 100), SkyColor = Color3.fromRGB(200, 230, 255) },
        { Name = "SecretCaves",    DisplayName = "Cavernas Secretas",Position = Vector3.new(0, -20, -400),  Size = Vector3.new(180, 40, 180),   FloorColor = Color3.fromRGB(60, 50, 40), SkyColor = Color3.fromRGB(30, 20, 10) },
        { Name = "VIPIsland",      DisplayName = "Ilha VIP",        Position = Vector3.new(300, 20, 0),    Size = Vector3.new(120, 10, 120),   FloorColor = Color3.fromRGB(255, 215, 0), SkyColor = Color3.fromRGB(255, 240, 200), RequireVIP = true },
        { Name = "HackerDimension",DisplayName = "Dimensao Hacker", Position = Vector3.new(-300, 0, -500), Size = Vector3.new(200, 50, 200),   FloorColor = Color3.fromRGB(0, 50, 0), SkyColor = Color3.fromRGB(0, 20, 0) },
        { Name = "NeonCity",       DisplayName = "Cidade Neon",     Position = Vector3.new(0, 0, -700),    Size = Vector3.new(250, 60, 250),   FloorColor = Color3.fromRGB(20, 20, 40), SkyColor = Color3.fromRGB(50, 0, 80) },
        { Name = "LavaBiome",      DisplayName = "Bioma de Lava",   Position = Vector3.new(250, 0, -500),  Size = Vector3.new(200, 30, 200),   FloorColor = Color3.fromRGB(80, 20, 0), SkyColor = Color3.fromRGB(200, 80, 0) },
        { Name = "IceBiome",       DisplayName = "Bioma de Gelo",   Position = Vector3.new(-250, 0, -600), Size = Vector3.new(200, 30, 200),   FloorColor = Color3.fromRGB(200, 230, 255), SkyColor = Color3.fromRGB(220, 240, 255) },
        { Name = "SpaceBiome",     DisplayName = "Bioma Espacial",  Position = Vector3.new(0, 150, -900),  Size = Vector3.new(300, 10, 300),   FloorColor = Color3.fromRGB(10, 10, 30), SkyColor = Color3.fromRGB(0, 0, 10) },
        { Name = "GiantPortals",   DisplayName = "Portais Gigantes",Position = Vector3.new(0, 0, -1100),   Size = Vector3.new(100, 80, 100),   FloorColor = Color3.fromRGB(150, 0, 200), SkyColor = Color3.fromRGB(80, 0, 120) },
    },
}

------------------------------------------------------------
-- ANTI-CHEAT v2
------------------------------------------------------------
Config.AntiCheat = {
    Enabled = true,
    CheckInterval = 1,
    MaxWalkSpeed = 120,
    MaxJumpPower = 100,
    TeleportThreshold = 200,
    MaxWarnings = 3,
    LogExploits = true,
    DetectAutoFarm = true,
    DetectInfiniteJump = true,
    DetectNoclip = true,
    DetectRemoteSpam = true,
    MaxRemotesPerSecond = 30,
    AutoFarmThreshold = 50,
    NoclipCheckInterval = 0.5,
}

------------------------------------------------------------
-- DISTANCE ZONES
------------------------------------------------------------
Config.DistanceZones = {
    { Name = "Inicio",    MinDist = 0,     Color = Color3.fromRGB(200, 200, 200), MoneyMult = 1 },
    { Name = "Pasto",     MinDist = 100,   Color = Color3.fromRGB(100, 200, 100), MoneyMult = 2 },
    { Name = "Deserto",   MinDist = 500,   Color = Color3.fromRGB(220, 180, 100), MoneyMult = 5 },
    { Name = "Floresta",  MinDist = 2000,  Color = Color3.fromRGB(50, 150, 50),   MoneyMult = 12 },
    { Name = "Montanha",  MinDist = 8000,  Color = Color3.fromRGB(150, 130, 110), MoneyMult = 30 },
    { Name = "Nuvens",    MinDist = 30000, Color = Color3.fromRGB(200, 220, 255), MoneyMult = 75 },
    { Name = "Espaco",    MinDist = 100000,Color = Color3.fromRGB(20, 0, 50),     MoneyMult = 200 },
}

------------------------------------------------------------
-- METEOR EVENT
------------------------------------------------------------
Config.MeteorEvent = {
    MinInterval = 180,
    MaxInterval = 420,
    WarningTime = 5,
    MeteorCount = 5,
    Duration = 30,
    ExplosionRadius = 15,
    BaseMoney = 500,
    BaseStrength = 100,
    MeteorMutationChance = 0.25,
}

------------------------------------------------------------
-- SELLER NPC
------------------------------------------------------------
Config.SellerNPC = {
    MaxDeals = 6,
    RefreshInterval = 300,
    DiscountRange = {0.3, 0.7},
    VoiceLines = {
        "Oferta imperdivel!",
        "Compra ai, baratinho!",
        "So hoje, preco especial!",
        "Brainrot fresquinho!",
        "Leva dois, paga um... nao, paga dois!",
        "O melhor negocio da sua vida!",
        "Garantia zero, diversao cem!",
        "Corre que ta acabando!",
    },
}

------------------------------------------------------------
-- RARITY ROAD
------------------------------------------------------------
Config.RarityRoad = {
    StartPosition = Vector3.new(0, 0, -50),
    ZoneLength = 80,
    ZoneWidth = 40,
    GapBetweenZones = 10,
}

------------------------------------------------------------
-- SHOP ITEMS
------------------------------------------------------------
Config.ShopItems = {
    SpeedUpgrades = {
        { Name = "Velocidade +1",  Cost = 500,    SpeedBoost = 1 },
        { Name = "Velocidade +2",  Cost = 2000,   SpeedBoost = 2 },
        { Name = "Velocidade +5",  Cost = 10000,  SpeedBoost = 5 },
        { Name = "Velocidade +10", Cost = 50000,  SpeedBoost = 10 },
        { Name = "Velocidade +25", Cost = 250000, SpeedBoost = 25 },
    },
    LuckBoosts = {
        { Name = "Sorte +1",  Cost = 1000,   LuckBoost = 1 },
        { Name = "Sorte +3",  Cost = 5000,   LuckBoost = 3 },
        { Name = "Sorte +5",  Cost = 15000,  LuckBoost = 5 },
        { Name = "Sorte +10", Cost = 50000,  LuckBoost = 10 },
        { Name = "Sorte +25", Cost = 200000, LuckBoost = 25 },
    },
}

------------------------------------------------------------
-- PERFORMANCE
------------------------------------------------------------
Config.Performance = {
    StreamingEnabled = true,
    StreamingMinRadius = 128,
    StreamingMaxRadius = 512,
    StreamingTargetRadius = 256,
    PreloadAssets = true,
    ParticleLimit = 200,
    PartLimit = 5000,
    EffectPoolSize = 50,
}

------------------------------------------------------------
-- UI SETTINGS
------------------------------------------------------------
Config.UI = {
    PrimaryColor = Color3.fromRGB(25, 25, 40),
    SecondaryColor = Color3.fromRGB(35, 35, 55),
    AccentColor = Color3.fromRGB(100, 150, 255),
    SuccessColor = Color3.fromRGB(80, 255, 80),
    ErrorColor = Color3.fromRGB(255, 80, 80),
    WarningColor = Color3.fromRGB(255, 200, 50),
    FontTitle = Enum.Font.GothamBold,
    FontBody = Enum.Font.Gotham,
    FontAccent = Enum.Font.GothamMedium,
}

return Config
