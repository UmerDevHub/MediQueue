import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({Key? key}) : super(key: key);

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final res = await _supabase
          .from('appointments')
          .select('*, users(first_name, last_name)')
          .eq('doctor_id', user.id)
          .order('appointment_time', ascending: true);
      if (mounted) {
        setState(() {
          _appointments = res;
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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF0F172A)),
          onPressed: () {},
        ),
        title: const Text('Appointments', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Color(0xFF0F172A)), onPressed: () {}),
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('FA', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold))),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text('November 2023', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_left, color: Color(0xFF475569)),
                    Icon(Icons.chevron_right, color: Color(0xFF475569)),
                  ],
                ),
                const Text('Today', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDateItem('MON', '18', false),
                _buildDateItem('TUE', '19', true),
                _buildDateItem('WED', '20', false),
                _buildDateItem('THU', '21', false),
                _buildDateItem('FRI', '22', false),
                _buildDateItem('SAT', '23', false),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTimelineSlot('09:00', false,
                    _buildAppointmentCard('AH', 'Ahmed Hassan', 'Post-Op Consultation', 'Completed', '30 mins', const Color(0xFFE0E7FF), const Color(0xFFDCFCE7), const Color(0xFF166534))),
                _buildTimelineSlot('10:00', true,
                    _buildAppointmentCard('ZM', 'Zainab Malik', 'General Checkup', 'In Progress', 'Live Now', const Color(0xFF2563EB), const Color(0xFFDBEAFE), const Color(0xFF1D4ED8), isPrimary: true, textColor: Colors.white)),
                _buildTimelineSlot('11:00', false, _buildAvailableSlot()),
                _buildTimelineSlot('12:00', false,
                    _buildAppointmentCard('RK', 'Rizwan Khan', 'Follow-up: Lab Results', 'Pending', '15 mins', const Color(0xFF475569), const Color(0xFFFEF08A), const Color(0xFF854D0E), textColor: Colors.white)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('LUNCH BREAK', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, letterSpacing: 1))),
                ),
                _buildTimelineSlot('13:00', false, const SizedBox.shrink(), isLineOnly: true),
                _buildTimelineSlot('14:00', false, _buildAvailableSlot()),
              ],
            ),
          ),
        ],
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

  Widget _buildDateItem(String day, String date, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 60,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1D4ED8) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(color: isSelected ? Colors.white70 : const Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF0F172A), fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTimelineSlot(String time, bool isActive, Widget content, {bool isLineOnly = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: const Color(0xFFBFDBFE), width: 3) : null,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(String initials, String name, String subtitle, String status, String duration, Color avatarColor, Color statusBg, Color statusText, {bool isPrimary = false, Color textColor = const Color(0xFF1D4ED8)}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPrimary ? const Color(0xFF2563EB) : Colors.grey.shade300, width: isPrimary ? 2 : 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            child: Text(initials, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(subtitle, style: const TextStyle(color: Color(0xFF475569))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: statusText, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Text(duration, style: TextStyle(color: isPrimary ? const Color(0xFF2563EB) : const Color(0xFF0F172A), fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSlot() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add_circle_outline, color: Color(0xFF64748B)),
          SizedBox(width: 8),
          Text('AVAILABLE SLOT', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
