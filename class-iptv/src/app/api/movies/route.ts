import { mockMovies } from '@/data/mock'

export const dynamic = 'force-dynamic'

export async function GET() {
  return Response.json({ movies: mockMovies, total: mockMovies.length })
}
