'use client'

import { use, useState } from 'react'
import { useRouter } from 'next/navigation'
import AppShell from '@/components/layout/AppShell'
import VideoPlayer from '@/components/player/VideoPlayer'
import { mockSeries } from '@/data/mock'
import { useAppStore } from '@/store'

export default function SeriesDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params)
  const router = useRouter()
  const [selectedSeason, setSelectedSeason] = useState(0)
  const [playingEpisode, setPlayingEpisode] = useState<{ url: string; title: string } | null>(null)
  const { favorites, toggleFavorite } = useAppStore()

  const serie = mockSeries.find((s) => s.id === id)

  if (!serie) {
    return (
      <AppShell>
        <div className="text-center py-20">
          <p className="text-foreground/40 text-lg">Série não encontrada</p>
          <button onClick={() => router.back()} className="mt-4 text-primary hover:text-primary-light">&larr; Voltar</button>
        </div>
      </AppShell>
    )
  }

  const isFav = favorites.series.includes(serie.id)
  const currentSeason = serie.seasons[selectedSeason]

  return (
    <AppShell>
      <div className="space-y-6">
        <button onClick={() => router.back()} className="text-foreground/50 hover:text-foreground transition-colors flex items-center gap-1 text-sm">
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
          </svg>
          Voltar
        </button>

        {playingEpisode ? (
          <VideoPlayer url={playingEpisode.url} title={playingEpisode.title} onClose={() => setPlayingEpisode(null)} />
        ) : (
          <div className="relative rounded-2xl overflow-hidden bg-gradient-to-r from-accent/20 via-surface to-primary/20 min-h-[350px] flex items-end">
            <div className="absolute inset-0 bg-gradient-to-t from-background via-background/50 to-transparent" />
            <div className="relative z-10 p-8 w-full">
              <div className="flex flex-col md:flex-row gap-6">
                <div className="w-36 h-52 bg-surface-light rounded-xl flex items-center justify-center shrink-0 border border-border">
                  <span className="text-5xl">📺</span>
                </div>
                <div className="flex-1">
                  <h1 className="text-3xl md:text-4xl font-bold text-foreground mb-2">{serie.title}</h1>
                  <div className="flex items-center gap-3 mb-4 flex-wrap">
                    <span className="text-warning font-medium">★ {serie.rating}</span>
                    <span className="text-foreground/40">{serie.year}</span>
                    <span className="text-foreground/40">{serie.seasons.length} temporadas</span>
                    {serie.genres.map((g) => (
                      <span key={g} className="px-2 py-0.5 bg-surface-light/50 rounded text-xs text-foreground/60">{g}</span>
                    ))}
                  </div>
                  <p className="text-foreground/60 max-w-2xl mb-6 leading-relaxed">{serie.description}</p>
                  <div className="flex gap-3">
                    <button
                      onClick={() => {
                        const ep = currentSeason.episodes[0]
                        setPlayingEpisode({ url: ep.streamUrl, title: `${serie.title} - S${currentSeason.number}E${ep.number}` })
                      }}
                      className="px-8 py-3 bg-gradient-to-r from-primary to-accent text-white font-semibold rounded-xl hover:opacity-90 transition-all flex items-center gap-2"
                    >
                      <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M8 5v14l11-7z" /></svg>
                      Assistir S{currentSeason.number}E1
                    </button>
                    <button
                      onClick={() => toggleFavorite(serie.id, 'series')}
                      className={`px-4 py-3 rounded-xl border transition-all ${
                        isFav ? 'bg-danger/10 border-danger/30 text-danger' : 'bg-surface border-border text-foreground/60 hover:text-foreground'
                      }`}
                    >
                      <svg className={`w-5 h-5 ${isFav ? 'fill-danger' : ''}`} fill={isFav ? 'currentColor' : 'none'} viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                      </svg>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        <div>
          <div className="flex gap-2 mb-4 overflow-x-auto no-scrollbar">
            {serie.seasons.map((season, idx) => (
              <button
                key={season.number}
                onClick={() => setSelectedSeason(idx)}
                className={`px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap transition-all ${
                  selectedSeason === idx
                    ? 'bg-primary text-white'
                    : 'bg-surface border border-border text-foreground/60 hover:text-foreground'
                }`}
              >
                Temporada {season.number}
              </button>
            ))}
          </div>

          <div className="space-y-2">
            {currentSeason.episodes.map((ep) => (
              <button
                key={ep.id}
                onClick={() => setPlayingEpisode({ url: ep.streamUrl, title: `${serie.title} - S${currentSeason.number}E${ep.number}: ${ep.title}` })}
                className="w-full flex items-center gap-4 p-4 bg-surface rounded-xl border border-border hover:border-primary/50 transition-all text-left group"
              >
                <div className="w-12 h-12 bg-surface-light rounded-lg flex items-center justify-center shrink-0 group-hover:bg-primary/20 transition-colors">
                  <span className="text-foreground/40 group-hover:text-primary font-bold">{ep.number}</span>
                </div>
                <div className="flex-1 min-w-0">
                  <p className="font-medium text-foreground/90 truncate">{ep.title}</p>
                  <p className="text-xs text-foreground/40 truncate mt-0.5">{ep.description}</p>
                </div>
                <span className="text-xs text-foreground/40 shrink-0">{ep.duration}</span>
                <svg className="w-5 h-5 text-foreground/20 group-hover:text-primary shrink-0 transition-colors" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M8 5v14l11-7z" />
                </svg>
              </button>
            ))}
          </div>
        </div>
      </div>
    </AppShell>
  )
}
