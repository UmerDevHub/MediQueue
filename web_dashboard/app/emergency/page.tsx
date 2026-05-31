'use client'

import React, { useEffect, useMemo, useState } from 'react';
import Sidebar from '../../components/Sidebar';
import { Activity, AlertCircle, Download, Filter, MapPin } from 'lucide-react';

type QueueRow = {
  id: string
  userName: string
  severity: number
  etaMinutes: number
  position: number
  status: 'Dispatched' | 'En Route' | 'Arrived'
}

const seedQueue: QueueRow[] = [
  { id: 'INC-8931', userName: 'Ahmed Khan', severity: 9, etaMinutes: 4, position: 1, status: 'En Route' },
  { id: 'INC-8932', userName: 'Fatima Bibi', severity: 6, etaMinutes: 11, position: 2, status: 'Dispatched' },
  { id: 'INC-8933', userName: 'Usman Ali', severity: 3, etaMinutes: 18, position: 3, status: 'Dispatched' },
]

function severityColor(severity: number) {
  if (severity >= 7) return 'bg-[#DC2626] text-white'
  if (severity >= 4) return 'bg-[#D97706] text-white'
  return 'bg-[#16A34A] text-white'
}

function severityLabel(severity: number) {
  if (severity >= 7) return 'CRITICAL'
  if (severity >= 4) return 'MODERATE'
  return 'STABLE'
}

