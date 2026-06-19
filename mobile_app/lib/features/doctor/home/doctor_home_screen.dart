import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  String _doctorName = 'Doctor';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      context.go('/role_selection');
      return;
    }
    try {
      // Fetch doctor profile
      final profile = await Supabase.instance.client
          .from('users')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();
      if (profile != null) {
        _doctorName = profile['full_name'] ?? 'Doctor';
      }

      // Fetch today's appointments
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day).toIso8601String();
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();
      final appts = await Supabase.instance.client
          .from('appointments')
          .select('*, users(full_name)')
          .eq('doctor_id', user.id)
          .gte('appointment_time', startOfDay)
          .lte('appointment_time', endOfDay)
          .order('appointment_time');

      if (mounted) {
        setState(() {
          _appointments = appts;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = _appointments.where((a) => a['status'] == 'completed').length;
    final waiting = _appointments.where((a) => a['status'] == 'pending').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('MediQueue',
            style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF475569)),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) context.go('/role_selection');
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome, Dr. ${_doctorName.split(' ').first}!',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  const Text("Here's your schedule for today.",
                      style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                          child: _buildMetricCard('Total', _appointments.length.toString(),
                              Icons.calendar_today, const Color(0xFF2563EB))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildMetricCard('Completed', completed.toString(),
                              Icons.check_circle_outline, const Color(0xFF10B981))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildMetricCard('Waiting', waiting.toString(),
                              Icons.hourglass_empty, const Color(0xFFF59E0B))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('TODAY\'S APPOINTMENTS',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                          letterSpacing: 1)),
                  const SizedBox(height: 16),
                  if (_appointments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No appointments scheduled for today.',
                            style: TextStyle(color: Color(0xFF475569))),
                      ),
                    )
                  else
                    ..._appointments.map((appt) {
                      final userName = (appt['users'] as Map?)?['full_name'] ?? 'Unknown User';
                      final time = appt['appointment_time'] ?? '';
                      final status = appt['status'] ?? 'pending';
                      return _buildAppointmentCard(userName, time, status, appt['id'] ?? '');
                    }),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/my_schedule'),
                    icon: const Icon(Icons.calendar_view_day),
                    label: const Text('Full Schedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(String name, String time, String status, String id) {
    final isPending = status == 'pending';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFDBEAFE),
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                    color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                Text(time,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPending ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPending ? 'WAITING' : 'DONE',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isPending ? const Color(0xFF92400E) : const Color(0xFF166534)),
            ),
          ),
        ],
      ),
    );
  }
}
