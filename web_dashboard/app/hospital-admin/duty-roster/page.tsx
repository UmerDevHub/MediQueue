"use client";
import { Calendar, Search, Clock, CheckCircle2 } from 'lucide-react';

export default function DutyRoster() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Facility Duty Roster</h1>
          <p className="text-slate-500 text-sm mt-1">Local staff shifts and availability management.</p>
        </div>
        <div className="flex items-center space-x-3">
          <button className="flex items-center px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold text-xs tracking-wider shadow-sm transition-colors whitespace-nowrap">
            <Calendar size={16} className="mr-2" /> SCHEDULE SHIFT
          </button>
        </div>
      </div>

      <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] overflow-hidden">
        <div className="p-6 border-b border-slate-100 flex flex-col sm:flex-row justify-between items-center bg-slate-50/80 gap-4">
          <div className="relative w-full sm:w-80">
            <input 
              type="text" 
              placeholder="Search by doctor or department..." 
              className="pl-10 pr-4 py-2.5 border border-slate-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full transition-all bg-white shadow-sm placeholder:text-slate-400"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
          </div>
          <div className="flex space-x-2">
            <span className="inline-flex items-center px-3.5 py-1.5 bg-white text-slate-700 text-xs font-bold rounded-lg border border-slate-200 shadow-sm">Cardiology</span>
            <span className="inline-flex items-center px-3.5 py-1.5 bg-blue-50 text-blue-700 text-xs font-bold rounded-lg border border-blue-100/50 shadow-sm">Emergency</span>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="text-[10px] text-slate-400 uppercase tracking-wider bg-white border-b border-slate-100">
              <tr>
                <th className="px-6 py-4 font-bold">DOCTOR</th>
                <th className="px-6 py-4 font-bold">DEPARTMENT</th>
                <th className="px-6 py-4 font-bold">SHIFT TIMING</th>
                <th className="px-6 py-4 font-bold">STATUS</th>
                <th className="px-6 py-4 font-bold text-right">ACTION</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {[1, 2, 3, 4, 5].map((item) => (
                <tr key={item} className="hover:bg-slate-50/80 transition-colors group">
                  <td className="px-6 py-5">
                    <div className="flex items-center space-x-4">
                      <div className="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center font-bold text-slate-600 border border-slate-200">DR</div>
                      <div className="flex flex-col">
                        <span className="font-bold text-slate-900 text-[14px]">Dr. Usman Tariq</span>
                        <span className="text-[11px] text-slate-500 font-medium mt-0.5">PMDC-100{item}</span>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-5 text-slate-600 font-semibold text-[13px]">Emergency</td>
                  <td className="px-6 py-5">
                    <div className="flex items-center font-bold text-slate-700 text-[13px]">
                      <Clock size={14} className="mr-2 text-slate-400" /> 08:00 AM - 08:00 PM
                    </div>
                  </td>
                  <td className="px-6 py-5">
                    <span className={`inline-flex items-center px-2.5 py-1 text-[9px] font-bold rounded uppercase tracking-wider border ${item <= 2 ? 'bg-emerald-50 text-emerald-700 border-emerald-100/50' : 'bg-amber-50 text-amber-700 border-amber-100/50'}`}>
                      {item <= 2 ? <><CheckCircle2 size={12} className="mr-1.5" /> Active</> : <><Clock size={12} className="mr-1.5" /> On Break</>}
                    </span>
                  </td>
                  <td className="px-6 py-5 text-right">
                    <button className="text-xs font-bold text-blue-600 hover:text-blue-800 transition-colors uppercase tracking-wider">EDIT SHIFT</button>
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
