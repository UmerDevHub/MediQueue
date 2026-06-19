import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Jinnah Hospital', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold, fontSize: 18)),
            Text('MediQueue Admin', style: TextStyle(color: Color(0xFF475569), fontSize: 12)),
          ],
        ),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDC2626)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emergency, color: Color(0xFFDC2626), size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('EMERGENCY ALERT', style: TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('2 incoming emergencies', style: TextStyle(color: Color(0xFF7F1D1D), fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Color(0xFF991B1B)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildStatCard(Icons.menu, 'CURRENT QUEUE', '18', 'Live updates', badge: '+12%', iconColor: const Color(0xFFDC2626)),
                _buildStatCard(Icons.medical_services_outlined, 'ACTIVE DOCTORS', '12', 'On duty now', badge: 'Stable', badgeColor: const Color(0xFFDBEAFE), badgeTextColor: const Color(0xFF1D4ED8), iconColor: const Color(0xFF2563EB)),
                _buildStatCard(Icons.calendar_today, 'APPOINTMENTS', '45', 'Scheduled today', badge: '85% Filled', badgeColor: const Color(0xFFF1F5F9), badgeTextColor: const Color(0xFF0F172A), iconColor: const Color(0xFF475569)),
                _buildStatCard(Icons.access_time, 'AVG WAIT TIME', '15m', 'Target: 10m', badge: '-2m', badgeColor: const Color(0xFFFEF3C7), badgeTextColor: const Color(0xFFD97706), iconColor: const Color(0xFFD97706), valueColor: const Color(0xFFD97706)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('QUICK ACTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.list_alt, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Manage Queue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2E8F0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.people_outline, color: Color(0xFF0F172A)),
                        SizedBox(width: 8),
                        Text('View Doctors', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CRITICAL MONITORING', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold))),
              ],
            ),
            _buildMonitorCard('Zubair Ahmed', 'MRN: #JH-9923 • Cardiac', 'INCOMING', 'ETA: 5m', const Color(0xFFFEE2E2), const Color(0xFFDC2626), const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
            const SizedBox(height: 12),
            _buildMonitorCard('Sara Malik', 'MRN: #JH-8812 • Trauma', 'ARRIVED', 'Wait: 2m', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8), const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF475569),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), label: 'Doctors'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, String subtitle, {String? badge, Color? badgeColor, Color? badgeTextColor, Color? iconColor, Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor ?? const Color(0xFF0F172A), size: 24),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: badgeColor ?? const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)),
                  child: Text(badge, style: TextStyle(color: badgeTextColor ?? const Color(0xFF991B1B), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: valueColor ?? const Color(0xFF0F172A))),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildMonitorCard(String name, String details, String status, String timeInfo, Color avatarBg, Color avatarIcon, Color statusBg, Color statusText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: avatarBg, child: Icon(Icons.person_outline, color: avatarIcon)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(details, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusText, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              Text(timeInfo, style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
            ],
          ),
        ],
      ),
    );
  }
}
