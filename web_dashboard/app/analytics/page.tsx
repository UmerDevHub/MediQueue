'use client'

import React from 'react';
import Sidebar from '../../components/Sidebar';
import { BarChart3, Download } from 'lucide-react';

export default function Analytics() {
  return (
    <div className="min-h-screen bg-[#F8FAFC] flex font-sans text-[#0F172A]">
      <Sidebar />
      
      <div className="flex-1 ml-[240px] p-8">
        <header className="mb-8 flex justify-between items-end">
          <div>
            <h1 className="text-3xl font-bold text-[#0F172A]">Hospital Analytics</h1>
            <p className="text-[#64748B] mt-1">Platform-wide data and machine learning insights</p>
          </div>
          <button className="flex items-center space-x-2 bg-white border border-[#E2E8F0] px-4 py-2 rounded-lg text-sm font-medium hover:bg-gray-50 transition">
            <Download className="h-4 w-4" /> <span>Export PDF</span>
          </button>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Chart 1 */}
          <div className="bg-white p-6 rounded-xl shadow-sm border border-[#E2E8F0]">
            <h3 className="text-lg font-bold mb-4">Daily Emergency Volume (7 Days)</h3>
            <div className="flex items-end space-x-4 h-48 mt-4 border-b border-l border-[#E2E8F0] p-4">
              <div className="w-1/6 bg-[#DC2626] rounded-t-sm" style={{ height: '40%' }}></div>
              <div className="w-1/6 bg-[#DC2626] rounded-t-sm" style={{ height: '60%' }}></div>
              <div className="w-1/6 bg-[#DC2626] rounded-t-sm" style={{ height: '30%' }}></div>
              <div className="w-1/6 bg-[#DC2626] rounded-t-sm" style={{ height: '80%' }}></div>
              <div className="w-1/6 bg-[#DC2626] rounded-t-sm" style={{ height: '50%' }}></div>
              <div className="w-1/6 bg-[#DC2626] rounded-t-sm" style={{ height: '90%' }}></div>
            </div>
            <div className="flex justify-between text-xs font-medium text-[#64748B] mt-2 px-4">
              <span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span>
            </div>
          </div>

          {/* Chart 2 */}
          <div className="bg-white p-6 rounded-xl shadow-sm border border-[#E2E8F0]">
            <h3 className="text-lg font-bold mb-4">Doctor Utilization Rate</h3>
            <div className="space-y-4 mt-4">
              <div>
                <div className="flex justify-between text-sm mb-1"><span className="font-semibold">Cardiology</span><span className="text-[#64748B]">85%</span></div>
                <div className="w-full bg-gray-200 rounded-full h-2"><div className="bg-[#2563EB] h-2 rounded-full" style={{ width: '85%' }}></div></div>
              </div>
              <div>
                <div className="flex justify-between text-sm mb-1"><span className="font-semibold">Neurology</span><span className="text-[#64748B]">60%</span></div>
                <div className="w-full bg-gray-200 rounded-full h-2"><div className="bg-[#2563EB] h-2 rounded-full" style={{ width: '60%' }}></div></div>
              </div>
              <div>
                <div className="flex justify-between text-sm mb-1"><span className="font-semibold">General</span><span className="text-[#64748B]">95%</span></div>
                <div className="w-full bg-gray-200 rounded-full h-2"><div className="bg-[#DC2626] h-2 rounded-full" style={{ width: '95%' }}></div></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}