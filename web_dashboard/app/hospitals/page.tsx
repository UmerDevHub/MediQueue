'use client'

import React from 'react';
import Sidebar from '../../components/Sidebar';
import { Building2, Plus, Search, MapPin } from 'lucide-react';

export default function Hospitals() {
  return (
    <div className="min-h-screen bg-[#F8FAFC] flex font-sans text-[#0F172A]">
      <Sidebar />
      
      <div className="flex-1 ml-[240px] p-8">
        <header className="mb-8 flex justify-between items-end">
          <div>
            <h1 className="text-3xl font-bold text-[#0F172A]">Hospital Profile</h1>
            <p className="text-[#64748B] mt-1">Manage hospital details and capacity settings</p>
          </div>
          <button className="flex items-center space-x-2 bg-[#2563EB] text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-blue-700 transition">
            <Plus className="h-4 w-4" /> <span>Edit Details</span>
          </button>
        </header>

        {/* Hospital Info Card */}
        <div className="bg-white p-6 rounded-xl shadow-sm border border-[#E2E8F0] mb-8 flex items-start justify-between">
          <div className="flex items-center space-x-4">
            <div className="bg-blue-50 p-4 rounded-xl border border-blue-100">
              <Building2 className="h-10 w-10 text-[#2563EB]" />
            </div>
            <div>
              <h2 className="text-2xl font-bold">City Hospital (Main Branch)</h2>
              <p className="text-[#64748B] flex items-center mt-1"><MapPin className="h-4 w-4 mr-1" /> Jinnah Avenue, Blue Area, Islamabad</p>
            </div>
          </div>
          <div className="flex flex-col items-end">
            <span className="text-sm text-[#64748B] font-semibold uppercase mb-2">Emergency Status</span>
            <label className="relative inline-flex items-center cursor-pointer hover:scale-105 transition">
              <input type="checkbox" className="sr-only peer" defaultChecked />
              <div className="w-14 h-7 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-[#16A34A]"></div>
              <span className="ml-3 text-sm font-bold text-[#16A34A]">AVAILABLE</span>
            </label>
          </div>
        </div>

        {/* Capacity Settings */}
        <h3 className="text-lg font-bold mb-4">Capacity & Load Settings</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-white p-6 rounded-xl shadow-sm border border-[#E2E8F0]">
            <label className="block text-sm font-semibold text-[#0F172A] mb-2">Maximum Queue Capacity</label>
            <input type="range" min="10" max="100" defaultValue="45" className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-[#2563EB]" />
            <div className="flex justify-between text-xs text-[#64748B] mt-2 font-medium">
              <span>10 Users</span>
              <span className="text-[#2563EB] font-bold">Current: 45</span>
              <span>100 Users</span>
            </div>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm border border-[#E2E8F0]">
            <label className="block text-sm font-semibold text-[#0F172A] mb-2">Average Service Time (per user)</label>
            <div className="flex items-center space-x-2">
              <input type="number" defaultValue="15" className="w-24 px-3 py-2 border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2563EB]" />
              <span className="text-[#64748B] font-medium">minutes</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
