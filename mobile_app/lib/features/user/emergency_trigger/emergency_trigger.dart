import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyTriggerScreen extends StatefulWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  _EmergencyTriggerScreenState createState() => _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState extends State<EmergencyTriggerScreen> {
  double _severity = 5;
  bool _needAmbulance = true;
  final _symptomsController = TextEditingController();

  Color _getSeverityColor() {
    if (_severity < 4) return const Color(0xFF16A34A); // Green
    if (_severity < 7) return const Color(0xFFD97706); // Amber
    return const Color(0xFFDC2626); // Red
  }

  String _getSeverityLabel() {
    if (_severity < 4) return "Mild";
    if (_severity < 7) return "Moderate";
    return "Critical";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC2626),
        title: Text('Describe Emergency',
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Symptoms',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A))),
            const SizedBox(height: 8),
            TextField(
              controller: _symptomsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your symptoms...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
            const SizedBox(height: 24),
            Text('Severity: ${_getSeverityLabel()} (${_severity.toInt()}/10)',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getSeverityColor())),
            Slider(
              value: _severity,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: _getSeverityColor(),
              onChanged: (val) => setState(() => _severity = val),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Require Ambulance?',
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Switch(
                    value: _needAmbulance,
                    activeThumbColor: const Color(0xFFDC2626),
                    onChanged: (val) => setState(() => _needAmbulance = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(
                children: [
                  const Icon(Icons.my_location, color: Color(0xFF2563EB)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location Auto-Detected',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        Text('Sector 10, Islamabad',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Color(0xFF16A34A)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Route to live tracker
                Navigator.pushReplacementNamed(context, '/live_tracker');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.airport_shuttle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Dispatch Emergency',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
