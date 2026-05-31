'use client'

import { useEffect, useState } from 'react'
import { Building2, Hospital, MapPinned, Users } from 'lucide-react'
import { supabase } from '../../lib/supabaseClient'

export default function SuperAdminDashboard() {
  const [metrics, setMetrics] = useState({ hospitals: 0, users: 0, emergencies: 0 })

  useEffect(() => {
    let active = true
    const loadMetrics = async () => {
      try {
        const [hospitals, users, incidents] = await Promise.all([
          supabase.from('hospitals').select('id', { count: 'exact', head: true }),
          supabase.from('users').select('id', { count: 'exact', head: true }),
          supabase.from('incidents').select('id', { count: 'exact', head: true }),
        ])
        if (!active) return
        setMetrics({
          hospitals: hospitals.count ?? 0,
          users: users.count ?? 0,
          emergencies: incidents.count ?? 0,
        })
      } catch {
        // Keep defaults if metrics cannot load.
      }
    }

    loadMetrics()
    const refresh = setInterval(loadMetrics, 15000)
    return () => {
      active = false
      clearInterval(refresh)
    }
  }, [])

  return (
    <div className="min-h-screen bg-background text-textprimary">
      <div className="bg-[#0F172A] text-white px-8 py-6 flex items-center justify-between">
        <div>
          <p className="text-sm text-slate-300">MediQueue Platform</p>
          <h1 className="text-2xl font-semibold">Super Admin Command Center</h1>
        </div>
        <div className="flex items-center gap-2 text-sm">
          <span className="inline-flex items-center gap-2 bg-white/10 px-3 py-1.5 rounded-full">
            <MapPinned className="h-4 w-4 text-[#2563EB]" />
            Monitoring all hospitals
          </span>
        </div>
      </div>

      <div className="p-8 space-y-8">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <MetricCard title="Total Hospitals" value={metrics.hospitals} icon={Hospital} />
          <MetricCard title="Total Users" value={metrics.users} icon={Users} />
          <MetricCard title="Active Emergencies" value={metrics.emergencies} icon={Building2} accent="danger" />
        </div>

        <div className="bg-white rounded-xl border border-border shadow-card p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold">Master Load Map</h2>
            <span className="text-xs text-textmuted">Live operations view</span>
          </div>
          <div className="h-72 rounded-xl border border-dashed border-border bg-slate-50 flex items-center justify-center relative overflow-hidden">
            <div className="absolute inset-10 rounded-full border border-blue-100"></div>
            <div className="absolute inset-20 rounded-full border border-blue-50"></div>
            <div className="absolute left-[22%] top-[35%] h-3 w-3 rounded-full bg-[#2563EB] animate-pulse"></div>
            <div className="absolute left-[45%] top-[55%] h-3 w-3 rounded-full bg-[#D97706] animate-pulse"></div>
            <div className="absolute right-[20%] top-[40%] h-3 w-3 rounded-full bg-[#DC2626] animate-pulse"></div>
            <div className="text-sm text-textmuted">Global hospital load map placeholder</div>
          </div>
        </div>
      </div>
    </div>
  )
}

function MetricCard({
  title,
  value,
  icon: Icon,
  accent = 'primary',
}: {
  title: string
  value: number
  icon: any
  accent?: 'primary' | 'danger'
}) {
  const color = accent === 'danger' ? 'text-[#DC2626] bg-red-50' : 'text-[#2563EB] bg-blue-50'
  return (
    <div className="bg-white rounded-xl border border-border shadow-card p-6 flex items-center justify-between">
      <div>
        <p className="text-sm text-textmuted font-semibold uppercase">{title}</p>
        <h3 className="text-3xl font-bold mt-2">{value}</h3>
      </div>
      <div className={`p-3 rounded-lg ${color}`}>
        <Icon className="h-5 w-5" />
      </div>
    </div>
  )
}
