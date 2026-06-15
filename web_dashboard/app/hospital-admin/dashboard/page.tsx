'use client';

import SeverityBar from '@/components/shared/SeverityBar';
import StatusBadge from '@/components/shared/StatusBadge';

export default function HospitalAdminDashboard() {
  return (
    <div className="space-y-6">
      {/* Header Actions Section */}
      <div className="flex justify-between items-end mb-6">
        <div>
          <h2 className="text-3xl font-semibold text-textprimary">Dashboard Overview</h2>
          <p className="text-sm text-textmuted mt-1">System status and operational summary for today.</p>
        </div>
        <div className="flex gap-4">
          <button className="flex items-center gap-2 px-4 py-2 bg-surface border border-border text-primary font-semibold text-sm rounded-lg shadow-sm hover:scale-[1.02] active:scale-[0.97] transition-all">
            <span className="material-symbols-outlined">download</span>
            Export Report
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-primary text-white font-semibold text-sm rounded-lg shadow-sm hover:scale-[1.02] active:scale-[0.97] transition-all">
            <span className="material-symbols-outlined">add</span>
            New Admission
          </button>
        </div>
      </div>

      {/* 4 Key Metric Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="card hover:scale-[1.02] transition-transform duration-150 cursor-pointer">
          <div className="flex justify-between items-start mb-4">
            <div className="p-2 rounded-lg bg-primary/10 text-primary">
              <span className="material-symbols-outlined">pending_actions</span>
            </div>
            <span className="text-xs text-primary font-bold bg-primary/10 px-2 py-0.5 rounded-full">+12%</span>
          </div>
          <h3 className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-1">Current Queue</h3>
          <p className="text-3xl font-semibold text-textprimary">42 Users</p>
          <p className="text-sm text-textmuted mt-2">Expected wait: 18 mins</p>
        </div>

        <div className="card hover:scale-[1.02] transition-transform duration-150 cursor-pointer">
          <div className="flex justify-between items-start mb-4">
            <div className="p-2 rounded-lg bg-blue-100 text-blue-700">
              <span className="material-symbols-outlined">medical_information</span>
            </div>
            <span className="text-xs text-blue-700 font-bold bg-blue-100 px-2 py-0.5 rounded-full">Active</span>
          </div>
          <h3 className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-1">Active Doctors</h3>
          <p className="text-3xl font-semibold text-textprimary">18 / 24</p>
          <p className="text-sm text-textmuted mt-2">6 on emergency call</p>
        </div>

        <div className="card hover:scale-[1.02] transition-transform duration-150 cursor-pointer">
          <div className="flex justify-between items-start mb-4">
            <div className="p-2 rounded-lg bg-indigo-100 text-indigo-700">
              <span className="material-symbols-outlined">calendar_month</span>
            </div>
            <span className="text-xs text-indigo-700 font-bold bg-indigo-100 px-2 py-0.5 rounded-full">85% Fulfilled</span>
          </div>
          <h3 className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-1">Appointments</h3>
          <p className="text-3xl font-semibold text-textprimary">156 Today</p>
          <p className="text-sm text-textmuted mt-2">24 remaining</p>
        </div>

        <div className="card hover:scale-[1.02] transition-transform duration-150 cursor-pointer">
          <div className="flex justify-between items-start mb-4">
            <div className="p-2 rounded-lg bg-red-100 text-red-700">
              <span className="material-symbols-outlined">timer</span>
            </div>
            <span className="text-xs text-danger font-bold bg-red-100 px-2 py-0.5 rounded-full">-5m Avg</span>
          </div>
          <h3 className="text-xs text-textmuted font-semibold uppercase tracking-wider mb-1">Avg. Wait Time</h3>
          <p className="text-3xl font-semibold text-textprimary">24.5 Mins</p>
          <p className="text-sm text-textmuted mt-2">Down from 30m yesterday</p>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
        
        {/* Critical Monitoring Section */}
        <div className="col-span-1 md:col-span-8 bg-surface border border-border rounded-xl shadow-card flex flex-col overflow-hidden">
          <div className="p-6 border-b border-border flex justify-between items-center bg-slate-50">
            <div className="flex items-center gap-3">
              <span className="material-symbols-outlined text-danger animate-pulse" style={{ fontVariationSettings: "'FILL' 1" }}>e911_emergency</span>
              <h3 className="text-xl font-semibold text-textprimary">Critical Monitoring</h3>
            </div>
            <div className="flex gap-2">
              <span className="flex items-center gap-1.5 px-2 py-1 bg-red-100 text-danger rounded text-xs font-semibold">
                <span className="w-2 h-2 rounded-full bg-danger"></span> Live
              </span>
            </div>
          </div>
          <div className="flex-1 overflow-x-auto">
            <table className="w-full text-left border-collapse min-w-[600px]">
              <thead className="bg-slate-50 border-b border-border">
                <tr>
                  <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">User</th>
                  <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">Emergency Type</th>
                  <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">Triage</th>
                  <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">ETA/Status</th>
                  <th className="px-6 py-4 text-xs font-semibold text-textmuted uppercase tracking-wider">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                <tr className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-lg bg-slate-200 flex items-center justify-center text-textmuted">
                        <span className="material-symbols-outlined">person</span>
                      </div>
                      <div>
                        <p className="text-sm font-bold text-textprimary">Zubair Khan</p>
                        <p className="text-xs text-textmuted">MRN: #98221</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <p className="text-sm font-medium text-textprimary">Cardiac Arrest</p>
                    <p className="text-xs text-danger font-medium mt-0.5">Critical Vitals</p>
                  </td>
                  <td className="px-6 py-4">
                    <SeverityBar level={1} />
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-0.5">
                      <span className="text-sm font-bold text-textprimary">Incoming</span>
                      <span className="text-xs text-textmuted">ETA: 4 mins</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <button className="btn-primary py-1.5 px-3">Assign Team</button>
                  </td>
                </tr>
                <tr className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-lg bg-slate-200 flex items-center justify-center text-textmuted">
                        <span className="material-symbols-outlined">person</span>
                      </div>
                      <div>
                        <p className="text-sm font-bold text-textprimary">Fatima Shah</p>
                        <p className="text-xs text-textmuted">MRN: #98225</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <p className="text-sm font-medium text-textprimary">Severe Trauma</p>
                    <p className="text-xs text-textmuted mt-0.5">Road Accident</p>
                  </td>
                  <td className="px-6 py-4">
                    <SeverityBar level={1} />
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-0.5">
                      <span className="text-sm font-bold text-textprimary">Arrived</span>
                      <span className="text-xs text-textmuted">Bay 04</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <button className="btn-ghost border border-border py-1.5 px-3 text-primary bg-white">View Record</button>
                  </td>
                </tr>
                <tr className="hover:bg-slate-50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-lg bg-slate-200 flex items-center justify-center text-textmuted">
                        <span className="material-symbols-outlined">person</span>
                      </div>
                      <div>
                        <p className="text-sm font-bold text-textprimary">Ali Raza</p>
                        <p className="text-xs text-textmuted">MRN: #98230</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <p className="text-sm font-medium text-textprimary">Respiratory Distress</p>
                    <p className="text-xs text-textmuted mt-0.5">Asthma Complication</p>
                  </td>
                  <td className="px-6 py-4">
                    <SeverityBar level={2} />
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-0.5">
                      <span className="text-sm font-bold text-textprimary">En Route</span>
                      <span className="text-xs text-textmuted">ETA: 12 mins</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <button className="btn-primary py-1.5 px-3">Pre-Authorize</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div className="p-4 bg-slate-50 border-t border-border text-center">
            <button className="text-primary font-semibold text-sm hover:underline">View All Active Emergencies</button>
          </div>
        </div>

        {/* Quick Actions Panel */}
        <div className="col-span-1 md:col-span-4 flex flex-col gap-6">
          <div className="card">
            <h3 className="text-xl font-semibold text-textprimary mb-6">Quick Actions</h3>
            <div className="grid grid-cols-2 gap-4">
              <button className="flex flex-col items-center justify-center p-4 rounded-xl bg-slate-50 hover:bg-primary/10 hover:text-primary transition-all group active:scale-[0.95] border border-border">
                <span className="material-symbols-outlined text-3xl mb-2 text-primary">medical_services</span>
                <span className="text-xs font-bold text-center">Add Staff</span>
              </button>
              <button className="flex flex-col items-center justify-center p-4 rounded-xl bg-slate-50 hover:bg-primary/10 hover:text-primary transition-all group active:scale-[0.95] border border-border">
                <span className="material-symbols-outlined text-3xl mb-2 text-primary">bed</span>
                <span className="text-xs font-bold text-center">Bed Status</span>
              </button>
              <button className="flex flex-col items-center justify-center p-4 rounded-xl bg-slate-50 hover:bg-primary/10 hover:text-primary transition-all group active:scale-[0.95] border border-border">
                <span className="material-symbols-outlined text-3xl mb-2 text-primary">inventory_2</span>
                <span className="text-xs font-bold text-center">Supplies</span>
              </button>
              <button className="flex flex-col items-center justify-center p-4 rounded-xl bg-slate-50 hover:bg-primary/10 hover:text-primary transition-all group active:scale-[0.95] border border-border">
                <span className="material-symbols-outlined text-3xl mb-2 text-primary">announcement</span>
                <span className="text-xs font-bold text-center">Broadcast</span>
              </button>
            </div>
          </div>

          <div className="card">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-xl font-semibold text-textprimary">Capacity Overview</h3>
              <span className="material-symbols-outlined text-textmuted text-sm">info</span>
            </div>
            <div className="space-y-6">
              <div>
                <div className="flex justify-between text-xs font-semibold mb-2">
                  <span className="text-textmuted">ICU BEDS</span>
                  <span className="text-danger">92%</span>
                </div>
                <div className="w-full bg-slate-200 h-2 rounded-full overflow-hidden">
                  <div className="bg-danger h-full rounded-full" style={{ width: '92%' }}></div>
                </div>
                <p className="text-[11px] text-textmuted mt-1 text-right">2 Beds Available</p>
              </div>
              
              <div>
                <div className="flex justify-between text-xs font-semibold mb-2">
                  <span className="text-textmuted">GENERAL WARD</span>
                  <span className="text-primary">68%</span>
                </div>
                <div className="w-full bg-slate-200 h-2 rounded-full overflow-hidden">
                  <div className="bg-primary h-full rounded-full" style={{ width: '68%' }}></div>
                </div>
                <p className="text-[11px] text-textmuted mt-1 text-right">38 Beds Available</p>
              </div>

              <div className="pt-4 border-t border-border mt-4">
                <h4 className="text-xs font-bold text-textmuted mb-4 uppercase">Departments Online</h4>
                <div className="flex flex-wrap gap-2">
                  <span className="px-2 py-1 rounded bg-green-100 text-green-800 text-[11px] font-semibold flex items-center gap-1.5">
                    <span className="w-1.5 h-1.5 rounded-full bg-green-600"></span> ENT
                  </span>
                  <span className="px-2 py-1 rounded bg-green-100 text-green-800 text-[11px] font-semibold flex items-center gap-1.5">
                    <span className="w-1.5 h-1.5 rounded-full bg-green-600"></span> Cardio
                  </span>
                  <span className="px-2 py-1 rounded bg-orange-100 text-orange-800 text-[11px] font-semibold flex items-center gap-1.5">
                    <span className="w-1.5 h-1.5 rounded-full bg-orange-600"></span> Radiology
                  </span>
                  <span className="px-2 py-1 rounded bg-green-100 text-green-800 text-[11px] font-semibold flex items-center gap-1.5">
                    <span className="w-1.5 h-1.5 rounded-full bg-green-600"></span> Gynae
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
