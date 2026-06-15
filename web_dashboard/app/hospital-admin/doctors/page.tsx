'use client';

import { useState } from 'react';

export default function StaffDirectoryPage() {
  const [searchQuery, setSearchQuery] = useState('');
  
  return (
    <div className="space-y-6">
      {/* Header Controls Section */}
      <section className="flex flex-col md:flex-row md:items-end justify-between gap-6">
        <div>
          <h2 className="text-3xl font-semibold text-textprimary mb-1">Staff Directory</h2>
          <p className="text-lg text-textmuted">Manage hospital staff credentials, schedules, and active duty status.</p>
        </div>
        <div className="flex items-center gap-4">
          <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-textmuted uppercase tracking-wider">Search Specialty</label>
            <select className="bg-surface border border-border rounded-lg px-4 py-2 text-sm min-w-[200px] focus:ring-2 focus:ring-primary outline-none appearance-none cursor-pointer">
              <option>All Specialties</option>
              <option>Cardiology</option>
              <option>Neurology</option>
              <option>Orthopedics</option>
              <option>Pediatrics</option>
              <option>General Surgery</option>
            </select>
          </div>
          <button className="h-11 px-6 bg-primary text-white rounded-lg text-sm font-semibold flex items-center gap-2 hover:scale-[1.02] transition-transform active:scale-[0.97] shadow-sm">
            <span className="material-symbols-outlined">person_add</span>
            Add New Staff
          </button>
        </div>
      </section>

      {/* Stats Overview Row */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm">
          <p className="text-xs font-semibold text-textmuted uppercase tracking-widest mb-2">Total Staff</p>
          <p className="text-2xl font-bold text-textprimary">142</p>
        </div>
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm">
          <p className="text-xs font-semibold text-textmuted uppercase tracking-widest mb-2">On Duty</p>
          <div className="flex items-center gap-2">
            <p className="text-2xl font-bold text-primary">58</p>
            <span className="px-2 py-0.5 bg-blue-50 text-primary text-xs font-semibold rounded-full">High Load</span>
          </div>
        </div>
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm">
          <p className="text-xs font-semibold text-textmuted uppercase tracking-widest mb-2">Off Duty</p>
          <p className="text-2xl font-bold text-textmuted">84</p>
        </div>
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm">
          <p className="text-xs font-semibold text-textmuted uppercase tracking-widest mb-2">Active Clinics</p>
          <p className="text-2xl font-bold text-textprimary">12</p>
        </div>
      </div>

      {/* Staff Grid (Bento Style Variation) */}
      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
        
        {/* Doctor Card 1 */}
        <div className="bg-surface border border-border rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150 overflow-hidden group">
          <div className="p-6 flex gap-6">
            <div className="relative h-20 w-20 flex-shrink-0">
              <div className="h-full w-full rounded-lg bg-slate-200 border border-border flex items-center justify-center">
                 <span className="material-symbols-outlined text-4xl text-textmuted">person</span>
              </div>
              <span className="absolute -bottom-1 -right-1 w-5 h-5 bg-success border-2 border-surface rounded-full"></span>
            </div>
            <div className="flex-1">
              <div className="flex justify-between items-start mb-1">
                <div>
                  <h3 className="text-xl font-semibold text-textprimary">Dr. Arsalan Khan</h3>
                  <p className="text-sm text-primary font-medium">Senior Cardiologist</p>
                </div>
                <span className="px-3 py-1 bg-blue-50 text-primary text-xs rounded-full font-bold">ACTIVE</span>
              </div>
              <div className="flex items-center gap-1 mt-4">
                <span className="material-symbols-outlined text-sm text-textmuted">assignment_ind</span>
                <span className="text-xs font-semibold text-textmuted uppercase">Emp ID: #CK-9021</span>
              </div>
            </div>
          </div>
          <div className="px-6 pb-6">
            <div className="bg-slate-50 rounded-lg p-4 flex items-center justify-between border border-border">
              <div>
                <p className="text-xs text-textmuted font-semibold uppercase mb-1">Daily User Load</p>
                <div className="flex items-end gap-1">
                  <span className="text-xl font-bold text-textprimary">24</span>
                  <span className="text-sm text-textmuted pb-1">/ 30 max</span>
                </div>
              </div>
              <div className="w-24 h-2 bg-slate-200 rounded-full overflow-hidden">
                <div className="bg-primary h-full w-[80%] rounded-full"></div>
              </div>
            </div>
            <div className="mt-6 pt-6 border-t border-border flex items-center justify-between">
              <span className="text-sm font-bold text-textprimary uppercase">On-Duty Status</span>
              <label className="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" className="sr-only peer" defaultChecked />
                <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>
          </div>
        </div>

        {/* Doctor Card 2 */}
        <div className="bg-surface border border-border rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150 overflow-hidden group">
          <div className="p-6 flex gap-6">
            <div className="relative h-20 w-20 flex-shrink-0">
               <div className="h-full w-full rounded-lg bg-slate-200 border border-border flex items-center justify-center">
                 <span className="material-symbols-outlined text-4xl text-textmuted">person</span>
              </div>
              <span className="absolute -bottom-1 -right-1 w-5 h-5 bg-slate-300 border-2 border-surface rounded-full"></span>
            </div>
            <div className="flex-1">
              <div className="flex justify-between items-start mb-1">
                <div>
                  <h3 className="text-xl font-semibold text-textprimary">Dr. Sarah Ahmed</h3>
                  <p className="text-sm text-primary font-medium">Head of Pediatrics</p>
                </div>
                <span className="px-3 py-1 bg-slate-100 text-textmuted text-xs rounded-full font-bold">OFF DUTY</span>
              </div>
              <div className="flex items-center gap-1 mt-4">
                <span className="material-symbols-outlined text-sm text-textmuted">assignment_ind</span>
                <span className="text-xs font-semibold text-textmuted uppercase">Emp ID: #PA-4412</span>
              </div>
            </div>
          </div>
          <div className="px-6 pb-6">
            <div className="bg-slate-50 rounded-lg p-4 flex items-center justify-between border border-border opacity-60">
              <div>
                <p className="text-xs text-textmuted font-semibold uppercase mb-1">Daily User Load</p>
                <div className="flex items-end gap-1">
                  <span className="text-xl font-bold text-textprimary">0</span>
                  <span className="text-sm text-textmuted pb-1">/ 25 max</span>
                </div>
              </div>
              <div className="w-24 h-2 bg-slate-200 rounded-full overflow-hidden">
                <div className="bg-primary h-full w-[0%] rounded-full"></div>
              </div>
            </div>
            <div className="mt-6 pt-6 border-t border-border flex items-center justify-between">
              <span className="text-sm font-bold text-textprimary uppercase">On-Duty Status</span>
              <label className="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" className="sr-only peer" />
                <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>
          </div>
        </div>

        {/* Doctor Card 3 */}
        <div className="bg-surface border border-border rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150 overflow-hidden group">
          <div className="p-6 flex gap-6">
            <div className="relative h-20 w-20 flex-shrink-0">
               <div className="h-full w-full rounded-lg bg-slate-200 border border-border flex items-center justify-center">
                 <span className="material-symbols-outlined text-4xl text-textmuted">person</span>
              </div>
              <span className="absolute -bottom-1 -right-1 w-5 h-5 bg-success border-2 border-surface rounded-full"></span>
            </div>
            <div className="flex-1">
              <div className="flex justify-between items-start mb-1">
                <div>
                  <h3 className="text-xl font-semibold text-textprimary">Dr. Zaid Malik</h3>
                  <p className="text-sm text-primary font-medium">Neurologist</p>
                </div>
                <span className="px-3 py-1 bg-blue-50 text-primary text-xs rounded-full font-bold">ACTIVE</span>
              </div>
              <div className="flex items-center gap-1 mt-4">
                <span className="material-symbols-outlined text-sm text-textmuted">assignment_ind</span>
                <span className="text-xs font-semibold text-textmuted uppercase">Emp ID: #NR-1109</span>
              </div>
            </div>
          </div>
          <div className="px-6 pb-6">
            <div className="bg-slate-50 rounded-lg p-4 flex items-center justify-between border border-border">
              <div>
                <p className="text-xs text-textmuted font-semibold uppercase mb-1">Daily User Load</p>
                <div className="flex items-end gap-1">
                  <span className="text-xl font-bold text-textprimary">12</span>
                  <span className="text-sm text-textmuted pb-1">/ 20 max</span>
                </div>
              </div>
              <div className="w-24 h-2 bg-slate-200 rounded-full overflow-hidden">
                <div className="bg-primary h-full w-[60%] rounded-full"></div>
              </div>
            </div>
            <div className="mt-6 pt-6 border-t border-border flex items-center justify-between">
              <span className="text-sm font-bold text-textprimary uppercase">On-Duty Status</span>
              <label className="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" className="sr-only peer" defaultChecked />
                <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>
          </div>
        </div>

        {/* Empty State / Add New Placeholder Card */}
        <button className="bg-slate-50 border-2 border-dashed border-border rounded-xl flex flex-col items-center justify-center p-8 gap-4 group hover:border-primary hover:bg-blue-50 transition-all duration-300 cursor-pointer shadow-sm min-h-[300px]">
          <div className="w-14 h-14 rounded-full bg-white flex items-center justify-center text-textmuted group-hover:text-primary transition-colors shadow-sm">
            <span className="material-symbols-outlined text-3xl">add</span>
          </div>
          <div className="text-center">
            <p className="text-xl font-semibold text-textmuted group-hover:text-primary transition-colors">Register New Practitioner</p>
            <p className="text-sm text-textmuted opacity-80 mt-1">Complete credential verification for new hires.</p>
          </div>
        </button>

      </div>

      {/* Directory Footer / Pagination */}
      <div className="mt-8 py-6 border-t border-border flex items-center justify-between">
        <p className="text-sm text-textmuted">Showing 1 to 5 of 142 hospital staff members</p>
        <div className="flex items-center gap-2">
          <button className="p-2 border border-border bg-white rounded-lg hover:bg-slate-50 disabled:opacity-30 disabled:cursor-not-allowed transition-colors">
            <span className="material-symbols-outlined">chevron_left</span>
          </button>
          <div className="flex items-center gap-1">
            <button className="w-10 h-10 rounded-lg bg-primary text-white font-bold">1</button>
            <button className="w-10 h-10 rounded-lg border border-border bg-white hover:bg-slate-50 font-medium text-textmuted transition-colors">2</button>
            <button className="w-10 h-10 rounded-lg border border-border bg-white hover:bg-slate-50 font-medium text-textmuted transition-colors">3</button>
            <span className="px-2 text-textmuted">...</span>
            <button className="w-10 h-10 rounded-lg border border-border bg-white hover:bg-slate-50 font-medium text-textmuted transition-colors">28</button>
          </div>
          <button className="p-2 border border-border bg-white rounded-lg hover:bg-slate-50 transition-colors">
            <span className="material-symbols-outlined">chevron_right</span>
          </button>
        </div>
      </div>
      
    </div>
  );
}
