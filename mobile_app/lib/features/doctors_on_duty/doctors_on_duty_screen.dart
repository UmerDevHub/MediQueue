import 'package:flutter/material.dart';

class DoctorsOnDutyScreen extends StatefulWidget {
  const DoctorsOnDutyScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsOnDutyScreen> createState() => _DoctorsOnDutyScreenState();
}

class _DoctorsOnDutyScreenState extends State<DoctorsOnDutyScreen> {
  bool _zainabDuty = true;
  bool _arshadDuty = true;
  bool _mariamDuty = false;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Staff Directory', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text('Manage active duty status and daily schedules.', style: TextStyle(color: Color(0xFF475569))),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('ACTIVE NOW', style: TextStyle(color: Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('12 Doctors', style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('TOTAL QUEUE', style: TextStyle(color: Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        // Refactored Patients -> Users based on domain directive
                        Text('48 Users', style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or specialty...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 24),
            _buildDoctorCard('Dr. Zainab Abbas', 'Cardiology Specialist', 'https://i.pravatar.cc/150?img=9', '08 Today', '02:30 PM', _zainabDuty, (val) => setState(() => _zainabDuty = val)),
            _buildDoctorCard('Dr. Arshad Khan', 'Orthopedics', 'https://i.pravatar.cc/150?img=11', '12 Today', '01:15 PM', _arshadDuty, (val) => setState(() => _arshadDuty = val)),
            _buildDoctorCard('Dr. Mariam Farooq', 'Pediatrics', 'https://i.pravatar.cc/150?img=5', '00 Today', 'N/A', _mariamDuty, (val) => setState(() => _mariamDuty = val), isOffDutyVisual: !_mariamDuty),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                minimumSize: const Size(double.infinity, 56),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Add New Staff', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF475569),
        showUnselectedLabels: true,
        currentIndex: 2, // Staff
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Staff'), // Replaced Doctors with Staff as per design icon
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(String name, String specialty, String imageUrl, String appointments, String nextSlot, bool isOnDuty, ValueChanged<bool> onChanged, {bool isOffDutyVisual = false}) {
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
              Opacity(
                opacity: isOffDutyVisual ? 0.5 : 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isOffDutyVisual ? const Color(0xFF94A3B8) : const Color(0xFF0F172A))),
                    Text(specialty, style: TextStyle(color: isOffDutyVisual ? const Color(0xFF94A3B8) : const Color(0xFF475569))),
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: isOnDuty,
                    activeColor: const Color(0xFF2563EB),
                    onChanged: onChanged,
                  ),
                  Text(isOnDuty ? 'On Duty' : 'Off Duty', style: TextStyle(color: isOnDuty ? const Color(0xFF1D4ED8) : const Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('APPOINTMENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: isOffDutyVisual ? const Color(0xFF94A3B8) : const Color(0xFF1D4ED8)),
                      const SizedBox(width: 4),
                      Text(appointments, style: TextStyle(fontWeight: FontWeight.bold, color: isOffDutyVisual ? const Color(0xFF94A3B8) : const Color(0xFF0F172A))),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NEXT SLOT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: isOffDutyVisual ? const Color(0xFF94A3B8) : const Color(0xFF0F172A)),
                      const SizedBox(width: 4),
                      Text(nextSlot, style: TextStyle(fontWeight: FontWeight.bold, color: isOffDutyVisual ? const Color(0xFF94A3B8) : const Color(0xFF0F172A))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
