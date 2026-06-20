import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';
import '../../auth/providers/auth_provider.dart';

// ============================================================================
// 1. DATA MODELS & STATE MANAGER FOR DOCTOR QUEUE
// ============================================================================

class DoctorPatientQueueItem {
  final int token;
  final String name;
  final String ageGender;
  final String checkinTime;
  final String symptoms;
  final String bp;
  final String pulse;
  final String spo2;
  final String temp;
  final String status; // "arrived", "vitals", "waiting", "completed"
  final String? appointmentId;
  final String? slotId;

  DoctorPatientQueueItem({
    required this.token,
    required this.name,
    required this.ageGender,
    required this.checkinTime,
    required this.symptoms,
    required this.bp,
    required this.pulse,
    required this.spo2,
    required this.temp,
    required this.status,
    this.appointmentId,
    this.slotId,
  });

  DoctorPatientQueueItem copyWith({String? status}) {
    return DoctorPatientQueueItem(
      token: token,
      name: name,
      ageGender: ageGender,
      checkinTime: checkinTime,
      symptoms: symptoms,
      bp: bp,
      pulse: pulse,
      spo2: spo2,
      temp: temp,
      status: status ?? this.status,
      appointmentId: appointmentId,
      slotId: slotId,
    );
  }
}

// ============================================================================
// 2. DOCTOR PERFORMANCE BEZIER LINE CHART PAINTER
// ============================================================================

/// Custom painter to draw a premium line chart showcasing consultation times by hour.
class DoctorPerformanceChartPainter extends CustomPainter {
  final List<double> consultingMinutes; // consulting times (e.g. 10m, 12m)
  final List<String> hours; // Labels
  final double animationVal;

  DoctorPerformanceChartPainter({
    required this.consultingMinutes,
    required this.hours,
    required this.animationVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double padding = 20.0;
    final double graphWidth = size.width - 2 * padding;
    final double graphHeight = size.height - 2 * padding;

    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..strokeWidth = 0.8;

    // Draw horizontal grid guidelines
    for (int i = 0; i <= 3; i++) {
      final double y = padding + (graphHeight / 3) * i;
      canvas.drawLine(Offset(padding, y), Offset(size.width - padding, y), gridPaint);
    }

    // Coordinates mapping
    final int count = consultingMinutes.length;
    final double spacing = graphWidth / (count - 1);
    final double maxVal = consultingMinutes.reduce(math.max);

    final List<Offset> points = [];
    for (int i = 0; i < count; i++) {
      final double normalizedVal = maxVal > 0 ? (consultingMinutes[i] / maxVal) : 0;
      final double x = padding + spacing * i;
      final double y = padding + graphHeight * (1.0 - normalizedVal * animationVal);
      points.add(Offset(x, y));
    }

    // Draw bottom area fill gradient
    final fillPath = Path()
      ..moveTo(points.first.dx, padding + graphHeight);
    for (final pt in points) {
      fillPath.lineTo(pt.dx, pt.dy);
    }
    fillPath.lineTo(points.last.dx, padding + graphHeight);
    fillPath.close();

    final areaGradient = LinearGradient(
      colors: [
        AppColors.primary.withValues(alpha: 0.15),
        AppColors.primary.withValues(alpha: 0.0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final areaPaint = Paint()
      ..shader = areaGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, areaPaint);

    // Draw smooth bezier connecting lines
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + spacing / 2, p1.dy);
      final controlPoint2 = Offset(p2.dx - spacing / 2, p2.dy);
      linePath.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    final linePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Draw glowing data points
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final outerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 6.0, dotPaint);
      canvas.drawCircle(points[i], 3.0, outerDotPaint);

      // Render hour label
      final hourPainter = TextPainter(
        text: TextSpan(
          text: hours[i],
          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      hourPainter.paint(canvas, Offset(points[i].dx - hourPainter.width / 2, padding + graphHeight + 6));
    }
  }

  @override
  bool shouldRepaint(covariant DoctorPerformanceChartPainter oldDelegate) {
    return oldDelegate.consultingMinutes != consultingMinutes ||
        oldDelegate.animationVal != animationVal ||
        oldDelegate.hours != hours;
  }
}

// ============================================================================
// 3. MAIN DOCTOR HOME SCREEN
// ============================================================================

class DoctorHomeScreen extends ConsumerStatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  ConsumerState<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends ConsumerState<DoctorHomeScreen> with SingleTickerProviderStateMixin {
  bool _isOnline = true;
  bool _isRefreshing = false;
  bool _isLoading = true;

  // Active enqueued index
  int _activeQueueIndex = 0;

  // Doctor session counters
  int _totalServedToday = 8;
  int _averageConsultMinutes = 11;

  // Custom Chart controller
  late AnimationController _chartController;

  // Patient queue
  List<DoctorPatientQueueItem> _queueItems = [];

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    
    // Fetch live queue from database
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRealQueue();
    });
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  Future<void> _fetchRealQueue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authState = ref.read(authProvider);
      final doctorId = authState.user?.id;

