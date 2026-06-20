import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import 'providers/emergency_provider.dart';

class EmergencyTriggerScreen extends ConsumerStatefulWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  ConsumerState<EmergencyTriggerScreen> createState() => _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState extends ConsumerState<EmergencyTriggerScreen>
    with SingleTickerProviderStateMixin {
  final _symptomsController = TextEditingController();
  late AnimationController _holdController;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerSOS();
      }
    });
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _holdController.dispose();
    super.dispose();
  }

  void _triggerSOS() async {
    setState(() {
      _isHolding = false;
    });
    
    // Save symptoms in provider
    ref.read(emergencyProvider.notifier).setSymptoms(_symptomsController.text);
    
    // Reset holding animation
    _holdController.reset();

    // Navigate to dispatching screen
    context.go('/emergency_dispatching');
  }

  Color _getSeverityColor(double score) {
    if (score < 4.0) return AppColors.success;
    if (score < 8.0) return AppColors.warning;
    return AppColors.danger;
  }

  String _getSeverityLabel(double score) {
    if (score < 4.0) return 'Mild / Urgent Care';
    if (score < 8.0) return 'Severe / High Priority';
    return 'Critical / Life-Threatening';
  }

  @override
  Widget build(BuildContext context) {
    final emergencyState = ref.watch(emergencyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/user_home'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.background,
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border, width: 0.8),
            ),
          ),
        ),
        title: Text(
          'Emergency SOS',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SOS Header Alert Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This will trigger an immediate emergency dispatch and route you to the nearest hospital.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.danger,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),

              // Symptoms input card
              Text(
                'Identify Symptoms',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _symptomsController,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Describe current symptoms (e.g. Chest pain, difficulty breathing, allergic reaction...)',
                  hintStyle: GoogleFonts.inter(color: AppColors.textSecondary.withValues(alpha: 0.6), fontSize: 13.5),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border, width: 0.8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border, width: 0.8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 24),

              // Severity Score Slider Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Severity Level',
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(emergencyState.severityScore).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            emergencyState.severityScore.toStringAsFixed(0),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _getSeverityColor(emergencyState.severityScore),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: _getSeverityColor(emergencyState.severityScore),
                        inactiveTrackColor: AppColors.background,
                        thumbColor: _getSeverityColor(emergencyState.severityScore),
                        overlayColor: _getSeverityColor(emergencyState.severityScore).withValues(alpha: 0.12),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        value: emergencyState.severityScore,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        onChanged: (val) {
                          ref.read(emergencyProvider.notifier).setSeverityScore(val);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        _getSeverityLabel(emergencyState.severityScore),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _getSeverityColor(emergencyState.severityScore),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),

              // Ambulance Request Toggle Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.airport_shuttle_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request Ambulance',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Dispatches local emergency service.',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: emergencyState.ambulanceRequired,
                      onChanged: (val) => ref.read(emergencyProvider.notifier).setAmbulanceRequired(val),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 250.ms),
              const SizedBox(height: 48),

              // 3-Second Hold Trigger Button
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onLongPressStart: (_) {
                        setState(() {
                          _isHolding = true;
                        });
                        _holdController.forward();
                      },
                      onLongPressEnd: (_) {
                        setState(() {
                          _isHolding = false;
                        });
                        if (_holdController.value < 1.0) {
                          _holdController.reverse();
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _holdController,
                        builder: (context, child) {
                          final progress = _holdController.value;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular Animated Ring Outline
                              SizedBox(
                                width: 140,
                                height: 140,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 6,
                                  backgroundColor: AppColors.border,
                                  valueColor: const AlwaysStoppedAnimation(AppColors.danger),
                                ),
                              ),
                              // Solid Trigger Center Button
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: _isHolding ? 110 : 120,
                                height: _isHolding ? 110 : 120,
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.danger.withValues(
                                        alpha: _isHolding ? 0.6 : 0.35,
                                      ),
                                      blurRadius: _isHolding ? 24 : 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.touch_app_rounded, color: Colors.white, size: 28),
                                    const SizedBox(height: 6),
                                    Text(
                                      'HOLD',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    Text(
                                      '3 SEC',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isHolding ? 'Holding... Keep pressing!' : 'Hold button down to trigger emergency dispatch',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _isHolding ? AppColors.danger : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ).animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
            ],
          ),
        ),
      ),
    );
  }
}
