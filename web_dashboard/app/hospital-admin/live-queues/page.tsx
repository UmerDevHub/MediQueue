"use client";
import { MapPin, Activity, AlertCircle, Search } from 'lucide-react';

export default function LiveQueues() {
  const departments = [
    { name: 'Emergency Room', current: 42, max: 50, color: 'bg-rose-500' },
    { name: 'Cardiology', current: 28, max: 30, color: 'bg-amber-500' },
    { name: 'Neurology', current: 15, max: 20, color: 'bg-blue-500' },
    { name: 'Pediatrics', current: 35, max: 40, color: 'bg-emerald-500' },
    { name: 'Orthopedics', current: 18, max: 25, color: 'bg-indigo-500' },
    { name: 'General Medicine', current: 55, max: 60, color: 'bg-slate-700' },
  ];

  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Live Queue Monitoring</h1>
          <p className="text-slate-500 text-sm mt-1">Real-time capacity tracking across all local departments.</p>
        </div>
        <div className="flex items-center space-x-3">
          <div className="relative w-full sm:w-64">
            <input 
              type="text" 
              placeholder="Search patient..." 
              className="pl-10 pr-4 py-2.5 border border-slate-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full transition-all bg-white shadow-sm placeholder:text-slate-400"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-5 gap-6">
        {/* Department Progress Bars */}
        <div className="lg:col-span-2 bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <h2 className="text-[13px] font-bold text-slate-900 flex items-center uppercase tracking-widest mb-8"><Activity size={16} className="mr-2 text-blue-500" strokeWidth={2.5} /> DEPARTMENT CAPACITY</h2>
          
          <div className="space-y-7 flex-1 overflow-y-auto pr-2">
            {departments.map((dept, i) => {
              const percent = Math.round((dept.current / dept.max) * 100);
              const isHigh = percent >= 90;
              return (
                <div key={i} className="group">
                  <div className="flex justify-between items-end mb-2">
                    <div>
                      <h4 className="font-bold text-slate-900 text-sm">{dept.name}</h4>
                      <p className="text-[11px] font-bold text-slate-500 mt-0.5 uppercase tracking-wider">Wait: ~{Math.floor(dept.current * 0.8)} mins</p>
                    </div>
                    <div className="text-right">
                      <span className={`text-[13px] font-bold ${isHigh ? 'text-rose-600' : 'text-slate-700'}`}>{dept.current} <span className="text-slate-400">/ {dept.max}</span></span>
                    </div>
                  </div>
                  <div className="w-full bg-slate-100 h-2.5 rounded-full overflow-hidden shadow-inner">
                    <div className={`h-full rounded-full transition-all duration-1000 ${isHigh ? 'bg-rose-500' : dept.color}`} style={{width: `${percent}%`}}></div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* High-quality Map Placeholder */}
        <div className="lg:col-span-3 bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] overflow-hidden flex flex-col relative h-[600px] lg:h-auto">
          <div className="absolute top-6 left-6 z-10 bg-white/95 backdrop-blur px-5 py-3 rounded-xl shadow-lg border border-slate-100/50 flex items-center">
            <div className="w-3 h-3 rounded-full bg-emerald-500 mr-3 animate-pulse"></div>
            <span className="font-bold text-slate-900 text-sm">Live Facility Map</span>
          </div>
          
          <div className="flex-1 bg-slate-50 relative">
            <div className="absolute inset-0" style={{ backgroundImage: 'radial-gradient(#CBD5E1 1px, transparent 1px)', backgroundSize: '32px 32px', opacity: 0.5 }}></div>
            
            <div className="absolute top-[20%] left-[20%] w-48 h-32 bg-white border-2 border-slate-200 rounded-lg shadow-sm flex flex-col items-center justify-center">
              <MapPin className="text-blue-500 mb-2" size={24} />
              <span className="font-bold text-slate-700 text-xs tracking-wider uppercase">Main Building</span>
              <div className="mt-2 px-2 py-0.5 bg-blue-50 text-blue-600 text-[9px] font-bold rounded">142 Queued</div>
            </div>
            
            <div className="absolute top-[50%] right-[25%] w-40 h-40 bg-white border-2 border-rose-200 rounded-lg shadow-sm flex flex-col items-center justify-center shadow-rose-100">
              <AlertCircle className="text-rose-500 mb-2" size={24} />
              <span className="font-bold text-slate-700 text-xs tracking-wider uppercase">ER & Trauma</span>
              <div className="mt-2 px-2 py-0.5 bg-rose-50 text-rose-600 text-[9px] font-bold rounded animate-pulse">AT CAPACITY</div>
            </div>

            <div className="absolute bottom-[20%] left-[35%] w-32 h-24 bg-white border-2 border-slate-200 rounded-lg shadow-sm flex flex-col items-center justify-center">
              <MapPin className="text-emerald-500 mb-2" size={24} />
              <span className="font-bold text-slate-700 text-xs tracking-wider uppercase">OPD Block</span>
              <div className="mt-2 px-2 py-0.5 bg-emerald-50 text-emerald-600 text-[9px] font-bold rounded">Low Volume</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
