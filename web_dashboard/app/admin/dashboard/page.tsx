'use client';

export default function AdminDashboardPage() {
  return (
    <div className="space-y-8">
      {/* Page Header */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div className="space-y-1">
          <h2 className="text-3xl font-semibold text-textprimary">Platform Overview</h2>
          <p className="text-sm font-medium text-textmuted">Real-time cross-facility health and performance metrics.</p>
        </div>
        <div className="flex gap-2">
          <button className="flex items-center gap-2 px-4 py-2 bg-surface border border-border rounded-lg text-xs font-bold hover:bg-slate-50 transition-colors active:scale-[0.97]">
            <span className="material-symbols-outlined text-[18px]">calendar_month</span>
            LAST 24 HOURS
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg text-xs font-bold hover:opacity-90 transition-opacity active:scale-[0.97]">
            <span className="material-symbols-outlined text-[18px]">download</span>
            EXPORT REPORT
          </button>
        </div>
      </div>

      {/* KPI Bento Grid */}
      <section className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Total Hospitals */}
        <div className="bg-surface p-6 rounded-xl border border-border shadow-sm hover:scale-[1.02] transition-all">
          <div className="flex justify-between items-start mb-2">
            <div className="p-2 bg-blue-50 rounded-lg">
              <span className="material-symbols-outlined text-primary">domain</span>
            </div>
            <span className="text-[10px] font-bold text-success bg-green-50 px-2 py-1 rounded-full">+2 This Month</span>
          </div>
          <p className="text-xs font-bold text-textmuted uppercase tracking-wider">Total Facilities</p>
          <h3 className="text-2xl font-bold mt-1 text-textprimary">142</h3>
          <p className="text-xs text-textmuted mt-2">Active healthcare nodes</p>
        </div>

        {/* Active Users */}
        <div className="bg-surface p-6 rounded-xl border border-border shadow-sm hover:scale-[1.02] transition-all">
          <div className="flex justify-between items-start mb-2">
            <div className="p-2 bg-purple-50 rounded-lg">
              <span className="material-symbols-outlined text-purple-600">person_search</span>
            </div>
            <div className="flex items-center gap-1">
              <div className="w-1.5 h-1.5 bg-success rounded-full animate-pulse"></div>
              <span className="text-[10px] font-bold text-textmuted uppercase">Live Now</span>
            </div>
          </div>
          <p className="text-xs font-bold text-textmuted uppercase tracking-wider">Live Users</p>
          <h3 className="text-2xl font-bold mt-1 text-textprimary">4,892</h3>
          <div className="w-full bg-slate-100 h-1 rounded-full mt-4">
            <div className="bg-primary h-full rounded-full" style={{ width: '72%' }}></div>
          </div>
        </div>

        {/* Emergency Response Time */}
        <div className="bg-surface p-6 rounded-xl border border-border shadow-sm hover:scale-[1.02] transition-all">
          <div className="flex justify-between items-start mb-2">
            <div className="p-2 bg-red-50 rounded-lg">
              <span className="material-symbols-outlined text-error">emergency</span>
            </div>
            <span className="text-[10px] font-bold text-error bg-red-50 px-2 py-1 rounded-full">-12% (Better)</span>
          </div>
          <p className="text-xs font-bold text-textmuted uppercase tracking-wider">Avg. Response Time</p>
          <h3 className="text-2xl font-bold mt-1 text-textprimary">4.2 min</h3>
          <p className="text-xs text-textmuted mt-2">Critical Triage efficiency</p>
        </div>

        {/* Revenue Trend */}
        <div className="bg-surface p-6 rounded-xl border border-border shadow-sm hover:scale-[1.02] transition-all">
          <div className="flex justify-between items-start mb-2">
            <div className="p-2 bg-green-50 rounded-lg">
              <span className="material-symbols-outlined text-success">payments</span>
            </div>
            <span className="text-[10px] font-bold text-textmuted bg-slate-100 px-2 py-1 rounded-full">PKR</span>
          </div>
          <p className="text-xs font-bold text-textmuted uppercase tracking-wider">Daily Processing</p>
          <h3 className="text-2xl font-bold mt-1 text-textprimary">1.28M</h3>
          <p className="text-xs text-textmuted mt-2">Across all billing units</p>
        </div>
      </section>

      {/* Main Analytics Section */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Data Visualizer (Centerpiece) */}
        <div className="lg:col-span-2 bg-surface rounded-xl border border-border shadow-sm p-6 overflow-hidden flex flex-col">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h4 className="text-xl font-semibold text-textprimary">User Traffic Trends</h4>
              <p className="text-sm text-textmuted">Aggregate queue volume vs. staffing capacity</p>
            </div>
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-1">
                <span className="w-3 h-3 bg-primary rounded-full"></span>
                <span className="text-xs font-medium text-textmuted">Volume</span>
              </div>
              <div className="flex items-center gap-1">
                <span className="w-3 h-3 bg-slate-400 rounded-full"></span>
                <span className="text-xs font-medium text-textmuted">Capacity</span>
              </div>
            </div>
          </div>
          
          {/* Chart Placeholder with Visual Elements */}
          <div className="flex-1 min-h-[300px] relative flex items-end justify-between gap-2 pt-4">
            <div className="absolute inset-0 flex flex-col justify-between py-4 pointer-events-none">
              <div className="border-t border-dashed border-border w-full"></div>
              <div className="border-t border-dashed border-border w-full"></div>
              <div className="border-t border-dashed border-border w-full"></div>
              <div className="border-t border-dashed border-border w-full"></div>
            </div>
            
            {/* Simplified Bars for Visual Depth */}
            <div className="w-full flex items-end justify-around h-full z-10">
              <div className="group relative flex flex-col items-center w-8 hover:opacity-80 transition-opacity">
                <div className="w-full bg-blue-100 rounded-t-sm h-1/2 mb-[2px]"></div>
                <div className="w-full bg-primary rounded-t-sm h-[40%]"></div>
                <span className="text-[10px] mt-2 font-bold text-textmuted">MON</span>
              </div>
              <div className="group relative flex flex-col items-center w-8 hover:opacity-80 transition-opacity">
                <div className="w-full bg-blue-100 rounded-t-sm h-2/3 mb-[2px]"></div>
                <div className="w-full bg-primary rounded-t-sm h-[55%]"></div>
                <span className="text-[10px] mt-2 font-bold text-textmuted">TUE</span>
              </div>
              <div className="group relative flex flex-col items-center w-8 hover:opacity-80 transition-opacity">
                <div className="w-full bg-blue-100 rounded-t-sm h-3/4 mb-[2px]"></div>
                <div className="w-full bg-primary rounded-t-sm h-[80%]"></div>
                <span className="text-[10px] mt-2 font-bold text-primary">WED</span>
              </div>
              <div className="group relative flex flex-col items-center w-8 hover:opacity-80 transition-opacity">
                <div className="w-full bg-blue-100 rounded-t-sm h-[90%] mb-[2px]"></div>
                <div className="w-full bg-primary rounded-t-sm h-[85%]"></div>
                <span className="text-[10px] mt-2 font-bold text-textmuted">THU</span>
              </div>
              <div className="group relative flex flex-col items-center w-8 hover:opacity-80 transition-opacity">
                <div className="w-full bg-blue-100 rounded-t-sm h-[40%] mb-[2px]"></div>
                <div className="w-full bg-primary rounded-t-sm h-[30%]"></div>
                <span className="text-[10px] mt-2 font-bold text-textmuted">FRI</span>
              </div>
              <div className="group relative flex flex-col items-center w-8 hover:opacity-80 transition-opacity">
                <div className="w-full bg-blue-100 rounded-t-sm h-[30%] mb-[2px]"></div>
                <div className="w-full bg-primary rounded-t-sm h-[20%]"></div>
                <span className="text-[10px] mt-2 font-bold text-textmuted">SAT</span>
              </div>
            </div>
          </div>
        </div>

        {/* Recent Critical Alerts */}
        <div className="bg-surface rounded-xl border border-border shadow-sm flex flex-col h-full">
          <div className="p-6 border-b border-border flex justify-between items-center">
            <h4 className="text-xs font-bold uppercase tracking-wider text-error flex items-center gap-1">
              <span className="material-symbols-outlined text-[18px]">warning</span>
              Critical Alerts
            </h4>
            <span className="bg-red-100 text-error text-[10px] px-2 py-0.5 rounded-full font-bold">4 NEW</span>
          </div>
          <div className="flex-1 overflow-y-auto max-h-[350px]">
            {/* Alert Item */}
            <div className="p-4 border-b border-border hover:bg-red-50 transition-colors cursor-pointer group">
              <div className="flex gap-4">
                <div className="w-1 h-12 bg-error rounded-full group-hover:w-2 transition-all"></div>
                <div className="flex-1">
                  <div className="flex justify-between items-start">
                    <p className="text-sm font-bold text-textprimary">Emergency Dept. At Capacity</p>
                    <span className="text-[10px] text-textmuted">2m ago</span>
                  </div>
                  <p className="text-xs text-textmuted line-clamp-1 mt-1">Jinnah General - Sector B Queue &gt; 40 users</p>
                  <div className="flex gap-1 mt-2">
                    <span className="bg-red-100 text-error text-[10px] px-2 py-0.5 rounded uppercase font-bold tracking-wider">Action Required</span>
                  </div>
                </div>
              </div>
            </div>
            
            {/* Alert Item */}
            <div className="p-4 border-b border-border hover:bg-amber-50 transition-colors cursor-pointer group">
              <div className="flex gap-4">
                <div className="w-1 h-12 bg-warning rounded-full group-hover:w-2 transition-all"></div>
                <div className="flex-1">
                  <div className="flex justify-between items-start">
                    <p className="text-sm font-bold text-textprimary">Data Sync Lag Detected</p>
                    <span className="text-[10px] text-textmuted">14m ago</span>
                  </div>
                  <p className="text-xs text-textmuted line-clamp-1 mt-1">Shifa Medical - Database node #4 latency high</p>
                  <div className="flex gap-1 mt-2">
                    <span className="bg-amber-100 text-warning text-[10px] px-2 py-0.5 rounded uppercase font-bold tracking-wider">Network</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Alert Item */}
            <div className="p-4 border-b border-border hover:bg-red-50 transition-colors cursor-pointer group">
              <div className="flex gap-4">
                <div className="w-1 h-12 bg-error rounded-full group-hover:w-2 transition-all"></div>
                <div className="flex-1">
                  <div className="flex justify-between items-start">
                    <p className="text-sm font-bold text-textprimary">Oxygen Supply Low</p>
                    <span className="text-[10px] text-textmuted">42m ago</span>
                  </div>
                  <p className="text-xs text-textmuted line-clamp-1 mt-1">Civil Hospital - Main tank below 15%</p>
                  <div className="flex gap-1 mt-2">
                    <span className="bg-red-100 text-error text-[10px] px-2 py-0.5 rounded uppercase font-bold tracking-wider">Critical</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <button className="p-4 text-center text-xs font-bold text-primary hover:bg-blue-50 transition-colors uppercase tracking-wider border-t border-border mt-auto">
            VIEW ALL SYSTEM ALERTS
          </button>
        </div>
      </div>

      {/* Regional Performance & Active Nodes */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        
        {/* System Health Monitor */}
        <div className="lg:col-span-1 bg-surface rounded-xl border border-border shadow-sm p-6">
          <h4 className="text-xs font-bold uppercase text-textmuted mb-6 tracking-wider">Node Status</h4>
          <div className="space-y-6">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="material-symbols-outlined text-success">dns</span>
                <span className="text-sm font-medium text-textprimary">Cloud Engine</span>
              </div>
              <span className="text-success font-bold text-xs">99.9%</span>
            </div>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="material-symbols-outlined text-success">database</span>
                <span className="text-sm font-medium text-textprimary">Health Records</span>
              </div>
              <span className="text-success font-bold text-xs uppercase">Online</span>
            </div>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="material-symbols-outlined text-warning">api</span>
                <span className="text-sm font-medium text-textprimary">Third-party Integrations</span>
              </div>
              <span className="text-warning font-bold text-xs uppercase">Degraded</span>
            </div>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="material-symbols-outlined text-success">security</span>
                <span className="text-sm font-medium text-textprimary">AES Encryption</span>
              </div>
              <span className="text-success font-bold text-xs uppercase">Secure</span>
            </div>
          </div>
          
          <div className="mt-6 p-4 bg-slate-50 rounded-lg border border-border">
            <div className="flex items-center justify-between mb-2">
              <span className="text-[10px] font-bold uppercase tracking-wider text-textmuted">Uptime Score</span>
              <span className="text-xs font-bold text-primary">A+</span>
            </div>
            <div className="w-full bg-slate-200 h-2 rounded-full">
              <div className="bg-success h-full rounded-full" style={{ width: '98%' }}></div>
            </div>
          </div>
        </div>

        {/* Active Facility List (Table View) */}
        <div className="lg:col-span-3 bg-surface rounded-xl border border-border shadow-sm overflow-hidden flex flex-col">
          <div className="p-6 border-b border-border bg-slate-50 flex justify-between items-center">
            <h4 className="text-xs font-bold uppercase text-textprimary tracking-wider">Top Performing Facilities</h4>
            <div className="relative">
              <span className="material-symbols-outlined absolute left-2 top-1/2 -translate-y-1/2 text-textmuted text-[18px]">search</span>
              <input 
                className="pl-8 pr-4 py-1.5 bg-white border border-border rounded-full text-xs focus:ring-2 focus:ring-primary/20 outline-none w-48 transition-all" 
                placeholder="Filter hospitals..." 
                type="text"
              />
            </div>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse min-w-[600px]">
              <thead className="bg-slate-50 border-b border-border">
                <tr>
                  <th className="px-6 py-4 text-xs font-bold text-textmuted uppercase tracking-wider">Facility Name</th>
                  <th className="px-6 py-4 text-xs font-bold text-textmuted uppercase tracking-wider">Region</th>
                  <th className="px-6 py-4 text-xs font-bold text-textmuted uppercase tracking-wider">Efficiency</th>
                  <th className="px-6 py-4 text-xs font-bold text-textmuted uppercase tracking-wider">Users Today</th>
                  <th className="px-6 py-4 text-xs font-bold text-textmuted uppercase tracking-wider text-right">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <div className="w-8 h-8 rounded bg-blue-50 flex items-center justify-center">
                        <span className="material-symbols-outlined text-primary text-[18px]">local_hospital</span>
                      </div>
                      <span className="font-bold text-sm text-textprimary group-hover:text-primary transition-colors">Jinnah General Hospital</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-xs text-textmuted">Karachi, South</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <div className="flex-1 w-12 bg-slate-200 h-1.5 rounded-full overflow-hidden">
                        <div className="bg-success h-full" style={{ width: '92%' }}></div>
                      </div>
                      <span className="text-[10px] font-bold text-textprimary">92%</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 font-bold text-sm text-textprimary">1,240</td>
                  <td className="px-6 py-4 text-right">
                    <span className="bg-blue-50 text-primary text-[10px] px-2 py-1 rounded font-bold uppercase tracking-wider">Optimal</span>
                  </td>
                </tr>

                <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <div className="w-8 h-8 rounded bg-blue-50 flex items-center justify-center">
                        <span className="material-symbols-outlined text-primary text-[18px]">local_hospital</span>
                      </div>
                      <span className="font-bold text-sm text-textprimary group-hover:text-primary transition-colors">Mayo Clinic Punjab</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-xs text-textmuted">Lahore, Central</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <div className="flex-1 w-12 bg-slate-200 h-1.5 rounded-full overflow-hidden">
                        <div className="bg-success h-full" style={{ width: '88%' }}></div>
                      </div>
                      <span className="text-[10px] font-bold text-textprimary">88%</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 font-bold text-sm text-textprimary">982</td>
                  <td className="px-6 py-4 text-right">
                    <span className="bg-blue-50 text-primary text-[10px] px-2 py-1 rounded font-bold uppercase tracking-wider">Optimal</span>
                  </td>
                </tr>

                <tr className="hover:bg-slate-50 transition-colors group cursor-pointer">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <div className="w-8 h-8 rounded bg-blue-50 flex items-center justify-center">
                        <span className="material-symbols-outlined text-primary text-[18px]">local_hospital</span>
                      </div>
                      <span className="font-bold text-sm text-textprimary group-hover:text-primary transition-colors">PIMS Heights</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-xs text-textmuted">Islamabad, Capital</td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      <div className="flex-1 w-12 bg-slate-200 h-1.5 rounded-full overflow-hidden">
                        <div className="bg-warning h-full" style={{ width: '64%' }}></div>
                      </div>
                      <span className="text-[10px] font-bold text-textprimary">64%</span>
                    </div>
                  </td>
                  <td className="px-6 py-4 font-bold text-sm text-textprimary">1,412</td>
                  <td className="px-6 py-4 text-right">
                    <span className="bg-amber-50 text-warning text-[10px] px-2 py-1 rounded font-bold uppercase tracking-wider">Strained</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

      </div>
    </div>
  );
}
