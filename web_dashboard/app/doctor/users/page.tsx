'use client';

import { useState } from 'react';

export default function DoctorUsersPage() {
  const [selectedUser, setSelectedUser] = useState<any>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);

  const openDrawer = (name: string, mrn: string) => {
    setSelectedUser({ name, mrn, initials: name.split(' ').map(n => n[0]).join('') });
    setIsDrawerOpen(true);
  };

  const closeDrawer = () => {
    setIsDrawerOpen(false);
  };

  return (
    <div className="space-y-6">
      {/* Header Section */}
      <header className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h1 className="text-3xl font-semibold text-textprimary mb-1">My Users</h1>
          <p className="text-base text-textmuted">Manage and review your user clinical records and history.</p>
        </div>
        <div className="flex gap-2">
          <button className="flex items-center gap-1 px-4 py-2 bg-primary text-white rounded-lg font-bold hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
            <span className="material-symbols-outlined text-[18px]">add</span>
            New User
          </button>
        </div>
      </header>

      {/* Filters & Search Bento Card */}
      <section className="bg-surface border border-border rounded-xl p-4 shadow-sm">
        <div className="flex flex-wrap gap-4 items-center">
          <div className="flex-grow relative min-w-[300px]">
            <span className="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-textmuted">search</span>
            <input 
              className="w-full pl-12 pr-4 py-2 bg-slate-50 border border-border rounded-lg text-sm focus:ring-2 focus:ring-primary focus:border-primary transition-all outline-none" 
              placeholder="Search by name, MRN or contact..." 
              type="text"
            />
          </div>
          <div className="flex gap-2">
            <button className="flex items-center gap-1 px-4 py-2 bg-slate-50 text-textprimary border border-border rounded-lg text-xs uppercase font-bold hover:bg-slate-100 active:scale-[0.97] transition-colors shadow-sm">
              <span className="material-symbols-outlined text-[18px]">filter_list</span>
              Filters
            </button>
            <button className="flex items-center gap-1 px-4 py-2 bg-slate-50 text-textprimary border border-border rounded-lg text-xs uppercase font-bold hover:bg-slate-100 active:scale-[0.97] transition-colors shadow-sm">
              <span className="material-symbols-outlined text-[18px]">download</span>
              Export
            </button>
          </div>
        </div>
      </section>

      {/* Data Table Surface */}
      <section className="bg-surface border border-border rounded-xl overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[800px]">
            <thead className="bg-slate-50 border-b border-border">
              <tr>
                <th className="px-6 py-4 text-xs font-semibold uppercase text-textmuted">User Name</th>
                <th className="px-6 py-4 text-xs font-semibold uppercase text-textmuted">MRN</th>
                <th className="px-6 py-4 text-xs font-semibold uppercase text-textmuted">Last Visit</th>
                <th className="px-6 py-4 text-xs font-semibold uppercase text-textmuted">Total Apps</th>
                <th className="px-6 py-4 text-xs font-semibold uppercase text-textmuted">Status</th>
                <th className="px-6 py-4 text-xs font-semibold uppercase text-textmuted text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {/* Row 1 */}
              <tr className="hover:bg-slate-50 cursor-pointer transition-colors group" onClick={() => openDrawer('Zainab Bibi', 'MRN-90210')}>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-primary font-bold">ZB</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Zainab Bibi</p>
                      <p className="text-xs text-textmuted">42 yrs • Female</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 text-sm font-mono text-textmuted">MRN-90210</td>
                <td className="px-6 py-4 text-sm text-textprimary">Oct 24, 2023</td>
                <td className="px-6 py-4 text-sm text-textprimary">12</td>
                <td className="px-6 py-4">
                  <span className="px-2 py-1 rounded-full text-xs font-bold bg-green-50 text-success border border-green-100">Stable</span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="p-2 rounded-lg hover:bg-slate-200 transition-colors text-textmuted">
                    <span className="material-symbols-outlined">more_vert</span>
                  </button>
                </td>
              </tr>
              {/* Row 2 */}
              <tr className="hover:bg-slate-50 cursor-pointer transition-colors group" onClick={() => openDrawer('Ahmed Raza', 'MRN-88432')}>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-primary font-bold">AR</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Ahmed Raza</p>
                      <p className="text-xs text-textmuted">29 yrs • Male</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 text-sm font-mono text-textmuted">MRN-88432</td>
                <td className="px-6 py-4 text-sm text-textprimary">Oct 26, 2023</td>
                <td className="px-6 py-4 text-sm text-textprimary">03</td>
                <td className="px-6 py-4">
                  <span className="px-2 py-1 rounded-full text-xs font-bold bg-blue-50 text-primary border border-blue-100">In Recovery</span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="p-2 rounded-lg hover:bg-slate-200 transition-colors text-textmuted">
                    <span className="material-symbols-outlined">more_vert</span>
                  </button>
                </td>
              </tr>
              {/* Row 3 */}
              <tr className="hover:bg-slate-50 cursor-pointer transition-colors group" onClick={() => openDrawer('Fatima Khan', 'MRN-77321')}>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-primary font-bold">FK</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Fatima Khan</p>
                      <p className="text-xs text-textmuted">55 yrs • Female</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 text-sm font-mono text-textmuted">MRN-77321</td>
                <td className="px-6 py-4 text-sm text-textprimary">Oct 27, 2023</td>
                <td className="px-6 py-4 text-sm text-textprimary">08</td>
                <td className="px-6 py-4">
                  <span className="px-2 py-1 rounded-full text-xs font-bold bg-amber-50 text-warning border border-amber-100">Follow-up</span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="p-2 rounded-lg hover:bg-slate-200 transition-colors text-textmuted">
                    <span className="material-symbols-outlined">more_vert</span>
                  </button>
                </td>
              </tr>
              {/* Row 4 */}
              <tr className="hover:bg-slate-50 cursor-pointer transition-colors group" onClick={() => openDrawer('Zubair Sheikh', 'MRN-44219')}>
                <td className="px-6 py-4">
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-primary font-bold">ZS</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Zubair Sheikh</p>
                      <p className="text-xs text-textmuted">68 yrs • Male</p>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 text-sm font-mono text-textmuted">MRN-44219</td>
                <td className="px-6 py-4 text-sm text-textprimary">Oct 15, 2023</td>
                <td className="px-6 py-4 text-sm text-textprimary">24</td>
                <td className="px-6 py-4">
                  <span className="px-2 py-1 rounded-full text-xs font-bold bg-red-50 text-error border border-red-100">Critical</span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="p-2 rounded-lg hover:bg-slate-200 transition-colors text-textmuted">
                    <span className="material-symbols-outlined">more_vert</span>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        {/* Pagination */}
        <div className="flex items-center justify-between px-6 py-4 bg-slate-50 border-t border-border">
          <p className="text-xs text-textmuted">Showing 1 to 4 of 128 users</p>
          <div className="flex gap-2">
            <button className="px-4 py-1 bg-white border border-border rounded-lg text-xs font-bold text-textprimary hover:bg-slate-50 transition-colors disabled:opacity-50">Prev</button>
            <button className="px-4 py-1 bg-primary text-white rounded-lg text-xs font-bold hover:scale-[1.02] active:scale-[0.97] transition-all">Next</button>
          </div>
        </div>
      </section>

      {/* Slide-out Drawer */}
      <div 
        className={`fixed inset-0 bg-black/20 backdrop-blur-[2px] z-[60] transition-opacity duration-300 ${isDrawerOpen ? 'opacity-100' : 'opacity-0 pointer-events-none'}`} 
        onClick={closeDrawer}
      ></div>
      <aside 
        className={`fixed right-0 top-0 h-full w-full max-w-[500px] bg-surface z-[70] border-l border-border overflow-y-auto shadow-2xl flex flex-col transition-transform duration-300 ${isDrawerOpen ? 'translate-x-0' : 'translate-x-full'}`}
      >
        <div className="flex items-center justify-between p-6 border-b border-border sticky top-0 bg-surface z-10">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-full bg-primary text-white flex items-center justify-center text-xl font-bold">
              {selectedUser?.initials || ''}
            </div>
            <div>
              <h3 className="text-xl font-bold text-textprimary">{selectedUser?.name || ''}</h3>
              <p className="text-xs font-mono text-textmuted">{selectedUser?.mrn || ''}</p>
            </div>
          </div>
          <button className="p-2 rounded-full hover:bg-slate-100 transition-colors text-textmuted" onClick={closeDrawer}>
            <span className="material-symbols-outlined">close</span>
          </button>
        </div>
        
        <div className="p-6 flex flex-col gap-6">
          {/* Stats Grid */}
          <div className="grid grid-cols-2 gap-4">
            <div className="p-4 bg-slate-50 border border-border rounded-xl">
              <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Total Appointments</p>
              <p className="text-lg font-bold text-primary mt-1">12 Visits</p>
            </div>
            <div className="p-4 bg-slate-50 border border-border rounded-xl">
              <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Last Diagnosis</p>
              <p className="text-sm font-bold text-textprimary mt-1">Chronic Gastritis</p>
            </div>
          </div>
          
          {/* Clinical Notes */}
          <section>
            <div className="flex items-center justify-between mb-4">
              <h4 className="text-xs font-bold uppercase tracking-wider text-textmuted">Latest Clinical Notes</h4>
              <button className="text-primary text-xs font-bold hover:underline">Edit Notes</button>
            </div>
            <div className="p-4 bg-white border border-border rounded-xl shadow-sm space-y-4">
              <p className="text-sm text-textprimary leading-relaxed">
                User reports improved appetite since starting Omeprazole 20mg. Occasional discomfort persists after spicy meals. Recommended continuing lifestyle adjustments and scheduled a follow-up endoscopy in 3 months.
              </p>
              <div className="flex gap-2">
                <span className="px-2 py-1 bg-slate-100 rounded text-[10px] font-bold text-textmuted">#Gastroenterology</span>
                <span className="px-2 py-1 bg-slate-100 rounded text-[10px] font-bold text-textmuted">#RoutineFollowUp</span>
              </div>
            </div>
          </section>

          {/* Timeline of Care */}
          <section>
            <h4 className="text-xs font-bold uppercase tracking-wider text-textmuted mb-4">Timeline of Care</h4>
            <div className="relative pl-6 border-l-2 border-border ml-2 space-y-8">
              {/* Timeline Item 1 */}
              <div className="relative">
                <div className="absolute -left-[29px] top-0 w-3 h-3 rounded-full bg-primary ring-4 ring-white shadow-sm"></div>
                <div className="flex flex-col gap-1">
                  <span className="text-[10px] font-bold text-primary uppercase">Oct 24, 2023</span>
                  <p className="text-sm font-bold text-textprimary">General Consultation</p>
                  <p className="text-xs text-textmuted">Routine check-up, vitals stable. BP: 120/80.</p>
                </div>
              </div>
              {/* Timeline Item 2 */}
              <div className="relative">
                <div className="absolute -left-[29px] top-0 w-3 h-3 rounded-full bg-slate-300 ring-4 ring-white shadow-sm"></div>
                <div className="flex flex-col gap-1">
                  <span className="text-[10px] font-bold text-textmuted uppercase">Sep 12, 2023</span>
                  <p className="text-sm font-bold text-textprimary">Diagnostic Lab Test</p>
                  <p className="text-xs text-textmuted">CBC and H. Pylori screen performed. Positive results for H. Pylori.</p>
                </div>
              </div>
              {/* Timeline Item 3 */}
              <div className="relative">
                <div className="absolute -left-[29px] top-0 w-3 h-3 rounded-full bg-slate-300 ring-4 ring-white shadow-sm"></div>
                <div className="flex flex-col gap-1">
                  <span className="text-[10px] font-bold text-textmuted uppercase">Aug 05, 2023</span>
                  <p className="text-sm font-bold text-textprimary">Initial Registration</p>
                  <p className="text-xs text-textmuted">User enrolled into system. Primary complaint: Epigastric pain.</p>
                </div>
              </div>
            </div>
          </section>
        </div>

        {/* Sticky Actions */}
        <div className="mt-auto p-6 border-t border-border flex gap-4 bg-surface">
          <button className="flex-1 py-2 px-4 bg-primary text-white rounded-lg font-bold hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">Schedule Next</button>
          <button className="flex-1 py-2 px-4 bg-white border border-border text-textprimary font-bold rounded-lg hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">Full History</button>
        </div>
      </aside>

    </div>
  );
}
