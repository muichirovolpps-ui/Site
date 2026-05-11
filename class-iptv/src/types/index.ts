export interface User {
  id: string;
  username: string;
  email: string;
  role: 'admin' | 'user';
  status: 'active' | 'suspended' | 'banned' | 'expired';
  plan: string;
  expiresAt: string;
  maxScreens: number;
  createdAt: string;
  lastLogin: string;
  devices: Device[];
}

export interface Device {
  id: string;
  name: string;
  type: 'mobile' | 'desktop' | 'tv' | 'tablet';
  lastActive: string;
  ip: string;
}

export interface Plan {
  id: string;
  name: string;
  price: number;
  duration: number;
  maxScreens: number;
  features: string[];
}

export interface Channel {
  id: string;
  name: string;
  logo: string;
  category: string;
  streamUrl: string;
  epg?: EPGItem[];
  isFavorite?: boolean;
}

export interface EPGItem {
  title: string;
  start: string;
  end: string;
  description: string;
}

export interface Movie {
  id: string;
  title: string;
  poster: string;
  backdrop: string;
  description: string;
  year: number;
  rating: number;
  duration: string;
  genres: string[];
  streamUrl: string;
  trailerUrl?: string;
  isFavorite?: boolean;
  progress?: number;
}

export interface Series {
  id: string;
  title: string;
  poster: string;
  backdrop: string;
  description: string;
  year: number;
  rating: number;
  genres: string[];
  seasons: Season[];
  isFavorite?: boolean;
}

export interface Season {
  number: number;
  episodes: Episode[];
}

export interface Episode {
  id: string;
  number: number;
  title: string;
  description: string;
  duration: string;
  streamUrl: string;
  thumbnail: string;
  progress?: number;
}

export interface AdminStats {
  totalUsers: number;
  activeUsers: number;
  expiredUsers: number;
  onlineUsers: number;
  totalChannels: number;
  totalMovies: number;
  totalSeries: number;
  bandwidth: string;
  revenue: number;
}

export interface Notification {
  id: string;
  title: string;
  message: string;
  type: 'info' | 'warning' | 'error' | 'success';
  read: boolean;
  createdAt: string;
}
