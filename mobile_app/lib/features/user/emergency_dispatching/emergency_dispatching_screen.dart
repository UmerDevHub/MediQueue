import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class EmergencyDispatchingScreen extends StatefulWidget {
  const EmergencyDispatchingScreen({super.key});

  @override
  State<EmergencyDispatchingScreen> createState() => _EmergencyDispatchingScreenState();
}

class _EmergencyDispatchingScreenState extends State<EmergencyDispatchingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    
    // Simulate finding hospital
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacement('/emergency_result');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'MediQueue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Emergency Dispatch Protocol',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          width: 150 + (_controller.value * 100),
                          height: 150 + (_controller.value * 100),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.danger.withOpacity(1 - _controller.value),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.danger.withOpacity(0.4),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.emergency, color: Colors.white, size: 40),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Finding nearest available hospital...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'REAL-TIME GRID COORDINATION ACTIVE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildStep(
                      icon: Icons.check,
                      title: 'Location detected',
                      subtitle: 'Jinnah Hospital Sector A-12',
                      isActive: false,
                      isCompleted: true,
                    ),
                    const SizedBox(height: 24),
                    _buildStep(
                      icon: Icons.arrow_forward,
                      title: 'Scanning hospitals',
                      subtitle: 'Looking for available emergency beds',
                      isActive: true,
                      isCompleted: false,
                    ),
                    const SizedBox(height: 24),
                    _buildStep(
                      icon: Icons.pending_outlined,
                      title: 'Assigning hospital',
                      subtitle: 'Pending sync...',
                      isActive: false,
                      isCompleted: false,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.call, color: Colors.white),
                    SizedBox(width: 8),
                    Text('CANCEL & CALL 1122', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
  }) {
    Color iconBgColor = isCompleted ? AppColors.primary.withOpacity(0.1) : (isActive ? AppColors.primary : Colors.transparent);
    Color iconColor = isCompleted ? AppColors.primary : (isActive ? Colors.white : AppColors.textMuted);
    
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
            border: (!isActive && !isCompleted) ? Border.all(color: AppColors.border, width: 2) : null,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: (isActive || isCompleted) ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              if (isActive)
                Container(
                  margin: const EdgeInsets.top: 8,
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
