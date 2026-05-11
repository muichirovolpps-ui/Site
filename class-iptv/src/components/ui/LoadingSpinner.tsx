'use client'

export default function LoadingSpinner({ size = 'md', text }: { size?: 'sm' | 'md' | 'lg'; text?: string }) {
  const sizes = { sm: 'w-6 h-6', md: 'w-10 h-10', lg: 'w-16 h-16' }

  return (
    <div className="flex flex-col items-center justify-center gap-3">
      <div className={`${sizes[size]} relative`}>
        <div className="absolute inset-0 rounded-full border-2 border-primary/20" />
        <div className="absolute inset-0 rounded-full border-2 border-transparent border-t-primary animate-spin" />
        <div className="absolute inset-1 rounded-full border-2 border-transparent border-b-neon animate-spin" style={{ animationDirection: 'reverse', animationDuration: '0.8s' }} />
      </div>
      {text && <p className="text-sm text-foreground/60 animate-pulse">{text}</p>}
    </div>
  )
}
