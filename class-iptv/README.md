# CLASS IPTV - Premium Streaming System

Sistema IPTV Premium Multiplataforma com interface moderna estilo Netflix + IPTV Smarters + Disney+ + Prime Video.

## Tecnologias

- **Frontend**: Next.js 16, React 19, TypeScript, TailwindCSS 4
- **State Management**: Zustand (persistido)
- **Player**: HLS.js (M3U8/HLS streams)
- **Animações**: CSS animations, transitions
- **PWA**: Service Worker, Web App Manifest
- **API**: Next.js Route Handlers (REST)

## Funcionalidades

### Tela de Login
- Login premium com partículas animadas e efeitos glow
- Verificação automática de sessão
- Lembrar login
- Mostrar/ocultar senha
- Loading animado

### Login Admin
- **Usuário**: `admindev2027`
- **Senha**: `15622715ph`

### Painel Admin
- Dashboard com estatísticas em tempo real
- Gerenciamento completo de usuários (criar, editar, deletar, suspender, renovar)
- Cards com métricas: usuários ativos, online, expirados, receita
- Sistema de logs
- Gestão de planos
- Status do sistema (CPU, memória, disco, rede)

### Home Screen
- Banners rotativos com gradientes
- Carrossel de conteúdos
- Seção "Continuar Assistindo" com progresso
- TV ao Vivo, Filmes em Alta, Séries Populares
- Navegação por categorias

### TV ao Vivo
- 20+ canais organizados por categoria
- Categorias: Esportes, Canais Abertos, Notícias, Infantil, Música, Filmes, Documentários, Internacionais, Séries
- Player integrado com HLS
- Sistema de favoritos
- Busca rápida
- Indicador "AO VIVO"

### Filmes
- Catálogo com 10+ filmes
- Filtros por gênero
- Ordenação (avaliação, ano, título)
- Página de detalhes com sinopse, avaliação, gêneros
- Player integrado
- Filmes relacionados
- Sistema de favoritos

### Séries
- 6+ séries com múltiplas temporadas
- Lista de episódios por temporada
- Player com reprodução automática
- Detalhes completos
- Sistema de favoritos

### Player de Vídeo
- HLS.js para streaming adaptativo
- Controles completos: play/pause, volume, seek, fullscreen
- Barra de progresso com buffer
- Controle de velocidade (0.5x - 2x)
- Seletor de qualidade
- Auto-hide de controles

### Configurações
- Perfil do usuário
- Tema claro/escuro
- Controle parental com PIN
- Qualidade de streaming padrão
- Gerenciamento de dispositivos
- Alteração de senha
- Notificações
- Idioma

### API REST
- `POST /api/auth` - Autenticação
- `GET /api/channels` - Lista de canais
- `GET /api/movies` - Lista de filmes
- `GET /api/series` - Lista de séries
- `GET /api/admin` - Estatísticas admin

### Visual Premium
- Tema escuro com azul neon e roxo
- Efeitos de glow e blur
- Animações suaves
- Partículas animadas no login
- Glass morphism
- Gradientes modernos
- Bordas arredondadas
- UX premium responsiva

### PWA
- Web App Manifest
- Ícones para instalação
- Tema escuro nativo
- Funciona como app instalável

## Instalação

```bash
cd class-iptv
npm install
npm run dev
```

Acesse `http://localhost:3000`

## Build

```bash
npm run build
npm start
```

## Estrutura do Projeto

```
class-iptv/
├── src/
│   ├── app/                    # Pages e rotas (App Router)
│   │   ├── page.tsx           # Login
│   │   ├── home/              # Home screen
│   │   ├── tv/                # TV ao Vivo
│   │   ├── filmes/            # Filmes + [id] detalhes
│   │   ├── series/            # Séries + [id] detalhes
│   │   ├── admin/             # Painel Admin
│   │   ├── configuracoes/     # Configurações
│   │   └── api/               # API Routes
│   ├── components/
│   │   ├── layout/            # Sidebar, Header, AppShell
│   │   ├── player/            # VideoPlayer HLS
│   │   └── ui/                # Particles, LoadingSpinner
│   ├── store/                 # Zustand stores
│   ├── data/                  # Mock data
│   └── types/                 # TypeScript types
├── public/
│   ├── manifest.json          # PWA manifest
│   └── icons/                 # App icons
└── package.json
```

## Compatibilidade

- Website (qualquer navegador moderno)
- PWA (instalável em qualquer dispositivo)
- Mobile (responsivo)
- Tablet (responsivo)
- Smart TV (via navegador)
- Desktop (via navegador)

## Licença

Proprietary - CLASS IPTV
