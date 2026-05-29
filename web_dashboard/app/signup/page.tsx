'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { ShieldCheck, UserPlus } from 'lucide-react'
import { supabase } from '../../lib/supabaseClient'

const roles = [
  { label: 'Super Admin', value: 'super_admin' },
  { label: 'Hospital Admin', value: 'hospital_admin' },
  { label: 'Doctor', value: 'doctor' },
]

export default function SignupPage() {
  const router = useRouter()
  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [role, setRole] = useState(roles[1].value)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')
    setSuccess('')
    const { data, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
          role,
        },
      },
    })

    if (signUpError) {
      setError(signUpError.message)
      setLoading(false)
      return
    }

    if (data.user) {
      setSuccess('Account created. Verify email then sign in.')
      setTimeout(() => router.push('/login'), 1200)
    }

    setLoading(false)
  }

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="mx-auto mb-3 w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center">
            <ShieldCheck className="h-6 w-6 text-[#2563EB]" />
          </div>
          <h1 className="text-2xl font-semibold text-textprimary">MediQueue Admin Signup</h1>
          <p className="text-textmuted text-sm mt-1">Create a secure staff account</p>
        </div>

        <div className="card">
          <form onSubmit={handleSignup} className="space-y-4">
            <div>
              <label className="block text-xs font-medium text-textmuted mb-1.5">Full name</label>
              <input
                type="text"
                className="input"
                placeholder="Dr. Ayesha Khan"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                required
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-textmuted mb-1.5">Work email</label>
              <input
                type="email"
                className="input"
                placeholder="staff@hospital.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-textmuted mb-1.5">Role</label>
              <select
                className="input"
                value={role}
                onChange={(e) => setRole(e.target.value)}
              >
                {roles.map((r) => (
                  <option key={r.value} value={r.value}>{r.label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-xs font-medium text-textmuted mb-1.5">Password</label>
              <input
                type="password"
                className="input"
                placeholder="Minimum 8 characters"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>

            {error && (
              <div className="bg-red-50 border border-red-100 rounded-lg px-3 py-2 text-xs text-danger">{error}</div>
            )}
            {success && (
              <div className="bg-green-50 border border-green-100 rounded-lg px-3 py-2 text-xs text-success">{success}</div>
            )}

            <button type="submit" disabled={loading} className="btn-primary w-full justify-center flex items-center gap-2">
              <UserPlus className="h-4 w-4" />
              {loading ? 'Creating account...' : 'Create account'}
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}
