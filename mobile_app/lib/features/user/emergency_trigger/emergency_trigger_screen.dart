import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_button.dart';

class EmergencyTriggerScreen extends StatefulWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  State<EmergencyTriggerScreen> createState() => _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState extends State<EmergencyTriggerScreen> {
  double _severity = 5;
  bool _requestAmbulance = true;

  void _dispatchEmergency() async {
    // Show loading/dispatching or navigate to dispatching screen
    context.push('/emergency_dispatching');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.danger,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Describe Your Emergency',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EMERGENCY DETAILS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1)),
                ],
              ),
              child: TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Describe your symptoms...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SEVERITY LEVEL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  _severity.toInt().toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _severity >= 8 ? AppColors.danger : (_severity >= 4 ? AppColors.warning : AppColors.success),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1)),
                ],
              ),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: Colors.white,
                      overlayColor: AppColors.danger.withOpacity(0.2),
                      trackShape: const RectangularSliderTrackShape(),
                      trackHeight: 12,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: const LinearGradient(
                          colors: [AppColors.success, AppColors.warning, AppColors.danger],
                        ),
                      ),
                      child: Slider(
                        value: _severity,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (v) => setState(() => _severity = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Mild', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text('Moderate', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text('Critical', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.airport_shuttle, color: AppColors.danger, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Request Immediate Ambulance', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('Dispatch nearest emergency vehicle', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _requestAmbulance,
                    onChanged: (v) => setState(() => _requestAmbulance = v),
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.danger,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'AUTO-DETECTED LOCATION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1)),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.location_on, color: AppColors.success, size: 20),
                            SizedBox(width: 8),
                            Text('24.8607° N, 67.0011° E', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            const Text('Location Found', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.report_problem_outlined, color: AppColors.danger, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'This will trigger an immediate emergency alert to the nearest MediQueue facility and dispatch emergency responders if selected.',
                      style: TextStyle(fontSize: 13, color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _dispatchEmergency,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.emergency_share, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Dispatch Emergency',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
