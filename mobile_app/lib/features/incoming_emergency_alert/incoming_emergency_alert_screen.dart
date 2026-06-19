import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IncomingEmergencyAlertScreen extends StatefulWidget {
  const IncomingEmergencyAlertScreen({Key? key}) : super(key: key);

  @override
  State<IncomingEmergencyAlertScreen> createState() => _IncomingEmergencyAlertScreenState();
}

class _IncomingEmergencyAlertScreenState extends State<IncomingEmergencyAlertScreen> {
  @override
  void initState() {
    super.initState();
    _listenForEmergencies();
  }

  void _listenForEmergencies() {
    Supabase.instance.client
        .channel('public:incidents_alert')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'incidents',
          callback: (payload) {
            // New emergency received logic here
            print('New emergency incident: \${payload.newRecord}');
          },
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9CA3AF), // Dark grey background for alert
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.medical_services, color: Colors.white, size: 80),
              const SizedBox(height: 24),
              const Text('NEW EMERGENCY INCOMING', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.my_location, color: Colors.white, size: 14),
                    SizedBox(width: 8),
                    Text('ZONE A-4 • EMERGENCY RESPONSE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CLASSIFICATION', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: const [
                                  Text('!', style: TextStyle(color: Color(0xFF991B1B), fontSize: 24, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Text('SEVERITY:\nCRITICAL', style: TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.bold, fontSize: 16, height: 1.2)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('ETA', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            Text('6', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, height: 1.1)),
                            Text('Minutes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('PRIMARY SYMPTOMS', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    const Text('Possible Cardiac Arrest', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.directions_car, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Logistics', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('Ambulance:\nRequired', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.medical_services_outlined, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Unit', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('ALS Team\n02', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // Green accept button
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text('ACCEPT CASE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  minimumSize: const Size(double.infinity, 56),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.call_split, color: Colors.white),
                    SizedBox(width: 8),
                    Text('REDIRECT', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const Text('PROTOCOL: IMMEDIATE DISPATCH REQUIRED', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Icon(Icons.graphic_eq, color: Colors.white70, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}
