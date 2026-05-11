import { mockUsers, mockAdminStats } from '@/data/mock'

export const dynamic = 'force-dynamic'

export async function GET() {
  return Response.json({ stats: mockAdminStats, users: mockUsers })
}
