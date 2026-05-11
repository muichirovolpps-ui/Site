'use client'

import { useState } from 'react'
import AppShell from '@/components/layout/AppShell'
import { useAuthStore } from '@/store'

export default function ConfiguracoesPage() {
  const { user, logout } = useAuthStore()
  const [darkMode, setDarkMode] = useState(true)
  const [language, setLanguage] = useState('pt-BR')
  const [quality, setQuality] = useState('auto')
  const [notifications, setNotifications] = useState(true)
  const [parentalControl, setParentalControl] = useState(false)
  const [parentalPin, setParentalPin] = useState('')
  const [currentPassword, setCurrentPassword] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [saved, setSaved] = useState(false)

  const handleSave = () => {
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  return (
    <AppShell>
      <div className="max-w-3xl mx-auto space-y-6">
        <h1 className="text-2xl font-bold text-foreground flex items-center gap-2">
          <svg className="w-7 h-7 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          Configurações
        </h1>

        <div className="bg-surface rounded-xl border border-border p-6">
          <h2 className="font-bold text-foreground mb-4">Perfil</h2>
          <div className="flex items-center gap-4 mb-4">
            <div className="w-16 h-16 rounded-full bg-gradient-to-br from-primary to-accent flex items-center justify-center">
              <span className="text-2xl font-bold text-white">{user?.username?.charAt(0).toUpperCase()}</span>
            </div>
            <div>
              <p className="font-medium text-foreground">{user?.username}</p>
              <p className="text-sm text-foreground/50">{user?.email}</p>
              <p className="text-xs text-primary mt-1">{user?.plan}</p>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div className="bg-surface-light rounded-lg p-3">
              <span className="text-foreground/40">Status</span>
              <p className="text-success font-medium mt-1">Ativo</p>
            </div>
            <div className="bg-surface-light rounded-lg p-3">
              <span className="text-foreground/40">Expira em</span>
              <p className="text-foreground font-medium mt-1">{user?.expiresAt}</p>
            </div>
            <div className="bg-surface-light rounded-lg p-3">
              <span className="text-foreground/40">Telas Simultâneas</span>
              <p className="text-foreground font-medium mt-1">{user?.maxScreens}</p>
            </div>
            <div className="bg-surface-light rounded-lg p-3">
              <span className="text-foreground/40">Membro desde</span>
              <p className="text-foreground font-medium mt-1">{user?.createdAt}</p>
            </div>
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border p-6">
          <h2 className="font-bold text-foreground mb-4">Aparência</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-foreground">Tema Escuro</p>
                <p className="text-xs text-foreground/40">Interface com fundo escuro premium</p>
              </div>
              <button
                onClick={() => setDarkMode(!darkMode)}
                className={`w-12 h-6 rounded-full transition-colors relative ${darkMode ? 'bg-primary' : 'bg-surface-light'}`}
              >
                <div className={`w-5 h-5 rounded-full bg-white absolute top-0.5 transition-all ${darkMode ? 'left-6' : 'left-0.5'}`} />
              </button>
            </div>
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-foreground">Idioma</p>
                <p className="text-xs text-foreground/40">Idioma da interface</p>
              </div>
              <select
                value={language}
                onChange={(e) => setLanguage(e.target.value)}
                className="px-3 py-1.5 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none"
              >
                <option value="pt-BR">Português (BR)</option>
                <option value="en">English</option>
                <option value="es">Español</option>
              </select>
            </div>
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border p-6">
          <h2 className="font-bold text-foreground mb-4">Streaming</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-foreground">Qualidade Padrão</p>
                <p className="text-xs text-foreground/40">Qualidade de vídeo preferida</p>
              </div>
              <select
                value={quality}
                onChange={(e) => setQuality(e.target.value)}
                className="px-3 py-1.5 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none"
              >
                <option value="auto">Automático</option>
                <option value="4k">4K Ultra HD</option>
                <option value="1080p">1080p Full HD</option>
                <option value="720p">720p HD</option>
                <option value="480p">480p</option>
              </select>
            </div>
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-foreground">Notificações</p>
                <p className="text-xs text-foreground/40">Receber alertas e avisos</p>
              </div>
              <button
                onClick={() => setNotifications(!notifications)}
                className={`w-12 h-6 rounded-full transition-colors relative ${notifications ? 'bg-primary' : 'bg-surface-light'}`}
              >
                <div className={`w-5 h-5 rounded-full bg-white absolute top-0.5 transition-all ${notifications ? 'left-6' : 'left-0.5'}`} />
              </button>
            </div>
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border p-6">
          <h2 className="font-bold text-foreground mb-4">Controle Parental</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-foreground">Ativar Controle Parental</p>
                <p className="text-xs text-foreground/40">Bloquear conteúdo adulto com PIN</p>
              </div>
              <button
                onClick={() => setParentalControl(!parentalControl)}
                className={`w-12 h-6 rounded-full transition-colors relative ${parentalControl ? 'bg-primary' : 'bg-surface-light'}`}
              >
                <div className={`w-5 h-5 rounded-full bg-white absolute top-0.5 transition-all ${parentalControl ? 'left-6' : 'left-0.5'}`} />
              </button>
            </div>
            {parentalControl && (
              <div>
                <label className="text-sm text-foreground/60 block mb-1">PIN (4 dígitos)</label>
                <input
                  type="password"
                  maxLength={4}
                  value={parentalPin}
                  onChange={(e) => setParentalPin(e.target.value.replace(/\D/g, ''))}
                  placeholder="****"
                  className="w-32 px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground text-center tracking-[0.5em] focus:outline-none focus:border-primary/50"
                />
              </div>
            )}
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border p-6">
          <h2 className="font-bold text-foreground mb-4">Alterar Senha</h2>
          <div className="space-y-3 max-w-sm">
            <input
              type="password" placeholder="Senha atual"
              value={currentPassword} onChange={(e) => setCurrentPassword(e.target.value)}
              className="w-full px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
            />
            <input
              type="password" placeholder="Nova senha"
              value={newPassword} onChange={(e) => setNewPassword(e.target.value)}
              className="w-full px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
            />
            <input
              type="password" placeholder="Confirmar nova senha"
              value={confirmPassword} onChange={(e) => setConfirmPassword(e.target.value)}
              className="w-full px-3 py-2 bg-surface-light border border-border rounded-lg text-sm text-foreground focus:outline-none focus:border-primary/50"
            />
          </div>
        </div>

        <div className="bg-surface rounded-xl border border-border p-6">
          <h2 className="font-bold text-foreground mb-4">Dispositivos Conectados</h2>
          {user?.devices && user.devices.length > 0 ? (
            <div className="space-y-3">
              {user.devices.map((dev) => (
                <div key={dev.id} className="flex items-center justify-between bg-surface-light rounded-lg p-3">
                  <div className="flex items-center gap-3">
                    <span className="text-xl">
                      {dev.type === 'mobile' ? '📱' : dev.type === 'tv' ? '📺' : dev.type === 'tablet' ? '📋' : '💻'}
                    </span>
                    <div>
                      <p className="text-sm font-medium text-foreground">{dev.name}</p>
                      <p className="text-xs text-foreground/40">IP: {dev.ip}</p>
                    </div>
                  </div>
                  <button className="text-xs text-danger hover:text-danger/80">Remover</button>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-sm text-foreground/40">Nenhum dispositivo conectado</p>
          )}
        </div>

        <div className="flex gap-3">
          <button
            onClick={handleSave}
            className="px-6 py-2.5 bg-gradient-to-r from-primary to-accent text-white font-medium rounded-xl hover:opacity-90 transition-all"
          >
            {saved ? 'Salvo!' : 'Salvar Configurações'}
          </button>
          <button
            onClick={logout}
            className="px-6 py-2.5 bg-danger/10 text-danger border border-danger/30 font-medium rounded-xl hover:bg-danger/20 transition-all"
          >
            Sair da Conta
          </button>
        </div>
      </div>
    </AppShell>
  )
}
