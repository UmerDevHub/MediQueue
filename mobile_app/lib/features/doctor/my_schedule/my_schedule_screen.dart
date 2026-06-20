import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

// ============================================================================
// 1. CLINIC TIMELINE PAINTER
// ============================================================================

class ClinicSessionTimelinePainter extends CustomPainter {
  final double currentHourPercentage; // Current time (0.0 to 1.0 representation of 9 AM - 9 PM)
  final List<Rect> blockedRanges; // Normalized coordinates for custom blocks
  final Color primaryColor;

  ClinicSessionTimelinePainter({
    required this.currentHourPercentage,
    required this.blockedRanges,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double padding = 12.0;
    final double timelineWidth = size.width - 2 * padding;
    final double timelineHeight = 16.0;
    final double yOffset = size.height / 2 - timelineHeight / 2;

    // Track background
    final bgPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    
    final trackRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(padding, yOffset, timelineWidth, timelineHeight),
      const Radius.circular(8),
    );
    canvas.drawRRect(trackRRect, bgPaint);

    // Draw blocked ranges (e.g. Lunch breaks, meetings)
    final blockPaint = Paint()
      ..color = Colors.amber.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    
    final blockBorderPaint = Paint()
      ..color = Colors.amber[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final rect in blockedRanges) {
      final double startX = padding + rect.left * timelineWidth;
      final double endX = padding + rect.right * timelineWidth;
      final blockRect = Rect.fromLTRB(startX, yOffset, endX, yOffset + timelineHeight);
      canvas.drawRect(blockRect, blockPaint);
      canvas.drawRect(blockRect, blockBorderPaint);
    }

    // Active session progress fill
    final activeProgressWidth = timelineWidth * currentHourPercentage;
    final activePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    
    if (activeProgressWidth > 0) {
      final activeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(padding, yOffset, activeProgressWidth, timelineHeight),
        const Radius.circular(8),
      );
      canvas.drawRRect(activeRect, activePaint);
    }

    // Current Time indicator pin
    final double pinX = padding + timelineWidth * currentHourPercentage;
    final pinPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(pinX, yOffset + timelineHeight / 2), 7.0, pinPaint);

    final pinGlow = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(pinX, yOffset + timelineHeight / 2), 12.0, pinGlow);
  }

  @override
  bool shouldRepaint(covariant ClinicSessionTimelinePainter oldDelegate) {
    return oldDelegate.currentHourPercentage != currentHourPercentage ||
        oldDelegate.blockedRanges != blockedRanges ||
        oldDelegate.primaryColor != primaryColor;
  }
}

// ============================================================================
// 2. MAIN SCHEDULE SCREEN
// ============================================================================

