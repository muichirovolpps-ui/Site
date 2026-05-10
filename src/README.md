# Treine Para Chutar Lucky Block  v2.0

Um jogo completo de simulador para Roblox Studio, com estilo moderno, colorido e viciante, inspirado nos jogos virais de simulador do Roblox.

## v2.0 - MAJOR UPDATE

**256 Brainrots** (32 por raridade) | **24 zonas** (8 raridades + 16 arenas) | **27 pesos** | **30 rebirths** | **5 mutacoes** | **13 novos sistemas**

---

## Estrutura do Projeto

```
src/
├── ServerScriptService/
│   ├── MainServer.lua           -- Inicializacao principal do servidor
│   ├── DataStoreManager.lua     -- Sistema de save/load com DataStore v2
│   ├── LuckyBlockServer.lua     -- Logica de chute e recompensas
│   ├── TrainingServer.lua       -- Sistema de treino (27 pesos, 6 tiers)
│   ├── ShopServer.lua           -- Loja e gamepasses
│   ├── RebirthServer.lua        -- Rebirth reworked (max 30, dual req)
│   ├── BaseServer.lua           -- Base pessoal (level 30, 5/server)
│   ├── AntiExploit.lua          -- Protecao anti-exploit basica
│   ├── AdminServer.lua          -- [NEW] Sistema admin completo (12 comandos)
│   ├── MeteorEventServer.lua    -- [NEW] Chuva de meteoros aleatoria
│   ├── DistanceKickServer.lua   -- [NEW] Sistema de distancia e chute reworked
│   ├── BrainrotLevelServer.lua  -- [NEW] Level up brainrots com dinheiro
│   ├── SellerNPCServer.lua      -- [NEW] NPC vendedor com ofertas
│   ├── PassiveIncomeServer.lua  -- [NEW] Renda passiva online/offline
│   ├── VIPServer.lua            -- [NEW] VIP + Server Boosts
│   └── AdvancedAntiCheat.lua    -- [NEW] Anti-cheat avancado
│
├── ReplicatedStorage/
│   ├── Modules/
│   │   ├── Config.lua           -- Configuracoes centrais v2 (expandido)
│   │   ├── Utils.lua            -- Funcoes utilitarias
│   │   ├── BrainrotDatabase.lua -- 256 Brainrots (32 por raridade)
│   │   └── RemoteSetup.lua      -- Criacao de RemoteEvents/Functions v2
│   └── Remotes/
│
├── StarterGui/
│   ├── MainUI.lua               -- UI principal (v2: kick btn, notifs, etc)
│   └── AdminUI.lua              -- [NEW] Painel admin (F3 ou botao)
│
├── StarterPlayer/StarterPlayerScripts/
│   ├── MainClient.lua           -- Script principal do cliente v2
│   └── EffectsClient.lua        -- Efeitos visuais v2 (meteoro, fly, etc)
│
├── Workspace/Builders/
│   ├── LobbyBuilder.lua         -- Construtor do lobby
│   ├── RarityRoadBuilder.lua    -- Construtor da estrada (8 + 16 arenas)
│   └── BaseBuilder.lua          -- Construtor de bases pessoais
│
└── default.project.json         -- Rojo project file (atualizado)
```

---

## Novos Sistemas v2.0

### 1. Admin Panel
- Botao "ADMIN" na tela + tecla F3
- Console de comandos com animacao
- 12 comandos: givemoney, givestrength, giverebirths, teleport, kick, ban, spawnmeteor, startevent, spawnbrainrot, givemutation, resetplayer, spawnboss
- Sistema de permissoes (AdminUserIds no Config)
- Log completo de acoes

### 2. 256 Brainrots
- 32 por raridade (era 16): Basico, Comum, Raro, Mitico, Divino, Classico, OG, Hacker
- Cada com nome, valor, multiplicador e efeito unicos
- 5 mutacoes: Gold (2x), Diamond (5x), Rainbow (10x), Pink (3x), Meteor (8x)

### 3. 16 Arenas Extras
- Vulcao, Abismo, Cristal, Tundra, Tempestade, Nebulosa, Inferno, Quantico
- Dimensional, Celestial, Sombrio, Cosmico, Eterno, Supremo, Omni, Infinito
- Temas unicos, cores, recompensas progressivas

### 4. 27 Pesos (6 Tiers)
- Basic (5), Giant (5), Neon (5), Hacker (5), Cosmic (4), Mythical (3)
- Multiplicadores de 1x ate 250.000x

### 5. Rebirth Reworked
- Max 30 rebirths (era 100)
- Requer AMBOS: Forca + Dinheiro
- +0.5x Money, +5% Strength, +1 Sorte por rebirth

### 6. Chute Reworked + Distancia
- Botao grande animado
- Power bar com cores (Red/Yellow/Green/Rainbow)
- Personagem voa, gira, trail, camera shake
- Distancia baseada em: Forca, Multiplicadores, Rebirths
- 7 zonas de distancia com recompensas

### 7. Chuva de Meteoros
- Eventos aleatorios (3-7 min)
- 5 meteoros com fogo, explosoes, particulas
- Recompensas: dinheiro, forca, Mutacao Meteor (25% chance)
- Aviso visual antes do evento

### 8. Base Level 30
- Max 5 bases por servidor
- Level 1-30 com custos crescentes
- Cada level: +2 slots, decoracoes, luzes neon
- 12 upgrades com nivel minimo requerido

### 9. Renda Passiva
- Brainrots geram renda automatica a cada 30s
- Recompensas offline (max 8h, 50% eficiencia)
- Popup de recompensa offline ao entrar

### 10. Brainrot Leveling
- Max nivel 50 por brainrot
- Custo crescente (base 100, mult 1.35x)
- +10% income e +5% stats por nivel

### 11. Vendedor NPC
- 6 ofertas com desconto (30-70%)
- Refresh a cada 300s
- Voice lines engracadas
- Compra direta com dinheiro

### 12. VIP + Server Boosts
- VIP: 2x Money/Strength/Luck, tag dourada, particulas
- Server Boosts: 2x/4x/8x/16x Luck para TODOS (30-60 min)
- Tags overhead e chat

### 13. Anti-Cheat Avancado
- Detecta: voo, speed hack, teleport, wall clip
- Rollback para posicao valida
- 3 avisos = kick automatico
- Log de todas as violacoes

---

## Como Importar

### Opcao 1: Rojo
1. Instale [Rojo](https://rojo.space/)
2. No terminal: `rojo serve default.project.json`
3. No Roblox Studio: conecte ao Rojo

### Opcao 2: Manual
1. Copie cada arquivo .lua para o servico correto no Roblox Studio
2. Siga a estrutura de pastas descrita acima
3. Crie a pasta "Remotes" dentro de ReplicatedStorage

### Configuracao
- Edite `Config.lua` para ajustar valores, IDs de gamepass, e AdminUserIds
- Substitua os IDs de gamepass (definidos como 0) pelos seus IDs reais
- Adicione seus UserIds ao `Config.AdminUserIds` para acesso admin

---

## Requisitos Tecnicos

- Roblox Studio atualizado
- DataStore habilitado (Settings > Security > Enable Studio Access)
- GamePasses criados no Roblox Developer Portal
- Compativel com PC e Mobile
