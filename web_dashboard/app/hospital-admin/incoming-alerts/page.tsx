"use client";
import { AlertTriangle, Clock, MapPin } from 'lucide-react';

export default function IncomingAlerts() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight text-rose-600 flex items-center">
            <AlertTriangle className="mr-3" size={32} strokeWidth={2.5} /> Emergency Alerts
          </h1>
          <p className="text-slate-500 text-sm mt-1">Real-time incoming ambulance and critical dispatch stream.</p>
        </div>
        <div className="flex items-center space-x-3 bg-rose-50 p-1.5 rounded-xl border border-rose-100 shadow-sm">
          <span className="px-3 py-1.5 text-[11px] font-bold text-rose-700 flex items-center tracking-wider"><div className="w-2 h-2 rounded-full bg-rose-500 mr-2 animate-pulse"></div> LISTENING FOR DISPATCHES</span>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-4">
        {[1, 2, 3].map((item) => (
          <div key={item} className={`bg-white rounded-2xl border ${item === 1 ? 'border-rose-200 shadow-[0_0_20px_rgba(225,29,72,0.1)]' : 'border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)]'} p-6 flex flex-col md:flex-row md:items-center justify-between gap-6 transition-all hover:shadow-lg relative overflow-hidden group`}>
            {item === 1 && <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-rose-500"></div>}
            
            <div className="flex items-start md:items-center space-x-6">
              <div className={`w-16 h-16 rounded-2xl flex items-center justify-center font-bold text-2xl border shadow-sm ${item === 1 ? 'bg-rose-50 text-rose-600 border-rose-100' : item === 2 ? 'bg-amber-50 text-amber-600 border-amber-100' : 'bg-emerald-50 text-emerald-600 border-emerald-100'}`}>
                L{item}
              </div>
              
              <div>
                <h3 className="text-xl font-bold text-slate-900 tracking-tight mb-1">
                  {item === 1 ? 'Cardiac Arrest - Male, 55' : item === 2 ? 'Motor Vehicle Accident - Trauma' : 'Respiratory Distress'}
                </h3>
                <div className="flex flex-wrap items-center gap-4 mt-2">
                  <span className="flex items-center text-[13px] font-bold text-slate-700 bg-slate-50 px-2.5 py-1 rounded-lg border border-slate-200">
                    <Clock size={14} className="mr-2 text-blue-600" /> ETA: {item * 5} mins
                  </span>
                  <span className="flex items-center text-[13px] font-medium text-slate-600">
                    <MapPin size={14} className="mr-1.5 text-slate-400" /> Dispatched from: {item === 1 ? 'Sector F-8' : 'Highway M2'}
                  </span>
                </div>
              </div>
            </div>
            
            <div className="flex flex-col md:items-end space-y-3">
              <span className={`inline-flex items-center px-3 py-1.5 text-[10px] font-bold rounded uppercase tracking-widest border ${item === 1 ? 'bg-rose-50 text-rose-700 border-rose-100' : item === 2 ? 'bg-amber-50 text-amber-700 border-amber-100' : 'bg-emerald-50 text-emerald-700 border-emerald-100'}`}>
                {item === 1 ? 'CRITICAL (L1)' : item === 2 ? 'URGENT (L2)' : 'ROUTINE (L3)'}
              </span>
              <button className="px-6 py-2.5 bg-slate-900 hover:bg-slate-800 text-white text-xs font-bold rounded-lg shadow-sm transition-colors tracking-widest">
                PREPARE BAY
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