class MyScheduleScreen extends ConsumerStatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  ConsumerState<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends ConsumerState<MyScheduleScreen> {
  // Weekly operating days status
  final Map<String, bool> _workingDays = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': false,
    'Sunday': false,
  };

  // Shifts timings
  String _morningTime = '09:00 AM - 01:00 PM';
  String _afternoonTime = '02:00 PM - 05:00 PM';
  String _eveningTime = '06:00 PM - 09:00 PM';

  bool _morningActive = true;
  bool _afternoonActive = true;
  bool _eveningActive = false;

  // Selected schedule tab for previewing
  String _selectedDayTab = 'Monday';

  // Custom block times on the timeline
  final List<Rect> _timelineBlocks = [
    const Rect.fromLTRB(0.33, 0, 0.42, 0), // Lunch Break: 1:00 PM - 2:00 PM (approx)
    const Rect.fromLTRB(0.66, 0, 0.72, 0), // Shift Handover Break: 5:00 PM - 6:00 PM
  ];

  void _showAddBlockDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String title = 'Lunch Break';
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Block Schedule Slot',
            style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Specify a period during which patients cannot book tickets (e.g. surgery, ward rounds, rest):',
                style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary, height: 1.45),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: 'Lunch Break',
                decoration: InputDecoration(
                  labelText: 'Block Reason',
                  labelStyle: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Lunch Break', child: Text('Lunch / Rest Break')),
                  DropdownMenuItem(value: 'Surgical Operations', child: Text('Surgical Procedures')),
                  DropdownMenuItem(value: 'Clinical Seminar', child: Text('Staff Meeting / Seminar')),
                ],
                onChanged: (val) {
                  if (val != null) title = val;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully blocked slot: $title'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Apply Block', style: GoogleFonts.inter(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysList = _workingDays.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildScheduleHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Interactive Weekday Tab Select
                    _buildWeekdaySelector(daysList),

                    const SizedBox(height: 24),

                    // B. Custom painted timeline visual
                    _buildTimelinePanel(),

                    const SizedBox(height: 24),

                    // C. Shift Toggles Section
                    _buildShiftTogglesSection(),

                    const SizedBox(height: 28),

                    // D. Custom Block Action Card
                    _buildCustomBlockActionCard(),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildDoctorBottomNavBar(context, 1),
    );
  }

  Widget _buildScheduleHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Shift Schedule',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'Control daily OPD consultation shifts and block hours.',
            style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdaySelector(List<String> days) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operating Days Configuration',
          style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isActive = _workingDays[day] ?? false;
              final isSelected = _selectedDayTab == day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDayTab = day;
                  });
                },
                child: Container(
                  width: 82,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.substring(0, 3).toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Active Dot or indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.success : Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isActive ? 'Open' : 'Off',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mark $_selectedDayTab as Working Day',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            Switch.adaptive(
              value: _workingDays[_selectedDayTab] ?? false,
              onChanged: (val) {
                setState(() {
                  _workingDays[_selectedDayTab] = val;
                });
              },
              activeTrackColor: AppColors.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelinePanel() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_selectedDayTab Daily Timeline',
                style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              Text(
                '9:00 AM - 9:00 PM',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Timeline painter canvas
          SizedBox(
            width: double.infinity,
            height: 38,
            child: CustomPaint(
              painter: ClinicSessionTimelinePainter(
                currentHourPercentage: 0.35, // Simulated middle of shift
                blockedRanges: _timelineBlocks,
                primaryColor: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Legend row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('Consulting Hours', AppColors.primary.withValues(alpha: 0.35)),
              _buildLegendItem('Rest/Lunch Breaks', Colors.amber.withValues(alpha: 0.3)),
              _buildLegendItem('Current Time', AppColors.primary, isCircle: true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {bool isCircle = false}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildShiftTogglesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operating Shift Slots',
          style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        
        _buildShiftRow(
          title: 'Morning OPD Shift',
          timings: _morningTime,
          isActive: _morningActive,
          icon: Icons.light_mode_rounded,
          iconColor: Colors.orangeAccent,
          onChanged: (val) {
            setState(() {
              _morningActive = val;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildShiftRow(
          title: 'Afternoon OPD Shift',
          timings: _afternoonTime,
          isActive: _afternoonActive,
          icon: Icons.wb_twilight_rounded,
          iconColor: Colors.deepOrangeAccent,
          onChanged: (val) {
            setState(() {
              _afternoonActive = val;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildShiftRow(
          title: 'Evening OPD Shift',
          timings: _eveningTime,
          isActive: _eveningActive,
          icon: Icons.dark_mode_rounded,
          iconColor: Colors.indigoAccent,
          onChanged: (val) {
            setState(() {
              _eveningActive = val;
            });
          },
        ),
      ],
    );
  }

  Widget _buildShiftRow({
    required String title,
    required String timings,
    required bool isActive,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  timings,
                  style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isActive,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          )
        ],
      ),
    );
  }

  Widget _buildCustomBlockActionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.block_flipped, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Custom Block Time',
                  style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Instantly block booking requests during operational shifts.',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showAddBlockDialog,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorBottomNavBar(BuildContext context, int activeIndex) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: activeIndex,
          onTap: (index) {
            if (index == activeIndex) return;
            switch (index) {
              case 0:
                context.go('/doctor_home');
                break;
              case 1:
                context.go('/my_schedule');
                break;
              case 2:
                context.go('/doctor_profile');
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Console'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'My Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
