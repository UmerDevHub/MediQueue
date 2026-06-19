"use client";
import { Search, Calendar, Clock, ChevronLeft, ChevronRight, CheckCircle2 } from 'lucide-react';

export default function DoctorAppointments() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Daily Schedule</h1>
          <p className="text-slate-500 text-sm mt-1">Manage your consultations and patient flow.</p>
        </div>
        <div className="flex items-center space-x-3">
          <div className="relative w-full sm:w-64">
            <input 
              type="text" 
              placeholder="Search by name or ID..." 
              className="pl-10 pr-4 py-2.5 border border-slate-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full transition-all bg-white shadow-sm placeholder:text-slate-400"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] overflow-hidden flex flex-col">
        <div className="p-6 border-b border-slate-100 flex flex-col sm:flex-row justify-between items-center bg-slate-50/80 gap-4">
          <div className="flex items-center space-x-4">
            <h2 className="text-lg font-bold text-slate-900 tracking-tight">Appointments</h2>
            <span className="px-3 py-1 bg-blue-100/50 text-blue-700 text-[11px] font-bold rounded-full tracking-wider border border-blue-200/50">JUNE 18, 2026</span>
          </div>
          <div className="flex space-x-2">
            <button className="p-2.5 border border-slate-200 rounded-lg text-slate-400 bg-white hover:bg-slate-50 hover:text-slate-700 transition-colors shadow-sm"><ChevronLeft size={18} /></button>
            <button className="p-2.5 border border-slate-200 rounded-lg text-slate-400 bg-white hover:bg-slate-50 hover:text-slate-700 transition-colors shadow-sm"><ChevronRight size={18} /></button>
          </div>
        </div>

        <div className="overflow-x-auto flex-1">
          <table className="w-full text-sm text-left">
            <thead className="text-[10px] text-slate-400 uppercase tracking-wider bg-white border-b border-slate-100">
              <tr>
                <th className="px-6 py-4 font-bold">TIME</th>
                <th className="px-6 py-4 font-bold">PATIENT</th>
                <th className="px-6 py-4 font-bold">TYPE</th>
                <th className="px-6 py-4 font-bold">STATUS</th>
                <th className="px-6 py-4 font-bold text-right">ACTION</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {[1, 2, 3, 4, 5, 6].map((item) => (
                <tr key={item} className="hover:bg-slate-50/80 transition-colors group">
                  <td className="px-6 py-5">
                    <span className="font-bold text-slate-900 flex items-center text-[13px]">
                      <Clock size={14} className="mr-2 text-slate-400" /> {9 + item}:00 AM
                    </span>
                  </td>
                  <td className="px-6 py-5">
                    <div className="flex flex-col">
                      <span className="font-bold text-slate-900 text-[13px]">Zainab Abbas</span>
                      <span className="text-[11px] text-slate-500 font-medium mt-0.5">ID: P-882{item}</span>
                    </div>
                  </td>
                  <td className="px-6 py-5 text-slate-600 font-medium text-[13px]">Follow-up</td>
                  <td className="px-6 py-5">
                    <span className={`inline-flex items-center px-2.5 py-1 text-[9px] font-bold rounded uppercase tracking-wider border ${item === 1 ? 'bg-emerald-50 text-emerald-700 border-emerald-100/50' : item === 2 ? 'bg-amber-50 text-amber-700 border-amber-100/50' : 'bg-slate-50 text-slate-500 border-slate-200/50'}`}>
                      {item === 1 ? 'COMPLETED' : item === 2 ? 'WAITING' : 'SCHEDULED'}
                    </span>
                  </td>
                  <td className="px-6 py-5 text-right">
                    <button className="text-xs font-bold text-blue-600 hover:text-blue-800 transition-colors uppercase tracking-wider">VIEW EHR</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
