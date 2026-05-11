'use client'

import { useState, useMemo } from 'react'
import Link from 'next/link'
import AppShell from '@/components/layout/AppShell'
import { mockMovies, movieGenres } from '@/data/mock'
import { useAppStore } from '@/store'

export default function FilmesPage() {
  const [selectedGenre, setSelectedGenre] = useState('Todos')
  const [sortBy, setSortBy] = useState<'rating' | 'year' | 'title'>('rating')
  const { searchQuery, favorites, toggleFavorite } = useAppStore()

  const filteredMovies = useMemo(() => {
    return mockMovies
      .filter((m) => {
        const matchGenre = selectedGenre === 'Todos' || m.genres.includes(selectedGenre)
        const matchSearch = !searchQuery || m.title.toLowerCase().includes(searchQuery.toLowerCase())
        return matchGenre && matchSearch
      })
      .sort((a, b) => {
        if (sortBy === 'rating') return b.rating - a.rating
        if (sortBy === 'year') return b.year - a.year
        return a.title.localeCompare(b.title)
      })
  }, [selectedGenre, searchQuery, sortBy])

  return (
    <AppShell>
      <div className="space-y-6">
        <div className="flex items-center justify-between flex-wrap gap-4">
          <div>
            <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
              <span className="text-3xl">🎬</span> Filmes
            </h1>
            <p className="text-sm text-foreground/50 mt-1">{filteredMovies.length} filmes disponíveis</p>
          </div>
          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value as 'rating' | 'year' | 'title')}
            className="px-3 py-2 bg-surface border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
          >
            <option value="rating">Melhor Avaliados</option>
            <option value="year">Mais Recentes</option>
            <option value="title">A-Z</option>
          </select>
        </div>

        <div className="flex gap-2 overflow-x-auto no-scrollbar pb-2">
          {movieGenres.map((genre) => (
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
          {filteredMovies.map((movie) => (
            <div key={movie.id} className="group relative">
              <Link
                href={`/filmes/${movie.id}`}
                className="block bg-surface rounded-xl overflow-hidden border border-border hover:border-primary/50 transition-all"
              >
                <div className="aspect-[2/3] bg-gradient-to-br from-primary/20 via-surface-light to-accent/20 flex items-center justify-center relative">
                  <span className="text-5xl">🎬</span>
                  <div className="absolute inset-0 bg-black/0 group-hover:bg-black/40 transition-colors flex items-center justify-center">
                    <svg className="w-14 h-14 text-white opacity-0 group-hover:opacity-100 transition-opacity drop-shadow-lg" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M8 5v14l11-7z" />
                    </svg>
                  </div>
                  <div className="absolute top-2 right-2 px-2 py-0.5 bg-black/60 rounded text-xs text-warning font-medium">
                    ★ {movie.rating}
                  </div>
                </div>
                <div className="p-3">
                  <p className="font-medium text-foreground/90 truncate">{movie.title}</p>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-xs text-foreground/40">{movie.year}</span>
                    <span className="text-xs text-foreground/40">{movie.duration}</span>
                  </div>
                  <div className="flex flex-wrap gap-1 mt-2">
                    {movie.genres.slice(0, 2).map((g) => (
                      <span key={g} className="px-2 py-0.5 bg-surface-light rounded text-[10px] text-foreground/50">{g}</span>
                    ))}
                  </div>
                </div>
              </Link>
              <button
                onClick={() => toggleFavorite(movie.id, 'movies')}
                className="absolute top-2 left-2 p-1.5 rounded-full bg-black/40 hover:bg-black/60 transition-colors z-10"
              >
                <svg
                  className={`w-4 h-4 ${favorites.movies.includes(movie.id) ? 'text-danger fill-danger' : 'text-white/70'}`}
                  fill={favorites.movies.includes(movie.id) ? 'currentColor' : 'none'}
                  viewBox="0 0 24 24" stroke="currentColor"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                </svg>
              </button>
            </div>
          ))}
        </div>

        {filteredMovies.length === 0 && (
          <div className="text-center py-12">
            <p className="text-foreground/40 text-lg">Nenhum filme encontrado</p>
          </div>
        )}
      </div>
    </AppShell>
  )
}
