'use client';

import { useState } from 'react';

export default function DoctorAvailabilityPage() {
  const [activeDate, setActiveDate] = useState<number>(4);

  // Helper to generate days 1 to 31
  const days = Array.from({ length: 31 }, (_, i) => i + 1);

  return (
    <div className="flex flex-col h-[calc(100vh-64px)] -m-6 relative">
      <div className="flex-grow flex overflow-hidden">
        
        {/* Calendar Section */}
        <section className="flex-grow p-6 overflow-y-auto">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-4">
              <h3 className="text-2xl font-semibold text-textprimary">October 2023</h3>
              <div className="flex border border-border rounded-lg overflow-hidden">
                <button className="p-2 hover:bg-slate-50 transition-colors bg-white">
                  <span className="material-symbols-outlined text-textmuted">chevron_left</span>
                </button>
                <button className="p-2 hover:bg-slate-50 transition-colors bg-white border-l border-border">
                  <span className="material-symbols-outlined text-textmuted">chevron_right</span>
                </button>
              </div>
            </div>
            <div className="flex gap-2">
              <button className="px-4 py-2 rounded-lg bg-surface border border-border text-sm font-medium hover:scale-[1.02] transition-transform">Today</button>
              <button className="px-4 py-2 rounded-lg bg-surface border border-border text-sm font-medium flex items-center gap-1 hover:scale-[1.02] transition-transform">
                <span className="material-symbols-outlined text-[18px]">filter_list</span> Month
              </button>
            </div>
          </div>

          {/* Calendar Grid */}
          <div className="bg-surface border border-border rounded-xl overflow-hidden shadow-sm">
            <div className="grid grid-cols-7 border-b border-border bg-slate-50">
              <div className="py-2 text-center text-xs text-textmuted uppercase font-bold">Sun</div>
              <div className="py-2 text-center text-xs text-textmuted uppercase font-bold">Mon</div>
              <div className="py-2 text-center text-xs text-textmuted uppercase font-bold">Tue</div>
              <div className="py-2 text-center text-xs text-textmuted uppercase font-bold">Wed</div>
              <div className="py-2 text-center text-xs text-textmuted uppercase font-bold">Thu</div>
              <div className="py-2 text-center text-xs text-textmuted uppercase font-bold">Fri</div>
              <div className="py-2 text-center text-xs text-textmuted uppercase font-bold">Sat</div>
            </div>
            <div className="grid grid-cols-7 auto-rows-[120px]">
              {/* Previous Month Padding */}
              {Array.from({ length: 3 }).map((_, i) => (
                <div key={`prev-${i}`} className="border-r border-b border-border p-2 text-slate-400 bg-slate-50">
                  {28 + i}
                </div>
              ))}
              
              {/* Current Month Days */}
              {days.map((day) => {
                const isActive = day === activeDate;
                const hasSlots = day === 2 || day === 3 || day === 4;
                
                return (
                  <div 
                    key={day} 
                    onClick={() => setActiveDate(day)}
                    className={`border-r border-b border-border p-2 cursor-pointer transition-colors ${
                      isActive ? 'bg-blue-50 border-2 border-primary shadow-inner' : 'hover:bg-slate-50 bg-white'
                    }`}
                  >
                    <span className={`text-sm ${isActive ? 'font-bold text-primary' : 'font-medium text-textprimary'}`}>
                      {day}
                    </span>
                    {hasSlots && (
                      <div className="mt-1 space-y-1">
                        <div className="h-1 w-full bg-primary rounded-full"></div>
                        <div className={`text-[10px] font-bold ${isActive ? 'text-primary' : 'text-textprimary'}`}>
                          {day === 4 ? '6 Active Slots' : `${day === 2 ? 12 : 8} Slots`}
                        </div>
                        {isActive && <div className="text-[10px] text-textmuted">Oct 4, 2023</div>}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        </section>

        {/* Right Side Panel: Slot Management */}
        <aside className="w-[380px] border-l border-border bg-white flex flex-col p-6 overflow-y-auto">
          <div className="mb-6">
            <h4 className="text-xl font-semibold text-textprimary mb-1">October 4th Slots</h4>
            <p className="text-sm text-textmuted">Manage availability for Wednesday</p>
          </div>

          {/* Bulk Actions */}
          <div className="flex gap-2 mb-6">
            <button className="flex-grow py-2 px-4 rounded-lg bg-slate-50 border border-border text-xs text-textprimary hover:bg-slate-100 transition-all hover:scale-[1.02] flex items-center justify-center gap-1 font-bold">
              <span className="material-symbols-outlined text-[16px]">sync</span> Recurring
            </button>
            <button className="flex-grow py-2 px-4 rounded-lg bg-slate-50 border border-border text-xs text-textprimary hover:bg-slate-100 transition-all hover:scale-[1.02] flex items-center justify-center gap-1 font-bold">
              <span className="material-symbols-outlined text-[16px]">block</span> Clear All
            </button>
          </div>

          <div className="mb-4 flex items-center justify-between">
            <span className="text-xs text-textmuted uppercase font-bold tracking-wider">Time Blocks (30 min)</span>
            <label className="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" className="sr-only peer" defaultChecked />
              <div className="w-8 h-4 bg-slate-200 rounded-full peer peer-checked:bg-primary after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:after:translate-x-full"></div>
            </label>
          </div>

          {/* Grid of Blocks */}
          <div className="grid grid-cols-1 gap-2 flex-grow mb-8">
            <SlotItem time="09:00 AM - 09:30 AM" initialActive={true} />
            <SlotItem time="09:30 AM - 10:00 AM" initialActive={false} />
            
            {/* Booked - Non-toggleable */}
            <div className="flex items-center justify-between p-4 border border-border rounded-xl bg-slate-100 opacity-60">
              <div className="flex flex-col">
                <span className="text-sm font-medium text-textprimary">10:00 AM - 10:30 AM</span>
                <div className="flex items-center gap-1 mt-0.5">
                  <span className="w-2 h-2 rounded-full bg-error"></span>
                  <span className="text-[10px] text-error font-bold uppercase tracking-wider">Booked by User</span>
                </div>
              </div>
              <span className="material-symbols-outlined text-error">lock</span>
            </div>

            <SlotItem time="10:30 AM - 11:00 AM" initialActive={true} />
            <SlotItem time="11:00 AM - 11:30 AM" initialActive={false} />
            <SlotItem time="11:30 AM - 12:00 PM" initialActive={true} />
            <SlotItem time="12:00 PM - 12:30 PM" initialActive={true} />
            <SlotItem time="12:30 PM - 01:00 PM" initialActive={false} />
          </div>

          {/* Footer Action */}
          <div className="mt-auto pt-6">
            <button className="w-full py-3 bg-primary text-white rounded-xl text-sm font-bold shadow-lg hover:shadow-xl transition-all active:scale-[0.98] flex items-center justify-center gap-2">
              <span className="material-symbols-outlined">save</span>
              Save Schedule
            </button>
          </div>
        </aside>

      </div>
    </div>
  );
}

function SlotItem({ time, initialActive }: { time: string, initialActive: boolean }) {
  const [active, setActive] = useState(initialActive);
  
  return (
    <div 
      className={`flex items-center justify-between p-4 border rounded-xl transition-all cursor-pointer group hover:shadow-sm ${
        active ? 'bg-blue-50 border-primary' : 'bg-slate-50 border-border'
      }`}
      onClick={() => setActive(!active)}
    >
      <div className="flex flex-col">
        <span className="text-sm font-medium text-textprimary">{time}</span>
        <span className={`text-[10px] uppercase font-bold mt-0.5 tracking-wider ${active ? 'text-primary' : 'text-textmuted'}`}>
          {active ? 'Available' : 'Inactive'}
        </span>
      </div>
      <span className={`material-symbols-outlined ${active ? 'text-primary' : 'text-textmuted'}`}>
        {active ? 'check_circle' : 'circle'}
      </span>
    </div>
  );
}
