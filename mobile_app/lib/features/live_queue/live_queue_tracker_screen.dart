import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../user/providers/appointments_provider.dart';
import '../user/providers/user_home_provider.dart';

// ============================================================================
// 1. ANCILLARY DATA MODELS & STATE PROVIDERS FOR PRE-CONSULTATION CHECKLIST
// ============================================================================

/// Represents an item in the pre-consultation checklist.
class ChecklistItem {
  final String id;
  final String title;
  final bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  ChecklistItem copyWith({String? id, String? title, bool? isCompleted}) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// State Notifier to manage the user's symptoms and questions checklist locally.
class ChecklistNotifier extends StateNotifier<List<ChecklistItem>> {
  ChecklistNotifier() : super([
    ChecklistItem(id: '1', title: 'Mention when the symptoms first started'),
    ChecklistItem(id: '2', title: 'Share list of current medications & dosages'),
    ChecklistItem(id: '3', title: 'Report any drug or food allergies'),
    ChecklistItem(id: '4', title: 'Ask about potential side effects of new treatments'),
  ]);

  void addItem(String title) {
    if (title.trim().isEmpty) return;
    final newItem = ChecklistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    state = [...state, newItem];
  }

  void toggleItem(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isCompleted: !item.isCompleted) else item
    ];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final checklistProvider = StateNotifierProvider<ChecklistNotifier, List<ChecklistItem>>((ref) {
  return ChecklistNotifier();
});

// ============================================================================
// 2. RADIAL QUEUE PROGRESS CUSTOM PAINTER
// ============================================================================

/// Custom painter that draws a premium circular queue tracker gauge.
class QueueRadialProgressPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0 representing progress in the queue
  final Color primaryColor;
  final Color accentColor;
  final double pulseValue; // Animated value for breathing pulse effect

  QueueRadialProgressPainter({
    required this.progress,
    required this.primaryColor,
    required this.accentColor,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;

    // Paint 1: Subtle outer glow track
    final outerGlowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.05 + (0.03 * pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.0 + (6.0 * pulseValue)
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, outerGlowPaint);

    // Paint 2: Background track ring
    final bgPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    canvas.drawCircle(center, radius, bgPaint);

    // Paint 3: Active progress arc using gradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: [
        accentColor,
        primaryColor,
        primaryColor.withValues(alpha: 0.6),
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    // Draw the progress arc starting from top (-90 degrees / -pi/2 radians)
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    // Paint 4: Draw indicator tick lines along the circle
    final tickPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    const tickCount = 48;
    for (int i = 0; i < tickCount; i++) {
      final angle = (2 * math.pi / tickCount) * i;
      final isAccent = (i / tickCount) <= progress;
      tickPaint.color = isAccent ? primaryColor.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2);
      
      final innerRad = radius - 16;
      final outerRad = radius - 20;

      final startOffset = Offset(
        center.dx + innerRad * math.cos(angle),
        center.dy + innerRad * math.sin(angle),
      );
      final endOffset = Offset(
        center.dx + outerRad * math.cos(angle),
        center.dy + outerRad * math.sin(angle),
      );
      canvas.drawLine(startOffset, endOffset, tickPaint);
    }

    // Paint 5: Glowing dot at the leading edge of progress arc
    final headAngle = startAngle + sweepAngle;
    final headOffset = Offset(
      center.dx + radius * math.cos(headAngle),
      center.dy + radius * math.sin(headAngle),
    );

    final glowPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(headOffset, 12, glowPaint);

    final headCorePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(headOffset, 6, headCorePaint);
  }

  @override
  bool shouldRepaint(covariant QueueRadialProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.pulseValue != pulseValue;
  }
}

// ============================================================================
// 3. INTERACTIVE HOSPITAL FLOOR PLAN BLUEPRINT PAINTER
// ============================================================================

/// Class to track coordinate metadata and labels for hospital floor plan tap-targets
class FloorPlanRoom {
  final String id;
  final String name;
  final Rect boundary;
  final String details;

