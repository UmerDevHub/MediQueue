'use client';

import { useState } from 'react';

export default function AdminHospitalsPage() {
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <div className="space-y-6">
      {/* Page Header & Bento Stats */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-6">
        <div>
          <h3 className="text-3xl font-semibold text-textprimary">Hospital Management</h3>
          <p className="text-sm font-medium text-textmuted">Overseeing 12 medical facilities across the network.</p>
        </div>
        <button className="bg-primary text-white px-6 py-2 rounded-lg font-bold flex items-center gap-2 hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
          <span className="material-symbols-outlined">add</span>
          Add New Facility
        </button>
      </div>

      {/* Bento Grid Summary */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white p-6 rounded-xl border border-border shadow-sm">
          <p className="text-xs font-bold uppercase text-textmuted mb-1 tracking-wider">Network Status</p>
          <div className="flex items-center gap-2">
            <span className="w-3 h-3 bg-success rounded-full animate-pulse"></span>
            <span className="text-xl font-bold text-textprimary">10/12 Online</span>
          </div>
        </div>
        <div className="bg-white p-6 rounded-xl border border-border shadow-sm">
          <p className="text-xs font-bold uppercase text-textmuted mb-1 tracking-wider">Avg. Load</p>
          <span className="text-xl font-bold text-textprimary">78% Capacity</span>
          <div className="w-full bg-slate-100 h-1.5 rounded-full mt-2">
            <div className="bg-warning h-1.5 rounded-full w-[78%]"></div>
          </div>
        </div>
        <div className="bg-white p-6 rounded-xl border border-border shadow-sm">
          <p className="text-xs font-bold uppercase text-textmuted mb-1 tracking-wider">Critical Beds</p>
          <span className="text-xl font-bold text-textprimary">42 Available</span>
          <p className="text-xs text-error mt-1 font-medium">-8% from yesterday</p>
        </div>
        <div className="bg-white p-6 rounded-xl border border-border shadow-sm">
          <p className="text-xs font-bold uppercase text-textmuted mb-1 tracking-wider">Active Staff</p>
          <span className="text-xl font-bold text-textprimary">1,240 Personnel</span>
          <div className="flex -space-x-2 mt-2">
            <div className="w-6 h-6 rounded-full border-2 border-white bg-blue-100"></div>
            <div className="w-6 h-6 rounded-full border-2 border-white bg-green-100"></div>
            <div className="w-6 h-6 rounded-full border-2 border-white bg-purple-100"></div>
            <div className="w-6 h-6 rounded-full bg-slate-100 border-2 border-white flex items-center justify-center text-[8px] font-bold text-textmuted">+1k</div>
          </div>
        </div>
      </div>

      {/* Filters Section */}
      <div className="bg-white border border-border rounded-t-xl p-6 flex flex-col md:flex-row gap-6 items-center shadow-sm">
        <div className="flex-grow w-full md:w-auto relative">
          <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-textmuted">search</span>
          <input 
            className="w-full pl-12 pr-4 py-2 rounded-lg border border-border focus:ring-2 focus:ring-primary focus:border-primary outline-none text-sm bg-surface transition-all" 
            placeholder="Search hospitals by name, code or region..." 
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        <div className="flex gap-4 w-full md:w-auto">
          <select className="flex-grow md:flex-grow-0 px-4 py-2 rounded-lg border border-border text-sm focus:ring-primary outline-none cursor-pointer bg-white font-medium text-textprimary">
            <option>All Cities</option>
            <option>Karachi</option>
            <option>Lahore</option>
            <option>Islamabad</option>
            <option>Peshawar</option>
          </select>
          <select className="flex-grow md:flex-grow-0 px-4 py-2 rounded-lg border border-border text-sm focus:ring-primary outline-none cursor-pointer bg-white font-medium text-textprimary">
            <option>Facility Type</option>
            <option>General Hospital</option>
            <option>Trauma Center</option>
            <option>Maternity Wing</option>
            <option>Testing Lab</option>
          </select>
          <button className="p-2 rounded-lg border border-border hover:bg-slate-50 transition-colors bg-white">
            <span className="material-symbols-outlined text-textmuted">filter_list</span>
          </button>
        </div>
      </div>

      {/* Hospital Data Table */}
      <div className="bg-white border-x border-b border-border rounded-b-xl overflow-hidden shadow-sm -mt-6">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[800px]">
            <thead>
              <tr className="bg-slate-50 border-b border-border">
                <th className="px-6 py-4 text-xs font-bold uppercase text-textmuted tracking-wider">Facility Name</th>
                <th className="px-6 py-4 text-xs font-bold uppercase text-textmuted tracking-wider">Location</th>
                <th className="px-6 py-4 text-xs font-bold uppercase text-textmuted tracking-wider">Status</th>
                <th className="px-6 py-4 text-xs font-bold uppercase text-textmuted tracking-wider">Current Load</th>
                <th className="px-6 py-4 text-xs font-bold uppercase text-textmuted tracking-wider">Available Beds</th>
                <th className="px-6 py-4 text-xs font-bold uppercase text-textmuted tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {/* Row 1 */}
              <tr className="hover:bg-slate-50 transition-colors cursor-pointer group">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-lg bg-blue-50 flex items-center justify-center text-primary">
                      <span className="material-symbols-outlined">local_hospital</span>
                    </div>
                    <div>
                      <p className="text-sm font-bold text-textprimary group-hover:text-primary transition-colors">Jinnah Memorial</p>
                      <p className="text-xs text-textmuted mt-0.5">MRN: JM-44201</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-medium text-textprimary">Karachi, Sindh</p>
                  <p className="text-xs text-textmuted mt-0.5">Saddar Town</p>
                </td>
                <td className="px-6 py-4">
                  <span className="inline-flex items-center gap-1.5 px-2 py-1 rounded-full bg-blue-50 text-primary text-[10px] font-bold border border-blue-100 uppercase tracking-wider">
                    <span className="w-1.5 h-1.5 rounded-full bg-primary"></span>
                    Online
                  </span>
                </td>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-bold text-textprimary">92%</span>
                    <div className="w-20 bg-slate-200 h-1.5 rounded-full overflow-hidden">
                      <div className="bg-error h-full w-[92%]"></div>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-bold text-error">12 / 150</p>
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="View Live Stats">
                      <span className="material-symbols-outlined text-[18px]">insights</span>
                    </button>
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Edit Facility">
                      <span className="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                  </div>
                </td>
              </tr>

              {/* Row 2 */}
              <tr className="hover:bg-slate-50 transition-colors cursor-pointer group">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-lg bg-blue-50 flex items-center justify-center text-primary">
                      <span className="material-symbols-outlined">medical_information</span>
                    </div>
                    <div>
                      <p className="text-sm font-bold text-textprimary group-hover:text-primary transition-colors">Indus Health Unit</p>
                      <p className="text-xs text-textmuted mt-0.5">MRN: IH-11029</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-medium text-textprimary">Lahore, Punjab</p>
                  <p className="text-xs text-textmuted mt-0.5">Johar Town</p>
                </td>
                <td className="px-6 py-4">
                  <span className="inline-flex items-center gap-1.5 px-2 py-1 rounded-full bg-blue-50 text-primary text-[10px] font-bold border border-blue-100 uppercase tracking-wider">
                    <span className="w-1.5 h-1.5 rounded-full bg-primary"></span>
                    Online
                  </span>
                </td>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-bold text-textprimary">45%</span>
                    <div className="w-20 bg-slate-200 h-1.5 rounded-full overflow-hidden">
                      <div className="bg-primary h-full w-[45%]"></div>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-bold text-textprimary">110 / 200</p>
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="View Live Stats">
                      <span className="material-symbols-outlined text-[18px]">insights</span>
                    </button>
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Edit Facility">
                      <span className="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                  </div>
                </td>
              </tr>

              {/* Row 3 (Offline) */}
              <tr className="hover:bg-slate-50 transition-colors cursor-pointer group">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center text-textmuted opacity-50">
                      <span className="material-symbols-outlined">domain_disabled</span>
                    </div>
                    <div className="opacity-60">
                      <p className="text-sm font-bold text-textprimary">City Diagnostics</p>
                      <p className="text-xs text-textmuted mt-0.5">MRN: CD-88012</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 opacity-60">
                  <p className="text-sm font-medium text-textprimary">Islamabad, ICT</p>
                  <p className="text-xs text-textmuted mt-0.5">Blue Area</p>
                </td>
                <td className="px-6 py-4">
                  <span className="inline-flex items-center gap-1.5 px-2 py-1 rounded-full bg-slate-100 text-textmuted text-[10px] font-bold border border-border uppercase tracking-wider">
                    <span className="w-1.5 h-1.5 rounded-full bg-textmuted"></span>
                    Offline
                  </span>
                </td>
                <td className="px-6 py-4 opacity-60">
                  <p className="text-sm italic text-textmuted font-medium">Maintenance</p>
                </td>
                <td className="px-6 py-4 opacity-60">
                  <p className="text-sm font-bold text-textprimary">--</p>
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="View Live Stats">
                      <span className="material-symbols-outlined text-[18px]">insights</span>
                    </button>
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Edit Facility">
                      <span className="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                  </div>
                </td>
              </tr>

              {/* Row 4 */}
              <tr className="hover:bg-slate-50 transition-colors cursor-pointer group">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-lg bg-blue-50 flex items-center justify-center text-primary">
                      <span className="material-symbols-outlined">emergency</span>
                    </div>
                    <div>
                      <p className="text-sm font-bold text-textprimary group-hover:text-primary transition-colors">Khyber Trauma Center</p>
                      <p className="text-xs text-textmuted mt-0.5">MRN: KT-22003</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-medium text-textprimary">Peshawar, KPK</p>
                  <p className="text-xs text-textmuted mt-0.5">University Road</p>
                </td>
                <td className="px-6 py-4">
                  <span className="inline-flex items-center gap-1.5 px-2 py-1 rounded-full bg-amber-50 text-warning text-[10px] font-bold border border-amber-100 uppercase tracking-wider">
                    <span className="w-1.5 h-1.5 rounded-full bg-warning"></span>
                    En Route
                  </span>
                </td>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-bold text-textprimary">68%</span>
                    <div className="w-20 bg-slate-200 h-1.5 rounded-full overflow-hidden">
                      <div className="bg-warning h-full w-[68%]"></div>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <p className="text-sm font-bold text-textprimary">32 / 100</p>
                </td>
                <td className="px-6 py-4 text-right">
                  <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="View Live Stats">
                      <span className="material-symbols-outlined text-[18px]">insights</span>
                    </button>
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Edit Facility">
                      <span className="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        
        {/* Pagination */}
        <div className="bg-slate-50 px-6 py-4 flex items-center justify-between border-t border-border">
          <p className="text-xs font-medium text-textmuted">Showing 1 to 4 of 12 facilities</p>
          <div className="flex gap-2">
            <button className="px-4 py-1.5 rounded-lg border border-border bg-white text-xs font-bold text-textmuted opacity-50 cursor-not-allowed">Previous</button>
            <button className="px-4 py-1.5 rounded-lg border border-border bg-white text-xs font-bold text-textprimary hover:bg-slate-100 transition-colors">Next</button>
          </div>
        </div>
      </div>

      {/* Management Insights Card */}
      <div className="mt-6 grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-2 bg-white rounded-xl border border-border p-6 shadow-sm relative overflow-hidden">
          <div className="relative z-10">
            <h4 className="text-xl font-bold text-textprimary mb-4">Regional Network Map</h4>
            <div className="w-full h-48 bg-slate-100 rounded-lg border border-border flex items-center justify-center overflow-hidden">
               <div className="text-textmuted text-sm font-medium">Map visualization placeholder</div>
            </div>
          </div>
        </div>
        
        <div className="bg-primary text-white rounded-xl p-6 shadow-md flex flex-col justify-between">
          <div>
            <span className="material-symbols-outlined text-[32px] mb-4">auto_awesome</span>
            <h4 className="text-xl font-bold mb-2">AI Recommendation</h4>
            <p className="text-sm font-medium text-white/90 leading-relaxed">Based on current traffic and load, redirect non-critical arrivals from Jinnah Memorial to Indus Health Unit for the next 3 hours.</p>
          </div>
          <button className="mt-6 w-full bg-white text-primary py-2.5 rounded-lg font-bold hover:scale-[1.02] active:scale-[0.98] transition-transform shadow-sm">
            Deploy Directive
          </button>
        </div>
      </div>

    </div>
  );
}
