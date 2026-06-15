'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/shared/Sidebar';
import TopBar from '@/components/shared/TopBar';

export default function HospitalAdminLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('mediqueue_token');
    const role = localStorage.getItem('user_role');

    if (!token || role !== 'hospital_admin') {
      router.push('/login');
    } else {
      setIsAuthenticated(true);
    }
  }, [router]);

  if (!isAuthenticated) return null; // or a loading spinner

  return (
    <div className="min-h-screen bg-background">
      <Sidebar role="hospital_admin" />
      <TopBar title="Hospital Admin" />
      <main className="pt-16 ml-[240px] p-6 bg-background min-h-screen">
        {children}
      </main>
    </div>
  );
}
