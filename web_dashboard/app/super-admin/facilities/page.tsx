"use client";
import { Building2, Search, Server, Plus, MoreHorizontal } from 'lucide-react';

export default function Facilities() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Hospital Nodes</h1>
          <p className="text-slate-500 text-sm mt-1">Manage connected facilities and integration statuses.</p>
        </div>
        <button className="flex items-center px-4 py-2.5 bg-slate-900 text-white rounded-lg hover:bg-slate-800 font-semibold text-xs tracking-wider shadow-sm transition-colors">
          <Plus size={16} className="mr-2" /> REGISTER NEW NODE
        </button>
      </div>

      <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] overflow-hidden">
        <div className="p-6 border-b border-slate-100 bg-slate-50/80">
          <div className="relative w-full md:w-96">
            <input 
              type="text" 
              placeholder="Search facilities by name or region..." 
              className="pl-10 pr-4 py-2.5 border border-slate-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full transition-all placeholder:text-slate-400 bg-white shadow-sm"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
          </div>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="text-[10px] text-slate-400 uppercase tracking-wider bg-white border-b border-slate-100">
              <tr>
                <th className="px-6 py-4 font-bold">FACILITY NAME</th>
                <th className="px-6 py-4 font-bold">LOCATION</th>
                <th className="px-6 py-4 font-bold">ACTIVE STAFF</th>
                <th className="px-6 py-4 font-bold">INTEGRATION</th>
                <th className="px-6 py-4 font-bold text-right">ACTION</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {[1, 2, 3, 4, 5].map((item) => (
                <tr key={item} className="hover:bg-slate-50/80 transition-colors group">
                  <td className="px-6 py-5">
                    <div className="flex items-center">
                      <div className="w-10 h-10 rounded-xl bg-blue-50/50 border border-blue-100 text-blue-600 flex items-center justify-center mr-4 group-hover:bg-blue-600 group-hover:text-white transition-colors"><Building2 size={18}/></div>
                      <span className="font-bold text-slate-900 text-[14px]">National Hospital {item}</span>
                    </div>
                  </td>
                  <td className="px-6 py-5 text-slate-500 font-medium text-[13px]">DHA Phase {item}, Lahore</td>
                  <td className="px-6 py-5 font-bold text-slate-900 text-[14px]">{45 + item * 10}</td>
                  <td className="px-6 py-5">
                    <span className="inline-flex items-center px-2.5 py-1 bg-emerald-50 text-emerald-700 text-[9px] font-bold rounded uppercase tracking-wider border border-emerald-100/50">
                      <Server size={12} className="mr-1.5" /> API Connected
                    </span>
                  </td>
                  <td className="px-6 py-5 text-right">
                    <button className="p-2 text-slate-400 hover:text-slate-600 transition-colors rounded-lg hover:bg-slate-50">
                      <MoreHorizontal size={18} />
                    </button>
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
