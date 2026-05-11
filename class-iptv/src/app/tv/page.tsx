'use client'

import { useState, useMemo } from 'react'
import AppShell from '@/components/layout/AppShell'
import VideoPlayer from '@/components/player/VideoPlayer'
import { mockChannels, channelCategories } from '@/data/mock'
import { useAppStore } from '@/store'

export default function TVPage() {
  const [selectedCategory, setSelectedCategory] = useState('Todos')
  const [playingChannel, setPlayingChannel] = useState<typeof mockChannels[0] | null>(null)
  const { searchQuery, favorites, toggleFavorite } = useAppStore()

  const filteredChannels = useMemo(() => {
    return mockChannels.filter((ch) => {
      const matchCategory = selectedCategory === 'Todos' || ch.category === selectedCategory
      const matchSearch = !searchQuery || ch.name.toLowerCase().includes(searchQuery.toLowerCase())
      return matchCategory && matchSearch
    })
  }, [selectedCategory, searchQuery])

  return (
    <AppShell>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
              <span className="text-3xl">📡</span> TV ao Vivo
            </h1>
            <p className="text-sm text-foreground/50 mt-1">{filteredChannels.length} canais disponíveis</p>
          </div>
        </div>

        {playingChannel && (
          <div className="animate-slide-up">
            <VideoPlayer
              url={playingChannel.streamUrl}
              title={playingChannel.name}
              onClose={() => setPlayingChannel(null)}
            />
          </div>
        )}

        <div className="flex gap-2 overflow-x-auto no-scrollbar pb-2">
          {channelCategories.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all ${
                selectedCategory === cat
                  ? 'bg-gradient-to-r from-primary to-accent text-white'
                  : 'bg-surface border border-border text-foreground/60 hover:text-foreground hover:border-primary/50'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-3">
          {filteredChannels.map((channel) => (
            <div
              key={channel.id}
              className={`group bg-surface rounded-xl border transition-all cursor-pointer ${
                playingChannel?.id === channel.id
                  ? 'border-primary glow-box'
                  : 'border-border hover:border-primary/50'
              }`}
            >
              <button
                onClick={() => setPlayingChannel(channel)}
                className="w-full p-4 text-center"
              >
                <div className="text-4xl mb-3 group-hover:scale-110 transition-transform">{channel.logo}</div>
                <p className="text-sm font-medium text-foreground/90 truncate">{channel.name}</p>
                <p className="text-xs text-foreground/40 mt-1">{channel.category}</p>
                <span className="inline-flex items-center gap-1 mt-2 text-xs text-success">
                  <span className="w-1.5 h-1.5 bg-success rounded-full animate-pulse" /> AO VIVO
                </span>
              </button>
              <div className="px-4 pb-3 flex justify-center">
                <button
                  onClick={(e) => { e.stopPropagation(); toggleFavorite(channel.id, 'channels') }}
                  className="p-1.5 rounded-full hover:bg-surface-hover transition-colors"
                >
                  <svg
                    className={`w-4 h-4 ${favorites.channels.includes(channel.id) ? 'text-warning fill-warning' : 'text-foreground/30'}`}
                    fill={favorites.channels.includes(channel.id) ? 'currentColor' : 'none'}
                    viewBox="0 0 24 24" stroke="currentColor"
                  >
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
                  </svg>
                </button>
              </div>
            </div>
          ))}
        </div>

        {filteredChannels.length === 0 && (
          <div className="text-center py-12">
            <p className="text-foreground/40 text-lg">Nenhum canal encontrado</p>
          </div>
        )}
      </div>
    </AppShell>
  )
}
