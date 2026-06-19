"use client";
import { Search, Brain, FileText, Activity, Clock, Sparkles } from 'lucide-react';

export default function PatientsHistory() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight">Patient History & EHR</h1>
          <p className="text-slate-500 text-sm mt-1">Review electronic health records and AI-generated insights.</p>
        </div>
        <div className="relative w-full sm:w-80">
          <input 
            type="text" 
            placeholder="Search patient records..." 
            className="pl-10 pr-4 py-2.5 border border-slate-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 w-full transition-all bg-white shadow-sm placeholder:text-slate-400"
          />
          <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main EHR Area */}
        <div className="lg:col-span-2 space-y-6">
          <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-8">
            <div className="flex items-center justify-between mb-8 pb-6 border-b border-slate-100">
              <div className="flex items-center space-x-5">
                <div className="w-16 h-16 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold text-xl border border-blue-100 shadow-sm">AR</div>
                <div>
                  <h2 className="text-2xl font-bold text-slate-900 tracking-tight">Ali Rahman</h2>
                  <p className="text-[13px] text-slate-500 font-medium mt-1">ID: P-2910 • 45 Yrs, Male • Blood: O+</p>
                </div>
              </div>
              <span className="px-3 py-1.5 bg-rose-50 text-rose-700 text-[10px] font-bold rounded uppercase tracking-widest border border-rose-100">Hypertensive</span>
            </div>
            
            <div className="space-y-6">
              <h3 className="text-[13px] font-bold text-slate-900 uppercase tracking-widest flex items-center"><FileText size={16} className="mr-2 text-slate-400"/> Recent Vitals</h3>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
                <div className="p-4 bg-slate-50/80 rounded-xl border border-slate-100">
                  <p className="text-[10px] font-bold text-slate-500 uppercase tracking-wider mb-1">Heart Rate</p>
                  <p className="text-xl font-bold text-slate-900">84 <span className="text-xs text-slate-400 font-medium">bpm</span></p>
                </div>
                <div className="p-4 bg-rose-50/80 rounded-xl border border-rose-100/80 shadow-sm">
                  <p className="text-[10px] font-bold text-rose-600 uppercase tracking-wider mb-1">Blood Pressure</p>
                  <p className="text-xl font-bold text-rose-900">145/90 <span className="text-xs text-rose-600/70 font-medium">mmHg</span></p>
                </div>
                <div className="p-4 bg-slate-50/80 rounded-xl border border-slate-100">
                  <p className="text-[10px] font-bold text-slate-500 uppercase tracking-wider mb-1">Temp</p>
                  <p className="text-xl font-bold text-slate-900">98.6 <span className="text-xs text-slate-400 font-medium">°F</span></p>
                </div>
                <div className="p-4 bg-slate-50/80 rounded-xl border border-slate-100">
                  <p className="text-[10px] font-bold text-slate-500 uppercase tracking-wider mb-1">O2 Sat</p>
                  <p className="text-xl font-bold text-slate-900">98 <span className="text-xs text-slate-400 font-medium">%</span></p>
                </div>
              </div>
            </div>

            <div className="mt-8 pt-8 border-t border-slate-100">
              <h3 className="text-[13px] font-bold text-slate-900 uppercase tracking-widest flex items-center mb-4"><Activity size={16} className="mr-2 text-slate-400"/> Chief Complaint</h3>
              <p className="text-[14px] text-slate-700 leading-relaxed font-medium bg-slate-50 p-5 rounded-xl border border-slate-100">Patient reports mild chest discomfort and persistent headaches over the past 48 hours. Noted a history of hypertension. No shortness of breath.</p>
            </div>
          </div>
        </div>

        {/* AI Hook Sidebar (Crucial) */}
        <div className="space-y-6">
          <div className="bg-gradient-to-b from-purple-50/80 to-white rounded-2xl border border-purple-100 shadow-[0_4px_20px_-5px_rgba(147,51,234,0.1)] p-7 relative overflow-hidden group">
            <div className="absolute top-0 right-0 p-4 opacity-5 group-hover:opacity-10 transition-opacity"><Brain size={100} /></div>
            
            <h2 className="text-[13px] font-bold text-purple-700 flex items-center uppercase tracking-widest mb-6">
              <Sparkles size={16} className="mr-2" strokeWidth={2.5} /> AI Patient Summary
            </h2>
            
            <div className="space-y-4 relative z-10">
              <p className="text-[14px] text-slate-700 leading-relaxed font-medium">
                <span className="font-bold text-purple-900 bg-purple-100/50 px-1.5 py-0.5 rounded mr-1">Chronic Hypertension (Diagnosed 2024).</span> Missed last two follow-up appointments. Recent vitals indicate elevated BP. High risk for cardiovascular events if untreated.
              </p>
              
              <div className="pt-5 mt-5 border-t border-purple-100/50">
                <p className="text-[10px] font-bold text-purple-500 uppercase tracking-widest mb-3">Suggested Focus Areas</p>
                <ul className="space-y-2.5">
                  <li className="flex items-center text-[13px] font-medium text-slate-700 bg-white px-3 py-2 rounded-lg border border-purple-50 shadow-sm"><div className="w-1.5 h-1.5 rounded-full bg-purple-500 mr-3"></div> Medication Adherence Check</li>
                  <li className="flex items-center text-[13px] font-medium text-slate-700 bg-white px-3 py-2 rounded-lg border border-purple-50 shadow-sm"><div className="w-1.5 h-1.5 rounded-full bg-purple-500 mr-3"></div> Order baseline ECG</li>
                </ul>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7">
            <h2 className="text-[13px] font-bold text-slate-900 flex items-center uppercase tracking-widest mb-6"><Clock size={16} className="mr-2 text-blue-500" /> Triage Predictions</h2>
            
            <div className="p-6 bg-blue-50/80 rounded-xl border border-blue-100 text-center shadow-inner">
              <p className="text-[10px] font-bold text-blue-600 uppercase tracking-[0.2em] mb-2">EST. CONSULTATION TIME</p>
              <h3 className="text-4xl font-bold text-blue-900">18 <span className="text-lg text-blue-700/70 font-semibold tracking-normal">mins</span></h3>
              <p className="text-[10px] font-bold text-blue-600 mt-3 tracking-wider uppercase bg-blue-100/80 inline-block px-2.5 py-1 rounded-md border border-blue-200/50">Based on Severity Level 2</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
