'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/shared/Sidebar';
import TopBar from '@/components/shared/TopBar';

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('mediqueue_token');
    const role = localStorage.getItem('user_role');

    if (!token || role !== 'super_admin') {
      router.push('/login');
    } else {
      setIsAuthenticated(true);
    }
  }, [router]);

  if (!isAuthenticated) return null;

  return (
    <div className="min-h-screen bg-background flex">
      <Sidebar role="super_admin" />
      <div className="flex-1 flex flex-col min-w-0 ml-[240px]">
        <TopBar title="Super Admin Portal" />
        <main className="pt-16 p-6 bg-background min-h-screen max-w-[1600px] mx-auto w-full">
          {children}
        </main>
      </div>
    </div>
  );
}
