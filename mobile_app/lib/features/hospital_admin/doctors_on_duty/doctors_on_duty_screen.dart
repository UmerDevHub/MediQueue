import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme.dart';

class DoctorsOnDutyScreen extends ConsumerStatefulWidget {
  const DoctorsOnDutyScreen({super.key});

  @override
  ConsumerState<DoctorsOnDutyScreen> createState() => _DoctorsOnDutyScreenState();
}

class _DoctorsOnDutyScreenState extends ConsumerState<DoctorsOnDutyScreen> {
  final _supabase = Supabase.instance.client;
  final _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDoctors() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _supabase
          .from('doctors')
          .select('*, hospitals(*)')
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      
      setState(() {
        _doctors = List<Map<String, dynamic>>.from(data);
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load doctor profiles: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _doctors.where((doc) {
        final name = (doc['name'] as String).toLowerCase();
        final spec = (doc['specialization'] as String).toLowerCase();
        return name.contains(query) || spec.contains(query);
      }).toList();
    });
  }

  Future<void> _toggleAvailability(String doctorId, bool currentVal) async {
    final newVal = !currentVal;
    try {
      // Update doctor availability in database
      await _supabase
          .from('doctors')
          .update({'availability': newVal})
          .eq('id', doctorId);

      // Locally update the UI
      setState(() {
        final index = _doctors.indexWhere((d) => d['id'] == doctorId);
        if (index != -1) {
          _doctors[index]['availability'] = newVal;
          _applyFilters();
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newVal ? 'Doctor checked in successfully' : 'Doctor checked out successfully'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update duty status: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _doctors.where((d) => d['availability'] == true).length;
    final totalCount = _doctors.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Doctors On Duty Manager',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.go('/admin_home'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
        ),
        actions: [
          IconButton(
            onPressed: _fetchDoctors,
            icon: const Icon(Icons.refresh_rounded, size: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top overview ribbon
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HOSPITAL CLINICAL SHIFTS',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Active Clinicians: $activeCount / $totalCount',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Ready to Serve',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Search doctor name or specialty...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13.5),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 18),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border, width: 0.8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border, width: 0.8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Doctors list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    )
                  : _filteredDoctors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.contact_emergency_rounded, size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 14),
                              Text(
                                'No doctors found matching filters',
                                style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _filteredDoctors.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final doc = _filteredDoctors[index];
                            return _buildDoctorCard(doc);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doc) {
    final bool isAvailable = doc['availability'] ?? false;
    final String specialization = doc['specialization'] ?? 'General Practitioner';
    final String license = doc['license_number'] ?? 'MQ-DOC-UNKNOWN';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: isAvailable
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left accent block or doctor initial
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.success.withValues(alpha: 0.08) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                doc['name'].toString().replaceAll('Dr. ', '').substring(0, 1),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isAvailable ? AppColors.success : AppColors.textSecondary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Doctor core info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'] ?? 'Doctor Name',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  specialization,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'License: $license',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Check-in status switcher toggle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isAvailable ? 'ON DUTY' : 'OFF DUTY',
                style: GoogleFonts.inter(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  color: isAvailable ? AppColors.success : AppColors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Switch(
                value: isAvailable,
                onChanged: (val) => _toggleAvailability(doc['id'], isAvailable),
                activeColor: Colors.white,
                activeTrackColor: AppColors.success,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
