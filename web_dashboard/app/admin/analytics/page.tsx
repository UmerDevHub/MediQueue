'use client';

export default function AdminAnalyticsPage() {
  return (
    <div className="space-y-6">
      {/* Header Section */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-6">
        <div>
          <h1 className="text-3xl font-semibold text-textprimary mb-1">Platform Analytics</h1>
          <p className="text-sm text-textmuted">Deep dive into clinical performance and operational metrics.</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <div className="flex items-center bg-white border border-border rounded-lg px-4 py-2 shadow-sm">
            <span className="material-symbols-outlined text-textmuted mr-2 text-[18px]">calendar_month</span>
            <input 
              className="bg-transparent border-none text-sm focus:ring-0 w-48 font-medium outline-none text-textprimary" 
              type="text" 
              value="Oct 01, 2023 - Oct 31, 2023"
              readOnly
            />
          </div>
          <button className="bg-primary text-white px-4 py-2 rounded-lg font-semibold text-sm uppercase flex items-center gap-2 hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
            <span className="material-symbols-outlined text-[18px]">download</span>
            Export PDF
          </button>
          <button className="bg-white border border-border text-primary px-4 py-2 rounded-lg font-semibold text-sm uppercase flex items-center gap-2 hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
            <span className="material-symbols-outlined text-[18px]">csv</span>
            Export CSV
          </button>
        </div>
      </div>

      {/* Bento Grid Analytics */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
        
        {/* User Growth Chart (Placeholder) */}
        <div className="md:col-span-8 bg-white border border-border rounded-xl p-6 shadow-sm">
          <div className="flex justify-between items-center mb-6">
            <div className="flex flex-col">
              <h3 className="text-xl font-semibold text-textprimary">User Volume Trends</h3>
              <p className="text-xs text-textmuted font-medium mt-1 uppercase tracking-wider">Across Network Facilities</p>
            </div>
            <div className="flex gap-2 bg-slate-50 border border-border p-1 rounded-lg">
              <button className="px-3 py-1 text-xs font-semibold rounded bg-white shadow-sm text-primary">Daily</button>
              <button className="px-3 py-1 text-xs font-semibold rounded text-textmuted hover:text-textprimary">Weekly</button>
              <button className="px-3 py-1 text-xs font-semibold rounded text-textmuted hover:text-textprimary">Monthly</button>
            </div>
          </div>
          {/* Chart Canvas Area */}
          <div className="w-full h-64 bg-slate-50 border border-border border-dashed rounded-lg flex items-center justify-center">
            <div className="text-center text-textmuted">
              <span className="material-symbols-outlined text-4xl mb-2 opacity-50">monitoring</span>
              <p className="text-sm font-medium">Interactive Line Chart visualization area</p>
            </div>
          </div>
        </div>

        {/* High-Level KPIs */}
        <div className="md:col-span-4 flex flex-col gap-4">
          <div className="bg-primary text-white rounded-xl p-6 shadow-md hover:scale-[1.02] transition-transform cursor-pointer relative overflow-hidden">
             <div className="relative z-10">
               <p className="text-xs font-bold uppercase tracking-wider text-white/80 mb-2">Total Platform Users</p>
               <h2 className="text-4xl font-bold mb-1">124,592</h2>
               <div className="flex items-center gap-1 text-sm font-medium">
                 <span className="material-symbols-outlined text-[16px]">trending_up</span>
                 <span>+12.5% from last month</span>
               </div>
             </div>
             <span className="material-symbols-outlined absolute -bottom-4 -right-4 text-8xl text-white/10">group</span>
          </div>
          
          <div className="bg-white border border-border rounded-xl p-6 shadow-sm flex items-center justify-between hover:scale-[1.02] transition-transform cursor-pointer">
            <div>
              <p className="text-xs font-bold uppercase tracking-wider text-textmuted mb-1">Avg Wait Time</p>
              <p className="text-2xl font-bold text-textprimary">18.4 mins</p>
              <p className="text-xs text-success font-bold mt-1 flex items-center gap-1">
                <span className="material-symbols-outlined text-[14px]">arrow_downward</span> -2.1 mins
              </p>
            </div>
            <div className="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center text-primary">
              <span className="material-symbols-outlined text-[24px]">schedule</span>
            </div>
          </div>
          
          <div className="bg-white border border-border rounded-xl p-6 shadow-sm flex items-center justify-between hover:scale-[1.02] transition-transform cursor-pointer">
            <div>
              <p className="text-xs font-bold uppercase tracking-wider text-textmuted mb-1">Critical Cases</p>
              <p className="text-2xl font-bold text-textprimary">8,201</p>
              <p className="text-xs text-error font-bold mt-1 flex items-center gap-1">
                <span className="material-symbols-outlined text-[14px]">arrow_upward</span> +4.3%
              </p>
            </div>
            <div className="w-12 h-12 rounded-full bg-red-50 flex items-center justify-center text-error">
              <span className="material-symbols-outlined text-[24px]">emergency</span>
            </div>
          </div>
        </div>

        {/* Operational Efficiency (Bottom Left) */}
        <div className="md:col-span-6 bg-white border border-border rounded-xl p-6 shadow-sm">
           <h3 className="text-xl font-semibold text-textprimary mb-6">Resource Allocation</h3>
           <div className="space-y-6">
              <div>
                 <div className="flex justify-between text-sm mb-2">
                   <span className="font-semibold text-textprimary">ICU Bed Occupancy</span>
                   <span className="font-bold text-textprimary">82%</span>
                 </div>
                 <div className="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                   <div className="bg-warning h-full w-[82%]"></div>
                 </div>
              </div>
              <div>
                 <div className="flex justify-between text-sm mb-2">
                   <span className="font-semibold text-textprimary">Ambulance Deployment</span>
                   <span className="font-bold text-textprimary">65%</span>
                 </div>
                 <div className="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                   <div className="bg-primary h-full w-[65%]"></div>
                 </div>
              </div>
              <div>
                 <div className="flex justify-between text-sm mb-2">
                   <span className="font-semibold text-textprimary">Staff Availability (On-Duty)</span>
                   <span className="font-bold text-textprimary">94%</span>
                 </div>
                 <div className="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                   <div className="bg-success h-full w-[94%]"></div>
                 </div>
              </div>
           </div>
        </div>

        {/* Top Hospitals Performance (Bottom Right) */}
        <div className="md:col-span-6 bg-white border border-border rounded-xl p-6 shadow-sm flex flex-col">
          <div className="flex justify-between items-center mb-4">
             <h3 className="text-xl font-semibold text-textprimary">Facility Throughput</h3>
             <button className="text-primary text-xs font-bold hover:underline uppercase">View Full List</button>
          </div>
          <div className="flex-1 space-y-4">
            <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg border border-border">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center font-bold text-xs">1</div>
                <div>
                  <p className="font-bold text-sm text-textprimary">Jinnah Memorial</p>
                  <p className="text-xs text-textmuted">4,102 users processed</p>
                </div>
              </div>
              <span className="text-success text-sm font-bold flex items-center gap-1">
                <span className="material-symbols-outlined text-[16px]">trending_up</span> Top
              </span>
            </div>
            
            <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg border border-border">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-slate-200 text-textmuted flex items-center justify-center font-bold text-xs">2</div>
                <div>
                  <p className="font-bold text-sm text-textprimary">Indus Health Unit</p>
                  <p className="text-xs text-textmuted">3,890 users processed</p>
                </div>
              </div>
              <span className="text-success text-sm font-bold flex items-center gap-1">
                <span className="material-symbols-outlined text-[16px]">trending_up</span>
              </span>
            </div>

            <div className="flex items-center justify-between p-3 bg-slate-50 rounded-lg border border-border">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-full bg-slate-200 text-textmuted flex items-center justify-center font-bold text-xs">3</div>
                <div>
                  <p className="font-bold text-sm text-textprimary">Khyber Trauma Center</p>
                  <p className="text-xs text-textmuted">2,951 users processed</p>
                </div>
              </div>
              <span className="text-textmuted text-sm font-bold flex items-center gap-1">
                <span className="material-symbols-outlined text-[16px]">trending_flat</span>
              </span>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
