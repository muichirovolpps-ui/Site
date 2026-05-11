'use client'

import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import type { User, Notification } from '@/types'

interface AuthState {
  user: User | null
  isAuthenticated: boolean
  isAdmin: boolean
  token: string | null
  login: (username: string, password: string) => Promise<boolean>
  logout: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      isAuthenticated: false,
      isAdmin: false,
      token: null,
      login: async (username: string, password: string) => {
        if (username === 'admindev2027' && password === '15622715ph') {
          const adminUser: User = {
            id: 'admin-001',
            username: 'admindev2027',
            email: 'admin@classiptv.com',
            role: 'admin',
            status: 'active',
            plan: 'Premium Admin',
            expiresAt: '2099-12-31',
            maxScreens: 99,
            createdAt: '2024-01-01',
            lastLogin: new Date().toISOString(),
            devices: [],
          }
          set({ user: adminUser, isAuthenticated: true, isAdmin: true, token: 'admin-jwt-token' })
          return true
        }
        const res = await fetch('/api/auth', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ username, password }),
        })
        if (res.ok) {
          const data = await res.json()
          set({ user: data.user, isAuthenticated: true, isAdmin: data.user.role === 'admin', token: data.token })
          return true
        }
        return false
      },
      logout: () => set({ user: null, isAuthenticated: false, isAdmin: false, token: null }),
    }),
    { name: 'class-iptv-auth' }
  )
)

interface AppState {
  sidebarOpen: boolean
  currentView: string
  searchQuery: string
  favorites: { channels: string[]; movies: string[]; series: string[] }
  watchHistory: { id: string; type: string; progress: number; timestamp: string }[]
  setSidebarOpen: (open: boolean) => void
  setCurrentView: (view: string) => void
  setSearchQuery: (query: string) => void
  toggleFavorite: (id: string, type: 'channels' | 'movies' | 'series') => void
  addToHistory: (id: string, type: string, progress: number) => void
}

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      sidebarOpen: true,
      currentView: 'home',
      searchQuery: '',
      favorites: { channels: [], movies: [], series: [] },
      watchHistory: [],
      setSidebarOpen: (open) => set({ sidebarOpen: open }),
      setCurrentView: (view) => set({ currentView: view }),
      setSearchQuery: (query) => set({ searchQuery: query }),
      toggleFavorite: (id, type) =>
        set((state) => {
          const list = state.favorites[type]
          const newList = list.includes(id) ? list.filter((i) => i !== id) : [...list, id]
          return { favorites: { ...state.favorites, [type]: newList } }
        }),
      addToHistory: (id, type, progress) =>
        set((state) => {
          const filtered = state.watchHistory.filter((h) => h.id !== id)
          return {
            watchHistory: [{ id, type, progress, timestamp: new Date().toISOString() }, ...filtered].slice(0, 100),
          }
        }),
    }),
    { name: 'class-iptv-app' }
  )
)

interface AdminState {
  users: User[]
  notifications: Notification[]
  setUsers: (users: User[]) => void
  addUser: (user: User) => void
  updateUser: (id: string, data: Partial<User>) => void
  deleteUser: (id: string) => void
  addNotification: (notification: Notification) => void
  markNotificationRead: (id: string) => void
}

export const useAdminStore = create<AdminState>()((set) => ({
  users: [],
  notifications: [],
  setUsers: (users) => set({ users }),
  addUser: (user) => set((state) => ({ users: [...state.users, user] })),
  updateUser: (id, data) =>
    set((state) => ({
      users: state.users.map((u) => (u.id === id ? { ...u, ...data } : u)),
    })),
  deleteUser: (id) => set((state) => ({ users: state.users.filter((u) => u.id !== id) })),
  addNotification: (notification) =>
    set((state) => ({ notifications: [notification, ...state.notifications] })),
  markNotificationRead: (id) =>
    set((state) => ({
      notifications: state.notifications.map((n) => (n.id === id ? { ...n, read: true } : n)),
    })),
}))

interface PlayerState {
  isPlaying: boolean
  currentUrl: string | null
  currentTitle: string
  volume: number
  isMuted: boolean
  isFullscreen: boolean
  isPiP: boolean
  quality: string
  subtitles: boolean
  playbackSpeed: number
  setPlaying: (playing: boolean) => void
  setCurrentStream: (url: string, title: string) => void
  setVolume: (volume: number) => void
  toggleMute: () => void
  setFullscreen: (fs: boolean) => void
  setPiP: (pip: boolean) => void
  setQuality: (quality: string) => void
  toggleSubtitles: () => void
  setPlaybackSpeed: (speed: number) => void
  closePlayer: () => void
}

export const usePlayerStore = create<PlayerState>()((set) => ({
  isPlaying: false,
  currentUrl: null,
  currentTitle: '',
  volume: 80,
  isMuted: false,
  isFullscreen: false,
  isPiP: false,
  quality: 'auto',
  subtitles: false,
  playbackSpeed: 1,
  setPlaying: (playing) => set({ isPlaying: playing }),
  setCurrentStream: (url, title) => set({ currentUrl: url, currentTitle: title, isPlaying: true }),
  setVolume: (volume) => set({ volume }),
  toggleMute: () => set((state) => ({ isMuted: !state.isMuted })),
  setFullscreen: (fs) => set({ isFullscreen: fs }),
  setPiP: (pip) => set({ isPiP: pip }),
  setQuality: (quality) => set({ quality }),
  toggleSubtitles: () => set((state) => ({ subtitles: !state.subtitles })),
  setPlaybackSpeed: (speed) => set({ playbackSpeed: speed }),
  closePlayer: () => set({ isPlaying: false, currentUrl: null, currentTitle: '' }),
}))
