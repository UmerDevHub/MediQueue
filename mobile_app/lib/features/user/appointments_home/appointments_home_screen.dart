import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppointmentsHomeScreen extends StatelessWidget {
  const AppointmentsHomeScreen({Key? key}) : super(key: key);

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
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Doctor Appointments', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 8),
                const Text('Find and book verified healthcare specialists in your area.', style: TextStyle(color: Color(0xFF475569))),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('NEW BOOKING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search doctors, hospitals, or specialties...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', true),
                        _buildFilterChip('Cardiology', false),
                        _buildFilterChip('General', false),
                        _buildFilterChip('Neurology', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDoctorCard(context, 'Dr. Ayesha Khan', 'Jinnah Hospital, Karachi', 'CARDIOLOGY', 'https://i.pravatar.cc/150?img=5', true),
                _buildDoctorCard(context, 'Dr. Mustafa Shah', 'Aga Khan University Hospital', 'NEUROLOGY', 'https://i.pravatar.cc/150?img=8', true),
                _buildDoctorCard(context, 'Dr. Zainab Abbas', 'South City Hospital', 'ORTHOPEDICS', 'https://i.pravatar.cc/150?img=9', true, badgeColor: const Color(0xFFFEE2E2), badgeTextColor: const Color(0xFF991B1B)),
                _buildDoctorCard(context, 'Dr. Usman Malik', 'Civil Hospital, Quetta', 'GENERAL PHYSICIAN', 'https://i.pravatar.cc/150?img=11', true, badgeColor: const Color(0xFFDCFCE7), badgeTextColor: const Color(0xFF166534)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF64748B),
        showUnselectedLabels: true,
        currentIndex: 2, // Highlight Bookings
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2563EB) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF0F172A), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, String name, String hospital, String specialty, String imageUrl, bool available, {Color badgeColor = const Color(0xFFE0E7FF), Color badgeTextColor = const Color(0xFF1D4ED8)}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                        child: Text(specialty, style: TextStyle(color: badgeTextColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    Text(hospital, style: const TextStyle(color: Color(0xFF475569))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text('Available Today', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                onPressed: () => context.push('/doctor_detail'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
