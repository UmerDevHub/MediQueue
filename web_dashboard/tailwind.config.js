/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './lib/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary:    '#2563EB',
        danger:     '#DC2626',
        success:    '#16A34A',
        warning:    '#D97706',
        background: '#F8FAFC',
        surface:    '#FFFFFF',
        textprimary:'#0F172A',
        textmuted:  '#64748B',
        border:     '#E2E8F0',
        sidebar:    '#0F172A',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        card: '0 1px 3px 0 rgba(0,0,0,0.08), 0 1px 2px -1px rgba(0,0,0,0.06)',
        elevated: '0 4px 12px 0 rgba(0,0,0,0.10)',
      },
    },
  },
  plugins: [],
}
