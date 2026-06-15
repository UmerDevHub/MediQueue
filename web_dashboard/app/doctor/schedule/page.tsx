'use client';

export default function DoctorSchedulePage() {
  return (
    <div className="flex flex-col h-[calc(100vh-64px)] -m-6">
      {/* Week Calendar Strip */}
      <section className="bg-surface px-6 py-4 border-b border-border">
        <div className="flex justify-between items-center mb-4">
          <div className="flex items-center gap-2">
            <span className="text-xl font-semibold text-textprimary">November 2023</span>
            <div className="flex gap-1">
              <button className="material-symbols-outlined text-textmuted hover:bg-slate-100 p-1 rounded transition-colors">chevron_left</button>
              <button className="material-symbols-outlined text-textmuted hover:bg-slate-100 p-1 rounded transition-colors">chevron_right</button>
            </div>
          </div>
          <button className="text-primary font-bold hover:bg-blue-50 px-4 py-2 rounded-lg transition-all active:scale-[0.97]">Today</button>
        </div>
        <div className="flex justify-between gap-2 overflow-x-auto">
          {/* Mon 18 */}
          <button className="flex flex-col items-center gap-1 min-w-[56px] py-3 rounded-xl transition-all hover:bg-slate-100 active:scale-[0.97] text-textmuted">
            <span className="text-xs font-semibold">MON</span>
            <span className="text-xl font-semibold">18</span>
          </button>
          {/* Tue 19 (Active) */}
          <button className="flex flex-col items-center gap-1 min-w-[56px] py-3 rounded-xl transition-all bg-primary text-white active:scale-[0.97] shadow-sm">
            <span className="text-xs font-semibold">TUE</span>
            <span className="text-xl font-semibold">19</span>
          </button>
          {/* Wed 20 */}
          <button className="flex flex-col items-center gap-1 min-w-[56px] py-3 rounded-xl transition-all hover:bg-slate-100 active:scale-[0.97] text-textmuted">
            <span className="text-xs font-semibold">WED</span>
            <span className="text-xl font-semibold">20</span>
          </button>
          {/* Thu 21 */}
          <button className="flex flex-col items-center gap-1 min-w-[56px] py-3 rounded-xl transition-all hover:bg-slate-100 active:scale-[0.97] text-textmuted">
            <span className="text-xs font-semibold">THU</span>
            <span className="text-xl font-semibold">21</span>
          </button>
          {/* Fri 22 */}
          <button className="flex flex-col items-center gap-1 min-w-[56px] py-3 rounded-xl transition-all hover:bg-slate-100 active:scale-[0.97] text-textmuted">
            <span className="text-xs font-semibold">FRI</span>
            <span className="text-xl font-semibold">22</span>
          </button>
          {/* Sat 23 */}
          <button className="flex flex-col items-center gap-1 min-w-[56px] py-3 rounded-xl transition-all hover:bg-slate-100 active:scale-[0.97] text-textmuted">
            <span className="text-xs font-semibold">SAT</span>
            <span className="text-xl font-semibold">23</span>
          </button>
        </div>
      </section>

      {/* Timeline View */}
      <section className="flex-1 overflow-y-auto px-6 py-8 space-y-4 relative bg-slate-50">
        
        {/* 09:00 - Completed */}
        <div className="flex gap-6 group">
          <div className="w-16 pt-1">
            <span className="text-xs text-textmuted font-bold">09:00</span>
          </div>
          <div className="flex-1 relative">
            <div className="absolute -left-6 top-2 w-[1px] h-[calc(100%+16px)] bg-slate-200 group-last:h-0"></div>
            <div className="absolute -left-[29px] top-2 w-3 h-3 rounded-full bg-slate-300 border-2 border-white shadow-sm z-10"></div>
            
            <div className="bg-surface border border-border p-4 rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150 cursor-pointer flex justify-between items-center group-hover:border-primary">
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-full bg-blue-100 text-primary flex items-center justify-center font-bold text-base">AH</div>
                <div>
                  <h4 className="font-bold text-textprimary">Ahmed Hassan</h4>
                  <p className="text-sm text-textmuted">Post-Op Consultation</p>
                </div>
              </div>
              <div className="flex flex-col items-end gap-1">
                <span className="px-3 py-1 bg-green-100 text-success text-xs font-bold rounded-full uppercase">Completed</span>
                <span className="text-xs text-textmuted font-semibold">30 mins</span>
              </div>
            </div>
          </div>
        </div>

        {/* 10:00 - In Progress */}
        <div className="flex gap-6 group">
          <div className="w-16 pt-1">
            <span className="text-xs text-textmuted font-bold">10:00</span>
          </div>
          <div className="flex-1 relative">
            <div className="absolute -left-6 top-2 w-[1px] h-[calc(100%+16px)] bg-slate-200 group-last:h-0"></div>
            <div className="absolute -left-[29px] top-2 w-3 h-3 rounded-full bg-primary ring-4 ring-blue-100 z-10"></div>
            
            <div className="bg-surface border-l-4 border-primary border-y border-r border-border p-4 rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150 cursor-pointer flex justify-between items-center">
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-bold text-base">ZM</div>
                <div>
                  <h4 className="font-bold text-textprimary">Zainab Malik</h4>
                  <p className="text-sm text-textmuted">General Checkup</p>
                </div>
              </div>
              <div className="flex flex-col items-end gap-1">
                <span className="px-3 py-1 bg-blue-100 text-primary text-xs font-bold rounded-full uppercase">In Progress</span>
                <span className="text-xs text-primary font-bold">Live Now</span>
              </div>
            </div>
          </div>
        </div>

        {/* 11:00 - Empty Slot */}
        <div className="flex gap-6 group">
          <div className="w-16 pt-1">
            <span className="text-xs text-textmuted font-bold">11:00</span>
          </div>
          <div className="flex-1 relative">
            <div className="absolute -left-6 top-2 w-[1px] h-[calc(100%+16px)] bg-slate-200 group-last:h-0"></div>
            <div className="absolute -left-[29px] top-2 w-3 h-3 rounded-full bg-slate-300 border-2 border-white z-10"></div>
            
            <div className="border-2 border-dashed border-border p-4 rounded-xl flex items-center justify-center gap-2 text-textmuted opacity-60 hover:opacity-100 transition-opacity cursor-pointer bg-slate-50">
              <span className="material-symbols-outlined">add_circle</span>
              <span className="text-xs font-bold uppercase tracking-wider">Available Slot</span>
            </div>
          </div>
        </div>

        {/* 12:00 - Pending */}
        <div className="flex gap-6 group">
          <div className="w-16 pt-1">
            <span className="text-xs text-textmuted font-bold">12:00</span>
          </div>
          <div className="flex-1 relative">
            <div className="absolute -left-6 top-2 w-[1px] h-[calc(100%+16px)] bg-slate-200 group-last:h-0"></div>
            <div className="absolute -left-[29px] top-2 w-3 h-3 rounded-full bg-slate-300 border-2 border-white z-10"></div>
            
            <div className="bg-surface border border-border p-4 rounded-xl shadow-sm hover:scale-[1.02] transition-transform duration-150 cursor-pointer flex justify-between items-center group-hover:border-primary">
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-full bg-slate-200 text-slate-700 flex items-center justify-center font-bold text-base">RK</div>
                <div>
                  <h4 className="font-bold text-textprimary">Rizwan Khan</h4>
                  <p className="text-sm text-textmuted">Follow-up: Lab Results</p>
                </div>
              </div>
              <div className="flex flex-col items-end gap-1">
                <span className="px-3 py-1 bg-amber-100 text-warning text-xs font-bold rounded-full uppercase">Pending</span>
                <span className="text-xs text-textmuted font-semibold">15 mins</span>
              </div>
            </div>
          </div>
        </div>

        {/* 13:00 - Break/Empty */}
        <div className="flex gap-6 group">
          <div className="w-16 pt-1">
            <span className="text-xs text-textmuted font-bold">13:00</span>
          </div>
          <div className="flex-1 relative">
            <div className="absolute -left-6 top-2 w-[1px] h-[calc(100%+16px)] bg-slate-200 group-last:h-0"></div>
            <div className="absolute -left-[29px] top-2 w-3 h-3 rounded-full bg-slate-300 border-2 border-white z-10"></div>
            
            <div className="flex items-center gap-2 text-textmuted opacity-40 px-4 py-4">
              <div className="h-[1px] flex-1 bg-slate-300"></div>
              <span className="text-xs font-bold uppercase tracking-widest">Lunch Break</span>
              <div className="h-[1px] flex-1 bg-slate-300"></div>
            </div>
          </div>
        </div>

        {/* 14:00 - Empty Slot */}
        <div className="flex gap-6 group">
          <div className="w-16 pt-1">
            <span className="text-xs text-textmuted font-bold">14:00</span>
          </div>
          <div className="flex-1 relative">
            <div className="absolute -left-6 top-2 w-[1px] h-0 bg-slate-200 group-last:h-0"></div>
            <div className="absolute -left-[29px] top-2 w-3 h-3 rounded-full bg-slate-300 border-2 border-white z-10"></div>
            
            <div className="border-2 border-dashed border-border p-4 rounded-xl flex items-center justify-center gap-2 text-textmuted opacity-60 hover:opacity-100 transition-opacity cursor-pointer bg-slate-50">
              <span className="material-symbols-outlined">add_circle</span>
              <span className="text-xs font-bold uppercase tracking-wider">Available Slot</span>
            </div>
          </div>
        </div>

      </section>

      {/* Floating Action Button */}
      <button className="fixed bottom-8 right-8 w-14 h-14 bg-primary text-white rounded-2xl shadow-lg flex items-center justify-center hover:scale-[1.02] hover:shadow-xl transition-all active:scale-[0.97] z-50">
        <span className="material-symbols-outlined text-3xl">add</span>
      </button>

    </div>
  );
}
