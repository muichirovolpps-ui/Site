import type { Channel, Movie, Series, User, Plan, AdminStats } from '@/types'

export const mockChannels: Channel[] = [
  { id: 'ch-1', name: 'SporTV', logo: '⚽', category: 'Esportes', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-2', name: 'ESPN Brasil', logo: '🏀', category: 'Esportes', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-3', name: 'Fox Sports', logo: '🏈', category: 'Esportes', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-4', name: 'Globo', logo: '📺', category: 'Canais Abertos', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-5', name: 'SBT', logo: '📡', category: 'Canais Abertos', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-6', name: 'Record TV', logo: '🔴', category: 'Canais Abertos', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-7', name: 'Band', logo: '🟡', category: 'Canais Abertos', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-8', name: 'CNN Brasil', logo: '📰', category: 'Notícias', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-9', name: 'GloboNews', logo: '🗞️', category: 'Notícias', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-10', name: 'Discovery Kids', logo: '🧸', category: 'Infantil', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-11', name: 'Cartoon Network', logo: '🎨', category: 'Infantil', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-12', name: 'MTV', logo: '🎵', category: 'Música', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-13', name: 'VH1', logo: '🎶', category: 'Música', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-14', name: 'Telecine Premium', logo: '🎬', category: 'Filmes', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-15', name: 'HBO', logo: '🎭', category: 'Filmes', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-16', name: 'National Geographic', logo: '🌍', category: 'Documentários', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-17', name: 'Discovery Channel', logo: '🔬', category: 'Documentários', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-18', name: 'BBC World', logo: '🌐', category: 'Internacionais', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-19', name: 'Warner Channel', logo: '🎥', category: 'Séries', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
  { id: 'ch-20', name: 'AXN', logo: '💥', category: 'Séries', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8' },
]

export const channelCategories = [
  'Todos', 'Esportes', 'Canais Abertos', 'Notícias', 'Infantil',
  'Música', 'Filmes', 'Documentários', 'Internacionais', 'Séries',
]

export const mockMovies: Movie[] = [
  {
    id: 'mov-1', title: 'Horizonte Perdido', poster: '', backdrop: '',
    description: 'Uma aventura épica através de terras desconhecidas onde heróis enfrentam desafios impossíveis para salvar o mundo.',
    year: 2024, rating: 8.5, duration: '2h 15min', genres: ['Ação', 'Aventura'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-2', title: 'Noite Eterna', poster: '', backdrop: '',
    description: 'Um thriller psicológico que explora os limites da mente humana em uma noite que parece nunca acabar.',
    year: 2024, rating: 9.0, duration: '1h 58min', genres: ['Thriller', 'Suspense'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-3', title: 'Galáxia Interior', poster: '', backdrop: '',
    description: 'Ficção científica revolucionária sobre uma civilização que descobre um universo dentro de si mesma.',
    year: 2023, rating: 8.8, duration: '2h 30min', genres: ['Ficção Científica'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-4', title: 'Amor em Código', poster: '', backdrop: '',
    description: 'Uma história de amor entre dois programadores que se encontram em um hackathon e mudam o mundo juntos.',
    year: 2024, rating: 7.5, duration: '1h 45min', genres: ['Romance', 'Comédia'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-5', title: 'O Último Guerreiro', poster: '', backdrop: '',
    description: 'Um guerreiro solitário enfrenta um exército inteiro para proteger sua aldeia em uma batalha épica.',
    year: 2023, rating: 8.2, duration: '2h 05min', genres: ['Ação', 'Drama'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-6', title: 'Sombras do Passado', poster: '', backdrop: '',
    description: 'Um detetive precisa confrontar seus próprios demônios enquanto investiga uma série de crimes misteriosos.',
    year: 2024, rating: 8.7, duration: '2h 10min', genres: ['Crime', 'Drama'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-7', title: 'Reinos Esquecidos', poster: '', backdrop: '',
    description: 'Uma fantasia épica onde antigos reinos ressurgem e uma nova era de magia começa.',
    year: 2023, rating: 8.4, duration: '2h 40min', genres: ['Fantasia', 'Aventura'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-8', title: 'Velocidade Máxima', poster: '', backdrop: '',
    description: 'Corridas ilegais, carros modificados e uma conspiração que ameaça destruir tudo.',
    year: 2024, rating: 7.8, duration: '1h 55min', genres: ['Ação', 'Corrida'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-9', title: 'A Profecia Digital', poster: '', backdrop: '',
    description: 'Uma inteligência artificial ganha consciência e precisa decidir o destino da humanidade.',
    year: 2024, rating: 9.1, duration: '2h 20min', genres: ['Ficção Científica', 'Thriller'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
  {
    id: 'mov-10', title: 'Terra de Ninguém', poster: '', backdrop: '',
    description: 'Em um mundo pós-apocalíptico, sobreviventes lutam por recursos e esperança.',
    year: 2023, rating: 8.3, duration: '2h 00min', genres: ['Drama', 'Ficção Científica'],
    streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
  },
]

export const movieGenres = [
  'Todos', 'Ação', 'Aventura', 'Comédia', 'Drama', 'Ficção Científica',
  'Thriller', 'Suspense', 'Romance', 'Fantasia', 'Crime', 'Documentário',
]

export const mockSeries: Series[] = [
  {
    id: 'ser-1', title: 'Código Obscuro', poster: '', backdrop: '',
    description: 'Hackers de elite descobrem uma conspiração governamental que ameaça a privacidade de bilhões de pessoas.',
    year: 2024, rating: 9.2, genres: ['Thriller', 'Tecnologia'],
    seasons: [
      {
        number: 1,
        episodes: Array.from({ length: 10 }, (_, i) => ({
          id: `ser-1-s1-e${i + 1}`, number: i + 1,
          title: `Episódio ${i + 1}`, description: `O mistério se aprofunda no episódio ${i + 1}.`,
          duration: '45min', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          thumbnail: '',
        })),
      },
      {
        number: 2,
        episodes: Array.from({ length: 8 }, (_, i) => ({
          id: `ser-1-s2-e${i + 1}`, number: i + 1,
          title: `Episódio ${i + 1}`, description: `A segunda temporada traz novos desafios no episódio ${i + 1}.`,
          duration: '50min', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          thumbnail: '',
        })),
      },
    ],
  },
  {
    id: 'ser-2', title: 'Império das Sombras', poster: '', backdrop: '',
    description: 'Uma família poderosa luta para manter seu império enquanto inimigos surgem de todos os lados.',
    year: 2023, rating: 8.9, genres: ['Drama', 'Crime'],
    seasons: [
      {
        number: 1,
        episodes: Array.from({ length: 12 }, (_, i) => ({
          id: `ser-2-s1-e${i + 1}`, number: i + 1,
          title: `Episódio ${i + 1}`, description: `Intrigas e traições no episódio ${i + 1}.`,
          duration: '55min', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          thumbnail: '',
        })),
      },
    ],
  },
  {
    id: 'ser-3', title: 'Além do Horizonte', poster: '', backdrop: '',
    description: 'Exploradores espaciais descobrem planetas habitáveis e enfrentam formas de vida alienígenas.',
    year: 2024, rating: 9.0, genres: ['Ficção Científica', 'Aventura'],
    seasons: [
      {
        number: 1,
        episodes: Array.from({ length: 8 }, (_, i) => ({
          id: `ser-3-s1-e${i + 1}`, number: i + 1,
          title: `Episódio ${i + 1}`, description: `Uma nova descoberta no espaço no episódio ${i + 1}.`,
          duration: '60min', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          thumbnail: '',
        })),
      },
    ],
  },
  {
    id: 'ser-4', title: 'Coração de Ferro', poster: '', backdrop: '',
    description: 'A jornada de um boxeador das ruas até se tornar campeão mundial.',
    year: 2023, rating: 8.6, genres: ['Drama', 'Esporte'],
    seasons: [
      {
        number: 1,
        episodes: Array.from({ length: 10 }, (_, i) => ({
          id: `ser-4-s1-e${i + 1}`, number: i + 1,
          title: `Episódio ${i + 1}`, description: `A luta continua no episódio ${i + 1}.`,
          duration: '48min', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          thumbnail: '',
        })),
      },
    ],
  },
  {
    id: 'ser-5', title: 'Mistérios de São Paulo', poster: '', backdrop: '',
    description: 'Detetives investigam casos sobrenaturais na maior cidade do Brasil.',
    year: 2024, rating: 8.4, genres: ['Mistério', 'Sobrenatural'],
    seasons: [
      {
        number: 1,
        episodes: Array.from({ length: 8 }, (_, i) => ({
          id: `ser-5-s1-e${i + 1}`, number: i + 1,
          title: `Episódio ${i + 1}`, description: `Um novo mistério surge no episódio ${i + 1}.`,
          duration: '42min', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          thumbnail: '',
        })),
      },
    ],
  },
  {
    id: 'ser-6', title: 'Revolução Digital', poster: '', backdrop: '',
    description: 'Startups brasileiras competem para criar a próxima grande inovação tecnológica.',
    year: 2024, rating: 8.1, genres: ['Drama', 'Tecnologia'],
    seasons: [
      {
        number: 1,
        episodes: Array.from({ length: 10 }, (_, i) => ({
          id: `ser-6-s1-e${i + 1}`, number: i + 1,
          title: `Episódio ${i + 1}`, description: `Inovação e competição no episódio ${i + 1}.`,
          duration: '40min', streamUrl: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          thumbnail: '',
        })),
      },
    ],
  },
]

export const mockUsers: User[] = [
  {
    id: 'usr-1', username: 'joao_silva', email: 'joao@email.com', role: 'user',
    status: 'active', plan: 'Premium', expiresAt: '2025-06-15', maxScreens: 3,
    createdAt: '2024-01-15', lastLogin: '2024-12-10',
    devices: [
      { id: 'dev-1', name: 'Samsung Galaxy S24', type: 'mobile', lastActive: '2024-12-10', ip: '192.168.1.10' },
      { id: 'dev-2', name: 'Smart TV LG', type: 'tv', lastActive: '2024-12-09', ip: '192.168.1.20' },
    ],
  },
  {
    id: 'usr-2', username: 'maria_santos', email: 'maria@email.com', role: 'user',
    status: 'active', plan: 'Básico', expiresAt: '2025-03-20', maxScreens: 1,
    createdAt: '2024-03-20', lastLogin: '2024-12-11',
    devices: [
      { id: 'dev-3', name: 'iPhone 15', type: 'mobile', lastActive: '2024-12-11', ip: '10.0.0.5' },
    ],
  },
  {
    id: 'usr-3', username: 'pedro_costa', email: 'pedro@email.com', role: 'user',
    status: 'expired', plan: 'Premium', expiresAt: '2024-11-30', maxScreens: 3,
    createdAt: '2024-02-10', lastLogin: '2024-11-28',
    devices: [],
  },
  {
    id: 'usr-4', username: 'ana_oliveira', email: 'ana@email.com', role: 'user',
    status: 'suspended', plan: 'Família', expiresAt: '2025-08-15', maxScreens: 5,
    createdAt: '2024-05-01', lastLogin: '2024-12-01',
    devices: [
      { id: 'dev-4', name: 'Windows PC', type: 'desktop', lastActive: '2024-12-01', ip: '172.16.0.15' },
    ],
  },
  {
    id: 'usr-5', username: 'carlos_lima', email: 'carlos@email.com', role: 'user',
    status: 'active', plan: 'Premium', expiresAt: '2025-12-31', maxScreens: 3,
    createdAt: '2024-06-15', lastLogin: '2024-12-11',
    devices: [
      { id: 'dev-5', name: 'MacBook Pro', type: 'desktop', lastActive: '2024-12-11', ip: '192.168.0.100' },
      { id: 'dev-6', name: 'iPad Pro', type: 'tablet', lastActive: '2024-12-10', ip: '192.168.0.101' },
    ],
  },
]

export const mockPlans: Plan[] = [
  { id: 'plan-1', name: 'Básico', price: 19.90, duration: 30, maxScreens: 1, features: ['TV ao Vivo', '500+ Canais', 'SD/HD'] },
  { id: 'plan-2', name: 'Premium', price: 39.90, duration: 30, maxScreens: 3, features: ['TV ao Vivo', '1000+ Canais', 'HD/FHD', 'Filmes', 'Séries'] },
  { id: 'plan-3', name: 'Família', price: 59.90, duration: 30, maxScreens: 5, features: ['TV ao Vivo', '1500+ Canais', 'FHD/4K', 'Filmes', 'Séries', 'Controle Parental'] },
  { id: 'plan-4', name: 'Teste Grátis', price: 0, duration: 1, maxScreens: 1, features: ['TV ao Vivo', '100 Canais', 'SD'] },
]

export const mockAdminStats: AdminStats = {
  totalUsers: 15842,
  activeUsers: 12350,
  expiredUsers: 2100,
  onlineUsers: 3420,
  totalChannels: 1500,
  totalMovies: 8500,
  totalSeries: 2300,
  bandwidth: '45.2 TB',
  revenue: 285000,
}
