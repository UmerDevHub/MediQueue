import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveQueueManagementScreen extends StatefulWidget {
  const LiveQueueManagementScreen({Key? key}) : super(key: key);

  @override
  State<LiveQueueManagementScreen> createState() => _LiveQueueManagementScreenState();
}

class _LiveQueueManagementScreenState extends State<LiveQueueManagementScreen> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _incidents = [];

  @override
  void initState() {
    super.initState();
    _fetchAndListenToIncidents();
  }

  void _fetchAndListenToIncidents() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      // Assuming user has a hospital_id in metadata or users table for filtering
      // For demo, we just fetch all or filter by a known hospital_id
      
      final res = await _supabase.from('incidents').select('*');
      if (mounted) {
        setState(() {
          _incidents = res;
        });
      }

      _supabase
          .channel('public:incidents')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'incidents',
            callback: (payload) {
              _refreshIncidents();
            },
          )
          .subscribe();
    }
  }

  Future<void> _refreshIncidents() async {
    final res = await _supabase.from('incidents').select('*');
    if (mounted) {
      setState(() {
        _incidents = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF0F172A)),
          onPressed: () {},
        ),
        title: const Text('MediQueue', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    const Text('User Queue', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))), // Refactored Emergency to User for general queue if needed, but design says Emergency Queue. Reverting to Emergency Queue but using User labels inside.
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                  child: Row(
                    children: const [
                      Icon(Icons.sort, size: 16, color: Color(0xFF475569)),
                      SizedBox(width: 4),
                      Text('PRIORITY SCORE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildQueueCard('ZA', 'Zubair Ahmed', 'Severe Chest Pain, Tachycardia', 'CRITICAL', 'INCOMING', '12 min', const Color(0xFFFEE2E2), const Color(0xFFDC2626), const Color(0xFFE0E7FF), const Color(0xFF3730A3)),
                _buildQueueCard('NK', 'Noman Khan', 'Fractured Radial Bone', 'MODERATE', 'EN ROUTE', '24 min', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8), const Color(0xFF2563EB), Colors.white),
                _buildQueueCard('SM', 'Sania Mirza', 'Allergic Anaphylaxis', 'CRITICAL', 'ARRIVED', '5 min', const Color(0xFFFEE2E2), const Color(0xFFDC2626), const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _buildQueueCard('HA', 'Hamza Ali', 'High Grade Fever (103°F)', 'MODERATE', 'INCOMING', '42 min', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8), const Color(0xFFE0E7FF), const Color(0xFF3730A3)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFDC2626),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF475569),
        showUnselectedLabels: true,
        currentIndex: 1, // Queue
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildQueueCard(String initials, String name, String details, String severity, String status, String time, Color avatarBg, Color avatarText, Color statusBg, Color statusText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: avatarBg,
            child: Text(initials, style: TextStyle(color: avatarText, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(color: Color(0xFF475569))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: severity == 'CRITICAL' ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: severity == 'CRITICAL' ? const Color(0xFFFCA5A5) : const Color(0xFF93C5FD)),
                      ),
                      child: Text(severity, style: TextStyle(color: severity == 'CRITICAL' ? const Color(0xFF991B1B) : const Color(0xFF1E3A8A), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(status, style: TextStyle(color: statusText, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, size: 14, color: statusText),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
