'use client';

import { useState } from 'react';
import SeverityBar from '@/components/shared/SeverityBar';

export default function EmergencyQueuePage() {
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <div className="space-y-6">
      {/* Stats / Overview Bento Grid */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="card">
          <p className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-2">Active Queue</p>
          <div className="flex items-baseline space-x-2">
            <h2 className="text-3xl font-semibold text-primary">24</h2>
            <span className="text-sm text-green-600 font-semibold">+3 since 1h</span>
          </div>
        </div>
        <div className="card">
          <p className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-2">Critical Triage</p>
          <div className="flex items-baseline space-x-2">
            <h2 className="text-3xl font-semibold text-danger">04</h2>
            <span className="text-sm text-danger font-semibold">Action Required</span>
          </div>
        </div>
        <div className="card">
          <p className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-2">Avg. Wait Time</p>
          <div className="flex items-baseline space-x-2">
            <h2 className="text-3xl font-semibold text-textprimary">18<span className="text-lg font-normal">m</span></h2>
            <span className="text-sm text-green-600 font-semibold">↓ 5m</span>
          </div>
        </div>
        <div className="card">
          <p className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-2">Staff on Duty</p>
          <div className="flex items-baseline space-x-2">
            <h2 className="text-3xl font-semibold text-textprimary">12</h2>
            <span className="text-sm text-textmuted">4 Departments</span>
          </div>
        </div>
      </div>

      {/* Controls & Filters */}
      <div className="bg-surface rounded-xl border border-border shadow-sm overflow-hidden">
        <div className="px-6 py-4 border-b border-border flex flex-col md:flex-row items-start md:items-center justify-between bg-slate-50 gap-4">
          <div className="flex items-center space-x-4">
            <h3 className="text-xl font-semibold text-textprimary">Live User Queue</h3>
            <span className="px-2 py-0.5 bg-blue-100 text-blue-800 rounded text-xs font-semibold uppercase tracking-wide">
              Live Updating
            </span>
          </div>
          <div className="flex items-center space-x-2 w-full md:w-auto">
            <button className="flex items-center space-x-2 px-4 py-2 border border-border rounded-lg text-sm text-textprimary hover:bg-slate-50 transition-colors active:scale-95 bg-white">
              <span className="material-symbols-outlined text-sm">filter_list</span>
              <span>Department</span>
            </button>
            <button className="flex items-center space-x-2 px-4 py-2 border border-border rounded-lg text-sm text-textprimary hover:bg-slate-50 transition-colors active:scale-95 bg-white">
              <span className="material-symbols-outlined text-sm">sort</span>
              <span>Priority Score</span>
            </button>
            <button className="flex items-center space-x-2 px-4 py-2 bg-primary text-white rounded-lg text-sm font-medium hover:scale-[1.02] transition-all active:scale-[0.97] shadow-sm">
              <span className="material-symbols-outlined text-sm">add</span>
              <span>Manual Entry</span>
            </button>
          </div>
        </div>

        {/* Queue Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[800px]">
            <thead className="bg-slate-50">
              <tr>
                <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">User Name</th>
                <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">MRN</th>
                <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">Triage Severity</th>
                <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">Status</th>
                <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">Wait Time</th>
                <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">Priority</th>
                <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                <td className="px-6 py-4">
                  <div className="flex items-center space-x-4">
                    <div className="w-10 h-10 rounded-full bg-red-100 text-danger flex items-center justify-center font-bold">AZ</div>
                    <div>
                      <p className="text-sm font-semibold text-textprimary">Ahmed Zafar</p>
                      <p className="text-xs text-textmuted">General OPD • Male, 45</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 text-sm font-mono text-textmuted">#MRN-90221</td>
                <td className="px-6 py-4">
                  <span className="px-3 py-1 bg-red-100 text-danger rounded-full text-xs font-bold">CRITICAL</span>
                </td>
                <td className="px-6 py-4">
                  <span className="flex items-center text-danger font-medium text-sm">
                    <span className="w-2 h-2 rounded-full bg-danger animate-pulse mr-2"></span>
                    Incoming
                  </span>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-semibold text-danger">04m</p>
                </td>
                <td className="px-6 py-4">
                  <div className="w-16 h-2 bg-slate-200 rounded-full overflow-hidden">
                    <div className="h-full bg-danger" style={{ width: '95%' }}></div>
                  </div>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="p-2 opacity-0 group-hover:opacity-100 transition-opacity text-textmuted hover:text-primary active:scale-90">
                    <span className="material-symbols-outlined">more_vert</span>
                  </button>
                </td>
              </tr>

              <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                <td className="px-6 py-4">
                  <div className="flex items-center space-x-4">
                    <div className="w-10 h-10 rounded-full bg-blue-100 text-primary flex items-center justify-center font-bold">FK</div>
                    <div>
                      <p className="text-sm font-semibold text-textprimary">Fatima Khan</p>
                      <p className="text-xs text-textmuted">Pediatrics • Female, 08</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 text-sm font-mono text-textmuted">#MRN-88432</td>
                <td className="px-6 py-4">
                  <span className="px-3 py-1 bg-orange-100 text-orange-800 rounded-full text-xs font-bold">MODERATE</span>
                </td>
                <td className="px-6 py-4">
                  <span className="flex items-center text-primary font-medium text-sm">
                    <span className="w-2 h-2 rounded-full bg-primary mr-2"></span>
                    Arrived
                  </span>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-semibold text-textprimary">12m</p>
                </td>
                <td className="px-6 py-4">
                  <div className="w-16 h-2 bg-slate-200 rounded-full overflow-hidden">
                    <div className="h-full bg-primary" style={{ width: '65%' }}></div>
                  </div>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="p-2 opacity-0 group-hover:opacity-100 transition-opacity text-textmuted hover:text-primary active:scale-90">
                    <span className="material-symbols-outlined">more_vert</span>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        {/* Table Pagination/Footer */}
        <div className="px-6 py-4 border-t border-border flex items-center justify-between bg-slate-50">
          <p className="text-sm text-textmuted">Showing 1-10 of 24 users</p>
          <div className="flex items-center space-x-2">
            <button className="p-2 border border-border bg-white rounded hover:bg-slate-50 disabled:opacity-30 transition-colors" disabled>
              <span className="material-symbols-outlined text-sm">chevron_left</span>
            </button>
            <button className="px-3 py-1 bg-primary text-white rounded text-sm font-medium">1</button>
            <button className="px-3 py-1 border border-border bg-white text-textmuted rounded hover:bg-slate-50 text-sm font-medium transition-colors">2</button>
            <button className="px-3 py-1 border border-border bg-white text-textmuted rounded hover:bg-slate-50 text-sm font-medium transition-colors">3</button>
            <button className="p-2 border border-border bg-white rounded hover:bg-slate-50 transition-colors">
              <span className="material-symbols-outlined text-sm">chevron_right</span>
            </button>
          </div>
        </div>
      </div>

      {/* Asymmetric Secondary Insight Area */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-surface p-6 rounded-xl border border-border shadow-sm">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-semibold text-textprimary">Staff Availability</h3>
            <button className="text-primary text-sm font-semibold hover:underline">View All Schedule</button>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="flex items-center justify-between p-4 border border-border rounded-lg bg-slate-50">
              <div className="flex items-center space-x-4">
                <div className="relative">
                  <div className="w-10 h-10 rounded-full bg-slate-200 border border-border flex items-center justify-center">
                    <span className="material-symbols-outlined text-textmuted">person</span>
                  </div>
                  <span className="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-surface rounded-full"></span>
                </div>
                <div>
                  <p className="text-sm font-semibold text-textprimary">Dr. Bilal Hussain</p>
                  <p className="text-xs text-textmuted">Cardiology • On Duty</p>
                </div>
              </div>
              <span className="text-xs font-semibold text-primary">4 in Queue</span>
            </div>
            
            <div className="flex items-center justify-between p-4 border border-border rounded-lg bg-slate-50">
              <div className="flex items-center space-x-4">
                <div className="relative">
                  <div className="w-10 h-10 rounded-full bg-slate-200 border border-border flex items-center justify-center">
                    <span className="material-symbols-outlined text-textmuted">person</span>
                  </div>
                  <span className="absolute bottom-0 right-0 w-3 h-3 bg-amber-500 border-2 border-surface rounded-full"></span>
                </div>
                <div>
                  <p className="text-sm font-semibold text-textprimary">Dr. Anam Tariq</p>
                  <p className="text-xs text-textmuted">Pediatrics • In Session</p>
                </div>
              </div>
              <span className="text-xs font-semibold text-primary">2 in Queue</span>
            </div>
          </div>
        </div>

        <div className="bg-primary p-6 rounded-xl border border-primary shadow-sm text-white relative overflow-hidden">
          {/* Atmospheric effect */}
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16 blur-2xl"></div>
          
          <h3 className="text-xl font-semibold mb-4 relative z-10">Queue Efficiency</h3>
          <p className="text-sm text-white/80 mb-6 relative z-10">Performance is 12% higher than yesterday's morning shift. Keep the flow steady!</p>
          
          <div className="space-y-4 relative z-10">
            <div>
              <div className="flex justify-between text-xs font-semibold mb-1">
                <span>Triage Velocity</span>
                <span>88%</span>
              </div>
              <div className="w-full h-1.5 bg-white/20 rounded-full">
                <div className="h-full bg-white rounded-full" style={{ width: '88%' }}></div>
              </div>
            </div>
            <div>
              <div className="flex justify-between text-xs font-semibold mb-1">
                <span>User Satisfaction</span>
                <span>4.8/5</span>
              </div>
              <div className="w-full h-1.5 bg-white/20 rounded-full">
                <div className="h-full bg-white rounded-full" style={{ width: '92%' }}></div>
              </div>
            </div>
          </div>
          
          <button className="mt-8 w-full py-2 bg-white text-primary rounded-lg text-sm font-semibold hover:bg-slate-50 transition-colors active:scale-95 shadow-sm">
            Download Report
          </button>
        </div>
      </div>

    </div>
  );
}
