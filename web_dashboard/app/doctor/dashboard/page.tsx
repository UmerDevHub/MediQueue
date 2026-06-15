'use client';

import { useState } from 'react';

export default function DoctorDashboardPage() {
  const [isOnDuty, setIsOnDuty] = useState(true);

  return (
    <div className="space-y-8">
      {/* HEADER SECTION IS HANDLED BY TopBar, but we can add some specific content here if needed */}
      <div className="flex justify-between items-center bg-surface border-b border-border -mx-6 -mt-6 p-6 mb-6">
        <div>
          <h1 className="text-xl font-semibold text-textprimary">Good Morning, Dr. Hassan</h1>
          <p className="text-sm text-textmuted">Your clinic summary for October 24, 2023</p>
        </div>
        <div className="flex items-center gap-6">
          <div className="flex items-center gap-3 bg-slate-50 rounded-full px-4 py-1.5 border border-border">
            <span className={`w-2 h-2 rounded-full ${isOnDuty ? 'bg-success animate-pulse' : 'bg-textmuted'}`}></span>
            <span className="text-xs font-semibold uppercase text-textmuted">{isOnDuty ? 'On Duty' : 'Off Duty'}</span>
            <button 
              onClick={() => setIsOnDuty(!isOnDuty)}
              className={`relative inline-flex h-5 w-9 shrink-0 cursor-pointer items-center rounded-full transition-colors focus:outline-none ${isOnDuty ? 'bg-primary' : 'bg-slate-300'}`}
            >
              <span className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${isOnDuty ? 'translate-x-4' : 'translate-x-1'}`}></span>
            </button>
          </div>
        </div>
      </div>

      {/* ROW 1: STATS CARDS */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150">
          <div className="flex justify-between items-start mb-4">
            <span className="material-symbols-outlined p-2 bg-blue-50 text-primary rounded-lg">event_note</span>
            <span className="text-xs font-bold text-success bg-green-50 px-2 py-0.5 rounded-full">+12%</span>
          </div>
          <p className="text-xs font-semibold uppercase text-textmuted">Total Slots Today</p>
          <h3 className="text-2xl font-bold text-textprimary mt-1">32</h3>
        </div>
        
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150">
          <div className="flex justify-between items-start mb-4">
            <span className="material-symbols-outlined p-2 bg-blue-50 text-primary rounded-lg">book_online</span>
            <span className="text-xs font-bold text-textmuted bg-slate-100 px-2 py-0.5 rounded-full">Full</span>
          </div>
          <p className="text-xs font-semibold uppercase text-textmuted">Booked</p>
          <h3 className="text-2xl font-bold text-textprimary mt-1">28</h3>
        </div>

        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150">
          <div className="flex justify-between items-start mb-4">
            <span className="material-symbols-outlined p-2 bg-green-50 text-success rounded-lg">check_circle</span>
            <span className="text-xs font-bold text-success bg-green-50 px-2 py-0.5 rounded-full">87% Done</span>
          </div>
          <p className="text-xs font-semibold uppercase text-textmuted">Completed</p>
          <h3 className="text-2xl font-bold text-textprimary mt-1">14</h3>
        </div>

        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150">
          <div className="flex justify-between items-start mb-4">
            <span className="material-symbols-outlined p-2 bg-amber-50 text-warning rounded-lg">pending_actions</span>
            <span className="text-xs font-bold text-warning bg-amber-50 px-2 py-0.5 rounded-full">Action Required</span>
          </div>
          <p className="text-xs font-semibold uppercase text-textmuted">Available</p>
          <h3 className="text-2xl font-bold text-textprimary mt-1">04</h3>
        </div>
      </div>

      {/* ROW 2: MAIN GRID */}
      <div className="grid grid-cols-1 lg:grid-cols-10 gap-8">
        {/* LEFT (70%): WEEKLY SCHEDULE */}
        <div className="lg:col-span-7 space-y-4">
          <div className="flex justify-between items-end mb-2">
            <h2 className="text-xl font-semibold">Weekly Schedule</h2>
            <div className="flex gap-2">
              <button className="p-1 bg-surface border border-border rounded hover:bg-slate-50 transition-colors">
                <span className="material-symbols-outlined text-sm">chevron_left</span>
              </button>
              <span className="text-sm font-bold px-2 flex items-center">Oct 21 - Oct 27</span>
              <button className="p-1 bg-surface border border-border rounded hover:bg-slate-50 transition-colors">
                <span className="material-symbols-outlined text-sm">chevron_right</span>
              </button>
            </div>
          </div>
          <div className="bg-surface border border-border rounded-xl overflow-hidden shadow-sm">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse min-w-[600px]">
                <thead>
                  <tr className="bg-slate-50 text-xs font-semibold uppercase text-textmuted border-b border-border">
                    <th className="p-4 border-r border-border w-24">Time</th>
                    <th className="p-4">Mon 21</th>
                    <th className="p-4">Tue 22</th>
                    <th className="p-4 bg-blue-50 text-primary">Wed 23</th>
                    <th className="p-4">Thu 24</th>
                    <th className="p-4">Fri 25</th>
                  </tr>
                </thead>
                <tbody className="text-sm">
                  {/* Slots */}
                  <tr className="border-b border-border hover:bg-slate-50 transition-colors">
                    <td className="p-4 border-r border-border font-medium text-textmuted">09:00 AM</td>
                    <td className="p-1">
                      <div className="bg-blue-50 border border-blue-100 rounded p-2 m-1">
                        <p className="font-bold text-primary text-xs truncate">Ahmed K.</p>
                        <p className="text-[10px] text-primary truncate">General Checkup</p>
                      </div>
                    </td>
                    <td className="p-1">
                      <div className="bg-slate-50 border border-border rounded p-2 m-1 border-dashed">
                        <p className="text-[10px] text-center text-textmuted uppercase font-bold">Available</p>
                      </div>
                    </td>
                    <td className="p-1 bg-blue-50/50">
                      <div className="bg-blue-50 border border-blue-100 rounded p-2 m-1">
                        <p className="font-bold text-primary text-xs truncate">Sara J.</p>
                        <p className="text-[10px] text-primary truncate">Follow-up</p>
                      </div>
                    </td>
                    <td className="p-1">
                      <div className="bg-blue-50 border border-blue-100 rounded p-2 m-1">
                        <p className="font-bold text-primary text-xs truncate">Ali R.</p>
                      </div>
                    </td>
                    <td className="p-1">
                       <div className="bg-slate-50 border border-border rounded p-2 m-1 border-dashed">
                        <p className="text-[10px] text-center text-textmuted uppercase font-bold">Available</p>
                      </div>
                    </td>
                  </tr>

                  <tr className="border-b border-border hover:bg-slate-50 transition-colors">
                    <td className="p-4 border-r border-border font-medium text-textmuted">10:00 AM</td>
                    <td className="p-1">
                       <div className="bg-slate-50 border border-border rounded p-2 m-1 border-dashed">
                        <p className="text-[10px] text-center text-textmuted uppercase font-bold">Available</p>
                      </div>
                    </td>
                    <td className="p-1">
                      <div className="bg-blue-50 border border-blue-100 rounded p-2 m-1">
                        <p className="font-bold text-primary text-xs truncate">Zahid M.</p>
                      </div>
                    </td>
                    <td className="p-1 bg-blue-50/50">
                      <div className="bg-blue-50 border border-blue-100 rounded p-2 m-1">
                        <p className="font-bold text-primary text-xs truncate">Maria L.</p>
                      </div>
                    </td>
                    <td className="p-1">
                      <div className="bg-blue-50 border border-blue-100 rounded p-2 m-1">
                        <p className="font-bold text-primary text-xs truncate">Yasin F.</p>
                      </div>
                    </td>
                    <td className="p-1">
                      <div className="bg-blue-50 border border-blue-100 rounded p-2 m-1">
                        <p className="font-bold text-primary text-xs truncate">Noman Q.</p>
                      </div>
                    </td>
                  </tr>

                  <tr className="border-b border-border bg-slate-50">
                    <td className="p-4 border-r border-border font-medium text-textmuted">11:00 AM</td>
                    <td className="p-4 text-center italic text-textmuted" colSpan={5}>Hospital Rounds</td>
                  </tr>

                  <tr className="border-b border-border hover:bg-slate-50 transition-colors">
                    <td className="p-4 border-r border-border font-medium text-textmuted">12:00 PM</td>
                    <td className="p-1"><div className="bg-blue-50 border border-blue-100 rounded p-2 m-1"><p className="font-bold text-primary text-xs">Irfan S.</p></div></td>
                    <td className="p-1"><div className="bg-blue-50 border border-blue-100 rounded p-2 m-1"><p className="font-bold text-primary text-xs">Asma T.</p></div></td>
                    <td className="p-1 bg-blue-50/50"><div className="bg-slate-50 border border-border rounded p-2 m-1 border-dashed"><p className="text-[10px] text-center text-textmuted font-bold uppercase">Available</p></div></td>
                    <td className="p-1"><div className="bg-blue-50 border border-blue-100 rounded p-2 m-1"><p className="font-bold text-primary text-xs">Hamza D.</p></div></td>
                    <td className="p-1"><div className="bg-blue-50 border border-blue-100 rounded p-2 m-1"><p className="font-bold text-primary text-xs">Fatima O.</p></div></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* RIGHT (30%): TODAY'S QUEUE */}
        <div className="lg:col-span-3 flex flex-col space-y-4">
          <div className="flex justify-between items-end mb-2">
            <h2 className="text-xl font-semibold">Today's Queue</h2>
            <span className="text-xs font-bold bg-blue-100 text-primary px-2 py-1 rounded-full uppercase">4 Waiting</span>
          </div>
          <div className="bg-surface border border-border rounded-xl overflow-hidden shadow-sm flex-1 flex flex-col">
            <div className="p-4 border-b border-border bg-slate-50 flex items-center justify-between">
              <span className="text-xs font-bold uppercase text-textmuted">Active User</span>
              <span className="text-[10px] font-bold text-primary bg-blue-100 px-2 py-0.5 rounded uppercase animate-pulse">In Progress</span>
            </div>

            {/* List */}
            <div className="divide-y divide-border overflow-y-auto max-h-[600px]">
              
              {/* Current */}
              <div className="p-4 bg-blue-50/50 flex flex-col gap-3">
                <div className="flex justify-between items-start">
                  <div className="flex gap-4">
                    <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center text-primary font-bold">SA</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Salman Ahmed</p>
                      <p className="text-xs text-textmuted">MRN: #MQ-2023-882</p>
                    </div>
                  </div>
                  <span className="text-xs font-bold text-textmuted">12:15 PM</span>
                </div>
                <div className="flex gap-2 mt-2">
                  <button className="flex-1 bg-primary text-white text-xs uppercase py-2 rounded-lg font-bold hover:scale-[1.02] transition-transform shadow-sm">Resume Session</button>
                </div>
              </div>

              {/* Next in Queue 1 */}
              <div className="p-4 hover:bg-slate-50 transition-colors group">
                <div className="flex justify-between items-start mb-3">
                  <div className="flex gap-4">
                    <div className="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center text-textmuted font-bold">FK</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Farhan Khan</p>
                      <p className="text-xs text-textmuted">Follow-up: Cardiac</p>
                    </div>
                  </div>
                  <span className="text-xs font-bold text-textmuted">12:45 PM</span>
                </div>
                <button className="w-full border border-primary text-primary text-xs uppercase py-2 rounded-lg font-bold hover:bg-blue-50 transition-colors group-hover:scale-[1.02]">Start Session</button>
              </div>

              {/* Next in Queue 2 */}
              <div className="p-4 hover:bg-slate-50 transition-colors group opacity-80">
                <div className="flex justify-between items-start mb-3">
                  <div className="flex gap-4">
                    <div className="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center text-textmuted font-bold">ZB</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Zainab Bibi</p>
                      <p className="text-xs text-textmuted">Consultation: ENT</p>
                    </div>
                  </div>
                  <span className="text-xs font-bold text-textmuted">01:05 PM</span>
                </div>
                <button className="w-full border border-border text-textmuted text-xs uppercase py-2 rounded-lg font-bold cursor-not-allowed">Pending Arrival</button>
              </div>

              {/* Next in Queue 3 */}
              <div className="p-4 hover:bg-slate-50 transition-colors group opacity-80">
                <div className="flex justify-between items-start mb-3">
                  <div className="flex gap-4">
                    <div className="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center text-textmuted font-bold">OM</div>
                    <div>
                      <p className="text-sm font-bold text-textprimary">Omar Malik</p>
                      <p className="text-xs text-textmuted">Prescription Renewal</p>
                    </div>
                  </div>
                  <span className="text-xs font-bold text-textmuted">01:30 PM</span>
                </div>
                <button className="w-full border border-border text-textmuted text-xs uppercase py-2 rounded-lg font-bold cursor-not-allowed">Pending Arrival</button>
              </div>

            </div>
            
            <div className="mt-auto p-4 border-t border-border bg-slate-50 text-center">
              <button className="text-sm text-primary font-bold hover:underline transition-all">View Full Queue History</button>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
