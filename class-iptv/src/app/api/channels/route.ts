import { mockChannels } from '@/data/mock'

export const dynamic = 'force-dynamic'

export async function GET() {
  return Response.json({ channels: mockChannels, total: mockChannels.length })
}