      if (doctorId == null || doctorId.isEmpty) {
        _loadMockQueue();
        return;
      }

      // Select active booked appointments for this doctor
      final response = await Supabase.instance.client
          .from('appointments')
          .select('*, users!inner(*), slots!inner(*)')
          .eq('doctor_id', doctorId)
          .order('created_at', ascending: true);

      final List<dynamic> data = response as List<dynamic>;

      if (data.isEmpty) {
        _loadMockQueue();
        return;
      }

      final List<DoctorPatientQueueItem> loadedItems = [];
      for (int i = 0; i < data.length; i++) {
        final appt = data[i];
        final patient = appt['users'];
        final slot = appt['slots'];
        final String apptStatus = appt['status'];

        String mappedStatus = 'waiting';
        if (apptStatus == 'completed') mappedStatus = 'completed';
        if (apptStatus == 'cancelled') mappedStatus = 'cancelled';

        DateTime? startTime;
        if (slot['start_time'] != null) {
          startTime = DateTime.tryParse(slot['start_time'] as String)?.toLocal();
        }
        final checkinTimeStr = startTime != null
            ? DateFormat('hh:mm a').format(startTime)
            : '10:00 AM';

        loadedItems.add(
          DoctorPatientQueueItem(
            token: i + 11,
            name: patient['name'] ?? 'Patient Name',
            ageGender: '34 yrs • Male',
            checkinTime: checkinTimeStr,
            symptoms: 'Mild chest pain, acid reflux, routine checkup.',
            bp: '120/80 mmHg',
            pulse: '76 bpm',
            spo2: '98%',
            temp: '98.6 °F',
            status: mappedStatus,
            appointmentId: appt['id'] as String,
            slotId: slot['id'] as String,
          ),
        );
      }

