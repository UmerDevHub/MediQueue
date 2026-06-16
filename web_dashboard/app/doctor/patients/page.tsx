'use client';

import { useState } from 'react';

export default function DoctorUsersPage() {
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <div className="space-y-6">
      {/* Header Section */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-6">
        <div>
          <h1 className="text-3xl font-semibold text-textprimary mb-1">My Users</h1>
          <p className="text-sm text-textmuted">Manage and review your user clinical records and history.</p>
        </div>
        <div className="flex gap-2">
          <button className="flex items-center gap-1 px-4 py-2 bg-primary text-white rounded-lg font-bold hover:scale-[1.02] active:scale-[0.97] transition-transform shadow-sm text-sm">
            <span className="material-symbols-outlined text-[18px]">add</span>
            New User
          </button>
        </div>
      </div>

      {/* Filters & Search Bento Card */}
      <div className="bg-white border border-border rounded-xl p-4 shadow-sm">
        <div className="flex flex-wrap gap-4 items-center">
          <div className="flex-grow relative min-w-[300px]">
            <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-textmuted">search</span>
            <input 
              className="w-full pl-12 pr-4 py-2 bg-surface border border-border rounded-lg text-sm focus:ring-2 focus:ring-primary focus:border-primary transition-all outline-none text-textprimary" 
              placeholder="Search by name, MRN or contact..." 
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
          <div className="flex gap-2 w-full md:w-auto">
            <button className="flex-1 md:flex-none flex items-center justify-center gap-1 px-4 py-2 bg-slate-50 text-textmuted border border-border rounded-lg text-xs uppercase font-bold hover:bg-slate-100 active:scale-[0.97] transition-colors">
              <span className="material-symbols-outlined text-[16px]">filter_list</span>
              Filter
            </button>
            <button className="flex-1 md:flex-none flex items-center justify-center gap-1 px-4 py-2 bg-slate-50 text-textmuted border border-border rounded-lg text-xs uppercase font-bold hover:bg-slate-100 active:scale-[0.97] transition-colors">
              <span className="material-symbols-outlined text-[16px]">sort</span>
              Sort
            </button>
          </div>
        </div>
        
        {/* Quick Filters */}
        <div className="flex gap-2 mt-4 pt-4 border-t border-border overflow-x-auto pb-1">
          <span className="px-3 py-1 bg-blue-50 text-primary border border-blue-100 rounded-full text-[11px] font-bold uppercase whitespace-nowrap cursor-pointer hover:bg-blue-100 transition-colors">All Users (142)</span>
          <span className="px-3 py-1 bg-white text-textmuted border border-border rounded-full text-[11px] font-bold uppercase whitespace-nowrap cursor-pointer hover:bg-slate-50 transition-colors">Recent (24)</span>
          <span className="px-3 py-1 bg-white text-textmuted border border-border rounded-full text-[11px] font-bold uppercase whitespace-nowrap cursor-pointer hover:bg-slate-50 transition-colors">Critical (5)</span>
          <span className="px-3 py-1 bg-white text-textmuted border border-border rounded-full text-[11px] font-bold uppercase whitespace-nowrap cursor-pointer hover:bg-slate-50 transition-colors">Follow-ups (12)</span>
        </div>
      </div>

      {/* User Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        
        {/* User Card 1 (Critical) */}
        <div className="bg-white border border-error/30 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow cursor-pointer relative group">
          <div className="absolute top-0 left-0 w-full h-1 bg-error"></div>
          <div className="p-5">
            <div className="flex justify-between items-start mb-4">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-full bg-slate-100 overflow-hidden border border-border">
                  {/* Placeholder Avatar */}
                  <div className="w-full h-full flex items-center justify-center text-textmuted font-bold text-lg">AS</div>
                </div>
                <div>
                  <h3 className="font-bold text-textprimary group-hover:text-primary transition-colors text-base">Ahmed Shah</h3>
                  <p className="text-xs text-textmuted mt-0.5">MRN: P-44921</p>
                </div>
              </div>
              <button className="text-textmuted hover:text-primary p-1 rounded-md hover:bg-slate-50 transition-colors">
                 <span className="material-symbols-outlined text-[20px]">more_vert</span>
              </button>
            </div>
            
            <div className="grid grid-cols-2 gap-y-3 gap-x-2 text-sm mb-4 bg-slate-50 p-3 rounded-lg border border-border">
              <div>
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Age / Gender</p>
                <p className="font-medium text-textprimary">45, M</p>
              </div>
              <div>
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Blood Type</p>
                <p className="font-medium text-error flex items-center gap-1">
                  O+ <span className="material-symbols-outlined text-[14px]">water_drop</span>
                </p>
              </div>
              <div className="col-span-2 pt-2 border-t border-border/50">
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Primary Diagnosis</p>
                <p className="font-medium text-textprimary">Severe Hypertension, Type 2 DM</p>
              </div>
            </div>
            
            <div className="flex items-center gap-2 mb-4">
               <span className="bg-red-50 text-error text-[10px] font-bold px-2 py-0.5 rounded border border-red-100 uppercase tracking-wide">Critical</span>
               <span className="bg-blue-50 text-primary text-[10px] font-bold px-2 py-0.5 rounded border border-blue-100 uppercase tracking-wide">ICU Admitted</span>
            </div>
          </div>
          <div className="bg-surface border-t border-border px-5 py-3 flex justify-between items-center group-hover:bg-blue-50/50 transition-colors">
            <span className="text-xs font-medium text-textmuted">Last visit: Today, 08:30 AM</span>
            <span className="text-primary font-bold text-xs uppercase tracking-wider flex items-center gap-1">
              View Chart <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
            </span>
          </div>
        </div>

        {/* User Card 2 */}
        <div className="bg-white border border-border rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow cursor-pointer relative group">
          <div className="p-5">
            <div className="flex justify-between items-start mb-4">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-full bg-slate-100 overflow-hidden border border-border">
                  <div className="w-full h-full flex items-center justify-center text-textmuted font-bold text-lg">FA</div>
                </div>
                <div>
                  <h3 className="font-bold text-textprimary group-hover:text-primary transition-colors text-base">Fatima Ali</h3>
                  <p className="text-xs text-textmuted mt-0.5">MRN: P-38290</p>
                </div>
              </div>
              <button className="text-textmuted hover:text-primary p-1 rounded-md hover:bg-slate-50 transition-colors">
                 <span className="material-symbols-outlined text-[20px]">more_vert</span>
              </button>
            </div>
            
            <div className="grid grid-cols-2 gap-y-3 gap-x-2 text-sm mb-4 bg-slate-50 p-3 rounded-lg border border-border">
              <div>
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Age / Gender</p>
                <p className="font-medium text-textprimary">28, F</p>
              </div>
              <div>
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Blood Type</p>
                <p className="font-medium text-textprimary">A+</p>
              </div>
              <div className="col-span-2 pt-2 border-t border-border/50">
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Primary Diagnosis</p>
                <p className="font-medium text-textprimary">Migraine with aura</p>
              </div>
            </div>
            
            <div className="flex items-center gap-2 mb-4">
               <span className="bg-slate-100 text-textmuted text-[10px] font-bold px-2 py-0.5 rounded border border-border uppercase tracking-wide">Stable</span>
               <span className="bg-amber-50 text-warning text-[10px] font-bold px-2 py-0.5 rounded border border-amber-100 uppercase tracking-wide">Follow-up Due</span>
            </div>
          </div>
          <div className="bg-surface border-t border-border px-5 py-3 flex justify-between items-center group-hover:bg-blue-50/50 transition-colors">
            <span className="text-xs font-medium text-textmuted">Last visit: 14 Oct, 2023</span>
            <span className="text-primary font-bold text-xs uppercase tracking-wider flex items-center gap-1">
              View Chart <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
            </span>
          </div>
        </div>

        {/* User Card 3 */}
        <div className="bg-white border border-border rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow cursor-pointer relative group">
          <div className="p-5">
            <div className="flex justify-between items-start mb-4">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-full bg-slate-100 overflow-hidden border border-border">
                  <div className="w-full h-full flex items-center justify-center text-textmuted font-bold text-lg">MQ</div>
                </div>
                <div>
                  <h3 className="font-bold text-textprimary group-hover:text-primary transition-colors text-base">Mohammad Qasim</h3>
                  <p className="text-xs text-textmuted mt-0.5">MRN: P-88211</p>
                </div>
              </div>
              <button className="text-textmuted hover:text-primary p-1 rounded-md hover:bg-slate-50 transition-colors">
                 <span className="material-symbols-outlined text-[20px]">more_vert</span>
              </button>
            </div>
            
            <div className="grid grid-cols-2 gap-y-3 gap-x-2 text-sm mb-4 bg-slate-50 p-3 rounded-lg border border-border">
              <div>
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Age / Gender</p>
                <p className="font-medium text-textprimary">62, M</p>
              </div>
              <div>
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Blood Type</p>
                <p className="font-medium text-textprimary">B-</p>
              </div>
              <div className="col-span-2 pt-2 border-t border-border/50">
                <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Primary Diagnosis</p>
                <p className="font-medium text-textprimary">Osteoarthritis, Knee</p>
              </div>
            </div>
            
            <div className="flex items-center gap-2 mb-4">
               <span className="bg-green-50 text-success text-[10px] font-bold px-2 py-0.5 rounded border border-green-100 uppercase tracking-wide">Recovering</span>
               <span className="bg-purple-50 text-purple-700 text-[10px] font-bold px-2 py-0.5 rounded border border-purple-100 uppercase tracking-wide">Physio Active</span>
            </div>
          </div>
          <div className="bg-surface border-t border-border px-5 py-3 flex justify-between items-center group-hover:bg-blue-50/50 transition-colors">
            <span className="text-xs font-medium text-textmuted">Last visit: 02 Nov, 2023</span>
            <span className="text-primary font-bold text-xs uppercase tracking-wider flex items-center gap-1">
              View Chart <span className="material-symbols-outlined text-[16px]">arrow_forward</span>
            </span>
          </div>
        </div>

      </div>

      {/* Pagination (Simplified) */}
      <div className="flex items-center justify-between mt-6">
        <p className="text-xs font-medium text-textmuted">Showing 1 to 3 of 142 users</p>
        <div className="flex gap-2">
           <button className="px-4 py-2 border border-border bg-white rounded-lg text-xs font-bold text-textmuted opacity-50 cursor-not-allowed">Previous</button>
           <button className="px-4 py-2 border border-border bg-white rounded-lg text-xs font-bold text-textprimary hover:bg-slate-50 transition-colors shadow-sm">Next</button>
        </div>
      </div>
    </div>
  );
}
