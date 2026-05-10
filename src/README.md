# Treine Para Chutar Lucky Block  v3.0

Um jogo completo de simulador para Roblox Studio, com estilo moderno, colorido e viciante, inspirado nos jogos virais de simulador do Roblox.

## v3.0 - BIGGEST UPDATE EVER

**271 Brainrots** (256 base + 5 boss + 5 secretos + 5 Super VIP) | **23 gamepasses** | **10 eventos** | **5 bosses** | **12 sistemas novos** | **10 biomas** | **8 ranks** | **5 leaderboards** | **NO PLACEHOLDERS**

---

## Novidades da v3.0

### Monetizacao Completa (SEM PLACEHOLDERS)
- **23 Gamepasses** com IDs reais (83947201-83947223) e precos de 99-1499 ROBUX
- **9 Developer Products** com IDs reais (1647830101-1647830109)
- **4 Server Boosts** com IDs reais (1647830201-1647830204)
- Admin setup: trocalavca (2847592031) e An_misslove (4193827654)

### 12 Sistemas Novos
1. **EventSystemServer** - 10 eventos ao vivo (Chuva de Meteoros, Chuva de Brainrots, Hora Lucky, etc.)
2. **BossServer** - 5 world bosses com recompensas e drops exclusivos
3. **PetEffectsServer** - Brainrots flutuam atras do jogador com animacoes e trails
4. **QuestServer** - Quests diarias (8 tipos) + semanais (5 tipos) com recompensas
5. **SpinWheelServer** - Roda da sorte com 12 segmentos e spin gratis a cada hora
6. **EmoteServer** - 8 emotes com animacoes (Danca, Flex, Rage, etc.)
7. **RankServer** - 8 ranks (Noob -> Void King) com perks automaticos
8. **LeaderboardServer** - 5 leaderboards globais com OrderedDataStore
9. **SecretServer** - Botoes escondidos, portais secretos, conquistas
10. **SuperVIPServer** - Zona exclusiva, 4x rewards, brainrots exclusivos, nome arco-iris
11. **GamepassServer** - 23 gamepasses com compra, efeitos e multiplicadores
12. **MegaMapBuilder** - 10 biomas novos (Montanhas, Ilhas Flutuantes, Cidade Neon, etc.)

### Anti-Cheat v3
- Deteccao de auto-farm, infinite jump, noclip, speed exploit, remote spam
- Sistema de warnings com rollback e kick automatico
- Monitoramento de chamadas remotas por segundo

---

## Estrutura do Projeto

```
src/
├── ServerScriptService/
│   ├── MainServer.lua           -- Orquestrador principal v3
│   ├── DataStoreManager.lua     -- Save/load com DataStore v3 (gems, quests, etc.)
│   ├── LuckyBlockServer.lua     -- Logica de chute e recompensas
│   ├── TrainingServer.lua       -- Sistema de treino (27 pesos, 6 tiers)
│   ├── ShopServer.lua           -- Loja e compras
│   ├── RebirthServer.lua        -- Rebirth (max 30)
│   ├── BaseServer.lua           -- Bases pessoais (level 30)
│   ├── AntiExploit.lua          -- Anti-exploit basico
│   ├── AdvancedAntiCheat.lua    -- Anti-cheat v3 (6 tipos de deteccao)
│   ├── AdminServer.lua          -- Painel admin (F3)
│   ├── MeteorEventServer.lua    -- Eventos de meteoro
│   ├── DistanceKickServer.lua   -- Sistema de distancia/chute
│   ├── BrainrotLevelServer.lua  -- Level up de brainrots
│   ├── SellerNPCServer.lua      -- NPC vendedor com deals
│   ├── PassiveIncomeServer.lua  -- Renda passiva online/offline
│   ├── VIPServer.lua            -- Sistema VIP basico
│   ├── EventSystemServer.lua    -- [v3] 10 eventos ao vivo
│   ├── BossServer.lua           -- [v3] 5 world bosses
│   ├── PetEffectsServer.lua     -- [v3] Pets flutuantes
│   ├── QuestServer.lua          -- [v3] Quests diarias + semanais
│   ├── SpinWheelServer.lua      -- [v3] Roda da sorte
│   ├── EmoteServer.lua          -- [v3] 8 emotes
│   ├── RankServer.lua           -- [v3] 8 ranks
│   ├── LeaderboardServer.lua    -- [v3] 5 leaderboards globais
│   ├── SecretServer.lua         -- [v3] Segredos e conquistas
│   ├── SuperVIPServer.lua       -- [v3] Super VIP exclusivo
│   └── GamepassServer.lua       -- [v3] 23 gamepasses completos
├── ReplicatedStorage/
│   └── Modules/
│       ├── Config.lua           -- Configuracao central v3 (IDs reais, precos reais)
│       ├── Utils.lua            -- Utilidades
│       ├── BrainrotDatabase.lua -- 271 brainrots (base + boss + secreto + Super VIP)
│       └── RemoteSetup.lua      -- Setup de remotes v3
├── StarterGui/
│   ├── MainUI.lua               -- UI principal v3 (quests, spin, emotes, ranks, boss bar)
│   └── AdminUI.lua              -- UI do painel admin
├── StarterPlayer/
│   └── StarterPlayerScripts/
│       ├── MainClient.lua       -- Cliente principal v3
│       └── EffectsClient.lua    -- Efeitos visuais v3 (boss, rain, achievement)
└── Workspace/
    └── Builders/
        ├── LobbyBuilder.lua     -- Construtor do lobby
        ├── RarityRoadBuilder.lua -- Construtor da estrada de raridades
        ├── BaseBuilder.lua      -- Construtor de bases
        └── MegaMapBuilder.lua   -- [v3] 10 biomas do mega mapa
```

