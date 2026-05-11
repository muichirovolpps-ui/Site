'use client'

import { useState } from 'react'
import Link from 'next/link'
import AppShell from '@/components/layout/AppShell'
import VideoPlayer from '@/components/player/VideoPlayer'
import { mockMovies, mockSeries, mockChannels } from '@/data/mock'

const banners = [
  { id: 1, title: 'Noite Eterna', subtitle: 'O thriller mais assistido do ano', gradient: 'from-purple-900 via-indigo-900 to-blue-900' },
  { id: 2, title: 'TV ao Vivo', subtitle: '1500+ canais em HD e 4K', gradient: 'from-blue-900 via-cyan-900 to-teal-900' },
  { id: 3, title: 'Código Obscuro', subtitle: 'Nova temporada disponível', gradient: 'from-red-900 via-rose-900 to-pink-900' },
]

export default function HomePage() {
  const [currentBanner, setCurrentBanner] = useState(0)
  const [playingUrl, setPlayingUrl] = useState<string | null>(null)
  const [playingTitle, setPlayingTitle] = useState('')
  const progressValues = [35, 62, 78, 15]
  const continueWatching = mockMovies.slice(0, 4).map((m, i) => ({ ...m, progress: progressValues[i] }))
  const trendingMovies = mockMovies.slice(0, 8)
  const popularSeries = mockSeries.slice(0, 6)
  const liveChannels = mockChannels.slice(0, 6)

  return (
    <AppShell>
      {playingUrl && (
        <div className="fixed inset-0 z-50 bg-black/90 flex items-center justify-center p-4">
          <div className="w-full max-w-5xl">
            <VideoPlayer url={playingUrl} title={playingTitle} onClose={() => setPlayingUrl(null)} />
          </div>
        </div>
      )}

      <div className="space-y-8">
        <div className={`relative rounded-2xl overflow-hidden bg-gradient-to-r ${banners[currentBanner].gradient} p-8 md:p-12 min-h-[300px] flex items-end`}>
          <div className="absolute inset-0 bg-black/30" />
          <div className="relative z-10 max-w-2xl">
            <span className="inline-block px-3 py-1 bg-primary/30 text-primary-light text-xs font-medium rounded-full mb-3">
              Em Destaque
            </span>
            <h2 className="text-3xl md:text-5xl font-bold text-white mb-2">{banners[currentBanner].title}</h2>
            <p className="text-white/70 text-lg mb-4">{banners[currentBanner].subtitle}</p>
            <div className="flex gap-3">
              <button
                onClick={() => { setPlayingUrl('https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'); setPlayingTitle(banners[currentBanner].title) }}
                className="px-6 py-2.5 bg-white text-black font-semibold rounded-lg hover:bg-white/90 transition-colors flex items-center gap-2"
              >
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M8 5v14l11-7z" /></svg>
                Assistir
              </button>
              <Link href="/filmes" className="px-6 py-2.5 bg-white/20 text-white font-semibold rounded-lg hover:bg-white/30 transition-colors">
                Mais Info
              </Link>
            </div>
          </div>
          <div className="absolute bottom-4 right-4 flex gap-2">
            {banners.map((_, i) => (
              <button
                key={i}
                onClick={() => setCurrentBanner(i)}
                className={`w-2.5 h-2.5 rounded-full transition-all ${i === currentBanner ? 'bg-white w-6' : 'bg-white/40'}`}
              />
            ))}
          </div>
        </div>

        {continueWatching.length > 0 && (
          <section>
            <h3 className="text-xl font-bold text-foreground mb-4 flex items-center gap-2">
              <svg className="w-5 h-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              Continuar Assistindo
            </h3>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {continueWatching.map((item) => (
                <button
                  key={item.id}
                  onClick={() => { setPlayingUrl(item.streamUrl); setPlayingTitle(item.title) }}
                  className="group relative bg-surface rounded-xl overflow-hidden border border-border hover:border-primary/50 transition-all"
                >
                  <div className="aspect-video bg-gradient-to-br from-surface-light to-surface flex items-center justify-center">
                    <svg className="w-12 h-12 text-primary/50 group-hover:text-primary group-hover:scale-110 transition-all" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M8 5v14l11-7z" />
                    </svg>
                  </div>
                  <div className="absolute bottom-0 left-0 right-0 h-1 bg-white/10">
                    <div className="h-full bg-primary" style={{ width: `${item.progress}%` }} />
                  </div>
                  <div className="p-3">
                    <p className="text-sm font-medium text-foreground/80 truncate">{item.title}</p>
                    <p className="text-xs text-foreground/40">{Math.round(item.progress)}% assistido</p>
                  </div>
                </button>
              ))}
            </div>
          </section>
        )}

        <section>
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xl font-bold text-foreground flex items-center gap-2">
              <span className="text-2xl">🔴</span> TV ao Vivo
            </h3>
            <Link href="/tv" className="text-sm text-primary hover:text-primary-light transition-colors">Ver todos &rarr;</Link>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
            {liveChannels.map((ch) => (
              <button
                key={ch.id}
                onClick={() => { setPlayingUrl(ch.streamUrl); setPlayingTitle(ch.name) }}
                className="group bg-surface rounded-xl p-4 border border-border hover:border-primary/50 hover:glow-box transition-all text-center"
              >
                <div className="text-3xl mb-2">{ch.logo}</div>
                <p className="text-sm font-medium text-foreground/80 truncate">{ch.name}</p>
                <span className="inline-flex items-center gap-1 mt-1 text-xs text-success">
                  <span className="w-1.5 h-1.5 bg-success rounded-full animate-pulse" /> AO VIVO
                </span>
              </button>
            ))}
          </div>
        </section>

        <section>
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xl font-bold text-foreground flex items-center gap-2">
              <span className="text-2xl">🎬</span> Filmes em Alta
            </h3>
            <Link href="/filmes" className="text-sm text-primary hover:text-primary-light transition-colors">Ver todos &rarr;</Link>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-4 gap-4">
            {trendingMovies.slice(0, 4).map((movie) => (
              <Link
                key={movie.id}
                href={`/filmes/${movie.id}`}
                className="group bg-surface rounded-xl overflow-hidden border border-border hover:border-primary/50 transition-all"
              >
                <div className="aspect-[2/3] bg-gradient-to-br from-primary/20 via-surface-light to-accent/20 flex items-center justify-center relative">
                  <span className="text-5xl">🎬</span>
                  <div className="absolute inset-0 bg-black/0 group-hover:bg-black/40 transition-colors flex items-center justify-center">
                    <svg className="w-12 h-12 text-white opacity-0 group-hover:opacity-100 transition-opacity" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M8 5v14l11-7z" />
                    </svg>
                  </div>
                </div>
                <div className="p-3">
                  <p className="font-medium text-foreground/90 truncate">{movie.title}</p>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-xs text-warning">★ {movie.rating}</span>
                    <span className="text-xs text-foreground/40">{movie.year}</span>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </section>

        <section>
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xl font-bold text-foreground flex items-center gap-2">
              <span className="text-2xl">📺</span> Séries Populares
            </h3>
            <Link href="/series" className="text-sm text-primary hover:text-primary-light transition-colors">Ver todos &rarr;</Link>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
            {popularSeries.map((serie) => (
              <Link
                key={serie.id}
                href={`/series/${serie.id}`}
                className="group bg-surface rounded-xl overflow-hidden border border-border hover:border-primary/50 transition-all"
              >
                <div className="aspect-[2/3] bg-gradient-to-br from-accent/20 via-surface-light to-primary/20 flex items-center justify-center">
                  <span className="text-4xl">📺</span>
                </div>
                <div className="p-3">
                  <p className="text-sm font-medium text-foreground/90 truncate">{serie.title}</p>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-xs text-warning">★ {serie.rating}</span>
                    <span className="text-xs text-foreground/40">{serie.seasons.length} temp.</span>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </section>
      </div>
    </AppShell>
  )
}
