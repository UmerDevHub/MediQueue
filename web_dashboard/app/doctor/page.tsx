"use client";
import { Users, Clock, Calendar, CheckCircle2, Activity, ArrowRight, UserCircle2 } from 'lucide-react';
import Link from 'next/link';

export default function DoctorDashboard() {
  return (
    <div className="space-y-8 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Welcome, Dr. Sarah!</h1>
          <p className="text-slate-500 text-sm mt-1">Here's your schedule and daily overview for today.</p>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-blue-50 text-blue-600 rounded-xl"><Users size={22} strokeWidth={2.5} /></div>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">TOTAL APPOINTMENTS</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">24</h3>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-emerald-50 text-emerald-600 rounded-xl"><CheckCircle2 size={22} strokeWidth={2.5} /></div>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">COMPLETED</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">8</h3>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-amber-50 text-amber-600 rounded-xl"><Clock size={22} strokeWidth={2.5} /></div>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">WAITING IN QUEUE</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">4</h3>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] flex flex-col justify-between transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <div className="flex items-start justify-between mb-4">
            <div className="p-3.5 bg-purple-50 text-purple-600 rounded-xl"><Activity size={22} strokeWidth={2.5} /></div>
          </div>
          <div>
            <p className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-1">AVG. CONSULT TIME</p>
            <h3 className="text-[32px] font-bold text-slate-900 leading-tight">14m</h3>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Next Appointment Feature */}
        <div className="bg-blue-600 rounded-2xl shadow-[0_8px_30px_rgba(37,99,235,0.15)] p-7 text-white flex flex-col relative overflow-hidden group">
          <div className="absolute top-0 right-0 p-6 opacity-10 group-hover:scale-110 transition-transform"><UserCircle2 size={120} /></div>
          <h2 className="text-[13px] font-bold text-blue-200 uppercase tracking-widest mb-6">NEXT PATIENT</h2>
          
          <div className="flex-1">
            <h3 className="text-3xl font-bold tracking-tight mb-1">Mr. Ali Rahman</h3>
            <p className="text-blue-200 font-medium text-sm mb-6">ID: P-2910 • 45 Yrs, Male</p>
            
            <div className="space-y-3 mb-8 relative z-10">
              <div className="flex items-center text-[13px] font-semibold tracking-wide bg-blue-700/50 p-3 rounded-xl border border-blue-500/50">
                <Clock size={16} className="mr-3 text-blue-300" /> 10:30 AM - 10:45 AM
              </div>
              <div className="flex items-center text-[13px] font-semibold tracking-wide bg-blue-700/50 p-3 rounded-xl border border-blue-500/50">
                <Activity size={16} className="mr-3 text-blue-300" /> Follow-up: Hypertension
              </div>
            </div>
          </div>
          
          <button className="w-full py-3.5 bg-white text-blue-600 font-bold text-xs rounded-xl uppercase tracking-widest hover:bg-blue-50 transition-colors shadow-sm relative z-10">
            START CONSULTATION
          </button>
        </div>

        {/* Schedule Preview */}
        <div className="lg:col-span-2 bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex items-center justify-between mb-6 pb-5 border-b border-slate-100">
            <h2 className="text-[13px] font-bold text-slate-900 flex items-center uppercase tracking-widest"><Calendar size={16} className="mr-2 text-blue-500" strokeWidth={2.5} /> UPCOMING SCHEDULE</h2>
            <Link href="/doctor/appointments" className="text-[11px] font-bold text-blue-600 hover:text-blue-800 transition-colors flex items-center uppercase tracking-widest">VIEW ALL <ArrowRight size={14} className="ml-1"/></Link>
          </div>
          
          <div className="flex-1 overflow-y-auto space-y-4 pr-2">
            {[1, 2, 3, 4].map((item) => (
              <div key={item} className="flex items-center justify-between p-4 rounded-xl border border-slate-100 hover:bg-slate-50 transition-colors group cursor-pointer">
                <div className="flex items-center space-x-4">
                  <div className="px-3.5 py-2.5 bg-slate-50 text-slate-700 font-bold text-[13px] rounded-lg border border-slate-200 group-hover:bg-white group-hover:border-slate-300 transition-colors shadow-sm">
                    {10 + item}:00 AM
                  </div>
                  <div>
                    <h4 className="font-bold text-slate-900 text-sm">Patient Name {item}</h4>
                    <p className="text-[11px] font-semibold text-slate-500 mt-0.5 tracking-wide">Routine Checkup</p>
                  </div>
                </div>
                <span className={`inline-flex items-center px-2.5 py-1 text-[9px] font-bold rounded uppercase tracking-wider border ${item === 1 ? 'bg-amber-50 text-amber-700 border-amber-100/50' : 'bg-slate-50 text-slate-500 border-slate-200/50'}`}>
                  {item === 1 ? 'WAITING' : 'SCHEDULED'}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
