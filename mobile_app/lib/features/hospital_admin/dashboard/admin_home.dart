import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A), // Dark Admin Theme
        elevation: 0,
        title: Text('City Hospital Admin',
            style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EMERGENCY ALERT BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(220, 38, 38, 0.4),
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2 INCOMING EMERGENCIES',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Critical users en route',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFDC2626)),
                    onPressed: () {},
                    child: const Text('VIEW'),
                  )
                ],
              ),
            ),

            // STAT CARDS GRID
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard('Current Queue', '15',
                    const Color(0xFFDC2626)), // Red if > 15
                _buildStatCard(
                    'Active Doctors', '8', const Color(0xFF16A34A)), // Green
                _buildStatCard(
                    'Appointments', '42', const Color(0xFF2563EB)), // Blue
                _buildStatCard(
                    'Avg Wait', '18m', const Color(0xFFD97706)), // Amber
              ],
            ),
            const SizedBox(height: 24),

            Text('Quick Actions',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A))),
            const SizedBox(height: 16),

            // ACTION BUTTONS
            _buildActionButton(Icons.list_alt, 'Manage Live Queue',
                const Color(0xFF2563EB), () {}),
            const SizedBox(height: 12),
            _buildActionButton(Icons.medical_services, 'View Doctors on Duty',
                const Color(0xFF16A34A), () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF64748B))),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color)),
            const SizedBox(width: 16),
            Text(title,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A))),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
