'use client'

import { useState } from 'react'
import { CalendarClock, ClipboardList, ToggleLeft, ToggleRight, User } from 'lucide-react'

const schedule = [
  { time: '09:30 AM', user: 'Ayesha Tariq', reason: 'Follow-up', status: 'Pending' },
  { time: '11:00 AM', user: 'Usman Ali', reason: 'Cardiology consult', status: 'Ready' },
  { time: '01:15 PM', user: 'Hina Saleem', reason: 'Diagnostics review', status: 'Pending' },
]

const queue = [
  { id: 'Q-301', user: 'Saad Khan', severity: 'Moderate', status: 'Waiting' },
  { id: 'Q-302', user: 'Nadia Iqbal', severity: 'Critical', status: 'In Room' },
  { id: 'Q-303', user: 'Bilal Ahmed', severity: 'Stable', status: 'Waiting' },
]

export default function DoctorDashboard() {
  const [onDuty, setOnDuty] = useState(true)

  return (
    <div className="min-h-screen bg-background text-textprimary">
      <div className="px-8 py-6 border-b border-border bg-white flex items-center justify-between">
        <div>
          <p className="text-sm text-textmuted">Doctor Workspace</p>
          <h1 className="text-2xl font-semibold">Today&apos;s Clinic Overview</h1>
        </div>
        <button
          onClick={() => setOnDuty((prev) => !prev)}
          className="flex items-center gap-2 text-sm font-semibold"
        >
          {onDuty ? (
            <>
              <ToggleRight className="h-5 w-5 text-[#16A34A]" /> On Duty
            </>
          ) : (
            <>
              <ToggleLeft className="h-5 w-5 text-[#64748B]" /> Off Duty
            </>
          )}
        </button>
      </div>

      <div className="p-8 space-y-8">
        <div className="bg-white rounded-xl border border-border shadow-card p-6">
          <div className="flex items-center gap-2 mb-4">
            <CalendarClock className="h-4 w-4 text-[#2563EB]" />
            <h2 className="text-lg font-semibold">Today&apos;s Schedule</h2>
          </div>
          <div className="space-y-4">
            {schedule.map((slot) => (
              <div key={slot.time} className="flex items-center justify-between border border-border rounded-lg p-4">
                <div>
                  <div className="text-sm font-semibold">{slot.time} · {slot.user}</div>
                  <div className="text-xs text-textmuted">{slot.reason}</div>
                </div>
                <span className="text-xs font-bold px-2.5 py-1 rounded-full bg-slate-100 text-textprimary">
                  {slot.status}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white rounded-xl border border-border shadow-card p-6">
          <div className="flex items-center gap-2 mb-4">
            <ClipboardList className="h-4 w-4 text-[#2563EB]" />
            <h2 className="text-lg font-semibold">User Queue</h2>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-[#F8FAFC] text-[#64748B] text-xs uppercase tracking-wider">
                <tr>
                  <th className="p-3 font-semibold">Queue ID</th>
                  <th className="p-3 font-semibold">User</th>
                  <th className="p-3 font-semibold">Severity</th>
                  <th className="p-3 font-semibold">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#E2E8F0] text-sm">
                {queue.map((row) => (
                  <tr key={row.id} className="hover:bg-slate-50">
                    <td className="p-3 font-medium">{row.id}</td>
                    <td className="p-3 flex items-center gap-2">
                      <span className="h-8 w-8 rounded-full bg-slate-100 flex items-center justify-center text-xs font-semibold text-[#2563EB]">
                        <User className="h-4 w-4" />
                      </span>
                      {row.user}
                    </td>
                    <td className="p-3">
                      <span className="text-xs font-semibold px-2 py-1 rounded-full bg-amber-50 text-[#D97706]">
                        {row.severity}
                      </span>
                    </td>
                    <td className="p-3 text-textmuted">{row.status}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
}