  FloorPlanRoom({
    required this.id,
    required this.name,
    required this.boundary,
    required this.details,
  });
}

class HospitalFloorMapPainter extends CustomPainter {
  final List<FloorPlanRoom> rooms;
  final String? selectedRoomId;
  final double animationProgress; // Controls dots path animation
  final Map<String, dynamic> pathStartEnd; // Coordinate path dictionary

  HospitalFloorMapPainter({
    required this.rooms,
    required this.selectedRoomId,
    required this.animationProgress,
    required this.pathStartEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFF0F1E36)
      ..style = PaintingStyle.fill;

    // Draw blueprint dark-grid background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final gridPaint = Paint()
      ..color = const Color(0xFF1E2D4A).withValues(alpha: 0.4)
      ..strokeWidth = 0.8;

    const gridSize = 16.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Paint structures
    final borderPaint = Paint()
      ..color = const Color(0xFF3B5680)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = const Color(0xFF1A2A44)
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final selectedBorderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    for (final room in rooms) {
      final isSelected = room.id == selectedRoomId;
      canvas.drawRect(room.boundary, isSelected ? selectedPaint : fillPaint);
      canvas.drawRect(room.boundary, isSelected ? selectedBorderPaint : borderPaint);

      // Render Label Texts inside chambers
      final textPainter = TextPainter(
        text: TextSpan(
          text: room.name,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF8AA3CE),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        room.boundary.left + (room.boundary.width - textPainter.width) / 2,
        room.boundary.top + (room.boundary.height - textPainter.height) / 2,
      );
      textPainter.paint(canvas, textOffset);
    }

    // Draw Navigation Routing Guide Path
    final pathPaint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    final List<Offset> routeCoordinates = pathStartEnd['coords'] as List<Offset>? ?? [];

    if (routeCoordinates.isNotEmpty) {
      final path = Path()..moveTo(routeCoordinates.first.dx, routeCoordinates.first.dy);
      for (int i = 1; i < routeCoordinates.length; i++) {
        path.lineTo(routeCoordinates[i].dx, routeCoordinates[i].dy);
      }
      canvas.drawPath(path, pathPaint);

      // Blinking moving dots animation path
      final dotPaint = Paint()
        ..color = AppColors.success
        ..style = PaintingStyle.fill;

      // Draw dynamic animated pulsing dot leading to clinic room
      final totalPathLength = routeCoordinates.length - 1;
      final currentPos = animationProgress * totalPathLength;
      final segmentIndex = currentPos.floor();
      final remainder = currentPos - segmentIndex;

      if (segmentIndex < totalPathLength) {
        final start = routeCoordinates[segmentIndex];
        final end = routeCoordinates[segmentIndex + 1];
        final animatedDotOffset = Offset(
          start.dx + (end.dx - start.dx) * remainder,
          start.dy + (end.dy - start.dy) * remainder,
        );

        // Halo circle pulse around indicator dot
        final haloPaint = Paint()
          ..color = AppColors.success.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(animatedDotOffset, 8.0, haloPaint);
        canvas.drawCircle(animatedDotOffset, 4.0, dotPaint);
      }

      // Draw start/end icons
      final startPinPaint = Paint()..color = AppColors.primary..style = PaintingStyle.fill;
      canvas.drawCircle(routeCoordinates.first, 5.0, startPinPaint);

      final endPinPaint = Paint()..color = AppColors.danger..style = PaintingStyle.fill;
      canvas.drawCircle(routeCoordinates.last, 6.0, endPinPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HospitalFloorMapPainter oldDelegate) {
    return oldDelegate.selectedRoomId != selectedRoomId ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.rooms != rooms;
  }
}

// ============================================================================
// 4. LIVE QUEUE ANALYTICS BAR CHART PAINTER
// ============================================================================

class QueueBarChartPainter extends CustomPainter {
  final List<double> values; // Wait times relative to base
  final List<String> labels; // Hour labels (e.g. 10AM, 11AM)
  final double animationVal; // Animating bar growth

  QueueBarChartPainter({
    required this.values,
    required this.labels,
    required this.animationVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = AppColors.border.withValues(alpha: 0.7)
      ..strokeWidth = 0.8;

    final double height = size.height - 24;
    final double width = size.width;

    // Draw baseline grid lines
    canvas.drawLine(Offset(0, height), Offset(width, height), paintGrid);
    canvas.drawLine(Offset(0, height / 2), Offset(width, height / 2), paintGrid);
    canvas.drawLine(Offset(0, 0), Offset(width, 0), paintGrid);

    // Calculate bar layouts
    final int count = values.length;
    final double barSpacing = width / count;
    final double barWidth = barSpacing * 0.55;

    final maxVal = values.reduce(math.max);

    for (int i = 0; i < count; i++) {
      final double normalizedHeight = maxVal > 0 ? (values[i] / maxVal) : 0;
      final double barHeight = normalizedHeight * height * animationVal;

      final double xPos = (barSpacing * i) + (barSpacing - barWidth) / 2;
      final double yPos = height - barHeight;

      // Draw Bar Gradient
      final rect = Rect.fromLTWH(xPos, yPos, barWidth, barHeight);
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );

      final barGradient = LinearGradient(
        colors: [
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.5),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

      final barPaint = Paint()
        ..shader = barGradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rrect, barPaint);

      // Render hour label
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final labelOffset = Offset(
        xPos + (barWidth - textPainter.width) / 2,
        height + 6,
      );
      textPainter.paint(canvas, labelOffset);

      // Value label on top of bar
      if (barHeight > 16) {
        final valPainter = TextPainter(
          text: TextSpan(
            text: '${values[i].toStringAsFixed(0)}m',
            style: GoogleFonts.inter(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        valPainter.layout();
        final valOffset = Offset(
          xPos + (barWidth - valPainter.width) / 2,
          yPos + 4,
        );
        valPainter.paint(canvas, valOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant QueueBarChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.animationVal != animationVal ||
        oldDelegate.labels != labels;
  }
}

// ============================================================================
// 5. MAIN LIVE QUEUE TRACKER SCREEN IMPLEMENTATION
// ============================================================================

class LiveQueueTrackerScreen extends ConsumerStatefulWidget {
  const LiveQueueTrackerScreen({super.key});

  @override
  ConsumerState<LiveQueueTrackerScreen> createState() => _LiveQueueTrackerScreenState();
}

class _LiveQueueTrackerScreenState extends ConsumerState<LiveQueueTrackerScreen> with TickerProviderStateMixin {
  bool _isRefreshing = false;
  int _mockServingNumber = 11;
  int _mockUserToken = 14;
  String _liveWaitTime = '15';
  String? _trackerError;

  // Settings states
  bool _isAudioEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isAutoAlertEnabled = true;

  // Custom controller animations
  late AnimationController _pulseController;
  late AnimationController _navDotController;
  late AnimationController _chartController;

  // Checklist controller
  final _checklistTextController = TextEditingController();

  // Selected floor plan room detail
  String? _selectedFloorRoomId;
  String _floorDetailMessage = 'Tap on the clinic floor layout blueprint below to view room info and services.';

  // Map coordinate nodes for floor plan navigation
  final List<FloorPlanRoom> _floorRooms = [
    FloorPlanRoom(
      id: 'reception',
      name: 'Reception Desk',
      boundary: const Rect.fromLTWH(10, 10, 80, 50),
      details: 'Patient Check-in, Triage validation, Token dispatch center. Desk hours: 24/7.',
    ),
    FloorPlanRoom(
      id: 'triage_room',
      name: 'Triage Center',
      boundary: const Rect.fromLTWH(100, 10, 80, 50),
      details: 'Initial vitals check (BP, SpO2, HR) done by lead nurse. Station active.',
    ),
    FloorPlanRoom(
      id: 'waiting_lounge',
      name: 'Lounge B',
      boundary: const Rect.fromLTWH(10, 90, 140, 80),
      details: 'Main waiting area with active display monitor. Sanitizers and charging ports available.',
    ),
    FloorPlanRoom(
      id: 'clinic_room_3a',
      name: 'Consulting Room 3A',
      boundary: const Rect.fromLTWH(210, 10, 90, 45),
      details: 'Dr. Zain Malik. Cardiology Consultant. Currently enqueuing Token #8.',
    ),
    FloorPlanRoom(
      id: 'clinic_room_3b',
      name: 'Consulting Room 3B',
      boundary: const Rect.fromLTWH(210, 65, 90, 45),
      details: 'Dr. Aisha Khan. General Medicine. Currently enqueuing Token #11. Your assigned room.',
    ),
    FloorPlanRoom(
      id: 'pharmacy',
      name: 'Pharmacy Dep',
      boundary: const Rect.fromLTWH(170, 130, 130, 40),
      details: 'Dispensing prescriptions, medical assets, and emergency injectables. Open.',
    ),
  ];

  // Coordinates mapping path from Lounge B to Consulting Room 3B
  late Map<String, dynamic> _navigatingPath;

  @override
  void initState() {
    super.initState();
    _fetchLiveWaitTime();

    // Pulse animation for radial progress tracker ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Floor plan route dot flow progress
    _navDotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Chart anim build on enter
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _navigatingPath = {
      'coords': const [
        Offset(80, 130),  // Lounge B start
        Offset(160, 130), // Junction
        Offset(160, 88),  // Mid hallway
        Offset(210, 88),  // Room 3B door
      ]
    };
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _navDotController.dispose();
    _chartController.dispose();
    _checklistTextController.dispose();
    super.dispose();
  }

  Future<void> _fetchLiveWaitTime() async {
    final appointmentsList = ref.read(appointmentsProvider);
    final active = appointmentsList.where((appt) => appt['status'] == 'booked').toList();
    if (active.isEmpty) return;

    final appt = active.first;
    final doctor = appt['doctor'] as Map<String, dynamic>? ?? {};
    final hospitalId = doctor['hospital_id'] as String? ?? '';

    if (hospitalId.isEmpty || hospitalId.startsWith('mock-')) {
      setState(() {
        _liveWaitTime = '18';
        _trackerError = null;
      });
      return;
    }

    setState(() {
      _isRefreshing = true;
      _trackerError = null;
    });

    try {
      final apiService = ref.read(userApiServiceProvider);
      final waitTimeData = await apiService.getHospitalWaitTime(hospitalId);
      final eta = (waitTimeData['eta_minutes'] as num? ?? 15.0).toStringAsFixed(0);
      
      setState(() {
        _liveWaitTime = eta;
        _mockServingNumber = (waitTimeData['queue_size'] as int? ?? 12) - 3;
        if (_mockServingNumber <= 0) _mockServingNumber = 1;
        _mockUserToken = _mockServingNumber + 3;
      });
    } catch (e) {
      setState(() {
        _trackerError = e.toString().replaceAll('Exception: ', '');
        _liveWaitTime = '22'; 
      });
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _handleFloorMapTap(TapUpDetails details, Size mapSize) {
    // Determine which room contains coordinates
    final tapOffset = details.localPosition;
    for (final room in _floorRooms) {
      if (room.boundary.contains(tapOffset)) {
        setState(() {
          _selectedFloorRoomId = room.id;
          _floorDetailMessage = '${room.name}: ${room.details}';
        });
        return;
      }
    }
    setState(() {
      _selectedFloorRoomId = null;
      _floorDetailMessage = 'Tap on the clinic floor layout blueprint below to view room info and services.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsList = ref.watch(appointmentsProvider);
    final active = appointmentsList.where((appt) => appt['status'] == 'booked').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderPanel(active.isNotEmpty),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchLiveWaitTime,
                color: AppColors.primary,
                child: active.isEmpty
                    ? _buildEmptyState()
                    : _buildTrackerContent(active.first),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 2),
    );
  }

  Widget _buildHeaderPanel(bool hasActive) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Live Queue Tracker',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (hasActive)
            IconButton(
              onPressed: _isRefreshing ? null : _fetchLiveWaitTime,
              icon: _isRefreshing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(AppColors.primary)),
                    )
                  : const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), shape: BoxShape.circle),
                child: const Icon(Icons.track_changes_rounded, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Text(
                'No Active Queue',
                style: GoogleFonts.inter(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                'You do not have any active appointments scheduled for today. Book an appointment to track your live queue status.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => context.go('/appointments_home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Find Doctors Now', style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackerContent(Map<String, dynamic> appointment) {
    final doctor = appointment['doctor'] as Map<String, dynamic>? ?? {};
    final docName = doctor['name'] as String? ?? 'Doctor';
    final docSpecialty = doctor['specialization'] as String? ?? 'Specialist';
    final hospital = doctor['hospital_name'] as String? ?? 'General Hospital';

    final peopleAhead = _mockUserToken - _mockServingNumber;
    
    // Calculate progress ratio (closer to serving token = higher ratio)
    double progressRatio = 0.2;
    if (_mockUserToken > 0) {
      final totalQueue = 10.0; // base scale
      final distance = _mockUserToken - _mockServingNumber;
      progressRatio = 1.0 - (distance / totalQueue).clamp(0.0, 0.9);
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Info Strip
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  child: Text(
                    docName.replaceAll('Dr. ', '').trim()[0].toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        docName,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$docSpecialty • $hospital',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms),

          const SizedBox(height: 20),

          // RADIAL GAUGE DISPLAY
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 250,
                  height: 250,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: QueueRadialProgressPainter(
                      progress: progressRatio,
                      primaryColor: AppColors.primary,
                      accentColor: AppColors.success,
                      pulseValue: _pulseController.value,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'EST. WAIT TIME',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _liveWaitTime,
                                style: GoogleFonts.inter(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 1.0),
                                child: Text(
                                  'min',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _trackerError != null ? 'Simulating Wait' : 'ML Predicted',
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 24),

          // Token Dashboard Counters
          Row(
            children: [
              Expanded(
                child: _buildCounterCard('YOUR TOKEN', '#$_mockUserToken', AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCounterCard('NOW SERVING', '#$_mockServingNumber', AppColors.success),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // ============================================================================
          // COMPONENT A: HOSPITAL FLOOR GUIDEBLUEPRINT (INTERACTIVE CUSTOM PAINT)
          // ============================================================================
          Text(
            'Hospital Navigator Guide',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Interactive blueprint showing path to consulting Room 3B.',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1E36),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF3B5680), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Interactive Area
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: GestureDetector(
                      onTapUp: (details) => _handleFloorMapTap(details, const Size(300, 180)),
                      child: AnimatedBuilder(
                        animation: _navDotController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: HospitalFloorMapPainter(
                              rooms: _floorRooms,
                              selectedRoomId: _selectedFloorRoomId,
                              animationProgress: _navDotController.value,
                              pathStartEnd: _navigatingPath,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                // Description Bar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E2D4A),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Colors.blueAccent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _floorDetailMessage,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms),

          const SizedBox(height: 28),

          // ============================================================================
          // COMPONENT B: LIVE QUEUE ANALYTICS BAR CHART
          // ============================================================================
          Text(
            'Queue Wait Time Analytics',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Predicted clinic wait intervals for today.',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 2.2,
                  child: AnimatedBuilder(
                    animation: _chartController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: QueueBarChartPainter(
                          values: const [12.0, 15.0, 22.0, 18.0, 14.0, 10.0],
                          labels: const ['10AM', '11AM', '12PM', '1PM', '2PM', '3PM'],
                          animationVal: _chartController.value,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.insights_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Peak wait detected at 12:00 PM (Lunch Shift). System advises enqueuing prior to 11:30 AM.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 28),

          // ============================================================================
          // COMPONENT C: PRE-CONSULTATION NOTE CHECKLIST
          // ============================================================================
          Text(
            'Pre-Consultation Planner',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add notes or symptoms you want to discuss with Dr. Aisha Khan.',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, child) {
              final checklist = ref.watch(checklistProvider);

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  children: [
                    // Textfield to append checklist item
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _checklistTextController,
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Add note (e.g. Headache for 3 days)...',
                              hintStyle: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            if (_checklistTextController.text.trim().isNotEmpty) {
                              ref.read(checklistProvider.notifier).addItem(_checklistTextController.text);
                              _checklistTextController.clear();
                              FocusScope.of(context).unfocus();
                            }
                          },
                          icon: const Icon(Icons.add_rounded, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Interactive Checklist items
                    if (checklist.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No pre-consultation notes yet. Type above to add.',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: checklist.length,
                        itemBuilder: (context, index) {
                          final item = checklist[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: item.isCompleted,
                                  onChanged: (val) {
                                    ref.read(checklistProvider.notifier).toggleItem(item.id);
                                  },
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      color: item.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                      fontWeight: item.isCompleted ? FontWeight.w500 : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => ref.read(checklistProvider.notifier).removeItem(item.id),
                                  icon: const Icon(Icons.close_rounded, size: 16, color: Colors.redAccent),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ).animate().fadeIn(delay: 350.ms),

          const SizedBox(height: 28),

          // ============================================================================
          // COMPONENT D: LIVE STEPS LIST
          // ============================================================================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Queue Progress Details',
                  style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 18),
                _buildProgressStep('Checked In', 'Validated queue status at reception', true, true),
                _buildProgressStep('Vitals Checked', 'Vitals checked by triage staff', true, true),
                _buildProgressStep(
                  'Standby Waiting',
                  peopleAhead > 0 ? '$peopleAhead patients ahead of you' : 'You are next in line!',
                  true,
                  false,
                  isActive: true,
                ),
                _buildProgressStep('Doctor Consultation', 'Consultation with physician', false, false),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 24),

          // ============================================================================
          // COMPONENT E: AUDIO & VIBRATION TICKET PANEL
          // ============================================================================
          Text(
            'Notification Preferences',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Column(
              children: [
                _buildToggleRow(
                  'Voice Announcements',
                  'Speak enqueued numbers aloud inside clinic floor.',
                  _isAudioEnabled,
                  (val) => setState(() => _isAudioEnabled = val),
                  Icons.volume_up_rounded,
                ),
                const Divider(height: 20, color: AppColors.border),
                _buildToggleRow(
                  'Vibration Alert',
                  'Vibrate mobile device when enqueued to Room 3B.',
                  _isVibrationEnabled,
                  (val) => setState(() => _isVibrationEnabled = val),
                  Icons.vibration_rounded,
                ),
                const Divider(height: 20, color: AppColors.border),
                _buildToggleRow(
                  'Auto Emergency Rerouting',
                  'Automatically query alternative centers if delays spike.',
                  _isAutoAlertEnabled,
                  (val) => setState(() => _isAutoAlertEnabled = val),
                  Icons.route_rounded,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 450.ms),

          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool currentVal, ValueChanged<bool> onChange, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: currentVal,
          onChanged: onChange,
          activeTrackColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildCounterCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String title, String subtitle, bool isCompleted, bool showLine, {bool isActive = false}) {
    Color iconColor = isCompleted ? AppColors.success : Colors.grey[300]!;
    if (isActive) iconColor = AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: isActive ? 2 : 1),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, size: 12, color: iconColor)
                    : Container(width: 6, height: 6, decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle)),
              ),
            ),
            if (showLine)
              Container(
                width: 1.5,
                height: 38,
                color: isCompleted ? AppColors.success : Colors.grey[300]!,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isActive || isCompleted ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.primary : (isCompleted ? AppColors.textPrimary : AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Shared Bottom Navigation Bar
  Widget _buildBottomNavBar(BuildContext context, int activeIndex) {
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
                context.go('/user_home');
                break;
              case 1:
                context.go('/appointments_home');
                break;
              case 2:
                context.go('/live_tracker');
                break;
              case 3:
                context.go('/user_profile');
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
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Appointments'),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes_rounded), label: 'Tracker'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
