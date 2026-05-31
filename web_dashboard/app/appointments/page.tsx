'use client'

import React from 'react';
import Sidebar from '../../components/Sidebar';
import { Calendar as CalendarIcon, Search, Plus } from 'lucide-react';

export default function Appointments() {
  return (
    <div className="min-h-screen bg-[#F8FAFC] flex font-sans text-[#0F172A]">
      <Sidebar />
      
      <div className="flex-1 ml-[240px] p-8">
        <header className="mb-8 flex justify-between items-end">
          <div>
            <h1 className="text-3xl font-bold text-[#0F172A]">Appointments</h1>
            <p className="text-[#64748B] mt-1">Manage doctor schedules and user bookings</p>
          </div>
          <button className="flex items-center space-x-2 bg-[#2563EB] text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-blue-700 transition">
            <Plus className="h-4 w-4" /> <span>New Booking</span>
          </button>
        </header>

        {/* Controls Row */}
        <div className="flex justify-between items-center mb-6">
          <div className="relative w-72">
            <Search className="w-5 h-5 absolute left-3 top-2.5 text-[#64748B]" />
            <input 
              type="text" 
              placeholder="Search users or doctors..." 
              className="w-full pl-10 pr-4 py-2 border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#2563EB] text-sm"
            />
          </div>
          <div className="flex space-x-2">
            <button className="bg-white border border-[#E2E8F0] px-4 py-2 rounded-lg text-sm font-medium hover:bg-gray-50 transition flex items-center">
              <CalendarIcon className="w-4 h-4 mr-2 text-[#64748B]"/> Today
            </button>
          </div>
        </div>

        {/* Appointments Table */}
        <div className="bg-white rounded-xl shadow-sm border border-[#E2E8F0] overflow-hidden">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-[#F8FAFC] text-[#64748B] text-xs uppercase tracking-wider">
                <th className="p-4 font-semibold">Time</th>
                <th className="p-4 font-semibold">User</th>
                <th className="p-4 font-semibold">Doctor</th>
                <th className="p-4 font-semibold">Department</th>
                <th className="p-4 font-semibold">Status</th>
                <th className="p-4 font-semibold text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#E2E8F0] text-sm">
              <tr className="hover:bg-gray-50 transition">
                <td className="p-4 font-bold text-[#0F172A]">09:00 AM</td>
                <td className="p-4 font-medium">Usman Ali</td>
                <td className="p-4">Dr. Hassan</td>
                <td className="p-4 text-[#64748B]">Cardiology</td>
                <td className="p-4">
                  <span className="text-[#16A34A] bg-green-50 border border-green-200 px-2 py-1 rounded text-xs font-bold">COMPLETED</span>
                </td>
                <td className="p-4 text-right">
                  <button className="text-[#2563EB] text-sm font-medium hover:underline">View Notes</button>
                </td>
              </tr>
              <tr className="hover:bg-gray-50 transition">
                <td className="p-4 font-bold text-[#0F172A]">02:30 PM</td>
                <td className="p-4 font-medium">Ayesha Tariq</td>
                <td className="p-4">Dr. Sarah</td>
                <td className="p-4 text-[#64748B]">Neurology</td>
                <td className="p-4">
                  <span className="text-[#2563EB] bg-blue-50 border border-blue-200 px-2 py-1 rounded text-xs font-bold">BOOKED</span>
                </td>
                <td className="p-4 text-right space-x-3">
                  <button className="text-[#DC2626] text-sm font-medium hover:underline">Cancel</button>
                  <button className="text-[#2563EB] text-sm font-medium hover:underline">Reschedule</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
