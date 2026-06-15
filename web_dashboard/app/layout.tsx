import type { ReactNode } from 'react'
import './globals.css'

export const metadata = {
  title: 'MediQueue Dashboard',
  description: 'Hospital queue management system',
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <head>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
      </head>
      <body>{children}</body>
    </html>
  )
}
