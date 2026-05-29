'use client'

import React, { useEffect, useState } from 'react';
import Sidebar from '../components/Sidebar';
import { AlertCircle, Calendar, Clock, Users, Activity, CheckCircle } from 'lucide-react';

export default function HospitalAdminDashboard() {
  const [stats, setStats] = useState({ queue: 0, emergencies: 0, appointments: 0, waitTime: 0 });
  const [queueData, setQueueData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  // API Call to your FastAPI Backend
  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        // Fetch queue data from local FastAPI server
        const res = await fetch('http://127.0.0.1:8000/api/v1/emergency/active'); 
        if (res.ok) {
          const data = await res.json();
          setQueueData(data.incidents || []);
          setStats({
            queue: data.total_queue || 0,
            emergencies: data.critical_count || 0,
            appointments: 12, // Placeholder until appointment route is ready
            waitTime: data.avg_wait || 15
          });
        }
      } catch (error) {
        console.error("Backend connection failed:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
    const interval = setInterval(fetchDashboardData, 5000); // Auto-refresh every 5s per prompt
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="min-h-screen bg-[#F8FAFC] flex font-sans text-[#0F172A]">
      <Sidebar />
      
      {/* MAIN CONTENT - Offset by sidebar width */}
      <div className="flex-1 ml-[240px] p-8">
        <header className="flex justify-between items-center mb-8">
          <div>
            <div className="text-sm text-[#64748B] mb-1">City Hospital &gt; Dashboard</div>
            <h1 className="text-3xl font-bold">Live Dashboard</h1>
          </div>
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2 bg-white px-4 py-2 rounded-full shadow-sm border border-[#E2E8F0]">
              <div className="h-3 w-3 bg-[#16A34A] rounded-full animate-pulse"></div>
              <span className="text-sm font-medium text-[#16A34A]">Updating in real time</span>
            </div>
          </div>
        </header>

        {/* ROW 1: STATS */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <StatCard title="Current Queue" value={stats.queue.toString()} icon={Users} color="blue" />
          <StatCard title="Active Emergencies" value={stats.emergencies.toString()} icon={AlertCircle} color="red" />
          <StatCard title="Today Appointments" value={stats.appointments.toString()} icon={Calendar} color="green" />
          <StatCard title="Avg Wait Time" value={`${stats.waitTime} min`} icon={Clock} color="amber" />
        </div>

        {/* ROW 2: LIVE FEED */}
        <div className="bg-white rounded-xl shadow-sm border border-[#E2E8F0] overflow-hidden">
          <div className="p-6 border-b border-[#E2E8F0] flex justify-between items-center bg-[#F8FAFC]">
            <h2 className="text-xl font-bold flex items-center">
              <Activity className="w-5 h-5 mr-2 text-[#2563EB]" /> Live Emergency Feed
            </h2>
          </div>
          
          {loading ? (
            <div className="p-12 flex justify-center"><div className="animate-pulse flex space-x-4"><div className="h-4 w-48 bg-slate-200 rounded"></div></div></div>
          ) : queueData.length === 0 ? (
            <div className="p-12 text-center text-[#64748B]">
              <CheckCircle className="h-12 w-12 mx-auto text-[#16A34A] mb-3 opacity-50" />
              <p>No active emergencies in queue. All clear.</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left">
                <thead>
                  <tr className="text-[#64748B] text-sm uppercase border-b border-[#E2E8F0]">
                    <th className="p-4 font-semibold">User</th>
                    <th className="p-4 font-semibold">Severity</th>
                    <th className="p-4 font-semibold">Status</th>
                    <th className="p-4 font-semibold">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-[#E2E8F0]">
                  {queueData.map((incident, idx) => (
                    <tr key={idx} className="hover:bg-gray-50 transition">
                      <td className="p-4 font-medium">{incident.user_name || 'Unknown'}</td>
                      <td className="p-4">
                        <span className={`text-xs px-2 py-1 rounded-full font-bold text-white ${incident.severity > 7 ? 'bg-[#DC2626]' : 'bg-[#D97706]'}`}>
                          {incident.severity > 7 ? 'CRITICAL' : 'MODERATE'}
                        </span>
                      </td>
                      <td className="p-4 text-sm font-medium">{incident.status}</td>
                      <td className="p-4">
                        <button className="bg-[#2563EB] text-white px-3 py-1 rounded text-sm hover:scale-105 transition">Accept</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// Reusable Stat Card Component
function StatCard({ title, value, icon: Icon, color }: { title: string, value: string, icon: any, color: 'red'|'blue'|'amber'|'green' }) {
  const colorMap = {
    red: 'text-[#DC2626] bg-red-50',
    blue: 'text-[#2563EB] bg-blue-50',
    amber: 'text-[#D97706] bg-amber-50',
    green: 'text-[#16A34A] bg-green-50'
  };
  return (
    <div className="bg-white p-6 rounded-xl shadow-[0_1px_3px_rgba(0,0,0,0.08)] border border-[#E2E8F0] hover:scale-[1.02] transition-transform">
      <div className="flex justify-between items-start">
        <div>
          <p className="text-sm text-[#64748B] font-semibold uppercase">{title}</p>
          <h3 className={`text-3xl font-bold mt-1 ${color === 'red' ? 'text-[#DC2626]' : 'text-[#0F172A]'}`}>{value}</h3>
        </div>
        <div className={`p-3 rounded-lg ${colorMap[color].split(' ')[1]}`}>
          <Icon className={colorMap[color].split(' ')[0]} />
        </div>
      </div>
    </div>
  );
}