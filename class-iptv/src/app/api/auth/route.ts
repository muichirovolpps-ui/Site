import { NextRequest } from 'next/server'

export async function POST(request: NextRequest) {
  const body = await request.json()
  const { username, password } = body

  if (!username || !password) {
    return Response.json({ error: 'Usuário e senha são obrigatórios' }, { status: 400 })
  }

  if (username === 'admindev2027' && password === '15622715ph') {
    return Response.json({
      user: {
        id: 'admin-001',
        username: 'admindev2027',
        email: 'admin@classiptv.com',
        role: 'admin',
        status: 'active',
        plan: 'Premium Admin',
        expiresAt: '2099-12-31',
        maxScreens: 99,
        createdAt: '2024-01-01',
        lastLogin: new Date().toISOString(),
        devices: [],
      },
      token: 'admin-jwt-token-' + Date.now(),
    })
  }

  return Response.json({ error: 'Credenciais inválidas' }, { status: 401 })
}