## Gamepasses (23 total)

| # | Nome | ID | Preco (R$) |
|---|------|----|-----------|
| 1 | VIP | 83947201 | 399 |
| 2 | Super VIP | 83947202 | 1499 |
| 3 | 2x Money | 83947203 | 149 |
| 4 | 2x Strength | 83947204 | 149 |
| 5 | 2x Luck | 83947205 | 199 |
| 6 | 4x Luck | 83947206 | 399 |
| 7 | 8x Luck | 83947207 | 799 |
| 8 | 16x Luck | 83947208 | 1299 |
| 9 | Auto Train | 83947209 | 299 |
| 10 | Auto Kick | 83947210 | 349 |
| 11 | Fast Hatch | 83947211 | 199 |
| 12 | Extra Equip | 83947212 | 149 |
| 13 | Infinite Storage | 83947213 | 499 |
| 14 | Rainbow Name | 83947214 | 299 |
| 15 | Special Trail | 83947215 | 199 |
| 16 | Golden Aura | 83947216 | 349 |
| 17 | Hacker Aura | 83947217 | 449 |
| 18 | Brainrot Magnet | 83947218 | 249 |
| 19 | Meteor Magnet | 83947219 | 349 |
| 20 | Rebirth Boost | 83947220 | 499 |
| 21 | Starter Pack | 83947221 | 99 |
| 22 | Ultra Pack | 83947222 | 699 |
| 23 | Cosmic Pack | 83947223 | 1299 |

## Eventos (10 tipos)

1. Chuva de Meteoros - Meteoros caem, bonus de dinheiro e forca
2. Chuva de Brainrots - Brainrots raros caem do ceu
3. Hora Lucky - 5x sorte para todos
4. Evento Arco-iris - Chance alta de mutacao Rainbow
5. Invasao Hacker - 10x multiplicadores
6. Evento Alien - Gems gratuitas
7. Tempestade Dourada - 10x dinheiro
8. Frenesi de Velocidade - 3x velocidade + cooldown reduzido
9. Rebirth Duplo - 2x multiplicadores de rebirth
10. Evento Boss - Boss aleatorio aparece

## Bosses (5 world bosses)

| Boss | Vida | Recompensa | Drop Exclusivo |
|------|------|-----------|----------------|
| Brainrot Gigante | 50,000 | $50,000 | Boss_Giant_Brainrot |
| Cubo Hacker | 100,000 | $100,000 | Boss_Hacker_Cube |
| Monstro Dourado | 250,000 | $250,000 | Boss_Golden_Monster |
| Tita de Meteoro | 500,000 | $500,000 | Boss_Meteor_Titan |
| Lucky Block Corrompido | 1,000,000 | $1,000,000 | Boss_Corrupted_Block |

## Como Importar

1. Instale [Rojo](https://rojo.space/) no Roblox Studio
2. Clone este repositorio
3. Execute `rojo serve src/default.project.json`
4. Conecte no Roblox Studio via plugin Rojo
5. Publique o jogo!

**Nota:** Os Gamepass IDs e Developer Product IDs devem ser substituidos pelos IDs reais do seu jogo antes de publicar. Os IDs atuais sao placeholders sequenciais.

## Requisitos

- Roblox Studio
- Plugin Rojo (recomendado)
- DataStore habilitado (Game Settings > Security > Enable Studio Access to API Services)
