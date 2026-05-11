'use client'

import { useState, useMemo } from 'react'
import Link from 'next/link'
import AppShell from '@/components/layout/AppShell'
import { mockSeries } from '@/data/mock'
import { useAppStore } from '@/store'

const seriesGenres = ['Todos', 'Thriller', 'Drama', 'Crime', 'Ficção Científica', 'Aventura', 'Esporte', 'Mistério', 'Tecnologia', 'Sobrenatural']

export default function SeriesPage() {
  const [selectedGenre, setSelectedGenre] = useState('Todos')
  const { searchQuery, favorites, toggleFavorite } = useAppStore()

  const filteredSeries = useMemo(() => {
    return mockSeries.filter((s) => {
      const matchGenre = selectedGenre === 'Todos' || s.genres.includes(selectedGenre)
      const matchSearch = !searchQuery || s.title.toLowerCase().includes(searchQuery.toLowerCase())
      return matchGenre && matchSearch
    })
  }, [selectedGenre, searchQuery])

  return (
    <AppShell>
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
            <span className="text-3xl">📺</span> Séries
          </h1>
          <p className="text-sm text-foreground/50 mt-1">{filteredSeries.length} séries disponíveis</p>
        </div>

        <div className="flex gap-2 overflow-x-auto no-scrollbar pb-2">
          {seriesGenres.map((genre) => (
            <button
              key={genre}
              onClick={() => setSelectedGenre(genre)}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all ${
                selectedGenre === genre
                  ? 'bg-gradient-to-r from-primary to-accent text-white'
                  : 'bg-surface border border-border text-foreground/60 hover:text-foreground hover:border-primary/50'
              }`}
            >
              {genre}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {filteredSeries.map((serie) => (
            <div key={serie.id} className="group relative">
              <Link
                href={`/series/${serie.id}`}
                className="block bg-surface rounded-xl overflow-hidden border border-border hover:border-primary/50 transition-all"
              >
                <div className="aspect-[2/3] bg-gradient-to-br from-accent/20 via-surface-light to-primary/20 flex items-center justify-center relative">
                  <span className="text-5xl">📺</span>
                  <div className="absolute inset-0 bg-black/0 group-hover:bg-black/40 transition-colors flex items-center justify-center">
                    <svg className="w-14 h-14 text-white opacity-0 group-hover:opacity-100 transition-opacity drop-shadow-lg" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M8 5v14l11-7z" />
                    </svg>
                  </div>
                  <div className="absolute top-2 right-2 px-2 py-0.5 bg-black/60 rounded text-xs text-warning font-medium">
                    ★ {serie.rating}
                  </div>
                  <div className="absolute bottom-2 left-2 px-2 py-0.5 bg-primary/80 rounded text-xs text-white font-medium">
                    {serie.seasons.length} Temp.
                  </div>
                </div>
                <div className="p-3">
                  <p className="font-medium text-foreground/90 truncate">{serie.title}</p>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-xs text-foreground/40">{serie.year}</span>
                    <span className="text-xs text-foreground/40">{serie.seasons.reduce((acc, s) => acc + s.episodes.length, 0)} eps.</span>
                  </div>
                  <div className="flex flex-wrap gap-1 mt-2">
                    {serie.genres.slice(0, 2).map((g) => (
                      <span key={g} className="px-2 py-0.5 bg-surface-light rounded text-[10px] text-foreground/50">{g}</span>
                    ))}
                  </div>
                </div>
              </Link>
              <button
                onClick={() => toggleFavorite(serie.id, 'series')}
                className="absolute top-2 left-2 p-1.5 rounded-full bg-black/40 hover:bg-black/60 transition-colors z-10"
              >
                <svg
                  className={`w-4 h-4 ${favorites.series.includes(serie.id) ? 'text-danger fill-danger' : 'text-white/70'}`}
                  fill={favorites.series.includes(serie.id) ? 'currentColor' : 'none'}
                  viewBox="0 0 24 24" stroke="currentColor"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                </svg>
              </button>
            </div>
          ))}
        </div>

        {filteredSeries.length === 0 && (
          <div className="text-center py-12">
            <p className="text-foreground/40 text-lg">Nenhuma série encontrada</p>
          </div>
        )}
      </div>
    </AppShell>
  )
}
