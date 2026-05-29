'use client'

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { 
  LayoutDashboard, 
  AlertCircle, 
  Calendar, 
  Users, 
  Building2, 
  BarChart3, 
  Settings, 
  LogOut 
} from 'lucide-react';
import { supabase } from '../lib/supabaseClient';
import { useRouter } from 'next/navigation';

export default function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push('/login');
  };

  const navItems = [
    { name: 'Dashboard', path: '/', icon: LayoutDashboard },
    { name: 'Emergency Queue', path: '/emergency', icon: AlertCircle },
    { name: 'Appointments', path: '/appointments', icon: Calendar },
    { name: 'Doctors', path: '/doctors', icon: Users }, // Note: We will create this folder next
    { name: 'Hospital Profile', path: '/hospitals', icon: Building2 },
    { name: 'Analytics', path: '/analytics', icon: BarChart3 },
  ];

  return (
    <div className="w-[240px] bg-[#0F172A] text-white flex flex-col min-h-screen fixed left-0 top-0">
      <div className="p-6 flex items-center space-x-3 border-b border-white/10">
        <div className="bg-[#2563EB] p-2 rounded-lg">
          <AlertCircle className="h-6 w-6 text-white" />
        </div>
        <span className="text-xl font-bold tracking-tight">MediQueue</span>
      </div>

      <nav className="flex-1 py-6 space-y-2 px-4">
        {navItems.map((item) => {
          const isActive = pathname === item.path;
          const Icon = item.icon;
          return (
            <Link 
              key={item.name} 
              href={item.path}
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg transition-all ${
                isActive 
                  ? 'bg-[#2563EB]/10 text-[#2563EB] border-l-4 border-[#2563EB] font-medium' 
                  : 'text-[#64748B] hover:text-white hover:bg-white/5'
              }`}
            >
              <Icon className="h-5 w-5" />
              <span>{item.name}</span>
            </Link>
          );
        })}
      </nav>

      <div className="p-4 border-t border-white/10 space-y-2">
        <Link 
          href="/settings"
          className="flex items-center space-x-3 px-4 py-2 text-[#64748B] hover:text-white rounded-lg transition"
        >
          <Settings className="h-5 w-5" />
          <span>Settings</span>
        </Link>
        <button 
          onClick={handleLogout}
          className="w-full flex items-center space-x-3 px-4 py-2 text-[#DC2626] hover:bg-[#DC2626]/10 rounded-lg transition"
        >
          <LogOut className="h-5 w-5" />
          <span>Log Out</span>
        </button>
      </div>
    </div>
  );
}