import { createClient } from '@supabase/supabase-js';

// Replace with your actual Supabase URL and anonymous key
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://your-project.supabase.co';
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'your-anon-key';

export const supabase = createClient(supabaseUrl, supabaseKey);

/**
 * MOCK REAL-TIME IMPLEMENTATION
 * 
 * Demonstrates to the FYP panel that when a Hospital Admin triggers "Auto-Divert"
 * or updates a queue, the Super Admin and Doctor dashboards update instantly 
 * via WebSockets without a page refresh.
 */
export const subscribeToFacilityUpdates = (callback: (payload: any) => void) => {
  const channel = supabase
    .channel('custom-all-channel')
    .on(
      'postgres_changes',
      { event: '*', schema: 'public', table: 'queues' },
      (payload) => {
        console.log('Real-time queue update received!', payload);
        callback(payload);
      }
    )
    .on(
      'postgres_changes',
      { event: 'UPDATE', schema: 'public', table: 'facility_settings' },
      (payload) => {
        console.log('Real-time facility settings update (e.g., Auto-Divert) received!', payload);
        callback(payload);
      }
    )
    .subscribe();

  return () => {
    supabase.removeChannel(channel);
  };
};
