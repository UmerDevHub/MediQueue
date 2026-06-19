"use client";
import { Search, Shield, MapPin, UserPlus, MoreHorizontal } from 'lucide-react';

export default function DoctorRoster() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Staff Directory & Roster</h1>
          <p className="text-slate-500 text-sm mt-1">Global management of all registered healthcare professionals.</p>
        </div>
        <div className="flex items-center space-x-3">
          <div className="relative w-full sm:w-64">
            <input 
              type="text" 
              placeholder="Search doctors..." 
              className="pl-10 pr-4 py-2.5 border border-slate-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full transition-all bg-white shadow-sm placeholder:text-slate-400"
            />
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
          </div>
          <button className="flex items-center px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold text-xs tracking-wider shadow-sm transition-colors whitespace-nowrap">
            <UserPlus size={16} className="mr-2" /> ADD DOCTOR
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
        {[1, 2, 3, 4, 5, 6].map((item) => (
          <div key={item} className="bg-white p-7 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)] transition-all relative group flex flex-col h-full">
            <div className="absolute top-5 right-5">
              <button className="p-1.5 text-slate-300 hover:text-slate-600 hover:bg-slate-50 rounded-lg transition-colors"><MoreHorizontal size={20}/></button>
            </div>
            <div className="flex items-center space-x-4 mb-6">
              <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-50 to-blue-100/50 flex items-center justify-center text-blue-600 font-bold text-xl border border-blue-100/50 relative shadow-sm">
                {item === 1 ? 'SA' : 'AK'}
                {item <= 2 && <div className="absolute -bottom-1 -right-1 w-4 h-4 bg-emerald-500 border-2 border-white rounded-full shadow-sm"></div>}
              </div>
              <div>
                <h3 className="text-lg font-bold text-slate-900 leading-tight">Dr. {item === 1 ? 'Syed Ali' : 'Ayesha Khan'}</h3>
                <p className="text-[13px] text-blue-600 font-semibold mt-0.5 tracking-wide">{item === 1 ? 'Cardiologist' : 'General Physician'}</p>
              </div>
            </div>
            
            <div className="space-y-3 mb-6 flex-1">
              <div className="flex items-center text-[13px] text-slate-600 font-medium bg-slate-50/80 p-2.5 rounded-lg border border-slate-100">
                <MapPin size={16} className="mr-3 text-slate-400" /> Shifa International Hospital
              </div>
              <div className="flex items-center text-[13px] text-slate-600 font-medium bg-slate-50/80 p-2.5 rounded-lg border border-slate-100">
                <Shield size={16} className="mr-3 text-slate-400" /> License: PMDC-{84739 + item}
              </div>
            </div>

            <div className="pt-5 border-t border-slate-100 flex items-center justify-between mt-auto">
              <span className={`px-2.5 py-1 rounded-full text-[9px] font-bold uppercase tracking-wider border ${item <= 2 ? 'bg-emerald-50 text-emerald-600 border-emerald-100/50' : 'bg-slate-50 text-slate-500 border-slate-200/50'}`}>
                {item <= 2 ? 'Active Now' : 'Offline'}
              </span>
              <button className="text-xs font-bold text-blue-600 hover:text-blue-800 transition-colors uppercase tracking-wider">VIEW PROFILE</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
