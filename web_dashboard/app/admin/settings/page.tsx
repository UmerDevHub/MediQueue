'use client';

export default function AdminSettingsPage() {
  return (
    <div className="space-y-6 max-w-5xl">
      {/* Header Section */}
      <div className="mb-8">
        <h1 className="text-3xl font-semibold text-textprimary mb-1">System Settings</h1>
        <p className="text-sm text-textmuted">Manage global platform configurations, integrations, and audit logs.</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
        {/* Left Column: Settings Categories */}
        <div className="md:col-span-8 space-y-6">
          
          {/* White-Labeling & Hospital Branding */}
          <section className="bg-white border border-border rounded-xl p-6 shadow-sm">
            <div className="flex items-center justify-between mb-6">
              <div>
                <h3 className="text-xl font-semibold text-textprimary">Global White-Labeling</h3>
                <p className="text-sm text-textmuted mt-1">Configure visual identity across member clinics.</p>
              </div>
              <span className="material-symbols-outlined text-primary text-[28px]">palette</span>
            </div>
            
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <label className="text-xs font-bold uppercase tracking-wider text-textmuted block">Platform Name</label>
                <input 
                  className="w-full border border-border rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary outline-none text-sm text-textprimary bg-surface transition-all" 
                  type="text" 
                  defaultValue="MediQueue Central"
                />
              </div>
              <div className="space-y-2">
                <label className="text-xs font-bold uppercase tracking-wider text-textmuted block">Primary Brand Color</label>
                <div className="flex gap-2 items-center">
                  <input 
                    className="h-9 w-12 border border-border rounded cursor-pointer" 
                    type="color" 
                    defaultValue="#2563EB"
                  />
                  <input 
                    className="flex-1 border border-border rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary outline-none text-sm text-textprimary bg-surface font-mono" 
                    type="text" 
                    defaultValue="#2563EB"
                  />
                </div>
              </div>
              <div className="sm:col-span-2 space-y-2 mt-2">
                 <label className="text-xs font-bold uppercase tracking-wider text-textmuted block">Platform Logo</label>
                 <div className="border-2 border-dashed border-border rounded-lg p-6 flex flex-col items-center justify-center bg-slate-50 hover:bg-slate-100 transition-colors cursor-pointer">
                    <span className="material-symbols-outlined text-textmuted text-3xl mb-2">cloud_upload</span>
                    <p className="text-sm font-semibold text-textprimary">Click to upload or drag and drop</p>
                    <p className="text-xs text-textmuted mt-1">SVG, PNG, or JPG (max. 800x400px)</p>
                 </div>
              </div>
            </div>
            <div className="mt-6 flex justify-end">
              <button className="bg-primary text-white px-6 py-2 rounded-lg font-bold text-sm hover:scale-[1.02] active:scale-[0.97] transition-all shadow-sm">
                Save Branding
              </button>
            </div>
          </section>

          {/* Electronic Health Record Integration */}
          <section className="bg-white border border-border rounded-xl p-6 shadow-sm">
            <div className="flex items-center justify-between mb-6">
              <div>
                <h3 className="text-xl font-semibold text-textprimary">EHR Integrations</h3>
                <p className="text-sm text-textmuted mt-1">Manage API connections to central health databases.</p>
              </div>
              <span className="material-symbols-outlined text-primary text-[28px]">api</span>
            </div>
            
            <div className="space-y-4">
              {/* Integration 1 */}
              <div className="flex items-center justify-between p-4 border border-border rounded-lg bg-slate-50">
                <div className="flex items-center gap-4">
                  <div className="w-10 h-10 bg-white rounded shadow-sm border border-border flex items-center justify-center font-bold text-primary">EP</div>
                  <div>
                    <h4 className="font-bold text-sm text-textprimary">Epic Systems</h4>
                    <p className="text-xs text-textmuted mt-0.5">Connected • Last sync: 2 mins ago</p>
                  </div>
                </div>
                <button className="text-xs font-bold uppercase text-textmuted border border-border px-3 py-1.5 rounded bg-white hover:bg-slate-100 transition-colors">
                  Configure
                </button>
              </div>
              
              {/* Integration 2 */}
              <div className="flex items-center justify-between p-4 border border-border rounded-lg bg-white">
                <div className="flex items-center gap-4">
                  <div className="w-10 h-10 bg-slate-100 rounded border border-border flex items-center justify-center font-bold text-textmuted opacity-50">CE</div>
                  <div className="opacity-70">
                    <h4 className="font-bold text-sm text-textprimary">Cerner</h4>
                    <p className="text-xs text-textmuted mt-0.5">Not configured</p>
                  </div>
                </div>
                <button className="text-xs font-bold uppercase text-primary border border-primary/20 bg-blue-50 px-3 py-1.5 rounded hover:bg-blue-100 transition-colors">
                  Connect
                </button>
              </div>
            </div>
          </section>
        </div>

        {/* Right Column: Audit Log & Security */}
        <div className="md:col-span-4 space-y-6">
          
          {/* Security Summary */}
          <section className="bg-primary text-white rounded-xl p-6 shadow-md">
            <h3 className="text-lg font-bold mb-4 flex items-center gap-2">
              <span className="material-symbols-outlined">security</span>
              Security Posture
            </h3>
            <div className="space-y-4">
              <div className="flex justify-between items-center pb-2 border-b border-white/20">
                <span className="text-sm text-white/80">2FA Enforcement</span>
                <span className="text-sm font-bold bg-white/20 px-2 py-0.5 rounded">Enabled</span>
              </div>
              <div className="flex justify-between items-center pb-2 border-b border-white/20">
                <span className="text-sm text-white/80">Session Timeout</span>
                <span className="text-sm font-bold">15 Mins</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-sm text-white/80">Failed Logins (24h)</span>
                <span className="text-sm font-bold text-red-200">12</span>
              </div>
            </div>
            <button className="w-full mt-6 bg-white text-primary py-2 rounded-lg font-bold text-sm hover:scale-[1.02] active:scale-[0.98] transition-transform shadow-sm">
              Security Center
            </button>
          </section>

          {/* Audit Log Mini-feed */}
          <section className="bg-white border border-border rounded-xl p-6 shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-bold uppercase tracking-wider text-textprimary">Recent Audit Logs</h3>
              <button className="text-primary text-xs font-bold hover:underline">VIEW ALL</button>
            </div>
            
            <div className="space-y-4 relative before:absolute before:inset-0 before:ml-2 before:-translate-x-px md:before:mx-auto md:before:translate-x-0 before:h-full before:w-0.5 before:bg-gradient-to-b before:from-transparent before:via-slate-200 before:to-transparent">
               
               {/* Log Item */}
               <div className="relative flex items-center justify-between md:justify-normal md:odd:flex-row-reverse group is-active">
                  <div className="flex items-center justify-center w-4 h-4 rounded-full border-2 border-white bg-primary shadow shrink-0 md:order-1 md:group-odd:-translate-x-1/2 md:group-even:translate-x-1/2"></div>
                  <div className="w-[calc(100%-2rem)] md:w-[calc(50%-1.5rem)] p-3 rounded border border-border bg-slate-50 shadow-sm">
                     <div className="flex items-center justify-between mb-1">
                        <span className="text-[10px] font-bold text-primary uppercase">Config Change</span>
                        <time className="text-[10px] text-textmuted">10:42 AM</time>
                     </div>
                     <p className="text-xs text-textprimary">Dr. Faisal updated triage protocol.</p>
                  </div>
               </div>

               {/* Log Item */}
               <div className="relative flex items-center justify-between md:justify-normal md:odd:flex-row-reverse group is-active">
                  <div className="flex items-center justify-center w-4 h-4 rounded-full border-2 border-white bg-success shadow shrink-0 md:order-1 md:group-odd:-translate-x-1/2 md:group-even:translate-x-1/2"></div>
                  <div className="w-[calc(100%-2rem)] md:w-[calc(50%-1.5rem)] p-3 rounded border border-border bg-white shadow-sm">
                     <div className="flex items-center justify-between mb-1">
                        <span className="text-[10px] font-bold text-success uppercase">Auth</span>
                        <time className="text-[10px] text-textmuted">09:15 AM</time>
                     </div>
                     <p className="text-xs text-textprimary">System admin login successful.</p>
                  </div>
               </div>

               {/* Log Item */}
               <div className="relative flex items-center justify-between md:justify-normal md:odd:flex-row-reverse group is-active">
                  <div className="flex items-center justify-center w-4 h-4 rounded-full border-2 border-white bg-warning shadow shrink-0 md:order-1 md:group-odd:-translate-x-1/2 md:group-even:translate-x-1/2"></div>
                  <div className="w-[calc(100%-2rem)] md:w-[calc(50%-1.5rem)] p-3 rounded border border-border bg-white shadow-sm">
                     <div className="flex items-center justify-between mb-1">
                        <span className="text-[10px] font-bold text-warning uppercase">Integration</span>
                        <time className="text-[10px] text-textmuted">Yesterday</time>
                     </div>
                     <p className="text-xs text-textprimary">Epic API latency spike detected.</p>
                  </div>
               </div>

            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
