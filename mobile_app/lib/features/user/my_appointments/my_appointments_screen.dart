import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _supabase = Supabase.instance.client;
  List<dynamic> _appointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final res = await _supabase
          .from('appointments')
          .select('*, doctors(first_name, last_name, specialty, hospital_id)')
          .eq('user_id', user.id);
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
        title: const Text('MediQueue', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('My Appointments', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ),
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF1D4ED8),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorColor: const Color(0xFF1D4ED8),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                tabs: const [
                  Tab(text: 'UPCOMING'),
                  Tab(text: 'PAST'),
                  Tab(text: 'CANCELLED'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(), // Show fetched or mocked for demo if empty
          const Center(child: Text('No past appointments')),
          const Center(child: Text('No cancelled appointments')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF475569),
        showUnselectedLabels: true,
        currentIndex: 2, // Highlight Appointments/Bookings
        onTap: (idx) {
           if (idx == 0) context.go('/user_home');
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAppointmentCard('Dr. Sarah Khan', 'SENIOR CARDIOLOGIST', 'Oct 24, 2023 • 10:30 AM', 'Jinnah General Hospital, Wing B', 'https://i.pravatar.cc/150?img=5'),
        _buildAppointmentCard('Dr. Ahmed Raza', 'PEDIATRICIAN', 'Oct 26, 2023 • 02:15 PM', 'MediClinic Plaza, 4th Floor', 'https://i.pravatar.cc/150?img=8'),
      ],
    );
  }

  Widget _buildAppointmentCard(String name, String specialty, String time, String location, String img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(img, width: 50, height: 50, fit: BoxFit.cover)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    Text(specialty, style: const TextStyle(color: Color(0xFF475569), fontSize: 12, letterSpacing: 1)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(16)),
                child: const Text('Booked', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF475569)),
              const SizedBox(width: 8),
              Text(time, style: const TextStyle(color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF475569)),
              const SizedBox(width: 8),
              Text(location, style: const TextStyle(color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052CC),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reschedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDC2626)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
