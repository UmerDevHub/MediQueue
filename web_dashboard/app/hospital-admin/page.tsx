"use client";
import { Users, Clock, Stethoscope, Calendar, Download, Activity, HeartPulse } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer } from 'recharts';

const hourlyIntake = [
  { time: '08:00', patients: 45 },
  { time: '10:00', patients: 80 },
  { time: '12:00', patients: 120 },
  { time: '14:00', patients: 90 },
  { time: '16:00', patients: 110 },
  { time: '18:00', patients: 65 },
];

export default function FacilityDashboard() {
  return (
    <div className="space-y-8 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Facility Dashboard</h1>
          <p className="text-slate-500 text-sm mt-1">Jinnah General Hospital - Operational Metrics</p>
        </div>
        <div className="flex items-center space-x-3">
          <button className="flex items-center px-4 py-2.5 bg-white border border-slate-200 text-slate-700 rounded-lg hover:bg-slate-50 font-semibold text-xs tracking-wider transition-colors shadow-sm">
            <Calendar size={16} className="mr-2 text-slate-500" /> TODAY
          </button>
          <button className="flex items-center px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold text-xs tracking-wider shadow-sm transition-colors">
            <Download size={16} className="mr-2" /> EXPORT REPORT
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-blue-50 text-blue-600 rounded-xl"><Users size={22} strokeWidth={2.5} /></div>
            <span className="px-2.5 py-1 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded-full tracking-wide">Live</span>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">TOTAL QUEUED</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">342</h3>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-amber-50 text-amber-600 rounded-xl"><Clock size={22} strokeWidth={2.5} /></div>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">AVG FACILITY WAIT</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">18m</h3>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-rose-50 text-rose-600 rounded-xl"><HeartPulse size={22} strokeWidth={2.5} /></div>
            <span className="px-2.5 py-1 bg-rose-50 text-rose-600 text-[10px] font-bold rounded-full tracking-wide">Critical</span>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">ER CAPACITY</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">92%</h3>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-emerald-50 text-emerald-600 rounded-xl"><Stethoscope size={22} strokeWidth={2.5} /></div>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">ON-DUTY DOCTORS</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">45</h3>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-xl font-bold text-slate-900 tracking-tight">Hourly Patient Intake</h2>
              <p className="text-sm text-slate-500 mt-1 font-medium">Distribution of incoming patients across the day.</p>
            </div>
          </div>
          <div className="flex-1 w-full h-[320px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={hourlyIntake} margin={{ top: 10, right: 0, left: -20, bottom: 0 }} barSize={36}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F1F5F9" />
                <XAxis dataKey="time" axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 12, fontWeight: 500}} dy={15} />
                <YAxis axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 12, fontWeight: 500}} />
                <RechartsTooltip cursor={{fill: '#F8FAFC'}} contentStyle={{borderRadius: '12px', border: '1px solid #F1F5F9', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)', fontWeight: 600}} />
                <Bar dataKey="patients" fill="#3B82F6" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex items-center justify-between mb-6 pb-5 border-b border-slate-100">
            <h2 className="text-[13px] font-bold text-slate-900 flex items-center uppercase tracking-widest"><Activity size={16} className="mr-2 text-blue-500" strokeWidth={2.5} /> RECENT ACTIVITY</h2>
          </div>
          
          <div className="flex-1 overflow-y-auto space-y-6 pr-2">
            {[
              { time: '2m ago', desc: 'Emergency dispatch arrived at Bay 3', type: 'urgent' },
              { time: '15m ago', desc: 'Dr. Sarah initiated emergency shift', type: 'staff' },
              { time: '42m ago', desc: 'Cardiology queue surpassed capacity threshold', type: 'system' },
              { time: '1h ago', desc: '5 routine checkups completed', type: 'routine' }
            ].map((log, i) => (
              <div key={i} className="flex gap-4">
                <div className="mt-1">
                  <div className={`w-2.5 h-2.5 rounded-full ${log.type === 'urgent' ? 'bg-rose-500' : log.type === 'staff' ? 'bg-blue-500' : log.type === 'system' ? 'bg-amber-500' : 'bg-emerald-500'}`}></div>
                </div>
                <div>
                  <p className="text-[13px] font-medium text-slate-700 leading-snug">{log.desc}</p>
                  <p className="text-[11px] font-bold text-slate-400 mt-1 uppercase tracking-wider">{log.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
