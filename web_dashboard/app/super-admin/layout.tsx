import Link from 'next/link';
import Image from 'next/image';
import { LayoutGrid, Users, Calendar, Contact, BarChart2, Settings, Server } from 'lucide-react';

export default function SuperAdminLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-screen bg-[#F8FAFC] font-sans text-slate-900">
      {/* Sidebar */}
      <aside className="w-64 bg-[#0F172A] text-white flex-col hidden md:flex shrink-0 shadow-xl z-10">
        <div className="p-6 border-b border-slate-800/50">
          <h1 className="text-2xl font-bold text-white tracking-tight">MediQueue</h1>
          <p className="text-[10px] font-bold text-slate-400 tracking-[0.2em] mt-1">SUPER CONSOLE</p>
        </div>
        
        <nav className="flex-1 py-6 space-y-1 px-3 overflow-y-auto">
          <Link href="/super-admin" className="flex items-center px-4 py-3 bg-blue-600/10 text-white rounded-lg border-l-4 border-blue-500 transition-colors">
            <LayoutGrid size={20} className="mr-4 text-blue-400" />
            <span className="font-semibold text-sm tracking-wide">DASHBOARD</span>
          </Link>
          <Link href="#" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <Users size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">PATIENT QUEUE</span>
          </Link>
          <Link href="#" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <Calendar size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">APPOINTMENTS</span>
          </Link>
          <Link href="#" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <Contact size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">STAFF DIRECTORY</span>
          </Link>
          <Link href="#" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <BarChart2 size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">REPORTS</span>
          </Link>
          <Link href="#" className="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-lg transition-colors border-l-4 border-transparent">
            <Settings size={20} className="mr-4" />
            <span className="font-semibold text-sm tracking-wide">SETTINGS</span>
          </Link>
        </nav>

        <div className="p-4 border-t border-slate-800/50">
          <div className="flex items-center space-x-3 px-4 py-3 bg-slate-900/50 rounded-xl border border-slate-800/50">
            <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse shadow-[0_0_8px_rgba(16,185,129,0.8)]"></div>
            <div>
              <p className="text-[10px] font-bold text-white uppercase tracking-wider">System Status</p>
              <p className="text-[10px] text-emerald-400 mt-0.5">All Nodes Operational</p>
            </div>
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Top Navbar */}
        <header className="h-20 bg-white border-b border-slate-200 flex items-center justify-end px-8 shrink-0 z-0 shadow-sm">
          <div className="flex items-center space-x-4">
            <div className="text-right">
              <p className="text-sm font-bold text-slate-900 tracking-wide">MASTER ADMIN</p>
              <p className="text-xs text-slate-500">System-wide Access</p>
            </div>
            <div className="w-11 h-11 rounded-full bg-slate-100 border-2 border-white shadow-md overflow-hidden relative flex items-center justify-center">
              <div className="text-slate-400 font-bold">MA</div>
              {/* <Image src="/avatar.png" alt="Admin" fill className="object-cover" /> */}
            </div>
          </div>
        </header>

        {/* Page Content */}
        <div className="flex-1 overflow-auto p-4 md:p-8">
          {children}
        </div>
      </main>
    </div>
  );
}
