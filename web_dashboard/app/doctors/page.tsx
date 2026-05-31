'use client'

import React from 'react';
import Sidebar from '../../components/Sidebar';
import { Users, Search, Plus } from 'lucide-react';

export default function Doctors() {
  return (
    <div className="min-h-screen bg-[#F8FAFC] flex font-sans text-[#0F172A]">
      <Sidebar />
      
      <div className="flex-1 ml-[240px] p-8">
        <header className="mb-8 flex justify-between items-end">
          <div>
            <h1 className="text-3xl font-bold text-[#0F172A]">Doctors</h1>
            <p className="text-[#64748B] mt-1">Manage hospital medical staff and availability</p>
          </div>
          <button className="flex items-center space-x-2 bg-[#2563EB] text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-blue-700 transition">
            <Plus className="h-4 w-4" /> <span>Add Doctor</span>
          </button>
        </header>

        <div className="relative w-96 mb-6">
          <Search className="w-5 h-5 absolute left-3 top-2.5 text-[#64748B]" />
          <input type="text" placeholder="Search by name or specialization..." className="w-full pl-10 pr-4 py-2 border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2563EB] text-sm" />
        </div>

        <div className="bg-white rounded-xl shadow-sm border border-[#E2E8F0] overflow-hidden">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-[#F8FAFC] text-[#64748B] text-xs uppercase tracking-wider">
                <th className="p-4 font-semibold">Doctor Name</th>
                <th className="p-4 font-semibold">Specialization</th>
                <th className="p-4 font-semibold">License No.</th>
                <th className="p-4 font-semibold">Duty Status</th>
                <th className="p-4 font-semibold text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#E2E8F0] text-sm">
              <tr className="hover:bg-gray-50 transition">
                <td className="p-4 font-bold flex items-center space-x-3">
                  <div className="w-8 h-8 rounded-full bg-blue-100 text-[#2563EB] flex items-center justify-center font-bold">HA</div>
                  <span>Dr. Hassan Ali</span>
                </td>
                <td className="p-4 text-[#64748B]">Cardiology</td>
                <td className="p-4 font-mono text-xs text-[#64748B]">PMC-49201</td>
                <td className="p-4">
                  <span className="text-[#16A34A] bg-green-50 px-2 py-1 rounded text-xs font-bold border border-green-200">ON DUTY</span>
                </td>
                <td className="p-4 text-right">
                  <button className="text-[#2563EB] text-sm font-medium hover:underline">Manage Profile</button>
                </td>
              </tr>
              <tr className="hover:bg-gray-50 transition">
                <td className="p-4 font-bold flex items-center space-x-3">
                  <div className="w-8 h-8 rounded-full bg-slate-100 text-[#64748B] flex items-center justify-center font-bold">ST</div>
                  <span>Dr. Sarah Tariq</span>
                </td>
                <td className="p-4 text-[#64748B]">Neurology</td>
                <td className="p-4 font-mono text-xs text-[#64748B]">PMC-81192</td>
                <td className="p-4">
                  <span className="text-[#64748B] bg-slate-100 px-2 py-1 rounded text-xs font-bold border border-slate-200">OFF DUTY</span>
                </td>
                <td className="p-4 text-right">
                  <button className="text-[#2563EB] text-sm font-medium hover:underline">Manage Profile</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}