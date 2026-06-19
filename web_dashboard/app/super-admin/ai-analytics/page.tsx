"use client";
import { Brain, TrendingUp, Database, Cpu } from 'lucide-react';
import { AreaChart, Area, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer, Legend } from 'recharts';

const patientLoadData = [
  { time: '00:00', actual: 40, predicted: 45 },
  { time: '04:00', actual: 20, predicted: 25 },
  { time: '08:00', actual: 120, predicted: 110 },
  { time: '12:00', actual: 250, predicted: 260 },
  { time: '16:00', actual: 180, predicted: 190 },
  { time: '20:00', actual: 300, predicted: 280 },
  { time: '23:59', actual: 150, predicted: 160 },
];

const nlpAccuracyData = [
  { category: 'Cardio', accuracy: 96, confidence: 92 },
  { category: 'Neuro', accuracy: 88, confidence: 85 },
  { category: 'Trauma', accuracy: 98, confidence: 95 },
  { category: 'Peds', accuracy: 94, confidence: 90 },
  { category: 'Oncology', accuracy: 91, confidence: 88 },
];

export default function AIAnalytics() {
  return (
    <div className="space-y-6 max-w-[1400px] mx-auto animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-2">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight flex items-center">
            <Brain className="mr-3 text-purple-600" size={32} strokeWidth={2.5} /> ML Control Center
          </h1>
          <p className="text-slate-500 text-sm mt-1">Real-time inference tracking, model accuracy, and predictive system health.</p>
        </div>
        <div className="flex items-center space-x-3 bg-white p-1.5 rounded-xl border border-slate-200 shadow-sm">
          <span className="px-3 py-1.5 text-[11px] font-bold text-slate-700 bg-slate-100 rounded-lg tracking-wider">PROD-MODEL-v2.4</span>
          <span className="px-3 py-1.5 text-[11px] font-bold text-emerald-600 flex items-center tracking-wider"><div className="w-2 h-2 rounded-full bg-emerald-500 mr-2 animate-pulse shadow-[0_0_8px_rgba(16,185,129,0.8)]"></div> HEALTHY</span>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-slate-900 p-6 rounded-2xl shadow-[0_8px_30px_rgba(15,23,42,0.15)] text-white relative overflow-hidden group hover:scale-[1.02] transition-transform">
          <div className="absolute -top-4 -right-4 p-4 opacity-10 group-hover:opacity-20 transition-opacity"><Cpu size={100} /></div>
          <p className="text-[10px] font-bold text-slate-400 tracking-[0.2em] uppercase mb-2">GLOBAL NLP ACCURACY</p>
          <h3 className="text-[36px] font-bold text-white leading-tight">94.8%</h3>
          <p className="text-xs text-emerald-400 mt-2 font-bold flex items-center bg-emerald-500/10 w-fit px-2 py-1 rounded"><TrendingUp size={14} className="mr-1.5"/> +1.2% this week</p>
        </div>
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <p className="text-[10px] font-bold text-slate-500 tracking-[0.2em] uppercase mb-2">PREDICTION VARIANCE</p>
          <h3 className="text-[36px] font-bold text-slate-900 leading-tight">±4.2%</h3>
          <p className="text-[13px] text-slate-500 mt-2 font-medium">Within acceptable bounds</p>
        </div>
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <p className="text-[10px] font-bold text-slate-500 tracking-[0.2em] uppercase mb-2">INFERENCE LATENCY</p>
          <h3 className="text-[36px] font-bold text-slate-900 leading-tight">42ms</h3>
          <p className="text-[13px] text-emerald-600 mt-2 font-bold tracking-wide">P99 Response Time</p>
        </div>
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] transition-all hover:shadow-[0_8px_30px_rgb(0,0,0,0.04)]">
          <p className="text-[10px] font-bold text-slate-500 tracking-[0.2em] uppercase mb-2">ACTIVE MODELS</p>
          <h3 className="text-[36px] font-bold text-slate-900 leading-tight">12</h3>
          <p className="text-[13px] text-slate-500 mt-2 font-medium">Distributed across 4 nodes</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-xl font-bold text-slate-900 tracking-tight">Predicted vs. Actual Load</h2>
              <p className="text-[13px] text-slate-500 mt-1 font-medium">Time-series forecasting performance</p>
            </div>
            <div className="flex items-center space-x-4 text-[11px] font-bold text-slate-600 tracking-wide bg-slate-50 px-3 py-2 rounded-lg border border-slate-100">
              <span className="flex items-center uppercase"><div className="w-2.5 h-2.5 rounded bg-blue-500 mr-2 shadow-sm"></div> Actual</span>
              <span className="flex items-center uppercase"><div className="w-2.5 h-2.5 rounded bg-purple-500 mr-2 shadow-sm"></div> Predicted</span>
            </div>
          </div>
          <div className="h-[320px] w-full flex-1">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={patientLoadData} margin={{ top: 10, right: 0, left: -20, bottom: 0 }}>
                <defs>
                  <linearGradient id="colorActual" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#2563EB" stopOpacity={0.4}/>
                    <stop offset="95%" stopColor="#2563EB" stopOpacity={0}/>
                  </linearGradient>
                  <linearGradient id="colorPredicted" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#9333EA" stopOpacity={0.4}/>
                    <stop offset="95%" stopColor="#9333EA" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F1F5F9" />
                <XAxis dataKey="time" axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 11, fontWeight: 600}} dy={15} />
                <YAxis axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 11, fontWeight: 600}} />
                <RechartsTooltip contentStyle={{borderRadius: '12px', border: '1px solid #E2E8F0', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)', fontWeight: 600}} />
                <Area type="monotone" dataKey="actual" stroke="#2563EB" strokeWidth={3} fillOpacity={1} fill="url(#colorActual)" />
                <Area type="monotone" dataKey="predicted" stroke="#9333EA" strokeWidth={3} strokeDasharray="6 6" fillOpacity={1} fill="url(#colorPredicted)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7 flex flex-col">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-xl font-bold text-slate-900 tracking-tight">NLP Accuracy by Domain</h2>
              <p className="text-[13px] text-slate-500 mt-1 font-medium">Text-to-severity classification confidence</p>
            </div>
          </div>
          <div className="h-[320px] w-full flex-1">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={nlpAccuracyData} margin={{ top: 10, right: 0, left: -20, bottom: 0 }} barSize={28}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F1F5F9" />
                <XAxis dataKey="category" axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 11, fontWeight: 600}} dy={15} />
                <YAxis axisLine={false} tickLine={false} tick={{fill: '#94A3B8', fontSize: 11, fontWeight: 600}} domain={[0, 100]} />
                <RechartsTooltip cursor={{fill: '#F8FAFC'}} contentStyle={{borderRadius: '12px', border: '1px solid #E2E8F0', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)', fontWeight: 600}} />
                <Legend iconType="circle" wrapperStyle={{fontSize: '11px', fontWeight: 600, paddingTop: '20px'}} />
                <Bar dataKey="accuracy" name="Accuracy (%)" fill="#0F172A" radius={[6, 6, 0, 0]} />
                <Bar dataKey="confidence" name="Model Confidence (%)" fill="#3B82F6" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
      
      <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_2px_10px_-3px_rgba(6,81,237,0.05)] p-7">
        <h2 className="text-[11px] font-bold text-slate-500 tracking-widest uppercase mb-6 flex items-center"><Database size={16} className="mr-2 text-slate-400"/> ML PIPELINE ANOMALIES</h2>
        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="text-[10px] text-slate-400 uppercase tracking-wider bg-slate-50/80">
              <tr>
                <th className="px-5 py-4 font-bold rounded-l-lg">TIMESTAMP</th>
                <th className="px-5 py-4 font-bold">MODEL NODE</th>
                <th className="px-5 py-4 font-bold">ANOMALY TYPE</th>
                <th className="px-5 py-4 font-bold">IMPACT</th>
                <th className="px-5 py-4 font-bold rounded-r-lg">ACTION TAKEN</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              <tr className="hover:bg-slate-50/50 transition-colors group">
                <td className="px-5 py-4 font-medium text-slate-500 text-[13px]">2026-06-18 19:42:11</td>
                <td className="px-5 py-4 font-bold text-slate-900 text-[13px]">nlp-triage-node-03</td>
                <td className="px-5 py-4"><span className="px-2.5 py-1 bg-amber-50 text-amber-700 text-[9px] font-bold rounded uppercase tracking-wider border border-amber-100/50">Concept Drift Detected</span></td>
                <td className="px-5 py-4 font-bold text-rose-600 text-[13px]">-4.2% Conf.</td>
                <td className="px-5 py-4 text-[13px] font-medium text-slate-600">Auto-routed to fallback heuristic</td>
              </tr>
              <tr className="hover:bg-slate-50/50 transition-colors group">
                <td className="px-5 py-4 font-medium text-slate-500 text-[13px]">2026-06-18 18:15:00</td>
                <td className="px-5 py-4 font-bold text-slate-900 text-[13px]">vision-scan-node-01</td>
                <td className="px-5 py-4"><span className="px-2.5 py-1 bg-rose-50 text-rose-700 text-[9px] font-bold rounded uppercase tracking-wider border border-rose-100/50">Latency Spike {'>'} 2s</span></td>
                <td className="px-5 py-4 font-bold text-slate-900 text-[13px]">0.0%</td>
                <td className="px-5 py-4 text-[13px] font-medium text-slate-600">Scaled up pod replicas (+2)</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
