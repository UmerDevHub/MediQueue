'use client';

import { useState } from 'react';

export default function AdminUsersPage() {
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <div className="space-y-6">
      {/* Header Section */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-6">
        <div>
          <h1 className="text-2xl font-semibold text-textprimary mb-1">User Management</h1>
          <p className="text-sm text-textmuted">Centralized directory for all platform roles and credentials.</p>
        </div>
        <div className="flex gap-2">
          <button className="px-4 h-10 border border-border bg-white hover:scale-[1.02] transition-all active:scale-[0.97] rounded-lg text-textprimary text-sm font-semibold flex items-center gap-1.5 shadow-sm">
            <span className="material-symbols-outlined text-[18px]">download</span> Export CSV
          </button>
          <button className="px-4 h-10 bg-primary text-white hover:scale-[1.02] transition-all active:scale-[0.97] rounded-lg text-sm font-semibold flex items-center gap-1.5 shadow-sm">
            <span className="material-symbols-outlined text-[18px]">person_add</span> Add New User
          </button>
        </div>
      </div>

      {/* Bento Filter & Search Grid */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="md:col-span-2 bg-white border border-border rounded-xl p-4 flex items-center gap-4 shadow-sm">
          <span className="material-symbols-outlined text-textmuted">search</span>
          <input 
            className="w-full bg-transparent border-none focus:ring-0 text-sm p-0 outline-none text-textprimary" 
            placeholder="Search by name, MRN, or License ID..." 
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        <div className="bg-white border border-border rounded-xl p-4 flex items-center justify-between shadow-sm">
          <div className="flex flex-col w-full">
            <span className="text-[11px] font-medium text-textmuted uppercase tracking-wider mb-1">User Role</span>
            <select className="bg-transparent border-none p-0 text-sm font-semibold focus:ring-0 outline-none cursor-pointer w-full text-textprimary">
              <option>All Roles</option>
              <option>Super Admin</option>
              <option>Doctors</option>
              <option>Users</option>
            </select>
          </div>
          <span className="material-symbols-outlined text-textmuted">filter_list</span>
        </div>
        <div className="bg-white border border-border rounded-xl p-4 flex items-center justify-between shadow-sm">
          <div className="flex flex-col w-full">
            <span className="text-[11px] font-medium text-textmuted uppercase tracking-wider mb-1">Status</span>
            <select className="bg-transparent border-none p-0 text-sm font-semibold focus:ring-0 outline-none cursor-pointer w-full text-textprimary">
              <option>Active</option>
              <option>Pending</option>
              <option>Suspended</option>
            </select>
          </div>
          <span className="material-symbols-outlined text-textmuted">check_circle</span>
        </div>
      </div>

      {/* Bulk Actions (Placeholder for selected state) */}
      {/* 
      <div className="flex items-center justify-between bg-primary text-white px-6 py-2 rounded-xl mb-4 animate-in slide-in-from-top-4 duration-300">
        <span className="text-sm font-medium"><span>2</span> users selected</span>
        <div className="flex gap-4">
          <button className="text-xs uppercase font-bold hover:underline">Change Status</button>
          <button className="text-xs uppercase font-bold hover:underline">Move Hospital</button>
          <button className="text-xs uppercase font-bold hover:underline text-red-200">Suspend</button>
        </div>
      </div> 
      */}

      {/* Data Table */}
      <div className="bg-white border border-border rounded-xl overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left min-w-[900px]">
            <thead className="bg-slate-50 border-b border-border">
              <tr>
                <th className="py-3 px-6 w-10">
                  <input className="rounded border-border text-primary focus:ring-primary cursor-pointer" type="checkbox" />
                </th>
                <th className="py-3 px-4 text-xs font-semibold uppercase text-textmuted tracking-wider">User Identity</th>
                <th className="py-3 px-4 text-xs font-semibold uppercase text-textmuted tracking-wider">Role</th>
                <th className="py-3 px-4 text-xs font-semibold uppercase text-textmuted tracking-wider">MRN / License</th>
                <th className="py-3 px-4 text-xs font-semibold uppercase text-textmuted tracking-wider">Affiliation</th>
                <th className="py-3 px-4 text-xs font-semibold uppercase text-textmuted tracking-wider text-center">Status</th>
                <th className="py-3 px-4 text-xs font-semibold uppercase text-textmuted tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {/* Row 1 - Doctor */}
              <tr className="hover:bg-slate-50 transition-colors group">
                <td className="py-4 px-6">
                  <input className="rounded border-border text-primary focus:ring-primary cursor-pointer" type="checkbox" />
                </td>
                <td className="py-4 px-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-primary font-bold text-sm">ZS</div>
                    <div>
                      <p className="font-semibold text-textprimary text-sm group-hover:text-primary transition-colors">Zainab Sheikh</p>
                      <p className="text-xs text-textmuted">z.sheikh@jinnah.org</p>
                    </div>
                  </div>
                </td>
                <td className="py-4 px-4">
                  <span className="text-sm text-textprimary font-medium">Senior Doctor</span>
                </td>
                <td className="py-4 px-4">
                  <code className="text-xs font-mono bg-slate-100 text-textprimary px-2 py-1 rounded border border-border">PMC-12993-D</code>
                </td>
                <td className="py-4 px-4">
                  <p className="text-sm text-textprimary font-medium">Jinnah Hospital</p>
                </td>
                <td className="py-4 px-4 text-center">
                  <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-green-50 text-success text-[11px] font-bold border border-green-100 uppercase tracking-wide">
                    <span className="w-1.5 h-1.5 rounded-full bg-success"></span>
                    Active
                  </span>
                </td>
                <td className="py-4 px-4 text-right">
                  <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Edit User">
                      <span className="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                    <button className="p-1.5 text-textmuted hover:text-error transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Suspend User">
                      <span className="material-symbols-outlined text-[18px]">block</span>
                    </button>
                  </div>
                </td>
              </tr>

              {/* Row 2 - User */}
              <tr className="hover:bg-slate-50 transition-colors group">
                <td className="py-4 px-6">
                  <input className="rounded border-border text-primary focus:ring-primary cursor-pointer" type="checkbox" />
                </td>
                <td className="py-4 px-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-textmuted font-bold text-sm">AK</div>
                    <div>
                      <p className="font-semibold text-textprimary text-sm group-hover:text-primary transition-colors">Ali Khan</p>
                      <p className="text-xs text-textmuted">+92 300 1234567</p>
                    </div>
                  </div>
                </td>
                <td className="py-4 px-4">
                  <span className="text-sm text-textprimary font-medium">App User</span>
                </td>
                <td className="py-4 px-4">
                  <code className="text-xs font-mono bg-slate-100 text-textprimary px-2 py-1 rounded border border-border">MRN-99821</code>
                </td>
                <td className="py-4 px-4">
                  <p className="text-sm text-textprimary font-medium">--</p>
                </td>
                <td className="py-4 px-4 text-center">
                  <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-green-50 text-success text-[11px] font-bold border border-green-100 uppercase tracking-wide">
                    <span className="w-1.5 h-1.5 rounded-full bg-success"></span>
                    Active
                  </span>
                </td>
                <td className="py-4 px-4 text-right">
                  <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Edit User">
                      <span className="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                    <button className="p-1.5 text-textmuted hover:text-error transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Suspend User">
                      <span className="material-symbols-outlined text-[18px]">block</span>
                    </button>
                  </div>
                </td>
              </tr>

              {/* Row 3 - Admin */}
              <tr className="hover:bg-slate-50 transition-colors group">
                <td className="py-4 px-6">
                  <input className="rounded border-border text-primary focus:ring-primary cursor-pointer" type="checkbox" />
                </td>
                <td className="py-4 px-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center text-purple-700 font-bold text-sm">SA</div>
                    <div>
                      <p className="font-semibold text-textprimary text-sm group-hover:text-primary transition-colors">Sarah Ahmed</p>
                      <p className="text-xs text-textmuted">admin@mediqueue.com</p>
                    </div>
                  </div>
                </td>
                <td className="py-4 px-4">
                  <span className="text-sm text-textprimary font-medium">Super Admin</span>
                </td>
                <td className="py-4 px-4">
                  <code className="text-xs font-mono bg-slate-100 text-textprimary px-2 py-1 rounded border border-border">SYS-0001</code>
                </td>
                <td className="py-4 px-4">
                  <p className="text-sm text-textprimary font-medium">Global</p>
                </td>
                <td className="py-4 px-4 text-center">
                  <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-green-50 text-success text-[11px] font-bold border border-green-100 uppercase tracking-wide">
                    <span className="w-1.5 h-1.5 rounded-full bg-success"></span>
                    Active
                  </span>
                </td>
                <td className="py-4 px-4 text-right">
                  <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-1.5 text-textmuted hover:text-primary transition-colors bg-white rounded-md border border-border shadow-sm hover:bg-slate-50" title="Edit User">
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
          <p className="text-xs font-medium text-textmuted">Showing 1 to 3 of 4,192 users</p>
          <div className="flex gap-2">
            <button className="px-4 py-1.5 rounded-lg border border-border bg-white text-xs font-bold text-textmuted opacity-50 cursor-not-allowed">Previous</button>
            <button className="px-4 py-1.5 rounded-lg border border-border bg-white text-xs font-bold text-textprimary hover:bg-slate-100 transition-colors shadow-sm">Next</button>
          </div>
        </div>
      </div>
    </div>
  );
}
