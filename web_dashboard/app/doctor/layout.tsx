import Link from 'next/link';
import { LayoutGrid, Calendar, Users, Settings, ClipboardList } from 'lucide-react';

export default function DoctorLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-screen bg-[#F8FAFC] font-sans text-slate-900">
      <aside className="w-64 bg-[#0F172A] text-white flex-col hidden md:flex shrink-0 shadow-xl z-10">
        <div className="p-6 border-b border-slate-800/50">
          <h1 className="text-2xl font-bold text-white tracking-tight">MediQueue</h1>
          <p className="text-[10px] font-bold text-emerald-400 tracking-[0.1em] mt-1 uppercase">Doctor Portal</p>
        </div>
        
        <nav className="flex-1 py-6 space-y-1 px-3 overflow-y-auto">
          <Link href="/doctor" className="flex items-center px-4 py-3 bg-blue-600/10 text-white rounded-lg border-l-4 border-blue-500 transition-colors">
            <LayoutGrid size={20} className="mr-4 text-blue-400" />
            <span className="font-semibold text-sm tracking-wide">DASHBOARD</span>
          </Link>
          <Link href="/doctor/appointments" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <Calendar size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">APPOINTMENTS</span>
          </Link>
          <Link href="/doctor/patients" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <Users size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">MY PATIENTS</span>
          </Link>
          <Link href="/doctor/settings" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <Settings size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">SETTINGS</span>
          </Link>
        </nav>

        <div className="p-4 border-t border-slate-800/50">
          <div className="flex items-center space-x-3 px-4 py-3 bg-slate-900/50 rounded-xl border border-slate-800/50">
            <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse shadow-[0_0_8px_rgba(16,185,129,0.8)]"></div>
            <div>
              <p className="text-[10px] font-bold text-white uppercase tracking-wider">Status</p>
              <p className="text-[10px] text-emerald-400 mt-0.5">Online & Accepting</p>
            </div>
          </div>
        </div>
      </aside>

      <main className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <header className="h-20 bg-white border-b border-slate-200 flex items-center justify-end px-8 shrink-0 z-0 shadow-sm">
          <div className="flex items-center space-x-4">
            <div className="text-right">
              <p className="text-sm font-bold text-slate-900 tracking-wide">Dr. Sarah Khan</p>
              <p className="text-xs text-slate-500">Cardiology Dept</p>
            </div>
            <div className="w-11 h-11 rounded-full bg-emerald-50 border-2 border-emerald-100 shadow-md overflow-hidden relative flex items-center justify-center">
              <div className="text-emerald-700 font-bold">SK</div>
            </div>
          </div>
        </header>

        <div className="flex-1 overflow-auto p-4 md:p-8">
          {children}
        </div>
      </main>
    </div>
  );
}
