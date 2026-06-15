'use client';

import StatusBadge from '@/components/shared/StatusBadge';

export default function AppointmentsPage() {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
      {/* Left Column: Weekly Calendar Density */}
      <div className="lg:col-span-8 space-y-6">
        {/* Header Actions */}
        <div className="flex flex-wrap items-center justify-between bg-surface p-4 rounded-xl shadow-sm border border-border">
          <div className="flex flex-wrap items-center gap-4">
            <div className="flex bg-slate-100 rounded-lg p-1">
              <button className="px-4 py-1.5 bg-white text-primary text-sm font-semibold rounded-md shadow-sm">Weekly</button>
              <button className="px-4 py-1.5 text-textmuted text-sm font-semibold hover:text-primary transition-colors">Monthly</button>
            </div>
            <div className="flex items-center gap-1">
              <button className="p-1 hover:bg-slate-100 rounded transition-colors">
                <span className="material-symbols-outlined text-xl">chevron_left</span>
              </button>
              <span className="text-lg font-semibold px-4 text-textprimary">Oct 14 - Oct 20, 2024</span>
              <button className="p-1 hover:bg-slate-100 rounded transition-colors">
                <span className="material-symbols-outlined text-xl">chevron_right</span>
              </button>
            </div>
          </div>
          <button className="flex items-center gap-2 bg-primary text-white px-6 py-2 rounded-lg text-sm font-semibold hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
            <span className="material-symbols-outlined text-lg">add</span>
            New Appointment
          </button>
        </div>

        {/* Calendar Bento Grid */}
        <div className="grid grid-cols-7 gap-2 overflow-x-auto min-w-[700px]">
          {/* Days Header */}
          {['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day, i) => (
            <div key={day} className={`text-center py-2 text-xs font-bold uppercase ${i === 3 ? 'text-primary border-b-2 border-primary' : 'text-textmuted'}`}>
              {day}
            </div>
          ))}

          {/* Monday */}
          <div className="bg-surface border border-border rounded-xl p-2 min-h-[400px] flex flex-col gap-2">
            <span className="text-xs font-bold text-textmuted">14</span>
            <div className="bg-blue-50 p-1.5 rounded border-l-4 border-primary">
              <p className="text-[11px] font-semibold text-primary">Cardiology (12)</p>
            </div>
            <div className="bg-slate-100 p-1.5 rounded border-l-4 border-textmuted">
              <p className="text-[11px] font-semibold text-textmuted">GP (8)</p>
            </div>
          </div>

          {/* Tuesday */}
          <div className="bg-surface border border-border rounded-xl p-2 min-h-[400px] flex flex-col gap-2">
            <span className="text-xs font-bold text-textmuted">15</span>
            <div className="bg-red-50 p-1.5 rounded border-l-4 border-danger">
              <p className="text-[11px] font-semibold text-danger">Surgery (4)</p>
            </div>
            <div className="bg-blue-50 p-1.5 rounded border-l-4 border-primary">
              <p className="text-[11px] font-semibold text-primary">Cardiology (15)</p>
            </div>
          </div>

          {/* Wednesday */}
          <div className="bg-surface border border-border rounded-xl p-2 min-h-[400px] flex flex-col gap-2">
            <span className="text-xs font-bold text-textmuted">16</span>
            <div className="bg-orange-50 p-1.5 rounded border-l-4 border-warning">
              <p className="text-[11px] font-semibold text-warning">Radiology (6)</p>
            </div>
          </div>

          {/* Thursday (Today) */}
          <div className="bg-blue-50/50 border border-primary rounded-xl p-2 min-h-[400px] flex flex-col gap-2 relative">
            <span className="text-xs font-bold text-primary">17</span>
            <div className="bg-white p-2 rounded-lg shadow-sm border border-border hover:scale-[1.02] transition-transform cursor-pointer">
              <p className="text-[10px] font-bold text-primary uppercase mb-1">09:00 AM</p>
              <p className="text-xs font-semibold text-textprimary">Zubair Ahmed</p>
              <p className="text-[11px] text-textmuted mt-0.5">Pediatrics</p>
            </div>
            <div className="bg-white p-2 rounded-lg shadow-sm border border-border hover:scale-[1.02] transition-transform cursor-pointer">
              <p className="text-[10px] font-bold text-primary uppercase mb-1">11:30 AM</p>
              <p className="text-xs font-semibold text-textprimary">Sana Malik</p>
              <p className="text-[11px] text-textmuted mt-0.5">Cardiology</p>
            </div>
            <div className="absolute bottom-4 left-0 right-0 text-center">
              <button className="text-xs text-primary font-bold hover:underline">+ 14 More</button>
            </div>
          </div>

          {/* Friday */}
          <div className="bg-surface border border-border rounded-xl p-2 min-h-[400px] flex flex-col gap-2">
            <span className="text-xs font-bold text-textmuted">18</span>
            <div className="bg-blue-50 p-1.5 rounded border-l-4 border-primary">
              <p className="text-[11px] font-semibold text-primary">Cardiology (20)</p>
            </div>
          </div>

          {/* Saturday */}
          <div className="bg-slate-50 border border-border rounded-xl p-2 min-h-[400px]">
            <span className="text-xs font-bold text-textmuted">19</span>
          </div>

          {/* Sunday */}
          <div className="bg-slate-50 border border-border rounded-xl p-2 min-h-[400px]">
            <span className="text-xs font-bold text-textmuted">20</span>
          </div>
        </div>
      </div>

      {/* Right Column: Today's Schedule & Pending */}
      <div className="lg:col-span-4 space-y-6">
        {/* Today's Schedule Card */}
        <div className="bg-surface rounded-xl shadow-sm border border-border overflow-hidden">
          <div className="p-6 border-b border-border flex items-center justify-between">
            <h3 className="text-xl font-semibold text-textprimary">Today's Schedule</h3>
            <span className="bg-primary text-white px-2 py-0.5 rounded-full text-xs font-bold">18</span>
          </div>
          <div className="p-4 space-y-3 max-h-[400px] overflow-y-auto">
            <div className="group flex items-center gap-4 p-3 border border-border rounded-lg hover:border-primary transition-colors cursor-pointer">
              <div className="w-1 h-8 bg-primary rounded-full"></div>
              <div className="flex-1">
                <p className="text-sm font-semibold text-textprimary">M. Rizwan</p>
                <p className="text-xs text-textmuted mt-0.5">General Checkup • 10:15 AM</p>
              </div>
              <StatusBadge status="booked" />
            </div>
            
            <div className="group flex items-center gap-4 p-3 border border-border rounded-lg hover:border-primary transition-colors cursor-pointer">
              <div className="w-1 h-8 bg-success rounded-full"></div>
              <div className="flex-1">
                <p className="text-sm font-semibold text-textprimary">Ayesha Pervez</p>
                <p className="text-xs text-textmuted mt-0.5">Dermatology • 10:45 AM</p>
              </div>
              <StatusBadge status="arrived" />
            </div>

            <div className="group flex items-center gap-4 p-3 border border-border rounded-lg hover:border-primary transition-colors cursor-pointer">
              <div className="w-1 h-8 bg-danger rounded-full"></div>
              <div className="flex-1">
                <p className="text-sm font-semibold text-textprimary">Ali Hassan</p>
                <p className="text-xs text-textmuted mt-0.5">Emergency Ward • 11:00 AM</p>
              </div>
              <StatusBadge status="incoming" />
            </div>
          </div>
          <div className="p-4 bg-slate-50 text-center border-t border-border">
            <button className="text-primary text-sm font-semibold hover:underline">View Full Timeline</button>
          </div>
        </div>

        {/* Pending Confirmations Card */}
        <div className="bg-surface rounded-xl shadow-sm border border-border overflow-hidden">
          <div className="p-6 border-b border-border bg-slate-50/50">
            <h3 className="text-xl font-semibold flex items-center gap-2 text-textprimary">
              Pending Confirmations
              <span className="material-symbols-outlined text-textmuted text-lg">pending_actions</span>
            </h3>
          </div>
          <div className="p-4 space-y-4">
            <div className="p-4 bg-white border border-border rounded-xl space-y-4 shadow-sm">
              <div className="flex justify-between items-start">
                <div>
                  <p className="text-sm font-semibold text-textprimary">Omar Farooq</p>
                  <p className="text-xs text-textmuted mt-0.5">Requested for: Tomorrow, 10:00 AM</p>
                  <p className="text-xs font-bold text-primary mt-1">Dr. Salman (Neurology)</p>
                </div>
                <span className="text-xs font-medium text-textmuted">2m ago</span>
              </div>
              <div className="flex gap-2">
                <button className="flex-1 py-1.5 bg-primary text-white rounded-lg text-sm font-medium hover:opacity-90 transition-opacity">Confirm</button>
                <button className="flex-1 py-1.5 bg-slate-100 text-textmuted rounded-lg text-sm font-medium hover:bg-red-50 hover:text-danger transition-colors">Reschedule</button>
              </div>
            </div>

            <div className="p-4 bg-white border border-border rounded-xl space-y-4 shadow-sm">
              <div className="flex justify-between items-start">
                <div>
                  <p className="text-sm font-semibold text-textprimary">Zoya Malik</p>
                  <p className="text-xs text-textmuted mt-0.5">Requested for: Oct 19, 04:30 PM</p>
                  <p className="text-xs font-bold text-primary mt-1">Dr. Nadia (Gynecology)</p>
                </div>
                <span className="text-xs font-medium text-textmuted">15m ago</span>
              </div>
              <div className="flex gap-2">
                <button className="flex-1 py-1.5 bg-primary text-white rounded-lg text-sm font-medium hover:opacity-90 transition-opacity">Confirm</button>
                <button className="flex-1 py-1.5 bg-slate-100 text-textmuted rounded-lg text-sm font-medium hover:bg-red-50 hover:text-danger transition-colors">Reschedule</button>
              </div>
            </div>
          </div>
          <div className="p-4 border-t border-border text-center">
            <button className="text-textmuted text-sm font-semibold hover:text-primary transition-colors">See All (12 requests)</button>
          </div>
        </div>

      </div>
    </div>
  );
}
