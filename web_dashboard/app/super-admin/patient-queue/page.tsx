"use client";
import { Users, Filter, Download, Search, AlertCircle, Clock, MoreVertical } from 'lucide-react';

export default function PatientQueue() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Live Patient Queue</h1>
          <p className="text-slate-500 text-sm mt-1">System-wide real-time tracking of triage and wait times.</p>
        </div>
        <div className="flex items-center space-x-3">
          <button className="flex items-center px-4 py-2.5 bg-white border border-slate-200 text-slate-700 rounded-lg hover:bg-slate-50 font-semibold text-xs tracking-wider transition-colors shadow-sm">
            <Filter size={16} className="mr-2 text-slate-500" /> FILTERS
          </button>
          <button className="flex items-center px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold text-xs tracking-wider shadow-sm transition-colors">
            <Download size={16} className="mr-2" /> EXPORT LOG
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xs font-bold text-slate-500 tracking-widest uppercase">CRITICAL TRIAGE</h3>
            <div className="p-2.5 bg-rose-50 text-rose-600 rounded-xl"><AlertCircle size={22} strokeWidth={2.5}/></div>
          </div>
          <p className="text-[32px] font-bold text-slate-900 leading-tight">184</p>
          <p className="text-xs text-rose-600 mt-1.5 font-bold">+12% from last hour</p>
        </div>
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xs font-bold text-slate-500 tracking-widest uppercase">AVG WAIT TIME</h3>
            <div className="p-2.5 bg-amber-50 text-amber-600 rounded-xl"><Clock size={22} strokeWidth={2.5}/></div>
          </div>
          <p className="text-[32px] font-bold text-slate-900 leading-tight">14.2m</p>
          <p className="text-xs text-emerald-600 mt-1.5 font-bold">-2.5m from yesterday</p>
        </div>
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xs font-bold text-slate-500 tracking-widest uppercase">TOTAL QUEUED</h3>
            <div className="p-2.5 bg-blue-50 text-blue-600 rounded-xl"><Users size={22} strokeWidth={2.5}/></div>
          </div>
          <p className="text-[32px] font-bold text-slate-900 leading-tight">2,492</p>
          <p className="text-xs text-slate-400 mt-1.5 font-medium">Across 142 facilities</p>
        </div>
      </div>

      <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col overflow-hidden">
        <div className="p-6 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="relative w-full md:w-96">
            <input 
              type="text" 
              placeholder="Search by Patient ID, Name, or Facility..." 
              className="pl-10 pr-4 py-2.5 border border-slate-200 rounded-xl text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full transition-all placeholder:text-slate-400 bg-slate-50/50"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
          </div>
          <div className="flex gap-2 overflow-x-auto pb-2 md:pb-0 hide-scrollbar">
            <span className="inline-flex whitespace-nowrap items-center px-3.5 py-1.5 bg-rose-50 text-rose-700 text-xs font-bold rounded-lg border border-rose-100/50 cursor-pointer hover:bg-rose-100 transition-colors shadow-sm">Critical (184)</span>
            <span className="inline-flex whitespace-nowrap items-center px-3.5 py-1.5 bg-amber-50 text-amber-700 text-xs font-bold rounded-lg border border-amber-100/50 cursor-pointer hover:bg-amber-100 transition-colors shadow-sm">Urgent (432)</span>
            <span className="inline-flex whitespace-nowrap items-center px-3.5 py-1.5 bg-emerald-50 text-emerald-700 text-xs font-bold rounded-lg border border-emerald-100/50 cursor-pointer hover:bg-emerald-100 transition-colors shadow-sm">Routine (1.8k)</span>
          </div>
        </div>

        <div className="overflow-x-auto flex-1">
          <table className="w-full text-sm text-left">
            <thead className="text-[10px] text-slate-400 uppercase tracking-wider bg-slate-50/80">
              <tr>
                <th className="px-6 py-4 font-bold">PATIENT / ID</th>
                <th className="px-6 py-4 font-bold">FACILITY</th>
                <th className="px-6 py-4 font-bold">TRIAGE LEVEL</th>
                <th className="px-6 py-4 font-bold">TIME IN QUEUE</th>
                <th className="px-6 py-4 font-bold">ASSIGNED TO</th>
                <th className="px-6 py-4 font-bold text-right">ACTION</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {[1, 2, 3, 4, 5].map((item) => (
                <tr key={item} className="hover:bg-slate-50/80 transition-colors group">
                  <td className="px-6 py-4">
                    <div className="flex flex-col">
                      <span className="font-bold text-slate-900 text-[13px]">Ali Rahman</span>
                      <span className="text-[11px] text-slate-500 font-medium mt-0.5">PT-294-811A</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-slate-600 font-medium text-[13px]">Jinnah General</td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center px-2.5 py-1 text-[9px] font-bold rounded uppercase tracking-wider border ${item === 1 ? 'bg-rose-50 text-rose-600 border-rose-100/50' : item === 2 ? 'bg-amber-50 text-amber-600 border-amber-100/50' : 'bg-emerald-50 text-emerald-600 border-emerald-100/50'}`}>
                      {item === 1 ? 'Critical (L1)' : item === 2 ? 'Urgent (L2)' : 'Routine (L3)'}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center font-bold text-slate-900 text-[13px]">
                      <Clock size={14} className={`mr-2 ${item === 1 ? 'text-rose-500' : 'text-slate-400'}`} />
                      {item === 1 ? '45 min' : '12 min'}
                    </div>
                  </td>
                  <td className="px-6 py-4 text-slate-600 font-medium text-[13px]">
                    {item === 1 ? 'Pending Assign' : 'Dr. Sarah Khan'}
                  </td>
                  <td className="px-6 py-4 text-right">
                    <button className="p-2 text-slate-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50">
                      <MoreVertical size={16} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="p-5 border-t border-slate-100 flex justify-between items-center bg-slate-50/50">
          <span className="text-xs font-medium text-slate-500 tracking-wide">Showing 1-5 of 2,492 patients</span>
          <div className="flex space-x-1">
            <button className="px-4 py-2 border border-slate-200 rounded-lg text-xs font-bold text-slate-400 bg-white cursor-not-allowed shadow-sm">PREV</button>
            <button className="px-4 py-2 border border-slate-200 rounded-lg text-xs font-bold text-slate-700 bg-white hover:bg-slate-50 transition-colors shadow-sm">NEXT</button>
          </div>
        </div>
      </div>
    </div>
  );
}
