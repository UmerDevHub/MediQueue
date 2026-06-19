"use client";
import { User, Clock, Shield, Save } from 'lucide-react';

export default function DoctorSettings() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Profile & Preferences</h1>
          <p className="text-slate-500 text-sm mt-1">Manage your account details and availability schedule.</p>
        </div>
        <button className="flex items-center px-5 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold text-xs tracking-wider shadow-sm transition-colors">
          <Save size={16} className="mr-2" /> SAVE PROFILE
        </button>
      </div>

      <div className="flex flex-col lg:flex-row gap-8">
        <div className="w-full lg:w-64 shrink-0 space-y-2">
          <button className="w-full flex items-center px-4 py-3.5 bg-white text-blue-600 rounded-xl font-bold text-sm shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-blue-100 transition-all">
            <User size={18} className="mr-3" /> Account Details
          </button>
          <button className="w-full flex items-center px-4 py-3.5 text-slate-500 hover:bg-white hover:text-slate-900 rounded-xl font-semibold text-sm transition-all border border-transparent hover:shadow-[0_2px_10px_-3px_rgba(0,0,0,0.05)] hover:border-slate-100">
            <Clock size={18} className="mr-3" /> Availability
          </button>
          <button className="w-full flex items-center px-4 py-3.5 text-slate-500 hover:bg-white hover:text-slate-900 rounded-xl font-semibold text-sm transition-all border border-transparent hover:shadow-[0_2px_10px_-3px_rgba(0,0,0,0.05)] hover:border-slate-100">
            <Shield size={18} className="mr-3" /> Security
          </button>
        </div>

        <div className="flex-1 bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-8 md:p-10">
          <h2 className="text-xl font-bold text-slate-900 mb-8 tracking-tight">Personal Information</h2>
          
          <div className="space-y-6 max-w-2xl">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label className="block text-[11px] font-bold text-slate-500 uppercase tracking-widest mb-2.5">Full Name</label>
                <input type="text" defaultValue="Dr. Sarah Khan" className="w-full px-4 py-3 bg-slate-50/80 border border-slate-200 rounded-xl text-slate-900 font-semibold focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-[15px]" />
              </div>
              <div>
                <label className="block text-[11px] font-bold text-slate-500 uppercase tracking-widest mb-2.5">PMDC License No.</label>
                <input type="text" disabled defaultValue="PMDC-84741" className="w-full px-4 py-3 bg-slate-100 border border-slate-200 rounded-xl text-slate-500 font-semibold cursor-not-allowed text-[15px]" />
              </div>
            </div>

            <div>
              <label className="block text-[11px] font-bold text-slate-500 uppercase tracking-widest mb-2.5">Specialization</label>
              <input type="text" defaultValue="Cardiology" className="w-full px-4 py-3 bg-slate-50/80 border border-slate-200 rounded-xl text-slate-900 font-semibold focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all text-[15px]" />
            </div>

            <hr className="border-slate-100 my-10" />

            <div>
              <h3 className="text-lg font-bold text-slate-900 mb-5 tracking-tight">Consultation Preferences</h3>
              <div className="space-y-4">
                <label className="flex items-center justify-between p-5 border border-slate-200 rounded-xl cursor-pointer hover:bg-slate-50/80 transition-colors shadow-sm">
                  <div>
                    <span className="block font-bold text-slate-900 text-[15px]">Accept Emergency Overrides</span>
                    <span className="block text-[13px] text-slate-500 font-medium mt-1">Allow L1 triage patients to bypass your standard queue.</span>
                  </div>
                  <div className="relative inline-block w-12 mr-2 align-middle select-none">
                    <input type="checkbox" defaultChecked className="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-[3px] appearance-none cursor-pointer" style={{right: 0, borderColor: '#2563EB'}} />
                    <label className="toggle-label block overflow-hidden h-6 rounded-full bg-blue-600 cursor-pointer"></label>
                  </div>
                </label>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
