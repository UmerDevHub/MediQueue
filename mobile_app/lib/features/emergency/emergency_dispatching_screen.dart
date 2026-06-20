import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../auth/providers/auth_provider.dart';
import 'providers/emergency_provider.dart';

class EmergencyDispatchingScreen extends ConsumerStatefulWidget {
  const EmergencyDispatchingScreen({super.key});

  @override
  ConsumerState<EmergencyDispatchingScreen> createState() => _EmergencyDispatchingScreenState();
}

class _EmergencyDispatchingScreenState extends ConsumerState<EmergencyDispatchingScreen> {
  String _statusText = 'Initializing GPS coordinates...';
  int _statusIndex = 0;
  final List<String> _statusPhases = [
    'Initializing GPS coordinates...',
    'Locating nearest emergency hospitals...',
    'Analyzing current queue sizes and traffic...',
    'Running smart ML load factor prediction...',
    'Securing priority token from hospital triage...',
  ];

  @override
  void initState() {
    super.initState();
    _startStatusRotation();
    _startDispatch();
  }

  void _startStatusRotation() async {
    while (mounted && _statusIndex < _statusPhases.length - 1) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      setState(() {
        _statusIndex++;
        _statusText = _statusPhases[_statusIndex];
      });
    }
  }

  void _startDispatch() async {
    // Wait brief duration for entry animations to settle
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    final authState = ref.read(authProvider);
    final userId = authState.user?.id ?? '';

    // Trigger API call
    final success = await ref.read(emergencyProvider.notifier).triggerEmergency(userId: userId);

    if (success && mounted) {
      // Allow the scanning animation to complete gracefully
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        context.go('/emergency_result');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emergencyState = ref.watch(emergencyProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Radar Sonar Pulsing animation
              Center(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Pulse Ring 3
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.04),
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(begin: const Offset(0.6, 0.6), end: const Offset(1.0, 1.0), duration: 2000.ms, curve: Curves.easeOut)
                       .fadeOut(duration: 2000.ms),

                      // Outer Pulse Ring 2
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0), duration: 2000.ms, delay: 500.ms, curve: Curves.easeOut)
                       .fadeOut(duration: 2000.ms),

                      // Outer Pulse Ring 1
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(begin: const Offset(0.4, 0.4), end: const Offset(1.0, 1.0), duration: 2000.ms, delay: 1000.ms, curve: Curves.easeOut)
                       .fadeOut(duration: 2000.ms),

                      // Core solid pulsar
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.danger.withValues(alpha: 0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.radar_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                       .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 800.ms, curve: Curves.easeInOut),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Title Header
              Text(
                'DISPATCHING ROUTE',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.2,
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 12),

              // Animated Phase Text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _statusText,
                  key: ValueKey<String>(_statusText),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Linear Progress Tracker
              if (emergencyState.error == null)
                SizedBox(
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation(AppColors.danger),
                      minHeight: 4,
                    ),
                  ),
                ),
              
              const Spacer(),

              // Error Widget (if dispatch fails)
              if (emergencyState.error != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              emergencyState.error!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.go('/emergency_trigger'),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _statusIndex = 0;
                                _statusText = _statusPhases[0];
                              });
                              _startStatusRotation();
                              _startDispatch();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.danger,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: Text(
                              'Retry Dispatch',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ).animate().slideY(begin: 0.2, end: 0, duration: 300.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
