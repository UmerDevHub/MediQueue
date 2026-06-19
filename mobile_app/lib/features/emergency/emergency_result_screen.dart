import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmergencyResultScreen extends StatelessWidget {
  const EmergencyResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: const Text('MediQueue',
            style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline, color: Color(0xFF166534), size: 48),
            ),
            const SizedBox(height: 24),
            const Text('Dispatched Successfully',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text(
              'Emergency dispatch confirmed. The nearest hospital is preparing for your arrival.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF475569)),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nearest Hospital',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF475569)),
                              SizedBox(width: 4),
                              Text('Calculating...', style: TextStyle(color: Color(0xFF475569))),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(16)),
                        child: const Text('Accepted',
                            style: TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ESTIMATED ARRIVAL',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                      Text('Calculating ETA...',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('QUEUE POSITION',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                      Text('Assigning...', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.map, color: Colors.grey, size: 100)),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(Icons.navigation, color: Color(0xFF2563EB)),
                          SizedBox(width: 8),
                          Text('Live Route Tracking Active',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/live_tracker'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                minimumSize: const Size(double.infinity, 56),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.gps_fixed, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Track Live',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/user_home'),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF8FAFC),
                minimumSize: const Size(double.infinity, 56),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, color: Color(0xFF334155)),
                  SizedBox(width: 8),
                  Text('Back to Home',
                      style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
