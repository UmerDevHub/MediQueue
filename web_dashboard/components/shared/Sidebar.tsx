'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

export type Role = 'hospital_admin' | 'doctor' | 'super_admin';

interface SidebarProps {
  role: Role;
}

export default function Sidebar({ role }: SidebarProps) {
  const pathname = usePathname();

  const navLinks = {
    hospital_admin: [
      { name: 'Dashboard', href: '/hospital-admin/dashboard', icon: 'dashboard' },
      { name: 'Emergency Queue', href: '/hospital-admin/emergency-queue', icon: 'e911_emergency' },
      { name: 'Appointments', href: '/hospital-admin/appointments', icon: 'event' },
      { name: 'Staff Directory', href: '/hospital-admin/doctors', icon: 'medical_services' },
      { name: 'Analytics', href: '/hospital-admin/analytics', icon: 'assessment' },
    ],
    doctor: [
      { name: 'Dashboard', href: '/doctor/dashboard', icon: 'dashboard' },
      { name: 'Schedule', href: '/doctor/schedule', icon: 'calendar_month' },
      { name: 'My Users', href: '/doctor/users', icon: 'group' },
      { name: 'Availability', href: '/doctor/availability', icon: 'event_available' },
    ],
    super_admin: [
      { name: 'Dashboard', href: '/admin/dashboard', icon: 'dashboard' },
      { name: 'Hospitals', href: '/admin/hospitals', icon: 'local_hospital' },
      { name: 'Users Access', href: '/admin/users', icon: 'group' },
      { name: 'Global Emergencies', href: '/admin/emergencies', icon: 'warning' },
      { name: 'Analytics', href: '/admin/analytics', icon: 'assessment' },
      { name: 'Settings', href: '/admin/settings', icon: 'settings' },
    ],
  };

  const links = navLinks[role] || [];

  return (
    <aside className="fixed h-full w-[240px] left-0 top-0 bg-sidebar border-r border-border flex flex-col py-6 z-50 text-white">
      <div className="px-6 mb-8">
        <h1 className="text-2xl font-bold tracking-tight">MediQueue</h1>
        <p className="text-xs text-white/70 mt-1">
          {role === 'super_admin' ? 'Super Admin Portal' : role === 'doctor' ? 'Doctor Portal' : 'Hospital Admin'}
        </p>
      </div>

      <nav className="flex-1 space-y-1">
        {links.map((link) => {
          const isActive = pathname.startsWith(link.href);
          return (
            <Link
              key={link.name}
              href={link.href}
              className={`flex items-center px-6 py-3 transition-transform duration-150 hover:scale-[1.02] active:scale-[0.97] ${
                isActive
                  ? 'text-primary border-l-4 border-primary bg-white/10 font-bold'
                  : 'text-white/80 hover:bg-white/5'
              }`}
            >
              <span className="material-symbols-outlined mr-4" style={{ fontVariationSettings: isActive ? "'FILL' 1" : "'FILL' 0" }}>
                {link.icon}
              </span>
              <span className="text-sm font-medium">{link.name}</span>
            </Link>
          );
        })}
      </nav>

      <div className="px-6 mt-8 pt-6 border-t border-white/20">
        <div className="flex items-center gap-4">
          <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center border border-primary/30">
            <span className="material-symbols-outlined text-primary" style={{ fontVariationSettings: "'FILL' 1" }}>
              account_circle
            </span>
          </div>
          <div>
            <p className="text-sm font-bold capitalize">{role.replace('_', ' ')}</p>
            <p className="text-xs text-white/60">Active</p>
          </div>
        </div>
      </div>
    </aside>
  );
}