export default function EmergencyQueue() {
  const [queue, setQueue] = useState<QueueRow[]>(seedQueue)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    let active = true
    const fetchLive = async () => {
      setLoading(true)
      try {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/emergency/active`)
        if (!res.ok) return
        const data = await res.json()
        if (!active) return
        const mapped: QueueRow[] = (data.incidents || []).map((row: any, idx: number) => ({
          id: row.id ?? `INC-${9000 + idx}`,
          userName: row.user_name ?? 'Unknown',
          severity: Number(row.severity_score ?? row.severity ?? 5),
          etaMinutes: Number(row.eta ?? 10),
          position: idx + 1,
          status: (row.status ?? 'Dispatched').replace(/_/g, ' ') as QueueRow['status'],
        }))
        if (mapped.length) setQueue(mapped)
      } catch {
        // Keep last known queue on any fetch failure.
      } finally {
        if (active) setLoading(false)
      }
    }

    fetchLive()
    const refresh = setInterval(fetchLive, 8000)
    return () => {
      active = false
      clearInterval(refresh)
    }
  }, [])

  useEffect(() => {
    const ticker = setInterval(() => {
      setQueue((prev) =>
        prev.map((row) => {
          const nextEta = Math.max(row.etaMinutes - 1, 0)
          const nextStatus = nextEta === 0 ? 'Arrived' : row.etaMinutes <= 3 ? 'En Route' : row.status
          return { ...row, etaMinutes: nextEta, status: nextStatus }
        })
      )
    }, 60000)
    return () => clearInterval(ticker)
  }, [])

  const summary = useMemo(() => {
    const critical = queue.filter((q) => q.severity >= 7).length
    const enRoute = queue.filter((q) => q.status === 'En Route').length
    return { total: queue.length, critical, enRoute }
  }, [queue])

  return (
    <div className="min-h-screen bg-[#F8FAFC] flex font-sans text-[#0F172A]">
      <Sidebar />

      <div className="flex-1 ml-[240px] p-8">
        <header className="mb-8 flex flex-wrap items-end justify-between gap-4">
          <div>
            <h1 className="text-3xl font-bold text-[#0F172A]">Emergency Queue</h1>
            <p className="text-[#64748B] mt-1">Live tracking of incoming emergencies for hospital operations</p>
          </div>
          <div className="flex items-center gap-3">
            <button className="flex items-center gap-2 bg-white border border-[#E2E8F0] px-4 py-2 rounded-lg text-sm font-medium hover:bg-gray-50 transition">
              <Filter className="h-4 w-4" /> Filters
            </button>
            <button className="flex items-center gap-2 bg-white border border-[#E2E8F0] px-4 py-2 rounded-lg text-sm font-medium hover:bg-gray-50 transition">
              <Download className="h-4 w-4" /> Export CSV
            </button>
          </div>
        </header>

        <div className="grid grid-cols-1 xl:grid-cols-[1.5fr_1fr] gap-6 mb-8">
          <div className="bg-white rounded-xl border border-[#E2E8F0] shadow-sm">
            <div className="p-6 border-b border-[#E2E8F0] flex items-center justify-between">
              <div>
                <h2 className="text-lg font-bold flex items-center gap-2">
                  <Activity className="h-4 w-4 text-[#2563EB]" /> Live Emergency Tracking
                </h2>
                <p className="text-xs text-[#64748B] mt-1">Updated every few seconds</p>
              </div>
              <div className="flex items-center gap-3 text-xs">
                <span className="px-2 py-1 rounded-full bg-red-50 text-[#DC2626] font-semibold">Critical: {summary.critical}</span>
                <span className="px-2 py-1 rounded-full bg-amber-50 text-[#D97706] font-semibold">En Route: {summary.enRoute}</span>
                <span className="px-2 py-1 rounded-full bg-slate-100 text-[#64748B] font-semibold">Total: {summary.total}</span>
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left">
                <thead className="bg-[#F8FAFC] text-[#64748B] text-xs uppercase tracking-wider">
                  <tr>
                    <th className="p-4 font-semibold">User</th>
                    <th className="p-4 font-semibold">Severity</th>
                    <th className="p-4 font-semibold">Arrival ETA</th>
                    <th className="p-4 font-semibold">Queue Pos</th>
                    <th className="p-4 font-semibold">Status</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-[#E2E8F0] text-sm">
                  {queue.map((row) => (
                    <tr key={row.id} className="hover:bg-slate-50 transition">
                      <td className="p-4">
                        <div className="font-semibold text-[#0F172A]">{row.userName}</div>
                        <div className="text-xs text-[#64748B]">{row.id}</div>
                      </td>
                      <td className="p-4">
                        <span className={`text-xs font-bold px-2.5 py-1 rounded-full ${severityColor(row.severity)}`}>
                          {severityLabel(row.severity)}
                        </span>
                      </td>
                      <td className="p-4">
                        <div className="text-sm font-semibold text-[#0F172A]">Arriving in {row.etaMinutes} mins</div>
                        <div className="text-xs text-[#64748B]">Ambulance tracked live</div>
                      </td>
                      <td className="p-4">
                        <div className="inline-flex items-center gap-2 font-semibold">
                          <span className="text-[#2563EB]">#{row.position}</span>
                          <span className="h-2 w-2 rounded-full bg-[#2563EB] animate-pulse"></span>
                        </div>
                      </td>
                      <td className="p-4">
                        <span className="text-xs font-bold px-2.5 py-1 rounded-full bg-slate-100 text-[#0F172A]">
                          {row.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                  {!queue.length && !loading && (
                    <tr>
                      <td colSpan={5} className="p-6 text-center text-[#64748B]">
                        No active emergencies right now.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>

          <div className="bg-white rounded-xl border border-[#E2E8F0] shadow-sm">
            <div className="p-6 border-b border-[#E2E8F0] flex items-center gap-2">
              <MapPin className="h-4 w-4 text-[#2563EB]" /> Live Map / Radar
            </div>
            <div className="p-6">
              <div className="relative h-64 rounded-xl border border-[#E2E8F0] bg-gradient-to-br from-slate-50 to-white overflow-hidden">
                <div className="absolute inset-6 rounded-full border border-dashed border-blue-200"></div>
                <div className="absolute inset-14 rounded-full border border-dashed border-blue-100"></div>
                <div className="absolute inset-24 rounded-full border border-dashed border-blue-50"></div>
                <div className="absolute left-8 top-10 text-xs font-semibold text-[#2563EB] flex items-center gap-1">
                  <MapPin className="h-3 w-3" /> City Hospital
                </div>
                <div className="absolute right-10 bottom-16 text-xs font-semibold text-[#DC2626] flex items-center gap-1">
                  <AlertCircle className="h-3 w-3" /> Ambulance en route
                </div>
                <div className="absolute left-[50%] top-[35%] h-3 w-3 rounded-full bg-[#DC2626] shadow-lg animate-pulse"></div>
                <div className="absolute left-[50%] top-[35%] h-20 w-20 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[#DC2626]/10 animate-ping"></div>
                <div className="absolute bottom-4 right-4 text-xs text-[#64748B]">
                  Live tracking placeholder
                </div>
              </div>
              <div className="mt-4 text-xs text-[#64748B]">
                Tracking is simulated until device GPS + dispatch stream is connected.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}