--[[
    BrainrotDatabase.lua  v3.0
    Contains all 256 unique Brainrots organized by rarity (32 per rarity),
    plus 5 Boss-drop Brainrots, 5 Secret Brainrots, and 5 Super VIP exclusives.
    Total: 271 Brainrots.
]]

local BrainrotDatabase = {}

local function B(name, displayName, value, size, effect, description)
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
    -- BASICO (1-32)
    ---------------------------------------------------
    Basico = {
        B("Skibidi_Toilet",       "Skibidi Toilet",        10,  1.0, "None",          "O classico toilet cantante"),
        B("Baby_Shark_Doo",       "Baby Shark Doo",        12,  0.8, "None",          "Tubarao bebe dancante"),
        B("Fanum_Tax",            "Fanum Tax",             15,  1.1, "None",          "Cobra seu imposto em tudo"),
        B("Rizz_Cat",             "Rizz Cat",              18,  0.9, "None",          "Gato com muito rizz"),
        B("Ohio_Rat",             "Ohio Rat",              11,  0.7, "None",          "So em Ohio mesmo"),
        B("Sigma_Baby",           "Sigma Baby",            20,  0.8, "None",          "Bebe sigma grindset"),
        B("Gyatt_Frog",           "Gyatt Frog",            14,  0.9, "None",          "Sapo com gyatt"),
        B("NPC_Walker",           "NPC Walker",            13,  1.0, "None",          "Anda como um NPC"),
        B("Mewing_Dog",           "Mewing Dog",            16,  1.0, "None",          "Cachorro fazendo mewing"),
        B("Looksmax_Snail",       "Looksmax Snail",        10,  0.6, "None",          "Caracol no looksmaxxing"),
        B("Broccoli_Head",        "Broccoli Head",         17,  1.2, "None",          "Cabeca de brocolis"),
        B("Sussy_Baka",           "Sussy Baka",            19,  1.0, "None",          "Muito suspeito"),
        B("Bing_Chilling",        "Bing Chilling",         15,  1.1, "None",          "Sorvete gelado demais"),
        B("Amogus_Mini",          "Amogus Mini",           12,  0.5, "None",          "Mini crewmate sus"),
        B("Whopper_Whopper",      "Whopper Whopper",       14,  1.3, "None",          "Burger dancante"),
        B("Backrooms_Entity",     "Backrooms Entity",      21,  1.0, "None",          "Entidade dos backrooms"),
        -- NEW 16
        B("Skibidi_Minion",       "Skibidi Minion",        11,  0.7, "None",          "Ajudante do skibidi"),
        B("TikTok_Dancer",        "TikTok Dancer",         13,  0.9, "None",          "Danca sem parar"),
        B("Fortnite_Default",     "Fortnite Default",      16,  1.0, "None",          "Default dance eterno"),
        B("Grimace_Baby",         "Grimace Baby",          18,  0.8, "None",          "Bebe do grimace"),
        B("Sus_Potato",           "Sus Potato",            10,  0.6, "None",          "Batata suspeita"),
        B("Dabbing_Skeleton",     "Dabbing Skeleton",      15,  1.1, "None",          "Esqueleto no dab"),
        B("Nerd_Emoji",           "Nerd Emoji",            14,  0.8, "None",          "Akchually"),
        B("Vine_Boom",            "Vine Boom",             19,  1.0, "None",          "Faz o som do vine boom"),
        B("Cope_Fish",            "Cope Fish",             12,  0.7, "None",          "Peixe no cope"),
        B("L_Plus_Ratio",         "L + Ratio",             17,  1.0, "None",          "Ratio absoluto"),
        B("No_Bitches",           "No Bitches",            20,  1.2, "None",          "Megamind perguntando"),
        B("Morbius_Fan",          "Morbius Fan",           11,  0.9, "None",          "Its morbin time"),
        B("Emotional_Damage",     "Emotional Damage",      16,  1.0, "None",          "Dano emocional critico"),
        B("Goofy_Ahh",            "Goofy Ahh",            13,  0.8, "None",          "Muito goofy"),
        B("Bussin_Burrito",       "Bussin Burrito",        15,  1.1, "None",          "Burrito que ta bussin"),
        B("Sheesh_Bird",          "Sheesh Bird",           22,  0.9, "None",          "Passaro do sheesh"),
    },

    ---------------------------------------------------
    -- COMUM (33-64)
    ---------------------------------------------------
    Comum = {
        B("Skibidi_Captain",      "Skibidi Captain",       50,  1.2, "SpeedBoost",    "Capitao dos toilets"),
        B("Cameraman_Soldier",    "Cameraman Soldier",     55,  1.3, "StrengthBoost", "Soldado cameraman"),
        B("Grimace_Shake",        "Grimace Shake",         60,  1.4, "MoneyBoost",    "Shake misterioso roxo"),
        B("Jellybean_King",       "Jellybean King",        45,  1.0, "LuckBoost",     "Rei dos jellybeans"),
        B("Sigma_Wolf",           "Sigma Wolf",            65,  1.5, "StrengthBoost", "Lobo alfa sigma"),
        B("Ohio_Boss",            "Ohio Boss",             70,  1.6, "SpeedBoost",    "Boss final de Ohio"),
        B("Rizz_Master",          "Rizz Master",           58,  1.1, "LuckBoost",     "Mestre do rizz absoluto"),
        B("Dancing_Cockroach",    "Dancing Cockroach",     48,  0.8, "SpeedBoost",    "Barata dancando"),
        B("Thicc_Pikachu",        "Thicc Pikachu",         52,  1.2, "MoneyBoost",    "Pikachu fortao"),
        B("Siren_Head_Mini",      "Siren Head Mini",       62,  1.8, "StrengthBoost", "Mini sirene cabecuda"),
        B("Huggy_Wuggy_Jr",       "Huggy Wuggy Jr",        56,  1.5, "SpeedBoost",    "Filhote do Huggy"),
        B("Baldi_Ruler",          "Baldi Ruler",           47,  1.1, "StrengthBoost", "Professor com regua"),
        B("Doge_Classic",         "Doge Classic",          53,  1.0, "MoneyBoost",    "Much wow very coin"),
        B("Nyan_Cat_Smol",        "Nyan Cat Smol",         59,  0.9, "SpeedBoost",    "Gatinho arco-iris"),
        B("MLG_Glasses",          "MLG Glasses",           64,  1.0, "LuckBoost",     "Oculos MLG pro player"),
        B("Trollface_Ghost",      "Trollface Ghost",       68,  1.2, "LuckBoost",     "Fantasma do trollface"),
        -- NEW 16
        B("Drip_Goku",            "Drip Goku",             72,  1.4, "StrengthBoost", "Goku com drip supremo"),
        B("Walter_White_Jr",      "Walter White Jr",       66,  1.3, "MoneyBoost",    "Say my name junior"),
        B("Shrek_Swamp",          "Shrek Swamp",           58,  1.5, "StrengthBoost", "Do pantano com amor"),
        B("Speed_Runner",         "Speed Runner",          75,  1.1, "SpeedBoost",    "Corre em world record"),
        B("Karen_Manager",        "Karen Manager",         54,  1.2, "MoneyBoost",    "Quer falar com o gerente"),
        B("Buff_Doge",            "Buff Doge",             80,  1.6, "StrengthBoost", "Doge bombado demais"),
        B("Capybara_Chill",       "Capybara Chill",        63,  1.0, "LuckBoost",     "Capivara no relax"),
        B("Pepe_Rare",            "Pepe Rare",             69,  1.1, "LuckBoost",     "Pepe raro encontrado"),
        B("Distorted_Cat",        "Distorted Cat",         57,  0.9, "SpeedBoost",    "Gato distorcido"),
        B("Gigachad_Mini",        "Gigachad Mini",         78,  1.4, "StrengthBoost", "Mini gigachad"),
        B("Stonks_Man",           "Stonks Man",            71,  1.2, "MoneyBoost",    "Meme man fazendo stonks"),
        B("Bonk_Dog",             "Bonk Dog",              55,  1.0, "StrengthBoost", "Vai pra jail"),
        B("Rickroll_Ghost",       "Rickroll Ghost",        67,  1.3, "LuckBoost",     "Never gonna give you up"),
        B("Harambe_Spirit",       "Harambe Spirit",        73,  1.5, "AllBoost",      "Espirito do Harambe"),
        B("Ugandan_Knuckles",     "Ugandan Knuckles",      61,  1.1, "SpeedBoost",    "Do you know da wae"),
        B("Wednesday_Frog",       "Wednesday Frog",        65,  1.0, "LuckBoost",     "It is Wednesday my dudes"),
    },

    ---------------------------------------------------
    -- RARO (65-96)
    ---------------------------------------------------
    Raro = {
        B("Titan_Cameraman",      "Titan Cameraman",       200, 2.0, "StrengthBoost", "Cameraman gigante titan"),
        B("Skibidi_General",      "Skibidi General",       220, 1.8, "MoneyBoost",    "General dos skibidis"),
        B("Golden_Grimace",       "Golden Grimace",        250, 1.5, "MoneyBoost",    "Grimace dourado raro"),
        B("Mega_Rizz_Lion",       "Mega Rizz Lion",        230, 1.9, "LuckBoost",     "Leao com mega rizz"),
        B("Crystal_Fanum",        "Crystal Fanum",         210, 1.3, "MoneyBoost",    "Fanum de cristal"),
        B("Shadow_Sigma",         "Shadow Sigma",          240, 1.7, "SpeedBoost",    "Sigma das sombras"),
        B("Electric_Ohio",        "Electric Ohio",         215, 1.4, "SpeedBoost",    "Ohio eletrico"),
        B("Frost_Mewer",          "Frost Mewer",           225, 1.6, "StrengthBoost", "Mewing congelante"),
        B("Lava_Broccoli",        "Lava Broccoli",         235, 1.8, "StrengthBoost", "Brocolis de lava"),
        B("Cyber_Doge",           "Cyber Doge",            245, 1.5, "MoneyBoost",    "Doge cibernetico"),
        B("Plasma_Toilet",        "Plasma Toilet",         260, 2.1, "SpeedBoost",    "Toilet de plasma"),
        B("Void_Walker",          "Void Walker",           270, 1.6, "LuckBoost",     "Caminhante do vazio"),
        B("Storm_Huggy",          "Storm Huggy",           205, 1.9, "StrengthBoost", "Huggy da tempestade"),
        B("Neon_Shark",           "Neon Shark",            255, 1.7, "SpeedBoost",    "Tubarao neon"),
        B("Pixel_Ghost",          "Pixel Ghost",           218, 1.2, "LuckBoost",     "Fantasma pixelado"),
        B("Turbo_Cockroach",      "Turbo Cockroach",       228, 1.1, "SpeedBoost",    "Barata turbo veloz"),
        -- NEW 16
        B("Thunder_Cameraman",    "Thunder Cameraman",     280, 2.2, "StrengthBoost", "Cameraman do trovao"),
        B("Magma_Toilet",         "Magma Toilet",          265, 2.0, "StrengthBoost", "Toilet de magma"),
        B("Frozen_Sigma",         "Frozen Sigma",          290, 1.8, "SpeedBoost",    "Sigma congelado"),
        B("Toxic_Frog",           "Toxic Frog",            240, 1.5, "LuckBoost",     "Sapo toxico brilhante"),
        B("Stealth_Cat",          "Stealth Cat",           275, 1.6, "SpeedBoost",    "Gato invisivel ninja"),
        B("Iron_Doge",            "Iron Doge",             300, 2.3, "StrengthBoost", "Doge de ferro blindado"),
        B("Gravity_Walker",       "Gravity Walker",        255, 1.7, "AllBoost",      "Caminhante da gravidade"),
        B("Sonic_Cockroach",      "Sonic Cockroach",       285, 1.4, "SpeedBoost",    "Barata sonica"),
        B("Emerald_Grimace",      "Emerald Grimace",       310, 1.9, "MoneyBoost",    "Grimace de esmeralda"),
        B("Chrome_Huggy",         "Chrome Huggy",          270, 2.1, "StrengthBoost", "Huggy cromado"),
        B("Sapphire_Lion",        "Sapphire Lion",         295, 1.8, "LuckBoost",     "Leao de safira"),
        B("Nitro_Shark",          "Nitro Shark",           260, 1.6, "SpeedBoost",    "Tubarao com nitro"),
        B("Acid_Broccoli",        "Acid Broccoli",         245, 1.5, "StrengthBoost", "Brocolis acido"),
        B("Binary_Ghost",         "Binary Ghost",          305, 1.3, "LuckBoost",     "Fantasma binario 01010"),
        B("Uranium_Baby",         "Uranium Baby",          320, 1.4, "AllBoost",      "Bebe radioativo"),
        B("Obsidian_Knight",      "Obsidian Knight",       335, 2.4, "StrengthBoost", "Cavaleiro de obsidiana"),
    },

    ---------------------------------------------------
    -- MITICO (97-128)
    ---------------------------------------------------
    Mitico = {
        B("Astral_Skibidi",       "Astral Skibidi",        800,  2.5, "AllBoost",      "Skibidi dos astros"),
        B("Titan_Speaker",        "Titan Speaker",         850,  2.8, "StrengthBoost", "Speaker titan colossal"),
        B("Cosmic_Cameraman",     "Cosmic Cameraman",      900,  2.3, "MoneyBoost",    "Cameraman cosmico"),
        B("Phoenix_Grimace",      "Phoenix Grimace",       820,  2.0, "MoneyBoost",    "Grimace fenix renascido"),
        B("Dragon_Sigma",         "Dragon Sigma",          950,  3.0, "StrengthBoost", "Dragao sigma supremo"),
        B("Quantum_Ohio",         "Quantum Ohio",          880,  2.2, "LuckBoost",     "Ohio quantico impossivel"),
        B("Nebula_Cat",           "Nebula Cat",            830,  1.8, "SpeedBoost",    "Gato nebulosa estelar"),
        B("Thunder_Rizz",         "Thunder Rizz",          870,  2.4, "LuckBoost",     "Rizz trovejante"),
        B("Volcanic_Toilet",      "Volcanic Toilet",       910,  2.6, "StrengthBoost", "Toilet vulcanico"),
        B("Mystic_Mewer",         "Mystic Mewer",          840,  2.1, "AllBoost",      "Mewer mistico ancestral"),
        B("Celestial_Doge",       "Celestial Doge",        920,  2.0, "MoneyBoost",    "Doge celestial divino"),
        B("Inferno_Huggy",        "Inferno Huggy",         860,  2.7, "StrengthBoost", "Huggy do inferno"),
        B("Galaxy_Frog",          "Galaxy Frog",           890,  1.9, "SpeedBoost",    "Sapo galactico"),
        B("Prism_Walker",         "Prism Walker",          845,  2.3, "LuckBoost",     "Caminhante prismatico"),
        B("Frozen_Phoenix",       "Frozen Phoenix",        930,  2.5, "SpeedBoost",    "Fenix de gelo eterno"),
        B("Dark_Matter_Baby",     "Dark Matter Baby",      960,  1.5, "AllBoost",      "Bebe de materia escura"),
        -- NEW 16
        B("Chrono_Skibidi",       "Chrono Skibidi",        980,  2.6, "AllBoost",      "Skibidi do tempo"),
        B("Plasma_Dragon",        "Plasma Dragon",         1050, 3.2, "StrengthBoost", "Dragao de plasma puro"),
        B("Void_Speaker",         "Void Speaker",          920,  2.8, "MoneyBoost",    "Speaker do vazio"),
        B("Aurora_Cat",           "Aurora Cat",            870,  2.0, "SpeedBoost",    "Gato aurora boreal"),
        B("Warp_Frog",            "Warp Frog",             940,  2.1, "SpeedBoost",    "Sapo que dobra o espaco"),
        B("Nuclear_Toilet",       "Nuclear Toilet",        1000, 2.9, "StrengthBoost", "Toilet nuclear"),
        B("Dimension_Doge",       "Dimension Doge",        1020, 2.4, "AllBoost",      "Doge dimensional"),
        B("Eclipse_Huggy",        "Eclipse Huggy",         890,  2.7, "StrengthBoost", "Huggy do eclipse"),
        B("Starfall_Lion",        "Starfall Lion",         960,  2.5, "LuckBoost",     "Leao chuva de estrelas"),
        B("Gravity_Grimace",      "Gravity Grimace",       910,  2.3, "MoneyBoost",    "Grimace gravitacional"),
        B("Photon_Walker",        "Photon Walker",         1040, 2.2, "SpeedBoost",    "Caminhante de fotons"),
        B("Antimatter_Baby",      "Antimatter Baby",       1100, 1.8, "AllBoost",      "Bebe de antimateria"),
        B("Supernova_Shark",      "Supernova Shark",       970,  2.6, "SpeedBoost",    "Tubarao supernova"),
        B("Cosmic_Broccoli",      "Cosmic Broccoli",       880,  2.4, "StrengthBoost", "Brocolis cosmico"),
        B("Zenith_Mewer",         "Zenith Mewer",          1030, 2.5, "AllBoost",      "Mewer no zenite"),
        B("Infinity_Ghost",       "Infinity Ghost",        1080, 2.0, "LuckBoost",     "Fantasma infinito"),
    },

    ---------------------------------------------------
    -- DIVINO (129-160)
    ---------------------------------------------------
    Divino = {
        B("God_Skibidi",          "God Skibidi",           3000, 3.5, "AllBoost",      "Skibidi deus supremo"),
        B("Archangel_Cam",        "Archangel Cam",         3200, 3.0, "StrengthBoost", "Cameraman arcanjo"),
        B("Holy_Grimace",         "Holy Grimace",          3500, 2.8, "MoneyBoost",    "Grimace sagrado"),
        B("Divine_Dragon",        "Divine Dragon",         3800, 4.0, "AllBoost",      "Dragao divino celestial"),
        B("Seraph_Sigma",         "Seraph Sigma",          3300, 3.2, "LuckBoost",     "Sigma serafim alado"),
        B("Eternal_Ohio",         "Eternal Ohio",          3100, 2.5, "SpeedBoost",    "Ohio eterno infinito"),
        B("Blessed_Mewer",        "Blessed Mewer",         3400, 2.9, "AllBoost",      "Mewer abencoado"),
        B("Solar_Toilet",         "Solar Toilet",          3600, 3.3, "StrengthBoost", "Toilet do sol"),
        B("Lunar_Cat",            "Lunar Cat",             3150, 2.6, "SpeedBoost",    "Gato da lua cheia"),
        B("Heavenly_Doge",        "Heavenly Doge",         3700, 3.1, "MoneyBoost",    "Doge celestial supremo"),
        B("Sacred_Huggy",         "Sacred Huggy",          3250, 3.4, "StrengthBoost", "Huggy sagrado protetor"),
        B("Angelic_Frog",         "Angelic Frog",          3050, 2.7, "LuckBoost",     "Sapo angelical"),
        B("Paradise_Shark",       "Paradise Shark",        3550, 3.0, "SpeedBoost",    "Tubarao do paraiso"),
        B("Miracle_Baby",         "Miracle Baby",          3900, 2.0, "AllBoost",      "Bebe milagre raro"),
        B("Light_Bringer",        "Light Bringer",         3450, 3.5, "LuckBoost",     "Traz a luz divina"),
        B("Spirit_Phoenix",       "Spirit Phoenix",        3650, 3.2, "AllBoost",      "Fenix espiritual"),
        -- NEW 16
        B("Cherub_Cameraman",     "Cherub Cameraman",      3850, 3.3, "StrengthBoost", "Cameraman querubim"),
        B("Halo_Grimace",         "Halo Grimace",          4000, 3.0, "MoneyBoost",    "Grimace com aureola"),
        B("Ascended_Sigma",       "Ascended Sigma",        4200, 3.6, "AllBoost",      "Sigma ascendido"),
        B("Starborn_Cat",         "Starborn Cat",          3750, 2.8, "SpeedBoost",    "Gato nascido das estrelas"),
        B("Radiant_Doge",         "Radiant Doge",          4100, 3.4, "MoneyBoost",    "Doge radiante"),
        B("Sanctified_Toilet",    "Sanctified Toilet",     3950, 3.5, "StrengthBoost", "Toilet santificado"),
        B("Wings_Of_Light",       "Wings Of Light",        4300, 3.2, "SpeedBoost",    "Asas de luz pura"),
        B("Grace_Walker",         "Grace Walker",          3800, 3.1, "LuckBoost",     "Caminhante da graca"),
        B("Nimbus_Frog",          "Nimbus Frog",           3650, 2.9, "SpeedBoost",    "Sapo das nuvens"),
        B("Resurrection_Huggy",   "Resurrection Huggy",    4150, 3.7, "StrengthBoost", "Huggy ressuscitado"),
        B("Prophecy_Lion",        "Prophecy Lion",         4050, 3.3, "LuckBoost",     "Leao da profecia"),
        B("Blessing_Shark",       "Blessing Shark",        3900, 3.0, "MoneyBoost",    "Tubarao da bencao"),
        B("Virtue_Broccoli",      "Virtue Broccoli",       3700, 2.8, "StrengthBoost", "Brocolis da virtude"),
        B("Rapture_Ghost",        "Rapture Ghost",         4250, 2.5, "AllBoost",      "Fantasma do arrebatamento"),
        B("Throne_Baby",          "Throne Baby",           4400, 2.2, "AllBoost",      "Bebe do trono divino"),
        B("Eden_Phoenix",         "Eden Phoenix",          4500, 3.8, "AllBoost",      "Fenix do Eden"),
    },

    ---------------------------------------------------
    -- CLASSICO (161-192)
    ---------------------------------------------------
    Classico = {
        B("Retro_Skibidi",        "Retro Skibidi",         10000, 4.0, "AllBoost",      "Skibidi retro classico"),
        B("Vintage_Cameraman",    "Vintage Cameraman",     11000, 3.5, "StrengthBoost", "Cameraman vintage raro"),
        B("Antique_Grimace",      "Antique Grimace",       12000, 3.8, "MoneyBoost",    "Grimace antiguidade"),
        B("Classic_Dragon",       "Classic Dragon",        13000, 4.5, "AllBoost",      "Dragao classico lendario"),
        B("Heritage_Sigma",       "Heritage Sigma",        10500, 3.6, "LuckBoost",     "Sigma patrimonio"),
        B("Timeless_Ohio",        "Timeless Ohio",         11500, 3.2, "SpeedBoost",    "Ohio atemporal"),
        B("Ancient_Mewer",        "Ancient Mewer",         12500, 4.2, "AllBoost",      "Mewer ancestral milenar"),
        B("Golden_Age_Toilet",    "Golden Age Toilet",     13500, 3.9, "StrengthBoost", "Toilet era dourada"),
        B("Renaissance_Cat",      "Renaissance Cat",       10800, 3.3, "SpeedBoost",    "Gato renascentista"),
        B("Epic_Doge",            "Epic Doge",             14000, 3.7, "MoneyBoost",    "Doge epico lendario"),
        B("Legendary_Huggy",      "Legendary Huggy",       11800, 4.1, "StrengthBoost", "Huggy lendario"),
        B("Mythical_Frog",        "Mythical Frog",         12800, 3.4, "LuckBoost",     "Sapo mitico antigo"),
        B("Royal_Shark",          "Royal Shark",           13200, 4.0, "SpeedBoost",    "Tubarao real da coroa"),
        B("Emperor_Baby",         "Emperor Baby",          14500, 2.5, "AllBoost",      "Bebe imperador supremo"),
        B("Dynasty_Phoenix",      "Dynasty Phoenix",       13800, 4.3, "AllBoost",      "Fenix da dinastia"),
        B("Noble_Walker",         "Noble Walker",          11200, 3.8, "LuckBoost",     "Caminhante nobre"),
        -- NEW 16
        B("Baroque_Toilet",       "Baroque Toilet",        15000, 4.0, "StrengthBoost", "Toilet barroco ornamentado"),
        B("Victorian_Cat",        "Victorian Cat",         12500, 3.5, "SpeedBoost",    "Gato vitoriano elegante"),
        B("Medieval_Doge",        "Medieval Doge",         16000, 4.2, "StrengthBoost", "Doge cavaleiro medieval"),
        B("Samurai_Sigma",        "Samurai Sigma",         14800, 4.4, "StrengthBoost", "Sigma samurai"),
        B("Pharaoh_Grimace",      "Pharaoh Grimace",       15500, 3.8, "MoneyBoost",    "Grimace farao do egito"),
        B("Viking_Huggy",         "Viking Huggy",          13500, 4.3, "StrengthBoost", "Huggy viking guerreiro"),
        B("Aztec_Frog",           "Aztec Frog",            14200, 3.6, "LuckBoost",     "Sapo asteca sagrado"),
        B("Roman_Lion",           "Roman Lion",            16500, 4.5, "AllBoost",      "Leao do imperio romano"),
        B("Spartan_Walker",       "Spartan Walker",        15200, 4.1, "StrengthBoost", "Caminhante espartano"),
        B("Pirate_Shark",         "Pirate Shark",          13800, 3.9, "MoneyBoost",    "Tubarao pirata"),
        B("Gladiator_Baby",       "Gladiator Baby",        17000, 2.8, "AllBoost",      "Bebe gladiador"),
        B("Shogun_Dragon",        "Shogun Dragon",         18000, 4.8, "AllBoost",      "Dragao shogun japones"),
        B("Templar_Ghost",        "Templar Ghost",         14500, 3.4, "LuckBoost",     "Fantasma templario"),
        B("Centurion_Cameraman",  "Centurion Cameraman",   15800, 4.0, "StrengthBoost", "Cameraman centuriao"),
        B("Oracle_Mewer",         "Oracle Mewer",          16200, 3.7, "AllBoost",      "Mewer oraculo"),
        B("Conquistador_Broccoli","Conquistador Broccoli", 14000, 3.5, "StrengthBoost", "Brocolis conquistador"),
    },

    ---------------------------------------------------
    -- OG (193-224)
    ---------------------------------------------------
    OG = {
        B("OG_Skibidi_Prime",     "OG Skibidi Prime",      40000, 5.0, "AllBoost",      "O primeiro skibidi OG"),
        B("OG_Titan_Cam",         "OG Titan Cam",          42000, 4.5, "StrengthBoost", "Titan cameraman original"),
        B("OG_Grimace_Alpha",     "OG Grimace Alpha",      45000, 4.8, "MoneyBoost",    "Grimace alfa original"),
        B("OG_Dragon_Lord",       "OG Dragon Lord",        50000, 5.5, "AllBoost",      "Senhor dragao OG"),
        B("OG_Sigma_King",        "OG Sigma King",         43000, 4.6, "LuckBoost",     "Rei sigma original"),
        B("OG_Ohio_Legend",       "OG Ohio Legend",        41000, 4.2, "SpeedBoost",    "Lenda de Ohio OG"),
        B("OG_Supreme_Mewer",     "OG Supreme Mewer",      48000, 5.2, "AllBoost",      "Mewer supremo original"),
        B("OG_Mega_Toilet",       "OG Mega Toilet",        46000, 5.0, "StrengthBoost", "Mega toilet OG"),
        B("OG_Phantom_Cat",       "OG Phantom Cat",        44000, 4.3, "SpeedBoost",    "Gato fantasma OG"),
        B("OG_Diamond_Doge",      "OG Diamond Doge",       52000, 4.7, "MoneyBoost",    "Doge diamante original"),
        B("OG_Eternal_Huggy",     "OG Eternal Huggy",      47000, 5.1, "StrengthBoost", "Huggy eterno OG"),
        B("OG_Void_Frog",         "OG Void Frog",          43500, 4.4, "LuckBoost",     "Sapo do vazio OG"),
        B("OG_Cosmic_Shark",      "OG Cosmic Shark",       49000, 5.0, "SpeedBoost",    "Tubarao cosmico OG"),
        B("OG_Infinity_Baby",     "OG Infinity Baby",      55000, 3.0, "AllBoost",      "Bebe infinito OG"),
        B("OG_Omega_Phoenix",     "OG Omega Phoenix",      51000, 5.3, "AllBoost",      "Fenix omega original"),
        B("OG_Nexus_Walker",      "OG Nexus Walker",       45500, 4.8, "LuckBoost",     "Caminhante nexus OG"),
        -- NEW 16
        B("OG_Genesis_Toilet",    "OG Genesis Toilet",     56000, 5.2, "StrengthBoost", "Toilet genesis primeiro"),
        B("OG_Alpha_Cameraman",   "OG Alpha Cameraman",    58000, 5.0, "StrengthBoost", "Cameraman alfa OG"),
        B("OG_Beta_Grimace",      "OG Beta Grimace",       53000, 4.8, "MoneyBoost",    "Grimace beta original"),
        B("OG_Proto_Dragon",      "OG Proto Dragon",       62000, 5.8, "AllBoost",      "Proto dragao ancestral"),
        B("OG_Source_Sigma",      "OG Source Sigma",        54000, 4.7, "LuckBoost",     "Sigma codigo fonte"),
        B("OG_Legacy_Cat",        "OG Legacy Cat",         50000, 4.5, "SpeedBoost",    "Gato legado OG"),
        B("OG_Original_Mewer",    "OG Original Mewer",     59000, 5.4, "AllBoost",      "Mewer original primeiro"),
        B("OG_Pioneer_Doge",      "OG Pioneer Doge",       57000, 4.9, "MoneyBoost",    "Doge pioneiro"),
        B("OG_Founder_Huggy",     "OG Founder Huggy",      55500, 5.3, "StrengthBoost", "Huggy fundador"),
        B("OG_First_Frog",        "OG First Frog",         51000, 4.6, "LuckBoost",     "Primeiro sapo da historia"),
        B("OG_Epoch_Shark",       "OG Epoch Shark",        60000, 5.2, "SpeedBoost",    "Tubarao da era OG"),
        B("OG_Dawn_Baby",         "OG Dawn Baby",          65000, 3.5, "AllBoost",      "Bebe do amanhecer OG"),
        B("OG_Primordial_Ghost",  "OG Primordial Ghost",   53500, 4.4, "LuckBoost",     "Fantasma primordial"),
        B("OG_Ancestor_Lion",     "OG Ancestor Lion",      58500, 5.1, "StrengthBoost", "Leao ancestral OG"),
        B("OG_Root_Broccoli",     "OG Root Broccoli",      52000, 4.3, "StrengthBoost", "Brocolis raiz original"),
        B("OG_Matrix_Phoenix",    "OG Matrix Phoenix",     63000, 5.6, "AllBoost",      "Fenix da matrix OG"),
    },

    ---------------------------------------------------
    -- HACKER (225-256)
    ---------------------------------------------------
    Hacker = {
        B("Hack_Skibidi_Zero",    "Hack Skibidi Zero",     150000, 6.0, "AllBoost",      "Skibidi hackeado nivel 0"),
        B("Hack_Glitch_Cam",      "Hack Glitch Cam",       160000, 5.5, "StrengthBoost", "Cameraman glitchado"),
        B("Hack_Matrix_Grimace",  "Hack Matrix Grimace",   175000, 5.8, "MoneyBoost",    "Grimace da matrix"),
        B("Hack_Virus_Dragon",    "Hack Virus Dragon",     200000, 7.0, "AllBoost",      "Dragao virus supremo"),
        B("Hack_Root_Sigma",      "Hack Root Sigma",       165000, 5.6, "LuckBoost",     "Sigma com root access"),
        B("Hack_Firewall_Ohio",   "Hack Firewall Ohio",    155000, 5.2, "SpeedBoost",    "Ohio atras do firewall"),
        B("Hack_Crypto_Mewer",    "Hack Crypto Mewer",     185000, 6.2, "AllBoost",      "Mewer criptografado"),
        B("Hack_DDoS_Toilet",     "Hack DDoS Toilet",      170000, 6.0, "StrengthBoost", "Toilet ataque DDoS"),
        B("Hack_Trojan_Cat",      "Hack Trojan Cat",       162000, 5.3, "SpeedBoost",    "Gato trojan furtivo"),
        B("Hack_Exploit_Doge",    "Hack Exploit Doge",     190000, 5.7, "MoneyBoost",    "Doge exploit master"),
        B("Hack_Malware_Huggy",   "Hack Malware Huggy",    175000, 6.1, "StrengthBoost", "Huggy malware perigoso"),
        B("Hack_Phishing_Frog",   "Hack Phishing Frog",    168000, 5.4, "LuckBoost",     "Sapo phishing esperto"),
        B("Hack_Worm_Shark",      "Hack Worm Shark",       182000, 6.0, "SpeedBoost",    "Tubarao worm invasor"),
        B("Hack_Zero_Day_Baby",   "Hack Zero Day Baby",    220000, 4.0, "AllBoost",      "Bebe zero-day lendario"),
        B("Hack_Omega_Phoenix",   "Hack Omega Phoenix",    195000, 6.5, "AllBoost",      "Fenix omega hackeada"),
        B("Hack_God_Walker",      "Hack God Walker",       210000, 6.3, "AllBoost",      "Caminhante deus hacker"),
        -- NEW 16
        B("Hack_Backdoor_Toilet", "Hack Backdoor Toilet",  230000, 6.2, "StrengthBoost", "Toilet backdoor secreto"),
        B("Hack_Ransomware_Cat",  "Hack Ransomware Cat",   245000, 5.8, "MoneyBoost",    "Gato ransomware"),
        B("Hack_Botnet_Doge",     "Hack Botnet Doge",      260000, 6.0, "AllBoost",      "Doge botnet supremo"),
        B("Hack_Kernel_Dragon",   "Hack Kernel Dragon",    300000, 7.5, "AllBoost",      "Dragao do kernel"),
        B("Hack_SQL_Sigma",       "Hack SQL Sigma",        240000, 5.9, "LuckBoost",     "Sigma SQL injection"),
        B("Hack_Keylogger_Frog",  "Hack Keylogger Frog",   235000, 5.5, "LuckBoost",     "Sapo keylogger"),
        B("Hack_Spyware_Huggy",   "Hack Spyware Huggy",    255000, 6.4, "StrengthBoost", "Huggy spyware"),
        B("Hack_Rootkit_Lion",    "Hack Rootkit Lion",     270000, 6.1, "StrengthBoost", "Leao rootkit"),
        B("Hack_Darknet_Shark",   "Hack Darknet Shark",    280000, 6.3, "SpeedBoost",    "Tubarao da darknet"),
        B("Hack_Quantum_Ghost",   "Hack Quantum Ghost",    250000, 5.7, "AllBoost",      "Fantasma quantico hacker"),
        B("Hack_Overflow_Baby",   "Hack Overflow Baby",    310000, 4.5, "AllBoost",      "Bebe buffer overflow"),
        B("Hack_Deepfake_Mewer",  "Hack Deepfake Mewer",   275000, 6.0, "AllBoost",      "Mewer deepfake"),
        B("Hack_Cipher_Broccoli", "Hack Cipher Broccoli",  242000, 5.6, "StrengthBoost", "Brocolis cifrado"),
        B("Hack_Payload_Walker",  "Hack Payload Walker",   290000, 6.5, "SpeedBoost",    "Caminhante payload"),
        B("Hack_APT_Phoenix",     "Hack APT Phoenix",      320000, 7.0, "AllBoost",      "Fenix APT avancada"),
        B("Hack_Singularity",     "Hack Singularity",      350000, 8.0, "AllBoost",      "Singularidade hacker final"),
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

------------------------------------------------------------
-- BOSS DROP BRAINROTS (obtained from world bosses)
------------------------------------------------------------
BrainrotDatabase.BossBrainrots = {
    B("Boss_Giant_Brainrot",  "Brainrot Gigante Boss",   50000,  5.0, "Earthquake",   "Dropado pelo Brainrot Gigante"),
    B("Boss_Hacker_Cube",     "Cubo Hacker Boss",        120000, 4.0, "MatrixRain",   "Dropado pelo Cubo Hacker"),
    B("Boss_Golden_Monster",  "Monstro Dourado Boss",    300000, 5.5, "GoldenAura",   "Dropado pelo Monstro Dourado"),
    B("Boss_Meteor_Titan",    "Tita Meteoro Boss",       800000, 6.0, "MeteorStorm",  "Dropado pelo Tita de Meteoro"),
    B("Boss_Corrupted_Block", "Lucky Block Corrompido",  2e6,    7.0, "Corruption",   "Dropado pelo Lucky Block Corrompido"),
}

------------------------------------------------------------
-- SECRET BRAINROTS (found via hidden buttons/portals)
------------------------------------------------------------
BrainrotDatabase.SecretBrainrots = {
    B("Shadow_Skibidi",  "Skibidi das Sombras",  100000,  3.0, "ShadowCloak",  "Encontrado em segredo escondido"),
    B("Void_Toilet",     "Toilet do Vazio",      250000,  3.5, "VoidRift",     "Encontrado no portal do vazio"),
    B("Glitch_Rizz",     "Rizz Glitchado",       500000,  3.0, "Glitch",       "Encontrado em falha dimensional"),
    B("Phantom_Ohio",    "Ohio Fantasma",         180000,  4.0, "PhantomPhase", "Encontrado na caverna secreta"),
    B("Hidden_Sigma",    "Sigma Oculto",          750000,  3.5, "Invisibility", "Encontrado pelo botao secreto"),
}

------------------------------------------------------------
-- SUPER VIP EXCLUSIVE BRAINROTS
------------------------------------------------------------
BrainrotDatabase.SuperVIPBrainrots = {
    B("Super_Skibidi_King",  "Rei Skibidi Super",   1e6,   5.0, "RoyalAura",    "Exclusivo Super VIP"),
    B("Rainbow_Sigma",       "Sigma Arco-iris",     1.5e6, 4.5, "RainbowTrail", "Exclusivo Super VIP"),
    B("Cosmic_Rizz_Lord",   "Lord Rizz Cosmico",   2e6,   5.5, "CosmicPower",  "Exclusivo Super VIP"),
    B("Ultra_Ohio_Boss",     "Boss Ohio Ultra",     3e6,   6.0, "UltraStrike",  "Exclusivo Super VIP"),
    B("Void_Brainrot_Prime", "Brainrot Prime Void", 5e6,   7.0, "VoidPrime",    "Exclusivo Super VIP"),
}

function BrainrotDatabase.GetTotalCount()
    local count = 0
    for _, list in pairs(BrainrotDatabase.Brainrots) do
        count = count + #list
    end
    count = count + #BrainrotDatabase.BossBrainrots
    count = count + #BrainrotDatabase.SecretBrainrots
    count = count + #BrainrotDatabase.SuperVIPBrainrots
    return count
end

function BrainrotDatabase.FindBrainrot(name)
    for _, list in pairs(BrainrotDatabase.Brainrots) do
        for _, b in ipairs(list) do
            if b.Name == name then return b end
        end
    end
    for _, b in ipairs(BrainrotDatabase.BossBrainrots) do
        if b.Name == name then return b end
    end
    for _, b in ipairs(BrainrotDatabase.SecretBrainrots) do
        if b.Name == name then return b end
    end
    for _, b in ipairs(BrainrotDatabase.SuperVIPBrainrots) do
        if b.Name == name then return b end
    end
    return nil
end

return BrainrotDatabase
