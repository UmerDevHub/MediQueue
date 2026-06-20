import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';

class LiveQueueManagementScreen extends ConsumerStatefulWidget {
  const LiveQueueManagementScreen({super.key});

  @override
  ConsumerState<LiveQueueManagementScreen> createState() => _LiveQueueManagementScreenState();
}

class _LiveQueueManagementScreenState extends ConsumerState<LiveQueueManagementScreen> {
  final _supabase = Supabase.instance.client;
  final _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _allAppointments = [];
  List<Map<String, dynamic>> _filteredAppointments = [];
  bool _isLoading = true;
  String _activeTab = 'all'; // 'all', 'booked', 'completed', 'cancelled'

  @override
  void initState() {
    super.initState();
    _fetchQueue();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchQueue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Query appointments with user, slot, and doctor details
      final response = await _supabase
          .from('appointments')
          .select('*, users!inner(*), slots!inner(*), doctors!inner(*)')
          .order('created_at', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      
      setState(() {
        _allAppointments = List<Map<String, dynamic>>.from(data);
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
            content: Text('Failed to load appointments: $e'),
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
      _filteredAppointments = _allAppointments.where((appt) {
        // Filter by tab status
        final status = appt['status'] as String;
        if (_activeTab == 'booked' && status != 'booked') return false;
        if (_activeTab == 'completed' && status != 'completed') return false;
        if (_activeTab == 'cancelled' && status != 'cancelled') return false;

        // Filter by search query
        final patientName = (appt['users']['name'] as String).toLowerCase();
        final doctorName = (appt['doctors']['name'] as String).toLowerCase();
        return patientName.contains(query) || doctorName.contains(query);
      }).toList();
    });
  }

  Future<void> _updateStatus(String appointmentId, String newStatus, String slotId) async {
    try {
      // Update appointment status
      await _supabase
          .from('appointments')
          .update({'status': newStatus})
          .eq('id', appointmentId);

      // If completing or cancelling, set slot is_booked to false
      if (newStatus == 'cancelled' || newStatus == 'completed') {
        await _supabase
            .from('slots')
            .update({'is_booked': false})
            .eq('id', slotId);
      }

      await _fetchQueue();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Queue status updated to $newStatus successfully.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Stats calculation
    final totalCount = _allAppointments.length;
    final activeCount = _allAppointments.where((a) => a['status'] == 'booked').length;
    final servedCount = _allAppointments.where((a) => a['status'] == 'completed').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Live Queue Management',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.go('/admin_home'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
        ),
        actions: [
          IconButton(
            onPressed: _fetchQueue,
            icon: const Icon(Icons.refresh_rounded, size: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Statistics Ribbon
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('TOTAL', '$totalCount', AppColors.primary),
                  _buildStatItem('ACTIVE', '$activeCount', AppColors.warning),
                  _buildStatItem('SERVED', '$servedCount', AppColors.success),
                ],
              ),
            ),
            
            const SizedBox(height: 12),

            // Search Bar & Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Search patient name or doctor...',
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

            const SizedBox(height: 12),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterTab('All', 'all'),
                  _buildFilterTab('Booked', 'booked'),
                  _buildFilterTab('Completed', 'completed'),
                  _buildFilterTab('Cancelled', 'cancelled'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Queue List Area
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    )
                  : _filteredAppointments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_turned_in_rounded, size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 14),
                              Text(
                                'No queue records found',
                                style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: _filteredAppointments.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final appt = _filteredAppointments[index];
                            return _buildQueueCard(appt);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: color),
        ),
      ],
    );
  }

  Widget _buildFilterTab(String label, String tabKey) {
    final isActive = _activeTab == tabKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tabKey;
          _applyFilters();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? AppColors.primary : AppColors.border, width: 0.8),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildQueueCard(Map<String, dynamic> appt) {
    final patient = appt['users'];
    final doctor = appt['doctors'];
    final slot = appt['slots'];
    final status = appt['status'] as String;

    DateTime? startTime;
    if (slot['start_time'] != null) {
      startTime = DateTime.tryParse(slot['start_time'] as String)?.toLocal();
    }
    final timeStr = startTime != null ? DateFormat('hh:mm a').format(startTime) : 'N/A';
    final dateStr = startTime != null ? DateFormat('MMM dd, yyyy').format(startTime) : 'N/A';

    Color badgeColor = AppColors.primary;
    if (status == 'completed') badgeColor = AppColors.success;
    if (status == 'cancelled') badgeColor = AppColors.danger;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Slot: $timeStr ($dateStr)',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: badgeColor, letterSpacing: 0.4),
                ),
              ),
            ],
          ),
          
          const Divider(height: 20, color: AppColors.border),

          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient['name'] ?? 'Unknown Patient',
                      style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Treated by: ${doctor['name']}',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (status == 'booked') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateStatus(appt['id'], 'cancelled', slot['id']),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger, width: 0.8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Cancel Booking',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(appt['id'], 'completed', slot['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Serve & Complete',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
