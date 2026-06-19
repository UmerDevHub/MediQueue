'use client';

export default function AdminEmergenciesPage() {
  return (
    <div className="space-y-6 min-h-[calc(100vh-8rem)] flex flex-col">
      {/* Header Section */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-4">
        <div>
          <h1 className="text-2xl font-semibold text-textprimary mb-1">System-Wide Emergencies</h1>
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-error animate-pulse"></span>
            <span className="text-[11px] font-bold text-error uppercase tracking-wider">Live Tracker Active</span>
          </div>
        </div>
        <div className="flex gap-4 items-center">
          <div className="flex items-center gap-2 bg-white px-4 py-2 rounded-full border border-border shadow-sm">
            <span className="material-symbols-outlined text-textmuted text-[20px]">search</span>
            <input 
              className="bg-transparent border-none text-sm focus:ring-0 w-48 outline-none text-textprimary" 
              placeholder="Search incidents..." 
              type="text" 
            />
          </div>
        </div>
      </div>

      {/* Grid Layout matching Bento Design */}
      <div className="flex-1 grid grid-cols-1 lg:grid-cols-12 gap-6 pb-6">
        {/* Left Column: Live Feed */}
        <div className="lg:col-span-4 flex flex-col gap-4">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-bold uppercase tracking-wider text-textmuted">Active Incidents (4)</h3>
            <button className="text-primary text-xs font-bold hover:underline">VIEW ALL</button>
          </div>
          
          <div className="flex-1 space-y-4 overflow-y-auto pr-1">
            {/* High Urgency Card */}
            <div className="bg-white border-l-4 border-error p-4 rounded-xl shadow-sm border-y border-r border-border hover:scale-[1.02] active:scale-[0.97] transition-all cursor-pointer">
              <div className="flex justify-between items-start mb-2">
                <div>
                  <h4 className="font-bold text-base text-textprimary">Cardiac Arrest - Sector G-8</h4>
                  <p className="text-xs text-textmuted mt-0.5">Dispatch ID: #EM-4921</p>
                </div>
                <span className="bg-red-50 text-error text-[10px] font-bold px-2 py-0.5 rounded border border-red-100 flex items-center gap-1 uppercase tracking-wide">
                  <span className="material-symbols-outlined text-[12px]">priority_high</span> Critical
                </span>
              </div>
              <div className="grid grid-cols-2 gap-4 mt-4">
                <div>
                  <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">ETA</p>
                  <p className="text-xl font-bold text-primary mt-0.5">03:45 MIN</p>
                </div>
                <div>
                  <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Ambulance</p>
                  <p className="text-sm font-bold text-textprimary mt-1">Unit 14-B (ALS)</p>
                </div>
              </div>
              <div className="mt-4 pt-3 border-t border-border flex items-center justify-between">
                <span className="text-xs text-textmuted italic">Assigned to Jinnah Hospital</span>
                <span className="material-symbols-outlined text-primary text-[18px]">chevron_right</span>
              </div>
            </div>

            {/* Medium Urgency Card */}
            <div className="bg-white border-l-4 border-warning p-4 rounded-xl shadow-sm border-y border-r border-border hover:scale-[1.02] active:scale-[0.97] transition-all cursor-pointer">
              <div className="flex justify-between items-start mb-2">
                <div>
                  <h4 className="font-bold text-base text-textprimary">RTA - Highway Junction</h4>
                  <p className="text-xs text-textmuted mt-0.5">Dispatch ID: #EM-4922</p>
                </div>
                <span className="bg-amber-50 text-amber-700 text-[10px] font-bold px-2 py-0.5 rounded border border-amber-100 uppercase tracking-wide">
                  En Route
                </span>
              </div>
              <div className="grid grid-cols-2 gap-4 mt-4">
                <div>
                  <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">ETA</p>
                  <p className="text-xl font-bold text-primary mt-0.5">12:10 MIN</p>
                </div>
                <div>
                  <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Ambulance</p>
                  <p className="text-sm font-bold text-textprimary mt-1">Unit 08-A (BLS)</p>
                </div>
              </div>
              <div className="mt-4 pt-3 border-t border-border flex items-center justify-between">
                <span className="text-xs text-textmuted italic">Routing to Indus Health</span>
                <span className="material-symbols-outlined text-primary text-[18px]">chevron_right</span>
              </div>
            </div>
            
            {/* Medium Urgency Card 2 */}
            <div className="bg-white border-l-4 border-warning p-4 rounded-xl shadow-sm border-y border-r border-border hover:scale-[1.02] active:scale-[0.97] transition-all cursor-pointer">
              <div className="flex justify-between items-start mb-2">
                <div>
                  <h4 className="font-bold text-base text-textprimary">Fall Injury - Blue Area</h4>
                  <p className="text-xs text-textmuted mt-0.5">Dispatch ID: #EM-4923</p>
                </div>
                <span className="bg-amber-50 text-amber-700 text-[10px] font-bold px-2 py-0.5 rounded border border-amber-100 uppercase tracking-wide">
                  Dispatched
                </span>
              </div>
              <div className="grid grid-cols-2 gap-4 mt-4">
                <div>
                  <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">ETA</p>
                  <p className="text-xl font-bold text-primary mt-0.5">18:00 MIN</p>
                </div>
                <div>
                  <p className="text-[10px] text-textmuted uppercase font-bold tracking-wider">Ambulance</p>
                  <p className="text-sm font-bold text-textprimary mt-1">Unit 22-C (BLS)</p>
                </div>
              </div>
              <div className="mt-4 pt-3 border-t border-border flex items-center justify-between">
                <span className="text-xs text-error font-medium">Pending Hospital Assignment</span>
                <span className="material-symbols-outlined text-error animate-pulse text-[18px]">warning</span>
              </div>
            </div>
          </div>
        </div>

        {/* Right Area: Map & Stats */}
        <div className="lg:col-span-8 flex flex-col gap-6">
          {/* Map Area */}
          <div className="flex-1 bg-white rounded-xl border border-border shadow-sm overflow-hidden flex flex-col relative min-h-[400px]">
             {/* Map Controls overlay */}
             <div className="absolute top-4 right-4 z-10 flex flex-col gap-2">
               <button className="w-10 h-10 bg-white rounded-lg shadow-md flex items-center justify-center border border-border text-textprimary hover:bg-slate-50 transition-colors">
                 <span className="material-symbols-outlined">add</span>
               </button>
               <button className="w-10 h-10 bg-white rounded-lg shadow-md flex items-center justify-center border border-border text-textprimary hover:bg-slate-50 transition-colors">
                 <span className="material-symbols-outlined">remove</span>
               </button>
               <button className="w-10 h-10 bg-white rounded-lg shadow-md flex items-center justify-center border border-border text-primary hover:bg-slate-50 transition-colors mt-2">
                 <span className="material-symbols-outlined">my_location</span>
               </button>
             </div>
             
             {/* Legend overlay */}
             <div className="absolute bottom-4 left-4 z-10 bg-white/90 backdrop-blur-sm p-3 rounded-lg shadow-md border border-border">
               <p className="text-[10px] font-bold text-textmuted uppercase tracking-wider mb-2">Map Legend</p>
               <div className="flex flex-col gap-2">
                 <div className="flex items-center gap-2">
                   <span className="w-3 h-3 rounded-full bg-error animate-pulse"></span>
                   <span className="text-xs font-medium text-textprimary">Critical Incident</span>
                 </div>
                 <div className="flex items-center gap-2">
                   <span className="w-3 h-3 rounded-full bg-warning"></span>
                   <span className="text-xs font-medium text-textprimary">Ambulance En Route</span>
                 </div>
                 <div className="flex items-center gap-2">
                   <span className="material-symbols-outlined text-[16px] text-primary">local_hospital</span>
                   <span className="text-xs font-medium text-textprimary">Network Hospital</span>
                 </div>
               </div>
             </div>
             
             {/* Map Placeholder */}
             <div className="w-full h-full bg-slate-100 flex items-center justify-center">
                <div className="text-center">
                  <span className="material-symbols-outlined text-4xl text-textmuted mb-2 opacity-50">map</span>
                  <p className="text-sm font-medium text-textmuted">Interactive Map Visualization Area</p>
                </div>
             </div>
          </div>

          {/* Quick Stats Footer */}
          <div className="grid grid-cols-3 gap-4 shrink-0">
            <div className="bg-white border border-border rounded-xl p-4 shadow-sm">
              <div className="flex items-center gap-3 mb-2">
                <div className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center text-primary">
                  <span className="material-symbols-outlined text-[18px]">airport_shuttle</span>
                </div>
                <p className="text-[11px] font-bold uppercase tracking-wider text-textmuted">Active Units</p>
              </div>
              <p className="text-2xl font-bold text-textprimary">24 <span className="text-xs text-textmuted font-medium normal-case tracking-normal">/ 45 Fleet</span></p>
            </div>
            
            <div className="bg-white border border-border rounded-xl p-4 shadow-sm">
              <div className="flex items-center gap-3 mb-2">
                <div className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center text-primary">
                  <span className="material-symbols-outlined text-[18px]">timer</span>
                </div>
                <p className="text-[11px] font-bold uppercase tracking-wider text-textmuted">Avg Response</p>
              </div>
              <p className="text-2xl font-bold text-textprimary">8.2 <span className="text-xs text-textmuted font-medium normal-case tracking-normal">Minutes</span></p>
            </div>
            
            <div className="bg-white border border-border rounded-xl p-4 shadow-sm">
              <div className="flex items-center gap-3 mb-2">
                <div className="w-8 h-8 rounded-full bg-red-50 flex items-center justify-center text-error">
                  <span className="material-symbols-outlined text-[18px]">warning</span>
                </div>
                <p className="text-[11px] font-bold uppercase tracking-wider text-textmuted">Critical Load</p>
              </div>
              <p className="text-2xl font-bold text-error">12 <span className="text-xs text-textmuted font-medium normal-case tracking-normal">Cases Today</span></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
