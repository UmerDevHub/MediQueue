import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class HospitalAdminDashboardScreen extends StatefulWidget {
  const HospitalAdminDashboardScreen({super.key});

  @override
  State<HospitalAdminDashboardScreen> createState() => _HospitalAdminDashboardScreenState();
}

class _HospitalAdminDashboardScreenState extends State<HospitalAdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primary),
          onPressed: () {},
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Jinnah Hospital', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('MediQueue Admin', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Dr. Faisal Ahmed', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Chief Administrator', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                    color: AppColors.surface,
                  ),
                  child: const Icon(Icons.person, color: AppColors.textMuted, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Alert Banner
            GestureDetector(
              onTap: () => context.push('/emergency_alert'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  border: Border.all(color: AppColors.danger),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emergency, color: AppColors.danger, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('EMERGENCY ALERT', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger, fontSize: 12, letterSpacing: 1.0)),
                          Text('2 incoming emergencies', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.danger),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2x2 Stats Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard('Current Queue', '18', Icons.reorder, AppColors.danger, '+12%', 'Live updates'),
                _buildStatCard('Active Doctors', '12', Icons.medical_services, AppColors.primary, 'Stable', 'On duty now'),
                _buildStatCard('Appointments', '45', Icons.calendar_today, const Color(0xFF46566C), '85% Filled', 'Scheduled today'),
                _buildStatCard('Avg Wait Time', '15m', Icons.schedule, Colors.orange, '-2m', 'Target: 10m'),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions
            const Text('QUICK ACTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.0)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAction('Manage Queue', Icons.list_alt, true, () => context.push('/live_queue')),
                  const SizedBox(width: 16),
                  _buildQuickAction('View Doctors', Icons.group, false, () => context.push('/doctors_on_duty')),
                  const SizedBox(width: 16),
                  _buildQuickAction('Reports', Icons.bar_chart, false, () {}),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Critical Monitoring
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('CRITICAL MONITORING', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1.0)),
                Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            _buildPatientCard('Zubair Ahmed', 'MRN: #JH-9923 • Cardiac', 'Incoming', 'ETA: 5m', true),
            const SizedBox(height: 12),
            _buildPatientCard('Sara Malik', 'MRN: #JH-8812 • Trauma', 'Arrived', 'Wait: 2m', false),
            
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) context.push('/live_queue');
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String badge, String subtitle) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(badge, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 1.0)),
              Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary ? null : Border.all(color: AppColors.border),
          boxShadow: isPrimary ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))] : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isPrimary ? Colors.white : AppColors.textPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(String name, String details, String status, String eta, bool isIncoming) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isIncoming ? AppColors.danger.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                ),
                child: Icon(Icons.person, color: isIncoming ? AppColors.danger : AppColors.primary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(details, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isIncoming ? AppColors.danger.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isIncoming ? AppColors.danger : AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text(eta, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
