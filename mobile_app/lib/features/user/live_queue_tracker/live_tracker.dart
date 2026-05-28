import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveTrackerScreen extends StatelessWidget {
  const LiveTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Live Tracker',
            style: GoogleFonts.inter(
                color: const Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: Column(
        children: [
          // Map Placeholder (Maps require billing API keys, so we use a visual placeholder)
          Container(
            height: 200,
            width: double.infinity,
            color: const Color(0xFFE2E8F0),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: Color(0xFF64748B)),
                  SizedBox(height: 8),
                  Text('Live Map Tracking Active',
                      style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Queue Position
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF2563EB), width: 4)),
                          child: Text('3rd',
                              style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2563EB))),
                        ),
                        const SizedBox(height: 8),
                        Text('in Queue',
                            style: GoogleFonts.inter(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text('Status Timeline',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  _buildTimelineItem(Icons.check_circle, 'Accepted', '10:42 AM',
                      const Color(0xFF16A34A)),
                  _buildTimelineItem(Icons.airport_shuttle, 'En Route',
                      '10:45 AM', const Color(0xFFD97706)),
                  _buildTimelineItem(Icons.radio_button_unchecked, 'Arrived',
                      '--:--', const Color(0xFFE2E8F0)),

                  const Spacer(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, '/user_home'),
                    child: Text('Cancel / Back to Home',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      IconData icon, String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
              child: Text(title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A)))),
          Text(time, style: GoogleFonts.inter(color: const Color(0xFF64748B))),
        ],
      ),
    );
  }
}
