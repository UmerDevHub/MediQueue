"use client";

import { Building2, Activity, Clock, Banknote, Calendar, Download, AlertTriangle, Server, Shield } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const aiPredictionsData = [
  { time: '08:00', waitTime: 12, predicted: 15 },
  { time: '10:00', waitTime: 25, predicted: 28 },
  { time: '12:00', waitTime: 45, predicted: 42 },
  { time: '14:00', waitTime: 30, predicted: 35 },
  { time: '16:00', waitTime: 15, predicted: 18 },
  { time: '18:00', waitTime: 55, predicted: 60 },
  { time: '20:00', waitTime: 20, predicted: 22 },
];

export default function SuperAdminDashboard() {
  return (
    <div className="space-y-8 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      {/* Header section */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Platform Overview</h1>
          <p className="text-slate-500 text-sm mt-1">Real-time cross-facility health and performance metrics.</p>
        </div>
        <div className="flex items-center space-x-3">
          <button className="flex items-center px-4 py-2.5 bg-white border border-slate-200 text-slate-700 rounded-lg hover:bg-slate-50 font-semibold text-xs tracking-wider transition-colors shadow-sm">
            <Calendar size={16} className="mr-2 text-slate-500" /> LAST 24 HOURS
          </button>
          <button className="flex items-center px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold text-xs tracking-wider shadow-sm transition-colors">
            <Download size={16} className="mr-2" /> EXPORT REPORT
          </button>
        </div>
      </div>

      {/* 4 Overview Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-blue-50 text-blue-600 rounded-xl"><Building2 size={22} strokeWidth={2.5} /></div>
            <span className="px-2.5 py-1 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded-full tracking-wide">+2 This Month</span>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">TOTAL FACILITIES</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">142</h3>
            <p className="text-xs text-slate-400 mt-1.5 font-medium">Active healthcare nodes</p>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-purple-50 text-purple-600 rounded-xl"><Activity size={22} strokeWidth={2.5} /></div>
            <span className="flex items-center text-[10px] font-bold text-slate-700 tracking-wide uppercase"><div className="w-1.5 h-1.5 rounded-full bg-emerald-500 mr-1.5 animate-pulse"></div> LIVE NOW</span>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">LIVE PATIENTS</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">4,892</h3>
            <div className="mt-3 w-full bg-slate-100 h-1.5 rounded-full overflow-hidden">
              <div className="bg-blue-600 h-full w-[70%] rounded-full shadow-[0_0_10px_rgba(37,99,235,0.5)]"></div>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-rose-50 text-rose-600 rounded-xl"><Clock size={22} strokeWidth={2.5} /></div>
            <span className="px-2.5 py-1 bg-rose-50 text-rose-600 text-[10px] font-bold rounded-full tracking-wide">-12% (Better)</span>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">AVG. RESPONSE TIME</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">4.2 min</h3>
            <p className="text-xs text-slate-400 mt-1.5 font-medium">Critical Triage efficiency</p>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-emerald-50 text-emerald-600 rounded-xl"><Banknote size={22} strokeWidth={2.5} /></div>
            <span className="px-2.5 py-1 bg-slate-100 text-slate-600 text-[10px] font-bold rounded-full tracking-wide">PKR</span>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">DAILY PROCESSING</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">1.28M</h3>
            <p className="text-xs text-slate-400 mt-1.5 font-medium">Across all billing units</p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* AI Hook Chart Area */}
        <div className="lg:col-span-2 bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-xl font-bold text-slate-900 tracking-tight">AI Wait Time Predictions</h2>
              <p className="text-sm text-slate-500 mt-1 font-medium">Aggregate queue volume vs. AI forecasted capacity</p>
            </div>
            <div className="flex items-center space-x-5 text-sm font-medium">
              <span className="flex items-center text-slate-700"><div className="w-2.5 h-2.5 rounded-full bg-blue-600 mr-2 shadow-sm"></div> Volume</span>
              <span className="flex items-center text-slate-500"><div className="w-2.5 h-2.5 rounded-full bg-slate-300 mr-2"></div> Capacity</span>
            </div>
          </div>
          <div className="flex-1 w-full h-[320px]">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={aiPredictionsData} margin={{ top: 10, right: 0, left: -20, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F1F5F9" />
                <XAxis dataKey="time" axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 12, fontWeight: 500}} dy={15} />
                <YAxis axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 12, fontWeight: 500}} />
                <Tooltip 
                  contentStyle={{borderRadius: '12px', border: '1px solid #F1F5F9', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)', fontWeight: 600, color: '#0F172A'}}
                  itemStyle={{fontWeight: 600}}
                />
                <Line type="monotone" dataKey="waitTime" name="Volume" stroke="#2563EB" strokeWidth={3} dot={{r: 4, strokeWidth: 2, fill: '#fff'}} activeDot={{r: 6, strokeWidth: 0, fill: '#2563EB'}} />
                <Line type="monotone" dataKey="predicted" name="Capacity" stroke="#CBD5E1" strokeWidth={3} strokeDasharray="6 6" dot={false} activeDot={false} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Critical Alerts */}
        <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex items-center justify-between mb-6 pb-5 border-b border-slate-100">
            <h2 className="text-[13px] font-bold text-rose-600 flex items-center uppercase tracking-widest"><AlertTriangle size={16} className="mr-2" strokeWidth={2.5} /> CRITICAL ALERTS</h2>
            <span className="px-2.5 py-1 bg-rose-50 text-rose-700 text-[10px] font-bold rounded-full tracking-wide">4 NEW</span>
          </div>
          
          <div className="flex-1 overflow-y-auto space-y-5 pr-2">
            <div className="relative pl-4 before:absolute before:left-0 before:top-1 before:bottom-1 before:w-1 before:bg-rose-500 before:rounded-full">
              <div className="flex justify-between items-start mb-1.5">
                <h4 className="font-bold text-slate-900 text-sm">Emergency Dept. At Capacity</h4>
                <span className="text-[11px] font-medium text-slate-400">2m ago</span>
              </div>
              <p className="text-[13px] text-slate-500 mb-2.5 leading-snug">Jinnah General - Sector B Queue {'>'} 40...</p>
              <span className="inline-block px-2 py-1 bg-rose-50 text-rose-700 text-[9px] font-bold rounded uppercase tracking-wider">Action Required</span>
            </div>
            
            <div className="relative pl-4 before:absolute before:left-0 before:top-1 before:bottom-1 before:w-1 before:bg-amber-400 before:rounded-full">
              <div className="flex justify-between items-start mb-1.5">
                <h4 className="font-bold text-slate-900 text-sm">Data Sync Lag Detected</h4>
                <span className="text-[11px] font-medium text-slate-400">14m ago</span>
              </div>
              <p className="text-[13px] text-slate-500 mb-2.5 leading-snug">Shifa Medical - Database node #4 laten...</p>
              <span className="inline-block px-2 py-1 bg-amber-50 text-amber-700 text-[9px] font-bold rounded uppercase tracking-wider">Network</span>
            </div>

            <div className="relative pl-4 before:absolute before:left-0 before:top-1 before:bottom-1 before:w-1 before:bg-rose-500 before:rounded-full">
              <div className="flex justify-between items-start mb-1.5">
                <h4 className="font-bold text-slate-900 text-sm">Oxygen Supply Low</h4>
                <span className="text-[11px] font-medium text-slate-400">42m ago</span>
              </div>
              <p className="text-[13px] text-slate-500 mb-2.5 leading-snug">Civil Hospital - Main tank below 15%</p>
              <span className="inline-block px-2 py-1 bg-rose-50 text-rose-700 text-[9px] font-bold rounded uppercase tracking-wider">Critical</span>
            </div>
          </div>
          
          <button className="mt-6 pt-5 w-full text-xs font-bold text-blue-600 hover:text-blue-800 border-t border-slate-100 transition-colors uppercase tracking-widest text-center">
            VIEW ALL SYSTEM ALERTS
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Node Status */}
        <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7">
          <h2 className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-7">NODE STATUS</h2>
          <div className="space-y-6">
            <div className="flex items-center justify-between group">
              <div className="flex items-center text-slate-700">
                <div className="p-2 bg-emerald-50 rounded-lg mr-3 group-hover:bg-emerald-100 transition-colors"><Server size={18} className="text-emerald-600" /></div>
                <span className="font-semibold text-[13px] text-slate-800">Cloud Engine</span>
              </div>
              <span className="text-xs font-bold text-emerald-600">99.9%</span>
            </div>
            <div className="flex items-center justify-between group">
              <div className="flex items-center text-slate-700">
                <div className="p-2 bg-emerald-50 rounded-lg mr-3 group-hover:bg-emerald-100 transition-colors"><Activity size={18} className="text-emerald-600" /></div>
                <span className="font-semibold text-[13px] text-slate-800">Health Records</span>
              </div>
              <span className="text-[10px] font-bold text-emerald-600 uppercase tracking-wide">Online</span>
            </div>
            <div className="flex items-center justify-between group">
              <div className="flex items-center text-slate-700">
                <div className="p-2 bg-amber-50 rounded-lg mr-3 group-hover:bg-amber-100 transition-colors"><Server size={18} className="text-amber-600" /></div>
                <span className="font-semibold text-[13px] text-slate-800">Third-party Integrations</span>
              </div>
              <span className="text-[10px] font-bold text-amber-600 uppercase tracking-wide">Degraded</span>
            </div>
            <div className="flex items-center justify-between group">
              <div className="flex items-center text-slate-700">
                <div className="p-2 bg-emerald-50 rounded-lg mr-3 group-hover:bg-emerald-100 transition-colors"><Shield size={18} className="text-emerald-600" /></div>
                <span className="font-semibold text-[13px] text-slate-800">AES Encryption</span>
              </div>
              <span className="text-[10px] font-bold text-emerald-600 uppercase tracking-wide">Secure</span>
            </div>
          </div>
          
          <div className="mt-8 p-5 bg-slate-50/80 rounded-xl border border-slate-100/80">
            <div className="flex justify-between items-center mb-3">
              <span className="text-[10px] font-bold text-slate-500 uppercase tracking-widest">Uptime Score</span>
              <span className="text-sm font-bold text-blue-600">A+</span>
            </div>
            <div className="w-full bg-slate-200 h-1.5 rounded-full overflow-hidden">
              <div className="bg-emerald-500 h-full w-[98%] rounded-full shadow-[0_0_8px_rgba(16,185,129,0.5)]"></div>
            </div>
          </div>
        </div>

        {/* Top Performing Facilities */}
        <div className="lg:col-span-2 bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-7 gap-4">
            <h2 className="text-[11px] font-bold text-slate-500 tracking-widest uppercase">TOP PERFORMING FACILITIES</h2>
            <div className="relative">
              <input 
                type="text" 
                placeholder="Filter hospitals..." 
                className="pl-9 pr-4 py-2 border border-slate-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full sm:w-64 transition-all placeholder:text-slate-400"
              />
              <svg className="w-4 h-4 text-slate-400 absolute left-3 top-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
            </div>
          </div>

          <div className="overflow-x-auto flex-1">
            <table className="w-full text-sm text-left">
              <thead className="text-[10px] text-slate-400 uppercase tracking-wider bg-slate-50/80">
                <tr>
                  <th className="px-5 py-4 font-bold rounded-l-lg">FACILITY NAME</th>
                  <th className="px-5 py-4 font-bold">REGION</th>
                  <th className="px-5 py-4 font-bold">EFFICIENCY</th>
                  <th className="px-5 py-4 font-bold">PATIENTS TODAY</th>
                  <th className="px-5 py-4 font-bold rounded-r-lg">STATUS</th>
                </tr>
              </thead>
              <tbody>
                <tr className="border-b border-slate-50 hover:bg-slate-50/50 transition-colors group">
                  <td className="px-5 py-4">
                    <div className="flex items-center">
                      <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center mr-3 font-bold text-lg border border-blue-100 group-hover:bg-blue-600 group-hover:text-white transition-colors">+</div>
                      <span className="font-bold text-slate-900 text-[13px]">Jinnah General Hospital</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-500 font-medium text-[13px]">Karachi, South</td>
                  <td className="px-5 py-4">
                    <div className="flex items-center">
                      <div className="w-16 h-1.5 bg-slate-100 rounded-full mr-3"><div className="h-full bg-emerald-500 rounded-full shadow-[0_0_8px_rgba(16,185,129,0.5)]" style={{width: '92%'}}></div></div>
                      <span className="text-[11px] font-bold text-slate-700">92%</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 font-bold text-slate-900">1,240</td>
                  <td className="px-5 py-4"><span className="px-2.5 py-1 bg-blue-50 text-blue-600 text-[9px] font-bold rounded uppercase tracking-wider border border-blue-100/50">Optimal</span></td>
                </tr>
                <tr className="border-b border-slate-50 hover:bg-slate-50/50 transition-colors group">
                  <td className="px-5 py-4">
                    <div className="flex items-center">
                      <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center mr-3 font-bold text-lg border border-blue-100 group-hover:bg-blue-600 group-hover:text-white transition-colors">+</div>
                      <span className="font-bold text-slate-900 text-[13px]">Mayo Clinic Punjab</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-500 font-medium text-[13px]">Lahore, Central</td>
                  <td className="px-5 py-4">
                    <div className="flex items-center">
                      <div className="w-16 h-1.5 bg-slate-100 rounded-full mr-3"><div className="h-full bg-emerald-500 rounded-full shadow-[0_0_8px_rgba(16,185,129,0.5)]" style={{width: '88%'}}></div></div>
                      <span className="text-[11px] font-bold text-slate-700">88%</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 font-bold text-slate-900">982</td>
                  <td className="px-5 py-4"><span className="px-2.5 py-1 bg-blue-50 text-blue-600 text-[9px] font-bold rounded uppercase tracking-wider border border-blue-100/50">Optimal</span></td>
                </tr>
                <tr className="hover:bg-slate-50/50 transition-colors group">
                  <td className="px-5 py-4">
                    <div className="flex items-center">
                      <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center mr-3 font-bold text-lg border border-blue-100 group-hover:bg-blue-600 group-hover:text-white transition-colors">+</div>
                      <span className="font-bold text-slate-900 text-[13px]">PIMS Heights</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-500 font-medium text-[13px]">Islamabad, Capital</td>
                  <td className="px-5 py-4">
                    <div className="flex items-center">
                      <div className="w-16 h-1.5 bg-slate-100 rounded-full mr-3"><div className="h-full bg-amber-400 rounded-full shadow-[0_0_8px_rgba(251,191,36,0.5)]" style={{width: '64%'}}></div></div>
                      <span className="text-[11px] font-bold text-slate-700">64%</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 font-bold text-slate-900">1,412</td>
                  <td className="px-5 py-4"><span className="px-2.5 py-1 bg-amber-50 text-amber-600 text-[9px] font-bold rounded uppercase tracking-wider border border-amber-100/50">Strained</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
