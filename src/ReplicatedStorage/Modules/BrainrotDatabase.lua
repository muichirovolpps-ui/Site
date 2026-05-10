--[[
    BrainrotDatabase.lua
    Contains all 128 unique Brainrots organized by rarity.
    Each rarity has 16 Brainrots with unique stats and designs.
]]

local BrainrotDatabase = {}

local function Brainrot(name, displayName, value, size, effect, description)
    return {
        Name = name,
        DisplayName = displayName,
        Value = value,
        Size = size,
        Effect = effect,
        Description = description,
    }
end

BrainrotDatabase.Brainrots = {
    ---------------------------------------------------
    -- BASICO (1-16)
    ---------------------------------------------------
    Basico = {
        Brainrot("Skibidi_Toilet",       "Skibidi Toilet",        10,  1.0, "None",      "O classico toilet cantante"),
        Brainrot("Baby_Shark_Doo",       "Baby Shark Doo",        12,  0.8, "None",      "Tubarao bebe dançante"),
        Brainrot("Fanum_Tax",            "Fanum Tax",             15,  1.1, "None",      "Cobra seu imposto em tudo"),
        Brainrot("Rizz_Cat",             "Rizz Cat",              18,  0.9, "None",      "Gato com muito rizz"),
        Brainrot("Ohio_Rat",             "Ohio Rat",              11,  0.7, "None",      "So em Ohio mesmo"),
        Brainrot("Sigma_Baby",           "Sigma Baby",            20,  0.8, "None",      "Bebe sigma grindset"),
        Brainrot("Gyatt_Frog",           "Gyatt Frog",            14,  0.9, "None",      "Sapo com gyatt"),
        Brainrot("NPC_Walker",           "NPC Walker",            13,  1.0, "None",      "Anda como um NPC"),
        Brainrot("Mewing_Dog",           "Mewing Dog",            16,  1.0, "None",      "Cachorro fazendo mewing"),
        Brainrot("Looksmax_Snail",       "Looksmax Snail",        10,  0.6, "None",      "Caracol no looksmaxxing"),
        Brainrot("Broccoli_Head",        "Broccoli Head",         17,  1.2, "None",      "Cabeca de brocolis"),
        Brainrot("Sussy_Baka",           "Sussy Baka",            19,  1.0, "None",      "Muito suspeito"),
        Brainrot("Bing_Chilling",        "Bing Chilling",         15,  1.1, "None",      "Sorvete gelado demais"),
        Brainrot("Amogus_Mini",          "Amogus Mini",           12,  0.5, "None",      "Mini crewmate sus"),
        Brainrot("Whopper_Whopper",      "Whopper Whopper",       14,  1.3, "None",      "Burger dançante"),
        Brainrot("Backrooms_Entity",     "Backrooms Entity",      21,  1.0, "None",      "Entidade dos backrooms"),
    },

    ---------------------------------------------------
    -- COMUM (17-32)
    ---------------------------------------------------
    Comum = {
        Brainrot("Skibidi_Captain",      "Skibidi Captain",       50,  1.2, "SpeedBoost",    "Capitao dos toilets"),
        Brainrot("Cameraman_Soldier",    "Cameraman Soldier",     55,  1.3, "StrengthBoost", "Soldado cameraman"),
        Brainrot("Grimace_Shake",        "Grimace Shake",         60,  1.4, "MoneyBoost",    "Shake misterioso roxo"),
        Brainrot("Jellybean_King",       "Jellybean King",        45,  1.0, "LuckBoost",     "Rei dos jellybeans"),
        Brainrot("Sigma_Wolf",           "Sigma Wolf",            65,  1.5, "StrengthBoost", "Lobo alfa sigma"),
        Brainrot("Ohio_Boss",            "Ohio Boss",             70,  1.6, "SpeedBoost",    "Boss final de Ohio"),
        Brainrot("Rizz_Master",          "Rizz Master",           58,  1.1, "LuckBoost",     "Mestre do rizz absoluto"),
        Brainrot("Dancing_Cockroach",    "Dancing Cockroach",     48,  0.8, "SpeedBoost",    "Barata dancando"),
        Brainrot("Thicc_Pikachu",        "Thicc Pikachu",         52,  1.2, "MoneyBoost",    "Pikachu fortao"),
        Brainrot("Siren_Head_Mini",      "Siren Head Mini",       62,  1.8, "StrengthBoost", "Mini sirene cabecuda"),
        Brainrot("Huggy_Wuggy_Jr",       "Huggy Wuggy Jr",        56,  1.5, "SpeedBoost",    "Filhote do Huggy"),
        Brainrot("Baldi_Ruler",          "Baldi Ruler",           47,  1.1, "StrengthBoost", "Professor com regua"),
        Brainrot("Doge_Classic",         "Doge Classic",          53,  1.0, "MoneyBoost",    "Much wow very coin"),
        Brainrot("Nyan_Cat_Smol",        "Nyan Cat Smol",         59,  0.9, "SpeedBoost",    "Gatinho arco-iris"),
        Brainrot("MLG_Glasses",          "MLG Glasses",           64,  1.0, "LuckBoost",     "Oculos MLG pro player"),
        Brainrot("Trollface_Ghost",      "Trollface Ghost",       68,  1.2, "LuckBoost",     "Fantasma do trollface"),
    },

    ---------------------------------------------------
    -- RARO (33-48)
    ---------------------------------------------------
    Raro = {
        Brainrot("Titan_Cameraman",      "Titan Cameraman",       200, 2.0, "StrengthBoost", "Cameraman gigante titan"),
        Brainrot("Skibidi_General",      "Skibidi General",       220, 1.8, "MoneyBoost",    "General dos skibidis"),
        Brainrot("Golden_Grimace",       "Golden Grimace",        250, 1.5, "MoneyBoost",    "Grimace dourado raro"),
        Brainrot("Mega_Rizz_Lion",       "Mega Rizz Lion",        230, 1.9, "LuckBoost",     "Leao com mega rizz"),
        Brainrot("Crystal_Fanum",        "Crystal Fanum",         210, 1.3, "MoneyBoost",    "Fanum de cristal"),
        Brainrot("Shadow_Sigma",         "Shadow Sigma",          240, 1.7, "SpeedBoost",    "Sigma das sombras"),
        Brainrot("Electric_Ohio",        "Electric Ohio",         215, 1.4, "SpeedBoost",    "Ohio eletrico"),
        Brainrot("Frost_Mewer",          "Frost Mewer",           225, 1.6, "StrengthBoost", "Mewing congelante"),
        Brainrot("Lava_Broccoli",        "Lava Broccoli",         235, 1.8, "StrengthBoost", "Brocolis de lava"),
        Brainrot("Cyber_Doge",           "Cyber Doge",            245, 1.5, "MoneyBoost",    "Doge cibernetico"),
        Brainrot("Plasma_Toilet",        "Plasma Toilet",         260, 2.1, "SpeedBoost",    "Toilet de plasma"),
        Brainrot("Void_Walker",          "Void Walker",           270, 1.6, "LuckBoost",     "Caminhante do vazio"),
        Brainrot("Storm_Huggy",          "Storm Huggy",           205, 1.9, "StrengthBoost", "Huggy da tempestade"),
        Brainrot("Neon_Shark",           "Neon Shark",            255, 1.7, "SpeedBoost",    "Tubarao neon"),
        Brainrot("Pixel_Ghost",          "Pixel Ghost",           218, 1.2, "LuckBoost",     "Fantasma pixelado"),
        Brainrot("Turbo_Cockroach",      "Turbo Cockroach",       228, 1.1, "SpeedBoost",    "Barata turbo veloz"),
    },

    ---------------------------------------------------
    -- MITICO (49-64)
    ---------------------------------------------------
    Mitico = {
        Brainrot("Astral_Skibidi",       "Astral Skibidi",        800,  2.5, "AllBoost",      "Skibidi dos astros"),
        Brainrot("Titan_Speaker",        "Titan Speaker",         850,  2.8, "StrengthBoost", "Speaker titan colossal"),
        Brainrot("Cosmic_Cameraman",     "Cosmic Cameraman",      900,  2.3, "MoneyBoost",    "Cameraman cosmico"),
        Brainrot("Phoenix_Grimace",      "Phoenix Grimace",       820,  2.0, "MoneyBoost",    "Grimace fenix renascido"),
        Brainrot("Dragon_Sigma",         "Dragon Sigma",          950,  3.0, "StrengthBoost", "Dragao sigma supremo"),
        Brainrot("Quantum_Ohio",         "Quantum Ohio",          880,  2.2, "LuckBoost",     "Ohio quantico impossivel"),
        Brainrot("Nebula_Cat",           "Nebula Cat",            830,  1.8, "SpeedBoost",    "Gato nebulosa estelar"),
        Brainrot("Thunder_Rizz",         "Thunder Rizz",          870,  2.4, "LuckBoost",     "Rizz trovejante"),
        Brainrot("Volcanic_Toilet",      "Volcanic Toilet",       910,  2.6, "StrengthBoost", "Toilet vulcanico"),
        Brainrot("Mystic_Mewer",         "Mystic Mewer",          840,  2.1, "AllBoost",      "Mewer mistico ancestral"),
        Brainrot("Celestial_Doge",       "Celestial Doge",        920,  2.0, "MoneyBoost",    "Doge celestial divino"),
        Brainrot("Inferno_Huggy",        "Inferno Huggy",         860,  2.7, "StrengthBoost", "Huggy do inferno"),
        Brainrot("Galaxy_Frog",          "Galaxy Frog",           890,  1.9, "SpeedBoost",    "Sapo galactico"),
        Brainrot("Prism_Walker",         "Prism Walker",          845,  2.3, "LuckBoost",     "Caminhante prismatico"),
        Brainrot("Frozen_Phoenix",       "Frozen Phoenix",        930,  2.5, "SpeedBoost",    "Fenix de gelo eterno"),
        Brainrot("Dark_Matter_Baby",     "Dark Matter Baby",      960,  1.5, "AllBoost",      "Bebe de materia escura"),
    },

    ---------------------------------------------------
    -- DIVINO (65-80)
    ---------------------------------------------------
    Divino = {
        Brainrot("God_Skibidi",          "God Skibidi",           3000, 3.5, "AllBoost",      "Skibidi deus supremo"),
        Brainrot("Archangel_Cam",        "Archangel Cam",         3200, 3.0, "StrengthBoost", "Cameraman arcanjo"),
        Brainrot("Holy_Grimace",         "Holy Grimace",          3500, 2.8, "MoneyBoost",    "Grimace sagrado"),
        Brainrot("Divine_Dragon",        "Divine Dragon",         3800, 4.0, "AllBoost",      "Dragao divino celestial"),
        Brainrot("Seraph_Sigma",         "Seraph Sigma",          3300, 3.2, "LuckBoost",     "Sigma serafim alado"),
        Brainrot("Eternal_Ohio",         "Eternal Ohio",          3100, 2.5, "SpeedBoost",    "Ohio eterno infinito"),
        Brainrot("Blessed_Mewer",        "Blessed Mewer",         3400, 2.9, "AllBoost",      "Mewer abençoado"),
        Brainrot("Solar_Toilet",         "Solar Toilet",          3600, 3.3, "StrengthBoost", "Toilet do sol"),
        Brainrot("Lunar_Cat",            "Lunar Cat",             3150, 2.6, "SpeedBoost",    "Gato da lua cheia"),
        Brainrot("Heavenly_Doge",        "Heavenly Doge",         3700, 3.1, "MoneyBoost",    "Doge celestial supremo"),
        Brainrot("Sacred_Huggy",         "Sacred Huggy",          3250, 3.4, "StrengthBoost", "Huggy sagrado protetor"),
        Brainrot("Angelic_Frog",         "Angelic Frog",          3050, 2.7, "LuckBoost",     "Sapo angelical"),
        Brainrot("Paradise_Shark",       "Paradise Shark",        3550, 3.0, "SpeedBoost",    "Tubarao do paraiso"),
        Brainrot("Miracle_Baby",         "Miracle Baby",          3900, 2.0, "AllBoost",      "Bebe milagre raro"),
        Brainrot("Light_Bringer",        "Light Bringer",         3450, 3.5, "LuckBoost",     "Traz a luz divina"),
        Brainrot("Spirit_Phoenix",       "Spirit Phoenix",        3650, 3.2, "AllBoost",      "Fenix espiritual"),
    },

    ---------------------------------------------------
    -- CLASSICO (81-96)
    ---------------------------------------------------
    Classico = {
        Brainrot("Retro_Skibidi",        "Retro Skibidi",         10000, 4.0, "AllBoost",      "Skibidi retro classico"),
        Brainrot("Vintage_Cameraman",    "Vintage Cameraman",     11000, 3.5, "StrengthBoost", "Cameraman vintage raro"),
        Brainrot("Antique_Grimace",      "Antique Grimace",       12000, 3.8, "MoneyBoost",    "Grimace antiguidade"),
        Brainrot("Classic_Dragon",       "Classic Dragon",        13000, 4.5, "AllBoost",      "Dragao classico lendario"),
        Brainrot("Heritage_Sigma",       "Heritage Sigma",        10500, 3.6, "LuckBoost",     "Sigma patrimonio"),
        Brainrot("Timeless_Ohio",        "Timeless Ohio",         11500, 3.2, "SpeedBoost",    "Ohio atemporal"),
        Brainrot("Ancient_Mewer",        "Ancient Mewer",         12500, 4.2, "AllBoost",      "Mewer ancestral milenar"),
        Brainrot("Golden_Age_Toilet",    "Golden Age Toilet",     13500, 3.9, "StrengthBoost", "Toilet era dourada"),
        Brainrot("Renaissance_Cat",      "Renaissance Cat",       10800, 3.3, "SpeedBoost",    "Gato renascentista"),
        Brainrot("Epic_Doge",            "Epic Doge",             14000, 3.7, "MoneyBoost",    "Doge epico lendario"),
        Brainrot("Legendary_Huggy",      "Legendary Huggy",       11800, 4.1, "StrengthBoost", "Huggy lendario"),
        Brainrot("Mythical_Frog",        "Mythical Frog",         12800, 3.4, "LuckBoost",     "Sapo mitico antigo"),
        Brainrot("Royal_Shark",          "Royal Shark",           13200, 4.0, "SpeedBoost",    "Tubarao real da coroa"),
        Brainrot("Emperor_Baby",         "Emperor Baby",          14500, 2.5, "AllBoost",      "Bebe imperador supremo"),
        Brainrot("Dynasty_Phoenix",      "Dynasty Phoenix",       13800, 4.3, "AllBoost",      "Fenix da dinastia"),
        Brainrot("Noble_Walker",         "Noble Walker",          11200, 3.8, "LuckBoost",     "Caminhante nobre"),
    },

    ---------------------------------------------------
    -- OG (97-112)
    ---------------------------------------------------
    OG = {
        Brainrot("OG_Skibidi_Prime",     "OG Skibidi Prime",      40000, 5.0, "AllBoost",      "O primeiro skibidi OG"),
        Brainrot("OG_Titan_Cam",         "OG Titan Cam",          42000, 4.5, "StrengthBoost", "Titan cameraman original"),
        Brainrot("OG_Grimace_Alpha",     "OG Grimace Alpha",      45000, 4.8, "MoneyBoost",    "Grimace alfa original"),
        Brainrot("OG_Dragon_Lord",       "OG Dragon Lord",        50000, 5.5, "AllBoost",      "Senhor dragao OG"),
        Brainrot("OG_Sigma_King",        "OG Sigma King",         43000, 4.6, "LuckBoost",     "Rei sigma original"),
        Brainrot("OG_Ohio_Legend",       "OG Ohio Legend",        41000, 4.2, "SpeedBoost",    "Lenda de Ohio OG"),
        Brainrot("OG_Supreme_Mewer",     "OG Supreme Mewer",      48000, 5.2, "AllBoost",      "Mewer supremo original"),
        Brainrot("OG_Mega_Toilet",       "OG Mega Toilet",        46000, 5.0, "StrengthBoost", "Mega toilet OG"),
        Brainrot("OG_Phantom_Cat",       "OG Phantom Cat",        44000, 4.3, "SpeedBoost",    "Gato fantasma OG"),
        Brainrot("OG_Diamond_Doge",      "OG Diamond Doge",       52000, 4.7, "MoneyBoost",    "Doge diamante original"),
        Brainrot("OG_Eternal_Huggy",     "OG Eternal Huggy",      47000, 5.1, "StrengthBoost", "Huggy eterno OG"),
        Brainrot("OG_Void_Frog",         "OG Void Frog",          43500, 4.4, "LuckBoost",     "Sapo do vazio OG"),
        Brainrot("OG_Cosmic_Shark",      "OG Cosmic Shark",       49000, 5.0, "SpeedBoost",    "Tubarao cosmico OG"),
        Brainrot("OG_Infinity_Baby",     "OG Infinity Baby",      55000, 3.0, "AllBoost",      "Bebe infinito OG"),
        Brainrot("OG_Omega_Phoenix",     "OG Omega Phoenix",      51000, 5.3, "AllBoost",      "Fenix omega original"),
        Brainrot("OG_Nexus_Walker",      "OG Nexus Walker",       45500, 4.8, "LuckBoost",     "Caminhante nexus OG"),
    },

    ---------------------------------------------------
    -- HACKER (113-128)
    ---------------------------------------------------
    Hacker = {
        Brainrot("Hack_Skibidi_Zero",    "Hack Skibidi Zero",     150000, 6.0, "AllBoost",      "Skibidi hackeado nivel 0"),
        Brainrot("Hack_Glitch_Cam",      "Hack Glitch Cam",       160000, 5.5, "StrengthBoost", "Cameraman glitchado"),
        Brainrot("Hack_Matrix_Grimace",  "Hack Matrix Grimace",   175000, 5.8, "MoneyBoost",    "Grimace da matrix"),
        Brainrot("Hack_Virus_Dragon",    "Hack Virus Dragon",     200000, 7.0, "AllBoost",      "Dragao virus supremo"),
        Brainrot("Hack_Root_Sigma",      "Hack Root Sigma",       165000, 5.6, "LuckBoost",     "Sigma com root access"),
        Brainrot("Hack_Firewall_Ohio",   "Hack Firewall Ohio",    155000, 5.2, "SpeedBoost",    "Ohio atras do firewall"),
        Brainrot("Hack_Crypto_Mewer",    "Hack Crypto Mewer",     185000, 6.2, "AllBoost",      "Mewer criptografado"),
        Brainrot("Hack_DDoS_Toilet",     "Hack DDoS Toilet",      170000, 6.0, "StrengthBoost", "Toilet ataque DDoS"),
        Brainrot("Hack_Trojan_Cat",      "Hack Trojan Cat",       162000, 5.3, "SpeedBoost",    "Gato trojan furtivo"),
        Brainrot("Hack_Exploit_Doge",    "Hack Exploit Doge",     190000, 5.7, "MoneyBoost",    "Doge exploit master"),
        Brainrot("Hack_Malware_Huggy",   "Hack Malware Huggy",    175000, 6.1, "StrengthBoost", "Huggy malware perigoso"),
        Brainrot("Hack_Phishing_Frog",   "Hack Phishing Frog",    168000, 5.4, "LuckBoost",     "Sapo phishing esperto"),
        Brainrot("Hack_Worm_Shark",      "Hack Worm Shark",       182000, 6.0, "SpeedBoost",    "Tubarao worm invasor"),
        Brainrot("Hack_Zero_Day_Baby",   "Hack Zero Day Baby",    220000, 4.0, "AllBoost",      "Bebe zero-day lendario"),
        Brainrot("Hack_Omega_Phoenix",   "Hack Omega Phoenix",    195000, 6.5, "AllBoost",      "Fenix omega hackeada"),
        Brainrot("Hack_God_Walker",      "Hack God Walker",       210000, 6.3, "AllBoost",      "Caminhante deus hacker"),
    },
}

function BrainrotDatabase.GetBrainrotsByRarity(rarityName)
    return BrainrotDatabase.Brainrots[rarityName] or {}
end

function BrainrotDatabase.GetBrainrot(rarityName, brainrotName)
    local list = BrainrotDatabase.Brainrots[rarityName]
    if not list then return nil end
    for _, b in ipairs(list) do
        if b.Name == brainrotName then
            return b
        end
    end
    return nil
end

function BrainrotDatabase.GetAllBrainrots()
    local all = {}
    for rarityName, list in pairs(BrainrotDatabase.Brainrots) do
        for _, b in ipairs(list) do
            local copy = {}
            for k, v in pairs(b) do copy[k] = v end
            copy.Rarity = rarityName
            table.insert(all, copy)
        end
    end
    return all
end

function BrainrotDatabase.GetTotalCount()
    local count = 0
    for _, list in pairs(BrainrotDatabase.Brainrots) do
        count = count + #list
    end
    return count
end

return BrainrotDatabase
