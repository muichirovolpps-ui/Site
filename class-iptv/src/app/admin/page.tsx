'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useAuthStore, useAdminStore } from '@/store'
import { mockUsers, mockPlans, mockAdminStats } from '@/data/mock'
import type { User } from '@/types'
import LoadingSpinner from '@/components/ui/LoadingSpinner'

type Tab = 'dashboard' | 'users' | 'plans' | 'logs'

export default function AdminPage() {
  const { isAuthenticated, isAdmin, logout } = useAuthStore()
  const { users, setUsers, addUser, updateUser, deleteUser } = useAdminStore()
  const router = useRouter()
  const [activeTab, setActiveTab] = useState<Tab>('dashboard')
  const [showCreateUser, setShowCreateUser] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [sidebarOpen, setSidebarOpen] = useState(true)

  const [newUser, setNewUser] = useState({ username: '', email: '', plan: 'Premium', maxScreens: 3 })

  useEffect(() => {
    if (!isAuthenticated || !isAdmin) {
      router.push('/')
      return
    }
    if (users.length === 0) setUsers(mockUsers)
  }, [isAuthenticated, isAdmin, router, users.length, setUsers])

  if (!isAuthenticated || !isAdmin) {
    return <div className="min-h-screen flex items-center justify-center"><LoadingSpinner size="lg" /></div>
  }

  const stats = mockAdminStats
  const filteredUsers = users.filter((u) =>
    u.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
    u.email.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const handleCreateUser = () => {
    const user: User = {
      id: `usr-${Date.now()}`,
      username: newUser.username,
      email: newUser.email,
      role: 'user',
      status: 'active',
      plan: newUser.plan,
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      maxScreens: newUser.maxScreens,
      createdAt: new Date().toISOString().split('T')[0],
      lastLogin: '-',
      devices: [],
    }
    addUser(user)
    setShowCreateUser(false)
    setNewUser({ username: '', email: '', plan: 'Premium', maxScreens: 3 })
  }

  const adminMenuItems = [
    { id: 'dashboard' as Tab, label: 'Dashboard', icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6' },
    { id: 'users' as Tab, label: 'Usuários', icon: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z' },
    { id: 'plans' as Tab, label: 'Planos', icon: 'M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z' },
    { id: 'logs' as Tab, label: 'Logs', icon: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2' },
  ]

  const statCards = [
    { label: 'Total Usuários', value: stats.totalUsers.toLocaleString(), color: 'from-blue-500 to-blue-700', icon: '👥' },
    { label: 'Usuários Ativos', value: stats.activeUsers.toLocaleString(), color: 'from-green-500 to-green-700', icon: '✅' },
    { label: 'Online Agora', value: stats.onlineUsers.toLocaleString(), color: 'from-cyan-500 to-cyan-700', icon: '🟢' },
    { label: 'Expirados', value: stats.expiredUsers.toLocaleString(), color: 'from-red-500 to-red-700', icon: '⚠️' },
    { label: 'Canais', value: stats.totalChannels.toLocaleString(), color: 'from-purple-500 to-purple-700', icon: '📡' },
    { label: 'Filmes', value: stats.totalMovies.toLocaleString(), color: 'from-indigo-500 to-indigo-700', icon: '🎬' },
    { label: 'Séries', value: stats.totalSeries.toLocaleString(), color: 'from-pink-500 to-pink-700', icon: '📺' },
    { label: 'Receita Mensal', value: `R$ ${stats.revenue.toLocaleString()}`, color: 'from-yellow-500 to-yellow-700', icon: '💰' },
  ]

  return (
    <div className="min-h-screen bg-background flex">
      {sidebarOpen && <div className="fixed inset-0 bg-black/50 z-40 lg:hidden" onClick={() => setSidebarOpen(false)} />}
      <aside className={`fixed top-0 left-0 h-full z-50 transition-all duration-300 ${sidebarOpen ? 'w-64' : 'w-0 lg:w-20'} bg-surface border-r border-border overflow-hidden`}>
        <div className="flex flex-col h-full min-w-[5rem]">
          <div className="p-4 border-b border-border">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary to-accent flex items-center justify-center shrink-0">
                <svg className="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
              </div>
              {sidebarOpen && <span className="font-bold text-lg text-foreground">Admin Panel</span>}
            </div>
          </div>
          <nav className="flex-1 p-3 space-y-1">
            {adminMenuItems.map((item) => (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id)}
                className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all ${
                  activeTab === item.id
                    ? 'bg-gradient-to-r from-primary/20 to-accent/20 text-primary-light border border-primary/30'
                    : 'text-foreground/60 hover:text-foreground hover:bg-surface-hover'
                }`}
              >
                <svg className="w-5 h-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d={item.icon} />
                </svg>
                {sidebarOpen && <span className="text-sm font-medium">{item.label}</span>}
              </button>
            ))}
            <button
              onClick={() => router.push('/home')}
              className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-foreground/60 hover:text-foreground hover:bg-surface-hover transition-all"
            >
              <svg className="w-5 h-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
              </svg>
              {sidebarOpen && <span className="text-sm font-medium">App IPTV</span>}
            </button>
          </nav>
          <div className="p-3 border-t border-border">
            <button onClick={logout} className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-danger/70 hover:text-danger hover:bg-danger/10 transition-all">
              <svg className="w-5 h-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
              </svg>
              {sidebarOpen && <span className="text-sm font-medium">Sair</span>}
            </button>
          </div>
        </div>
      </aside>

      <div className={`flex-1 transition-all duration-300 ${sidebarOpen ? 'lg:ml-64' : 'lg:ml-20'}`}>
        <header className="h-16 glass border-b border-border flex items-center px-4 gap-4 sticky top-0 z-30">
          <button onClick={() => setSidebarOpen(!sidebarOpen)} className="p-2 rounded-lg hover:bg-surface-hover transition-colors">
            <svg className="w-5 h-5 text-foreground/70" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          </button>
          <h2 className="text-lg font-bold text-foreground capitalize">{activeTab}</h2>
          <div className="flex-1" />
          <span className="text-xs text-foreground/40">Banda: {stats.bandwidth}</span>
        </header>

        <main className="p-4 md:p-6">
          {activeTab === 'dashboard' && (
            <div className="space-y-6 animate-fade-in">
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {statCards.map((card) => (
                  <div key={card.label} className="bg-surface rounded-xl border border-border p-4 hover:border-primary/30 transition-all">
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-2xl">{card.icon}</span>
                      <div className={`w-2 h-2 rounded-full bg-gradient-to-r ${card.color}`} />
                    </div>
                    <p className="text-2xl font-bold text-foreground">{card.value}</p>
                    <p className="text-xs text-foreground/50 mt-1">{card.label}</p>
                  </div>
                ))}
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="bg-surface rounded-xl border border-border p-6">
                  <h3 className="font-bold text-foreground mb-4">Atividade Recente</h3>
                  <div className="space-y-3">
                    {['joao_silva fez login', 'maria_santos assistiu Canal ESPN', 'Novo usuário: carlos_lima', 'pedro_costa - assinatura expirada', 'Sistema atualizado v1.0.5'].map((log, i) => (
                      <div key={i} className="flex items-center gap-3 text-sm">
                        <div className="w-2 h-2 rounded-full bg-primary shrink-0" />
                        <span className="text-foreground/60">{log}</span>
                        <span className="text-xs text-foreground/30 ml-auto">{i + 1}h atrás</span>
                      </div>
                    ))}
                  </div>
                </div>
                <div className="bg-surface rounded-xl border border-border p-6">
                  <h3 className="font-bold text-foreground mb-4">Status do Sistema</h3>
                  <div className="space-y-4">
                    {[
                      { label: 'CPU', value: 45, color: 'bg-green-500' },
                      { label: 'Memória', value: 62, color: 'bg-yellow-500' },
                      { label: 'Disco', value: 38, color: 'bg-blue-500' },
                      { label: 'Rede', value: 73, color: 'bg-purple-500' },
                    ].map((item) => (
                      <div key={item.label}>
                        <div className="flex justify-between text-sm mb-1">
                          <span className="text-foreground/60">{item.label}</span>
                          <span className="text-foreground/80">{item.value}%</span>
                        </div>
                        <div className="w-full h-2 bg-surface-light rounded-full">
                          <div className={`h-full ${item.color} rounded-full transition-all`} style={{ width: `${item.value}%` }} />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeTab === 'users' && (
            <div className="space-y-4 animate-fade-in">
              <div className="flex items-center justify-between flex-wrap gap-3">
                <div className="relative flex-1 max-w-sm">
                  <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-foreground/30" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                  <input
                    type="text" placeholder="Buscar usuário..."
                    value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full pl-9 pr-4 py-2 bg-surface border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
                  />
                </div>
                <button
                  onClick={() => setShowCreateUser(true)}
                  className="px-4 py-2 bg-gradient-to-r from-primary to-accent text-white text-sm font-medium rounded-lg hover:opacity-90 transition-all"
                >
                  + Novo Usuário
                </button>
              </div>

              {showCreateUser && (
                <div className="bg-surface rounded-xl border border-primary/30 p-6 animate-slide-up">
                  <h3 className="font-bold text-foreground mb-4">Criar Novo Usuário</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <input
                      type="text" placeholder="Username"
                      value={newUser.username} onChange={(e) => setNewUser({ ...newUser, username: e.target.value })}
                      className="px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
                    />
                    <input
                      type="email" placeholder="Email"
                      value={newUser.email} onChange={(e) => setNewUser({ ...newUser, email: e.target.value })}
                      className="px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
                    />
                    <select
                      value={newUser.plan} onChange={(e) => setNewUser({ ...newUser, plan: e.target.value })}
                      className="px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
                    >
                      {mockPlans.map((p) => <option key={p.id} value={p.name}>{p.name}</option>)}
                    </select>
                    <input
                      type="number" placeholder="Max Telas" min={1} max={10}
                      value={newUser.maxScreens} onChange={(e) => setNewUser({ ...newUser, maxScreens: Number(e.target.value) })}
                      className="px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
                    />
                  </div>
                  <div className="flex gap-3 mt-4">
                    <button onClick={handleCreateUser} className="px-4 py-2 bg-primary text-white text-sm rounded-lg hover:opacity-90">Criar</button>
                    <button onClick={() => setShowCreateUser(false)} className="px-4 py-2 bg-surface-light text-foreground/60 text-sm rounded-lg hover:text-foreground">Cancelar</button>
                  </div>
                </div>
              )}

              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-border">
                      <th className="text-left px-4 py-3 text-xs font-medium text-foreground/50 uppercase">Usuário</th>
                      <th className="text-left px-4 py-3 text-xs font-medium text-foreground/50 uppercase">Plano</th>
                      <th className="text-left px-4 py-3 text-xs font-medium text-foreground/50 uppercase">Status</th>
                      <th className="text-left px-4 py-3 text-xs font-medium text-foreground/50 uppercase">Expira</th>
                      <th className="text-left px-4 py-3 text-xs font-medium text-foreground/50 uppercase">Telas</th>
                      <th className="text-left px-4 py-3 text-xs font-medium text-foreground/50 uppercase">Ações</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredUsers.map((user) => (
                      <tr key={user.id} className="border-b border-border/50 hover:bg-surface-hover transition-colors">
                        <td className="px-4 py-3">
                          <div>
                            <p className="text-sm font-medium text-foreground">{user.username}</p>
                            <p className="text-xs text-foreground/40">{user.email}</p>
                          </div>
                        </td>
                        <td className="px-4 py-3 text-sm text-foreground/70">{user.plan}</td>
                        <td className="px-4 py-3">
                          <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${
                            user.status === 'active' ? 'bg-success/20 text-success' :
                            user.status === 'expired' ? 'bg-warning/20 text-warning' :
                            user.status === 'suspended' ? 'bg-danger/20 text-danger' :
                            'bg-foreground/10 text-foreground/50'
                          }`}>
                            {user.status === 'active' ? 'Ativo' : user.status === 'expired' ? 'Expirado' : user.status === 'suspended' ? 'Suspenso' : 'Banido'}
                          </span>
                        </td>
                        <td className="px-4 py-3 text-sm text-foreground/50">{user.expiresAt}</td>
                        <td className="px-4 py-3 text-sm text-foreground/50">{user.maxScreens}</td>
                        <td className="px-4 py-3">
                          <div className="flex gap-1">
                            <button
                              onClick={() => updateUser(user.id, { status: user.status === 'active' ? 'suspended' : 'active' })}
                              className="p-1.5 rounded-lg hover:bg-surface-light transition-colors"
                              title={user.status === 'active' ? 'Suspender' : 'Ativar'}
                            >
                              <svg className={`w-4 h-4 ${user.status === 'active' ? 'text-warning' : 'text-success'}`} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d={user.status === 'active' ? 'M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636' : 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z'} />
                              </svg>
                            </button>
                            <button
                              onClick={() => updateUser(user.id, { expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0], status: 'active' })}
                              className="p-1.5 rounded-lg hover:bg-surface-light transition-colors"
                              title="Renovar 30 dias"
                            >
                              <svg className="w-4 h-4 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                              </svg>
                            </button>
                            <button
                              onClick={() => { if (confirm(`Deletar ${user.username}?`)) deleteUser(user.id) }}
                              className="p-1.5 rounded-lg hover:bg-danger/10 transition-colors"
                              title="Deletar"
                            >
                              <svg className="w-4 h-4 text-danger" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                              </svg>
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {activeTab === 'plans' && (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 animate-fade-in">
              {mockPlans.map((plan) => (
                <div key={plan.id} className="bg-surface rounded-xl border border-border p-6 hover:border-primary/30 transition-all">
                  <h3 className="font-bold text-lg text-foreground">{plan.name}</h3>
                  <p className="text-3xl font-bold text-primary mt-2">
                    {plan.price === 0 ? 'Grátis' : `R$ ${plan.price.toFixed(2)}`}
                    {plan.price > 0 && <span className="text-sm text-foreground/40 font-normal">/mês</span>}
                  </p>
                  <p className="text-xs text-foreground/40 mt-1">{plan.duration} dias &middot; {plan.maxScreens} tela(s)</p>
                  <ul className="mt-4 space-y-2">
                    {plan.features.map((f) => (
                      <li key={f} className="flex items-center gap-2 text-sm text-foreground/60">
                        <svg className="w-4 h-4 text-success shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                        </svg>
                        {f}
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          )}

          {activeTab === 'logs' && (
            <div className="bg-surface rounded-xl border border-border p-6 animate-fade-in">
              <h3 className="font-bold text-foreground mb-4">Logs do Sistema</h3>
              <div className="space-y-2 font-mono text-xs">
                {[
                  { time: '09:15:32', level: 'INFO', msg: 'Sistema iniciado com sucesso' },
                  { time: '09:16:01', level: 'INFO', msg: 'Usuário joao_silva fez login - IP: 192.168.1.10' },
                  { time: '09:18:45', level: 'INFO', msg: 'Stream iniciado: Canal SporTV - Usuário: joao_silva' },
                  { time: '09:20:12', level: 'WARN', msg: 'Tentativa de login falhada - IP: 10.0.0.55' },
                  { time: '09:22:33', level: 'INFO', msg: 'Novo usuário registrado: carlos_lima' },
                  { time: '09:25:01', level: 'INFO', msg: 'Assinatura expirada: pedro_costa' },
                  { time: '09:27:15', level: 'ERROR', msg: 'Falha na conexão com servidor de stream #3' },
                  { time: '09:28:00', level: 'INFO', msg: 'Reconexão automática com servidor #3 bem-sucedida' },
                  { time: '09:30:45', level: 'INFO', msg: 'Cache atualizado: 1500 canais sincronizados' },
                  { time: '09:32:10', level: 'WARN', msg: 'Rate limit atingido - IP: 172.16.0.88' },
                ].map((log, i) => (
                  <div key={i} className={`flex gap-3 px-3 py-2 rounded-lg ${
                    log.level === 'ERROR' ? 'bg-danger/10' : log.level === 'WARN' ? 'bg-warning/10' : 'bg-surface-light/50'
                  }`}>
                    <span className="text-foreground/30">{log.time}</span>
                    <span className={`font-medium ${
                      log.level === 'ERROR' ? 'text-danger' : log.level === 'WARN' ? 'text-warning' : 'text-success'
                    }`}>[{log.level}]</span>
                    <span className="text-foreground/60">{log.msg}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </main>
      </div>
    </div>
  )
}
