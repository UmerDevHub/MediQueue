import Image from 'next/image';
import Link from 'next/link';
import { ArrowRight, Activity, Stethoscope, Building2 } from 'lucide-react';

export default function RoleGateway() {
  return (
    <main className="min-h-screen bg-slate-50 flex flex-col items-center justify-center p-6 font-sans">
      <div className="max-w-4xl w-full grid grid-cols-1 md:grid-cols-2 gap-12 items-center bg-white rounded-3xl shadow-xl border border-slate-100 overflow-hidden p-8 md:p-12">
        <div className="flex flex-col items-center text-center space-y-6">
          <div className="relative w-32 h-32 md:w-40 md:h-40 animate-pulse">
            <Image 
              src="/logo.png" 
              alt="MediQueue Logo" 
              fill 
              className="object-contain drop-shadow-2xl"
              priority
            />
          </div>
          <div>
            <h1 className="text-3xl md:text-4xl font-bold text-slate-900 mb-4 tracking-tight">Welcome to MediQueue</h1>
            <p className="text-slate-500 text-lg">Intelligent Healthcare Ecosystem</p>
          </div>
        </div>

        <div className="flex flex-col space-y-4 w-full max-w-md mx-auto">
          <h2 className="text-xs font-bold text-slate-400 tracking-widest uppercase mb-2">Select Your Portal</h2>
          
          <Link href="/doctor" className="group flex items-center justify-between p-5 bg-white border-2 border-emerald-50 hover:border-emerald-600 hover:bg-emerald-50 rounded-xl transition-all duration-300 shadow-sm hover:shadow-md">
            <div className="flex items-center space-x-4">
              <div className="p-3 bg-emerald-100 text-emerald-600 rounded-lg group-hover:bg-emerald-600 group-hover:text-white transition-colors">
                <Stethoscope size={24} />
              </div>
              <div className="text-left">
                <h3 className="font-bold text-slate-900 text-lg">Continue as Doctor</h3>
                <p className="text-sm text-slate-500">Manage your appointments</p>
              </div>
            </div>
            <ArrowRight className="text-slate-400 group-hover:text-emerald-600 transition-colors" />
          </Link>

          <Link href="/hospital-admin" className="group flex items-center justify-between p-5 bg-white border-2 border-blue-50 hover:border-blue-600 hover:bg-blue-50 rounded-xl transition-all duration-300 shadow-sm hover:shadow-md">
            <div className="flex items-center space-x-4">
              <div className="p-3 bg-blue-100 text-blue-600 rounded-lg group-hover:bg-blue-600 group-hover:text-white transition-colors">
                <Building2 size={24} />
              </div>
              <div className="text-left">
                <h3 className="font-bold text-slate-900 text-lg">Continue as Hospital Admin</h3>
                <p className="text-sm text-slate-500">Local facility management</p>
              </div>
            </div>
            <ArrowRight className="text-slate-400 group-hover:text-blue-600 transition-colors" />
          </Link>

          <Link href="/super-admin" className="group flex items-center justify-between p-5 bg-white border-2 border-slate-100 hover:border-slate-800 hover:bg-slate-50 rounded-xl transition-all duration-300 shadow-sm hover:shadow-md">
            <div className="flex items-center space-x-4">
              <div className="p-3 bg-slate-100 text-slate-700 rounded-lg group-hover:bg-slate-800 group-hover:text-white transition-colors">
                <Building2 size={24} />
              </div>
              <div className="text-left">
                <h3 className="font-bold text-slate-900 text-lg">Continue as Super Admin</h3>
                <p className="text-sm text-slate-500">Global platform analytics</p>
              </div>
            </div>
            <ArrowRight className="text-slate-400 group-hover:text-slate-800 transition-colors" />
          </Link>
        </div>
      </div>
    </main>
  );
}