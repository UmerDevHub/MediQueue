'use client';

export default function AnalyticsPage() {
  return (
    <div className="space-y-6">
      {/* Header Section */}
      <section className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h1 className="text-3xl font-semibold text-textprimary mb-1">Platform Analytics</h1>
          <p className="text-base text-textmuted">Deep dive into clinical performance and operational metrics.</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <div className="flex items-center bg-surface border border-border rounded-lg px-4 py-2 shadow-sm">
            <span className="material-symbols-outlined text-textmuted mr-2">calendar_month</span>
            <input className="bg-transparent border-none text-sm font-medium focus:ring-0 w-48 outline-none text-textprimary" type="text" defaultValue="Oct 01, 2023 - Oct 31, 2023" />
          </div>
          <button className="bg-primary text-white px-6 py-2 rounded-lg text-sm font-semibold uppercase flex items-center gap-2 hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
            <span className="material-symbols-outlined text-[18px]">download</span>
            Export PDF
          </button>
          <button className="bg-surface border border-border text-primary px-6 py-2 rounded-lg text-sm font-semibold uppercase flex items-center gap-2 hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
            <span className="material-symbols-outlined text-[18px]">csv</span>
            Export CSV
          </button>
        </div>
      </section>

      {/* Bento Grid Analytics */}
      <section className="grid grid-cols-1 md:grid-cols-12 gap-6">
        {/* User Growth Chart */}
        <div className="md:col-span-8 bg-surface border border-border rounded-xl p-6 shadow-sm flex flex-col">
          <div className="flex justify-between items-center mb-6">
            <div className="flex flex-col">
              <span className="text-xs font-semibold uppercase text-textmuted mb-1">User Inflow Trend</span>
              <span className="text-xl font-semibold text-textprimary">+12.4% vs last month</span>
            </div>
            <div className="flex gap-1">
              <button className="px-2 py-1 rounded bg-blue-50 text-primary text-xs font-bold">Daily</button>
              <button className="px-2 py-1 rounded text-textmuted text-xs font-medium hover:bg-slate-50 transition-colors">Weekly</button>
            </div>
          </div>
          <div className="h-64 flex items-end justify-between gap-2 mt-auto">
            {/* Mock Chart Bars */}
            <div className="flex-1 bg-primary/10 rounded-t h-[40%] relative group cursor-pointer hover:bg-primary/20 transition-colors">
               <div className="absolute -top-8 left-1/2 -translate-x-1/2 bg-slate-800 text-white text-[10px] py-1 px-2 rounded opacity-0 group-hover:opacity-100 transition-opacity">124</div>
            </div>
            <div className="flex-1 bg-primary/15 rounded-t h-[55%] relative group cursor-pointer hover:bg-primary/25 transition-colors">
               <div className="absolute -top-8 left-1/2 -translate-x-1/2 bg-slate-800 text-white text-[10px] py-1 px-2 rounded opacity-0 group-hover:opacity-100 transition-opacity">145</div>
            </div>
            <div className="flex-1 bg-primary/20 rounded-t h-[45%] relative group cursor-pointer hover:bg-primary/30 transition-colors"></div>
            <div className="flex-1 bg-primary/30 rounded-t h-[70%] relative group cursor-pointer hover:bg-primary/40 transition-colors"></div>
            <div className="flex-1 bg-primary/25 rounded-t h-[60%] relative group cursor-pointer hover:bg-primary/35 transition-colors"></div>
            <div className="flex-1 bg-primary/40 rounded-t h-[85%] relative group cursor-pointer hover:bg-primary/50 transition-colors"></div>
            <div className="flex-1 bg-primary/50 rounded-t h-[95%] relative group cursor-pointer hover:bg-primary/60 transition-colors"></div>
            <div className="flex-1 bg-primary/35 rounded-t h-[50%] relative group cursor-pointer hover:bg-primary/45 transition-colors"></div>
            <div className="flex-1 bg-primary/45 rounded-t h-[65%] relative group cursor-pointer hover:bg-primary/55 transition-colors"></div>
            <div className="flex-1 bg-primary rounded-t h-[100%] relative group cursor-pointer hover:bg-blue-700 transition-colors">
               <div className="absolute -top-8 left-1/2 -translate-x-1/2 bg-slate-800 text-white text-[10px] py-1 px-2 rounded opacity-0 group-hover:opacity-100 transition-opacity">288</div>
            </div>
          </div>
          <div className="flex justify-between mt-2 text-[11px] font-semibold text-textmuted px-1">
            <span>Oct 01</span><span>Oct 10</span><span>Oct 20</span><span>Oct 31</span>
          </div>
        </div>

        {/* Emergency Response Score */}
        <div className="md:col-span-4 bg-indigo-50 border border-indigo-200 rounded-xl p-6 flex flex-col justify-between shadow-sm overflow-hidden relative">
          <div className="absolute -right-4 -top-4 text-primary/10 select-none">
            <span className="material-symbols-outlined text-[120px]" style={{ fontVariationSettings: "'FILL' 1" }}>emergency</span>
          </div>
          <div className="z-10">
            <span className="text-xs font-semibold uppercase text-primary mb-1 block">Response Efficiency</span>
            <h3 className="text-5xl font-bold text-primary leading-tight mt-2">4.2<span className="text-xl font-medium">/min</span></h3>
            <p className="text-sm font-medium text-primary mt-2">Average triage-to-treatment time.</p>
          </div>
          <div className="mt-8 z-10">
            <div className="flex justify-between text-xs mb-1 text-primary font-bold">
              <span>Target Efficiency</span>
              <span>94%</span>
            </div>
            <div className="w-full bg-white rounded-full h-2">
              <div className="bg-primary h-2 rounded-full" style={{ width: '94%' }}></div>
            </div>
          </div>
        </div>

        {/* Doctor Productivity Table */}
        <div className="md:col-span-7 bg-surface border border-border rounded-xl shadow-sm overflow-hidden">
          <div className="p-6 border-b border-border flex justify-between items-center">
            <h3 className="text-xl font-semibold text-textprimary">Doctor Productivity</h3>
            <button className="text-primary text-xs font-bold hover:underline uppercase tracking-wide">View All</button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left min-w-[500px]">
              <thead className="bg-slate-50">
                <tr className="text-xs font-semibold text-textmuted uppercase">
                  <th className="px-6 py-4">Practitioner</th>
                  <th className="px-6 py-4">Users</th>
                  <th className="px-6 py-4">Avg Time</th>
                  <th className="px-6 py-4">Satisfaction</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-primary font-bold text-xs">AA</div>
                      <div>
                        <p className="text-sm font-semibold text-textprimary">Dr. Ali Ahmed</p>
                        <p className="text-[11px] text-textmuted">Cardiology</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-sm font-medium">342</td>
                  <td className="px-6 py-4 text-sm">18m</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-1">
                      <span className="material-symbols-outlined text-[14px] text-amber-500" style={{ fontVariationSettings: "'FILL' 1" }}>star</span>
                      <span className="text-sm font-bold">4.9</span>
                    </div>
                  </td>
                </tr>
                <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-xs">ZS</div>
                      <div>
                        <p className="text-sm font-semibold text-textprimary">Dr. Zainab Shah</p>
                        <p className="text-[11px] text-textmuted">Pediatrics</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-sm font-medium">289</td>
                  <td className="px-6 py-4 text-sm">14m</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-1">
                      <span className="material-symbols-outlined text-[14px] text-amber-500" style={{ fontVariationSettings: "'FILL' 1" }}>star</span>
                      <span className="text-sm font-bold">4.7</span>
                    </div>
                  </td>
                </tr>
                <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-slate-200 flex items-center justify-center text-slate-700 font-bold text-xs">MK</div>
                      <div>
                        <p className="text-sm font-semibold text-textprimary">Dr. Mustafa Khan</p>
                        <p className="text-[11px] text-textmuted">Neurology</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-sm font-medium">215</td>
                  <td className="px-6 py-4 text-sm">24m</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-1">
                      <span className="material-symbols-outlined text-[14px] text-amber-500" style={{ fontVariationSettings: "'FILL' 1" }}>star</span>
                      <span className="text-sm font-bold">4.8</span>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        {/* Departmental Distribution (Circular Mock-up) */}
        <div className="md:col-span-5 bg-surface border border-border rounded-xl p-6 shadow-sm flex flex-col">
          <h3 className="text-xl font-semibold text-textprimary mb-6">Caseload Distribution</h3>
          <div className="flex-1 flex flex-col items-center justify-center relative my-4">
            {/* Simple CSS Donut Chart */}
            <div className="w-48 h-48 rounded-full border-[16px] border-primary relative flex items-center justify-center">
              <div className="absolute inset-0 rounded-full border-[16px] border-blue-200" style={{ clipPath: 'polygon(50% 50%, 50% 0%, 100% 0%, 100% 100%, 0% 100%, 0% 50%)', left: '-16px', top: '-16px', right: '-16px', bottom: '-16px' }}></div>
              <div className="text-center z-10">
                <span className="text-3xl font-bold text-textprimary">1,248</span>
                <p className="text-xs text-textmuted uppercase font-semibold mt-1">Total Visits</p>
              </div>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-4 mt-6">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-primary"></div>
              <span className="text-sm">Outpatient (64%)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-blue-200"></div>
              <span className="text-sm">Emergency (28%)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-indigo-200"></div>
              <span className="text-sm">Diagnostics (5%)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-slate-300"></div>
              <span className="text-sm">Other (3%)</span>
            </div>
          </div>
        </div>
      </section>

      {/* Insights Summary (Cards) */}
      <section className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm hover:scale-[1.02] transition-transform">
          <div className="w-10 h-10 rounded-lg bg-green-50 flex items-center justify-center text-success mb-4">
            <span className="material-symbols-outlined">trending_up</span>
          </div>
          <h4 className="font-bold text-base text-textprimary mb-2">Retention High</h4>
          <p className="text-sm text-textmuted">User revisit rate increased by 8% this month due to new automated follow-up reminders.</p>
        </div>
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm hover:scale-[1.02] transition-transform">
          <div className="w-10 h-10 rounded-lg bg-blue-50 flex items-center justify-center text-primary mb-4">
            <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>bolt</span>
          </div>
          <h4 className="font-bold text-base text-textprimary mb-2">Queue Velocity</h4>
          <p className="text-sm text-textmuted">Peak morning queue wait time reduced by 4.5 minutes through improved triage workflows.</p>
        </div>
        <div className="bg-surface border border-border p-6 rounded-xl shadow-sm hover:scale-[1.02] transition-transform">
          <div className="w-10 h-10 rounded-lg bg-amber-50 flex items-center justify-center text-warning mb-4">
            <span className="material-symbols-outlined">feedback</span>
          </div>
          <h4 className="font-bold text-base text-textprimary mb-2">Staff Satisfaction</h4>
          <p className="text-sm text-textmuted">Internal surveys show a 92% approval rating for the new digital reporting module.</p>
        </div>
      </section>

    </div>
  );
}
