import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _supabase = Supabase.instance.client;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final res = await _supabase.from('users').select('first_name').eq('id', user.id).single();
      if (mounted) {
        setState(() {
          _userName = res['first_name'] ?? 'User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Color(0xFF1D4ED8)),
        title: const Text('MediQueue', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
        actions: const [
          Icon(Icons.notifications_outlined, color: Color(0xFF0F172A)),
          SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            radius: 16,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, $_userName',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Stay updated with your health queue.',
              style: TextStyle(fontSize: 16, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('EMERGENCY', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Get Emergency Help', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.local_hospital, color: Colors.white, size: 48),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('APPOINTMENTS', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Book Appointment', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.calendar_today, color: Colors.white, size: 48),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('RECENT ACTIVITY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)))),
              ],
            ),
            const SizedBox(height: 8),
            _buildActivityCard(
              icon: Icons.medical_services_outlined,
              title: 'Dr. Faisal Ahmed',
              subtitle: 'General Consultation',
              time: 'Oct 24, 10:30 AM',
              status: 'Booked',
              statusColor: const Color(0xFFDBEAFE),
              statusTextColor: const Color(0xFF1E40AF),
            ),
            const SizedBox(height: 12),
            _buildActivityCard(
              icon: Icons.history,
              title: 'Blood Test Results',
              subtitle: 'Pathology Lab',
              time: 'Oct 21, 09:15 AM',
              status: 'Completed',
              statusColor: const Color(0xFFDCFCE7),
              statusTextColor: const Color(0xFF166534),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF64748B),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: statusTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(time, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
