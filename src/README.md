# Treine Para Chutar Lucky Block

Um jogo completo de simulador para Roblox Studio, com estilo moderno, colorido e viciante, inspirado nos jogos virais de simulador do Roblox.

## Visao Geral

O jogador treina forca e velocidade para chutar Lucky Blocks e desbloquear Brainrots cada vez mais fortes. O jogo inclui 128 Brainrots unicos, 8 raridades, 4 mutacoes, sistema de base pessoal, rebirth, loja, e muito mais.

---

## Estrutura do Projeto

```
src/
├── ServerScriptService/        -- Scripts do servidor
│   ├── MainServer.lua          -- Inicializacao principal do servidor
│   ├── DataStoreManager.lua    -- Sistema de save/load
│   ├── LuckyBlockServer.lua    -- Logica de chute e recompensas
│   ├── TrainingServer.lua      -- Sistema de treino de forca/velocidade
│   ├── ShopServer.lua          -- Loja e gamepasses
│   ├── RebirthServer.lua       -- Sistema de rebirth
│   ├── BaseServer.lua          -- Sistema de base pessoal
│   └── AntiExploit.lua         -- Protecao anti-exploit
│
├── ReplicatedStorage/          -- Modulos compartilhados
│   ├── Modules/
│   │   ├── Config.lua          -- Configuracoes centrais do jogo
│   │   ├── Utils.lua           -- Funcoes utilitarias
│   │   ├── BrainrotDatabase.lua-- 128 Brainrots (16 por raridade)
│   │   └── RemoteSetup.lua     -- Criacao de RemoteEvents/Functions
│   └── Remotes/
│       └── RemoteSetup.lua     -- (duplicado para referencia)
│
├── StarterGui/                 -- Interface do jogador
│   └── MainUI.lua              -- UI completa (loja, index, inventario, etc)
│
├── StarterPlayer/
│   └── StarterPlayerScripts/   -- Scripts do cliente
│       ├── MainClient.lua      -- Inicializacao do cliente
│       └── EffectsClient.lua   -- Efeitos visuais e animacoes
│
└── Workspace/
    └── Builders/               -- Construtores do mundo
        ├── LobbyBuilder.lua    -- Lobby interativo com neon
        ├── RarityRoadBuilder.lua-- Estrada das raridades (8 zonas)
        └── BaseBuilder.lua     -- Bases pessoais dos jogadores
```

---

## Como Importar no Roblox Studio

### Metodo 1: Importacao Manual

1. Abra o **Roblox Studio** e crie um novo **Baseplate**.
2. Para cada arquivo `.lua`, crie o script correspondente no local correto:

| Pasta do Projeto | Local no Roblox Studio | Tipo de Script |
|---|---|---|
| `ServerScriptService/*.lua` | ServerScriptService | Script |
| `ReplicatedStorage/Modules/*.lua` | ReplicatedStorage > Modules (Folder) | ModuleScript |
| `StarterGui/MainUI.lua` | StarterGui | LocalScript |
| `StarterPlayer/StarterPlayerScripts/*.lua` | StarterPlayerScripts | LocalScript |
| `Workspace/Builders/*.lua` | Workspace > Builders (Folder) | ModuleScript |

3. **Crie as pastas** necessarias:
   - `ReplicatedStorage` > `Modules` (Folder)
   - `ReplicatedStorage` > `Remotes` (Folder - sera preenchida automaticamente)
   - `Workspace` > `Builders` (Folder)

4. Copie o conteudo de cada arquivo `.lua` para o script correspondente.

### Metodo 2: Usando Rojo

Se voce usa [Rojo](https://rojo.space/), pode sincronizar diretamente:

1. Instale o Rojo
2. Crie um arquivo `default.project.json` na raiz do projeto
3. Configure o mapeamento das pastas
4. Use `rojo serve` para sincronizar

---

## Sistemas do Jogo

### Gameplay Principal
- Treine **forca** clicando nos pesos
- Compre **pesos melhores** para mais forca por clique
- Chute **Lucky Blocks** com a barra de poder
- Colete **Brainrots** raros
- Armazene na sua **base pessoal**
- Faca **rebirth** para multiplicadores permanentes
- Avance pela **Estrada das Raridades**

### 8 Raridades
1. **Basico** - Inicio da jornada
2. **Comum** - Primeiros upgrades
3. **Raro** - Brainrots com efeitos
4. **Mitico** - Poder cosmico
5. **Divino** - Forca divina
6. **Classico** - Lendas do passado
7. **OG** - Os originais
8. **Hacker** - Poder maximo

### 128 Brainrots Unicos
Cada raridade tem 16 Brainrots com:
- Nomes e descricoes unicas
- Valores diferentes
- Efeitos especiais (SpeedBoost, StrengthBoost, MoneyBoost, LuckBoost, AllBoost)
- Tamanhos variados

### 4 Mutacoes
- **Gold** - 2x valor (10% chance)
- **Diamond** - 5x valor (4% chance)
- **Rainbow** - 10x valor (1% chance)
- **Pink** - 3x valor (6% chance)

### Sistema de Barra de Poder
- Bad (0-25%): 0.25x recompensas
- Good (25-50%): 0.60x recompensas
- Great (50-75%): 1.00x recompensas
- Perfect (75-100%): 2.00x recompensas

### UI Completa
- Barra de stats (Money, Strength, Speed, Luck, Rebirths)
- Loja com pesos, velocidade, sorte e gamepasses
- Index com todos os 128 Brainrots
- Inventario com sistema de armazenamento
- Painel de rebirth
- Sistema de notificacoes
- Popups de recompensa animados
- Suporte mobile e PC

### DataStore
Salva automaticamente a cada 60 segundos:
- Dinheiro, forca, velocidade, sorte, rebirths
- Inventario completo de Brainrots
- Progresso da base
- Upgrades comprados
- Gamepasses ativados

---

## Configuracao de Gamepasses

No arquivo `Config.lua`, atualize os IDs dos gamepasses:

```lua
Config.Gamepasses = {
    { Name = "2x Money",     Id = SEU_ID_AQUI, Price = 99,   Multiplier = 2,  Type = "Money" },
    { Name = "2x Strength",  Id = SEU_ID_AQUI, Price = 99,   Multiplier = 2,  Type = "Strength" },
    ...
}
```

---

## Requisitos

- Roblox Studio (versao mais recente)
- Acesso ao jogo publicado para DataStore funcionar
- Gamepasses configurados para monetizacao

---

## Compatibilidade

- PC (mouse + teclado)
- Mobile (touch)
- Tablet
- Xbox (parcial)

---

## Licenca

Este projeto e fornecido como codigo-fonte completo para uso no Roblox Studio.
