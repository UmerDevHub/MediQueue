import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class LiveQueueScreen extends StatefulWidget {
  const LiveQueueScreen({super.key});

  @override
  State<LiveQueueScreen> createState() => _LiveQueueScreenState();
}

class _LiveQueueScreenState extends State<LiveQueueScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMuted),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'MediQueue',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textMuted),
            onPressed: () {},
          ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    const Text('Emergency Queue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.sort, size: 16, color: AppColors.textMuted),
                      SizedBox(width: 4),
                      Text('PRIORITY SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                _buildQueueCard('Zubair Ahmed', 'ZA', 'Severe Chest Pain, Tachycardia', '12 min', true, 'Incoming'),
                const SizedBox(height: 12),
                _buildQueueCard('Noman Khan', 'NK', 'Fractured Radial Bone', '24 min', false, 'En Route'),
                const SizedBox(height: 12),
                _buildQueueCard('Sania Mirza', 'SM', 'Allergic Anaphylaxis', '5 min', true, 'Arrived'),
                const SizedBox(height: 12),
                _buildQueueCard('Hamza Ali', 'HA', 'High Grade Fever (103°F)', '42 min', false, 'Incoming'),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.danger,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 0) context.go('/admin_home');
          if (i == 2) context.push('/doctors_on_duty');
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

  Widget _buildQueueCard(String name, String initials, String details, String time, bool isCritical, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCritical ? AppColors.danger.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isCritical ? AppColors.danger : AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                    Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCritical ? AppColors.danger.withOpacity(0.1) : const Color(0xFFE9F0FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isCritical ? AppColors.danger.withOpacity(0.2) : AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Text(
                        isCritical ? 'CRITICAL' : 'MODERATE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isCritical ? AppColors.danger : const Color(0xFF38485D)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'Arrived' ? const Color(0xFFD1FAE5) : (isCritical ? AppColors.primary.withOpacity(0.1) : AppColors.primary.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: status == 'Arrived' ? const Color(0xFF10B981).withOpacity(0.2) : AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            status.toUpperCase(),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: status == 'Arrived' ? const Color(0xFF065F46) : AppColors.primary),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.expand_more, size: 14, color: status == 'Arrived' ? const Color(0xFF065F46) : AppColors.primary),
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
