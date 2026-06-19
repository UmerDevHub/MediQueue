import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class DoctorsOnDutyScreen extends StatefulWidget {
  const DoctorsOnDutyScreen({super.key});

  @override
  State<DoctorsOnDutyScreen> createState() => _DoctorsOnDutyScreenState();
}

class _DoctorsOnDutyScreenState extends State<DoctorsOnDutyScreen> {
  int _currentIndex = 2;
  bool _doc1OnDuty = true;
  bool _doc2OnDuty = true;
  bool _doc3OnDuty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primary),
          onPressed: () {},
        ),
        title: const Text(
          'MediQueue',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.person, color: AppColors.textMuted, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Staff Directory', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Manage active duty status and daily schedules.', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
            const SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('ACTIVE NOW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                        SizedBox(height: 4),
                        Text('12 Doctors', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('TOTAL QUEUE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                        SizedBox(height: 4),
                        Text('48 Users', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: AppColors.textMuted),
                  hintText: 'Search by name or specialty...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Doctor List
            _buildDoctorCard('Dr. Zainab Abbas', 'Cardiology Specialist', '08 Today', '02:30 PM', _doc1OnDuty, (val) => setState(() => _doc1OnDuty = val)),
            const SizedBox(height: 12),
            _buildDoctorCard('Dr. Arshad Khan', 'Orthopedics', '12 Today', '01:15 PM', _doc2OnDuty, (val) => setState(() => _doc2OnDuty = val)),
            const SizedBox(height: 12),
            _buildDoctorCard('Dr. Mariam Farooq', 'Pediatrics', '00 Today', 'N/A', _doc3OnDuty, (val) => setState(() => _doc3OnDuty = val)),
            const SizedBox(height: 24),

            // Add new staff button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 56),
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
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 0) context.go('/admin_home');
          if (i == 1) context.push('/live_queue');
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Doctors'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(String name, String spec, String appts, String nextSlot, bool isOnDuty, ValueChanged<bool> onToggle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Opacity(
        opacity: isOnDuty ? 1.0 : 0.6,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: AppColors.textMuted, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text(spec, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Switch(
                      value: isOnDuty,
                      onChanged: onToggle,
                      activeColor: AppColors.primary,
                    ),
                    Text(
                      isOnDuty ? 'On Duty' : 'Off Duty',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isOnDuty ? AppColors.primary : AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('APPOINTMENTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.event_note, color: isOnDuty ? AppColors.primary : AppColors.textMuted, size: 18),
                          const SizedBox(width: 8),
                          Text(appts, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NEXT SLOT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(isOnDuty ? Icons.schedule : Icons.block, color: isOnDuty ? const Color(0xFF46566C) : AppColors.textMuted, size: 18),
                          const SizedBox(width: 8),
                          Text(nextSlot, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