      setState(() {
        _queueItems = loadedItems;
        _activeQueueIndex = _queueItems.indexWhere((item) => item.status == 'waiting');
        if (_activeQueueIndex == -1) _activeQueueIndex = 0;
        _totalServedToday = _queueItems.where((item) => item.status == 'completed').length;
        _isLoading = false;
      });
    } catch (e) {
      _loadMockQueue();
    }
  }

  void _loadMockQueue() {
    setState(() {
      _queueItems = [
        DoctorPatientQueueItem(
          token: 11,
          name: 'Ahmad Ali',
          ageGender: '34 yrs • Male',
          checkinTime: '10:14 AM',
          symptoms: 'Mild chest pain, acid reflux, shortness of breath on exertion.',
          bp: '138/88 mmHg',
          pulse: '82 bpm',
          spo2: '97%',
          temp: '98.4 °F',
          status: 'waiting',
        ),
        DoctorPatientQueueItem(
          token: 12,
          name: 'Zainab Fatima',
          ageGender: '27 yrs • Female',
          checkinTime: '10:28 AM',
          symptoms: 'Persistent dry cough for 2 weeks, low-grade fever.',
          bp: '115/72 mmHg',
          pulse: '74 bpm',
          spo2: '99%',
          temp: '100.1 °F',
          status: 'arrived',
        ),
        DoctorPatientQueueItem(
          token: 13,
          name: 'Mohammad Raza',
          ageGender: '52 yrs • Male',
          checkinTime: '10:45 AM',
          symptoms: 'Diabetic follow-up, numbness in feet, routine screening.',
          bp: '142/90 mmHg',
          pulse: '80 bpm',
          spo2: '96%',
          temp: '98.6 °F',
          status: 'vitals',
        ),
        DoctorPatientQueueItem(
          token: 14,
          name: 'Sara Bibi',
          ageGender: '8 yrs • Female',
          checkinTime: '11:02 AM',
          symptoms: 'Acute abdominal ache, nausea, mild dehydration.',
          bp: '100/60 mmHg',
          pulse: '98 bpm',
          spo2: '98%',
          temp: '99.2 °F',
          status: 'arrived',
        ),
      ];
      _activeQueueIndex = 0;
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    await _fetchRealQueue();
    setState(() {
      _isRefreshing = false;
    });
  }

  void _callNextPatient() async {
    if (_activeQueueIndex < _queueItems.length) {
      final currentItem = _queueItems[_activeQueueIndex];

      // Update database status to completed if it's real
      if (currentItem.appointmentId != null) {
        try {
          await Supabase.instance.client
              .from('appointments')
              .update({'status': 'completed'})
              .eq('id', currentItem.appointmentId!);

          if (currentItem.slotId != null) {
            await Supabase.instance.client
                .from('slots')
                .update({'is_booked': false})
                .eq('id', currentItem.slotId!);
          }
        } catch (_) {}
      }

      setState(() {
        _queueItems[_activeQueueIndex] = currentItem.copyWith(status: 'completed');
        _totalServedToday++;
        
        // Find next waiting/arrived patient
        final nextIdx = _queueItems.indexWhere((item) => item.status == 'waiting' || item.status == 'arrived' || item.status == 'vitals');
        if (nextIdx != -1) {
          _activeQueueIndex = nextIdx;
        } else {
          _activeQueueIndex = _queueItems.length; // Set to end
        }
      });

      if (_activeQueueIndex < _queueItems.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calling Token #${_queueItems[_activeQueueIndex].token}: ${_queueItems[_activeQueueIndex].name}'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All patient consultations have been completed.'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  void _postponePatient() {
    if (_activeQueueIndex < _queueItems.length) {
      final currentItem = _queueItems[_activeQueueIndex];
      setState(() {
        _queueItems.removeAt(_activeQueueIndex);
        _queueItems.add(currentItem); // Shift to end
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Postponed ${currentItem.name} to end of queue list.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final docName = authState.user?.name ?? 'Dr. Aisha Khan';

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_queueItems.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildDoctorHeader(docName),
              const Expanded(
                child: Center(
                  child: Text('No patient queue records found.'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Safely clamp active index
    final displayIndex = _activeQueueIndex < _queueItems.length ? _activeQueueIndex : _queueItems.length - 1;
    final activePatient = _queueItems[displayIndex];
    final remainingCount = _queueItems.where((item) => item.status != 'completed').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildDoctorHeader(docName),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Stats Row
                      Row(
                        children: [
                          Expanded(child: _buildDashboardMetric('SERVED', '$_totalServedToday', AppColors.success)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDashboardMetric('PENDING', '$remainingCount', AppColors.primary)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDashboardMetric('AVG TIME', '${_averageConsultMinutes}m', Colors.amber)),
                        ],
                      ).animate().fadeIn(duration: 300.ms),

                      const SizedBox(height: 24),

                      // ACTIVE PATIENT CONSULTATION CONSOLE
                      Text(
                        'Active Consultation Console',
                        style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border, width: 0.8),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row: Patient details
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'TOKEN #${activePatient.token}',
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Active Call',
                                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            Text(
                              activePatient.name,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${activePatient.ageGender} • Checked in ${activePatient.checkinTime}',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            ),

                            const Divider(height: 24, color: AppColors.border),

                            // Symptoms Block
                            Text(
                              'CHIEF COMPLAINTS',
                              style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              activePatient.symptoms,
                              style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textPrimary, height: 1.4),
                            ),

                            const Divider(height: 24, color: AppColors.border),

                            // Vitals Strip
                            Text(
                              'TRIAGE VITALS SUMMARY',
                              style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildVitalsCell('BP', activePatient.bp, Icons.favorite_rounded, Colors.redAccent),
                                _buildVitalsCell('Pulse', activePatient.pulse, Icons.pulse_ops, Colors.blue),
                                _buildVitalsCell('SpO2', activePatient.spo2, Icons.air_rounded, Colors.teal),
                                _buildVitalsCell('Temp', activePatient.temp, Icons.thermostat_rounded, Colors.orange),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Console controls
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _callNextPatient,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.skip_next_rounded, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Next / Serve',
                                          style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _postponePatient,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.border, width: 1.0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.update_rounded, size: 18, color: AppColors.textPrimary),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Hold & Defer',
                                          style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 150.ms),

                      const SizedBox(height: 28),

                      // UP NEXT QUEUE SCHEDULE
                      Text(
                        'Upcoming Patients List',
                        style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _queueItems.length,
                        itemBuilder: (context, index) {
                          final item = _queueItems[index];
                          final isCompleted = item.status == 'completed';
                          final isActive = index == _activeQueueIndex;

                          if (isCompleted) return const SizedBox.shrink();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primary.withValues(alpha: 0.04) : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isActive ? AppColors.primary : AppColors.border,
                                width: isActive ? 1.2 : 0.8,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: isActive ? AppColors.primary : Colors.grey[200],
                                  child: Text(
                                    '#${item.token}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: isActive ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.ageGender} • Checked in ${item.checkinTime}',
                                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildStatusIndicatorTag(item.status),
                              ],
                            ),
                          );
                        },
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 28),

                      // BEZIER PERFORMANCE CHART
                      Text(
                        'Hourly Consultation Times',
                        style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Average diagnostics minutes per consultation slot.',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border, width: 0.8),
                        ),
                        child: AspectRatio(
                          aspectRatio: 2.2,
                          child: AnimatedBuilder(
                            animation: _chartController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: DoctorPerformanceChartPainter(
                                  consultingMinutes: const [10.0, 14.0, 11.0, 15.0, 9.0],
                                  hours: const ['8AM', '9AM', '10AM', '11AM', '12PM'],
                                  animationVal: _chartController.value,
                                ),
                              );
                            },
                          ),
                        ),
                      ).animate().fadeIn(delay: 250.ms),
                      
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildDoctorBottomNavBar(context, 0),
    );
  }

  Widget _buildStatusIndicatorTag(String status) {
    Color tagColor = Colors.grey;
    String tagLabel = 'Awaiting';
    if (status == 'vitals') {
      tagColor = Colors.orange;
      tagLabel = 'Triage';
    } else if (status == 'arrived') {
      tagColor = AppColors.success;
      tagLabel = 'Arrived';
    } else if (status == 'waiting') {
      tagColor = AppColors.primary;
      tagLabel = 'Up Next';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tagLabel,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: tagColor),
      ),
    );
  }

  Widget _buildDoctorHeader(String name) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                'OPD Room 3B • General Medicine',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                _isOnline ? 'Active' : 'Offline',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: _isOnline ? AppColors.success : Colors.grey),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: _isOnline,
                onChanged: (val) {
                  setState(() {
                    _isOnline = val;
                  });
                },
                activeTrackColor: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardMetric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsCell(String label, String val, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(
          val,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
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
