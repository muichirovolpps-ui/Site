import { mockSeries } from '@/data/mock'

export const dynamic = 'force-dynamic'

export async function GET() {
  return Response.json({ series: mockSeries, total: mockSeries.length })
}
