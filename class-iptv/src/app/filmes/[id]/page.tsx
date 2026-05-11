'use client'

import { use, useState } from 'react'
import { useRouter } from 'next/navigation'
import AppShell from '@/components/layout/AppShell'
import VideoPlayer from '@/components/player/VideoPlayer'
import { mockMovies } from '@/data/mock'
import { useAppStore } from '@/store'

export default function MovieDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params)
  const router = useRouter()
  const [isPlaying, setIsPlaying] = useState(false)
  const { favorites, toggleFavorite } = useAppStore()

  const movie = mockMovies.find((m) => m.id === id)

  if (!movie) {
    return (
      <AppShell>
        <div className="text-center py-20">
          <p className="text-foreground/40 text-lg">Filme não encontrado</p>
          <button onClick={() => router.back()} className="mt-4 text-primary hover:text-primary-light">
            &larr; Voltar
          </button>
        </div>
      </AppShell>
    )
  }

  const isFav = favorites.movies.includes(movie.id)
  const related = mockMovies.filter((m) => m.id !== movie.id && m.genres.some((g) => movie.genres.includes(g))).slice(0, 4)

  return (
    <AppShell>
      <div className="space-y-6">
        <button onClick={() => router.back()} className="text-foreground/50 hover:text-foreground transition-colors flex items-center gap-1 text-sm">
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
          </svg>
          Voltar
        </button>

        {isPlaying ? (
          <VideoPlayer url={movie.streamUrl} title={movie.title} onClose={() => setIsPlaying(false)} />
        ) : (
          <div className="relative rounded-2xl overflow-hidden bg-gradient-to-r from-primary/20 via-surface to-accent/20 min-h-[400px] flex items-end">
            <div className="absolute inset-0 bg-gradient-to-t from-background via-background/50 to-transparent" />
            <div className="relative z-10 p-8 w-full">
              <div className="flex flex-col md:flex-row gap-6">
                <div className="w-40 h-60 bg-surface-light rounded-xl flex items-center justify-center shrink-0 border border-border">
                  <span className="text-6xl">🎬</span>
                </div>
                <div className="flex-1">
                  <h1 className="text-3xl md:text-4xl font-bold text-foreground mb-2">{movie.title}</h1>
                  <div className="flex items-center gap-3 mb-4 flex-wrap">
                    <span className="text-warning font-medium">★ {movie.rating}</span>
                    <span className="text-foreground/40">{movie.year}</span>
                    <span className="text-foreground/40">{movie.duration}</span>
                    {movie.genres.map((g) => (
                      <span key={g} className="px-2 py-0.5 bg-surface-light/50 rounded text-xs text-foreground/60">{g}</span>
                    ))}
                  </div>
                  <p className="text-foreground/60 max-w-2xl mb-6 leading-relaxed">{movie.description}</p>
                  <div className="flex gap-3">
                    <button
                      onClick={() => setIsPlaying(true)}
                      className="px-8 py-3 bg-gradient-to-r from-primary to-accent text-white font-semibold rounded-xl hover:opacity-90 transition-all flex items-center gap-2"
                    >
                      <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M8 5v14l11-7z" /></svg>
                      Assistir Agora
                    </button>
                    <button
                      onClick={() => toggleFavorite(movie.id, 'movies')}
                      className={`px-4 py-3 rounded-xl border transition-all flex items-center gap-2 ${
                        isFav ? 'bg-danger/10 border-danger/30 text-danger' : 'bg-surface border-border text-foreground/60 hover:text-foreground'
                      }`}
                    >
                      <svg className={`w-5 h-5 ${isFav ? 'fill-danger' : ''}`} fill={isFav ? 'currentColor' : 'none'} viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                      </svg>
                      {isFav ? 'Favorito' : 'Favoritar'}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {related.length > 0 && (
          <section>
            <h3 className="text-lg font-bold text-foreground mb-4">Filmes Relacionados</h3>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {related.map((m) => (
                <button
                  key={m.id}
                  onClick={() => router.push(`/filmes/${m.id}`)}
                  className="bg-surface rounded-xl overflow-hidden border border-border hover:border-primary/50 transition-all text-left"
                >
                  <div className="aspect-video bg-gradient-to-br from-primary/10 to-accent/10 flex items-center justify-center">
                    <span className="text-3xl">🎬</span>
                  </div>
                  <div className="p-3">
                    <p className="text-sm font-medium text-foreground/80 truncate">{m.title}</p>
                    <span className="text-xs text-warning">★ {m.rating}</span>
                  </div>
                </button>
              ))}
            </div>
          </section>
        )}
      </div>
    </AppShell>
  )
}
