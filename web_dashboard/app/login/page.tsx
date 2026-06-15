'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<'hospital_admin' | 'doctor' | 'super_admin'>('hospital_admin');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    // Simulate API call and set token
    setTimeout(() => {
      localStorage.setItem('mediqueue_token', 'simulated_token_123');
      localStorage.setItem('user_role', role);
      
      setIsLoading(false);
      
      // Role based routing
      if (role === 'hospital_admin') {
        router.push('/hospital-admin/dashboard');
      } else if (role === 'doctor') {
        router.push('/doctor/dashboard');
      } else if (role === 'super_admin') {
        router.push('/admin/dashboard');
      }
    }, 1000);
  };

  return (
    <div className="bg-background min-h-screen flex flex-col relative overflow-hidden">
      {/* Abstract Atmospheric Background Elements */}
      <div className="absolute top-0 left-0 w-full h-full opacity-20 pointer-events-none">
        <div className="absolute -top-24 -right-24 w-96 h-96 bg-primary/30 rounded-full blur-3xl"></div>
        <div className="absolute top-1/2 -left-24 w-64 h-64 bg-primary/20 rounded-full blur-3xl"></div>
      </div>

      <main className="flex-grow flex items-center justify-center px-4 py-8 z-10">
        <div className="w-full max-w-[420px] bg-surface border border-border rounded-xl shadow-card p-8 flex flex-col items-center">
          
          {/* Branding & Logo Section */}
          <div className="flex flex-col items-center mb-6">
            <div className="w-16 h-16 bg-primary rounded-2xl flex items-center justify-center mb-4 transition-transform duration-150 hover:scale-105">
              <span className="material-symbols-outlined text-white text-[32px]">apartment</span>
            </div>
            <h1 className="text-xl font-semibold text-textprimary mb-1">MediQueue Portal</h1>
            <p className="text-sm text-textmuted">Staff & Administration Access</p>
          </div>

          {/* Role Toggle for demo purposes to simulate combined login */}
          <div className="w-full mb-6">
            <div className="flex bg-slate-100 p-1 rounded-lg">
              {(['hospital_admin', 'doctor', 'super_admin'] as const).map((r) => (
                <button
                  key={r}
                  type="button"
                  onClick={() => setRole(r)}
                  className={`flex-1 text-xs py-2 rounded-md font-medium transition-colors ${
                    role === r ? 'bg-white shadow-sm text-primary' : 'text-textmuted hover:text-textprimary'
                  }`}
                >
                  {r.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')}
                </button>
              ))}
            </div>
          </div>

          <div className="w-full text-center mb-6">
            <h2 className="text-2xl font-semibold text-textprimary">
              {isLogin ? 'Welcome Back' : 'Create Account'}
            </h2>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="w-full space-y-4">
            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-textmuted uppercase block">Email Address</label>
              <div className="relative">
                <input 
                  type="email" 
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required 
                  className="input pl-10" 
                  placeholder="name@hospital.com"
                />
                <span className="material-symbols-outlined absolute left-3 top-2.5 text-textmuted text-[20px]">mail</span>
              </div>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-textmuted uppercase block">Password</label>
              <div className="relative">
                <input 
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  placeholder="••••••••" 
                  className="input pl-10 pr-10"
                />
                <span className="material-symbols-outlined absolute left-3 top-2.5 text-textmuted text-[20px]">lock</span>
                <button 
                  type="button" 
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-2.5 text-textmuted hover:text-textprimary focus:outline-none"
                >
                  <span className="material-symbols-outlined text-[20px]">
                    {showPassword ? 'visibility_off' : 'visibility'}
                  </span>
                </button>
              </div>
            </div>

            <div className="flex justify-between items-center">
              <button 
                type="button" 
                onClick={() => setIsLogin(!isLogin)}
                className="text-xs text-primary hover:underline"
              >
                {isLogin ? 'Need an account?' : 'Already have one?'}
              </button>
              {isLogin && (
                <a href="#" className="text-xs text-primary hover:underline">Forgot Password?</a>
              )}
            </div>

            <button 
              type="submit" 
              disabled={isLoading}
              className="w-full h-12 bg-primary text-white rounded-lg font-medium text-sm hover:scale-[1.02] active:scale-[0.97] transition-all duration-150 flex items-center justify-center gap-2 shadow-sm disabled:opacity-70 disabled:hover:scale-100"
            >
              {isLoading ? (
                <svg className="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
              ) : (
                <>
                  <span>{isLogin ? 'Sign In' : 'Sign Up'}</span>
                  <span className="material-symbols-outlined text-[18px]">login</span>
                </>
              )}
            </button>
          </form>
        </div>

        {/* Compliance Badges */}
        <div className="absolute bottom-8 w-full flex justify-center gap-8 px-4 opacity-60 grayscale hover:grayscale-0 transition-all duration-300">
          <div className="flex items-center gap-2">
            <span className="material-symbols-outlined text-textmuted">verified_user</span>
            <span className="text-xs font-semibold text-textmuted uppercase">HIPAA Compliant</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="material-symbols-outlined text-textmuted">encrypted</span>
            <span className="text-xs font-semibold text-textmuted uppercase">256-bit AES Security</span>
          </div>
        </div>
      </main>
    </div>
  );
}
