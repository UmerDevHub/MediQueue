import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  // Mock notifications list
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif-1',
      'title': 'Queue Update — You are next!',
      'body': 'Dr. Aisha Khan is ready to see you. Please proceed to Clinical Room 3B immediately.',
      'time': 'Just now',
      'type': 'queue',
      'isRead': false,
    },
    {
      'id': 'notif-2',
      'title': 'Appointment Booking Confirmed',
      'body': 'Your reservation with Dr. Zain Malik has been confirmed for tomorrow at 10:00 AM.',
      'time': '2 hours ago',
      'type': 'calendar',
      'isRead': false,
    },
    {
      'id': 'notif-3',
      'title': 'Emergency Queue Activated',
      'body': 'Priority emergency token generated at Mayo Clinic. Route guidance is active on your screen.',
      'time': '1 day ago',
      'type': 'emergency',
      'isRead': true,
    },
    {
      'id': 'notif-4',
      'title': 'ML Wait Estimates Updated',
      'body': 'We updated wait-time prediction factors for nearest hospitals based on afternoon peak traffic.',
      'time': '3 days ago',
      'type': 'system',
      'isRead': true,
    }
  ];

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _dismissNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'queue':
        return Icons.track_changes_rounded;
      case 'calendar':
        return Icons.calendar_month_rounded;
      case 'emergency':
        return Icons.emergency_rounded;
      case 'system':
      default:
        return Icons.insights_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'queue':
        return AppColors.warning;
      case 'calendar':
        return AppColors.primary;
      case 'emergency':
        return AppColors.danger;
      case 'system':
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Notifications Header
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
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
                      const SizedBox(width: 14),
                      Text(
                        'Notifications',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (unreadCount > 0)
                        GestureDetector(
                          onTap: _markAllAsRead,
                          child: Text(
                            'Mark all read',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Notification List Content
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notif = _notifications[index];
                        final title = notif['title'] as String;
                        final body = notif['body'] as String;
                        final time = notif['time'] as String;
                        final type = notif['type'] as String;
                        final isRead = notif['isRead'] as bool;

                        final icon = _getIconForType(type);
                        final color = _getColorForType(type);

                        return Dismissible(
                          key: Key(notif['id'] as String),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) => _dismissNotification(index),
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 24),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isRead ? Colors.white : color.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isRead ? AppColors.border : color.withValues(alpha: 0.15),
                                width: isRead ? 0.8 : 1.2,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Icon Circle
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(icon, color: color, size: 18),
                                ),
                                const SizedBox(width: 14),
                                
                                // Text details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              title,
                                              style: GoogleFonts.inter(
                                                fontSize: 13.5,
                                                fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            time,
                                            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        body,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Unread Dot Indicator
                                if (!isRead)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8, top: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: (index * 60).ms).slideY(begin: 0.04, end: 0);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), shape: BoxShape.circle),
            child: const Icon(Icons.notifications_off_rounded, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 18),
          Text(
            'All Caught Up!',
            style: GoogleFonts.inter(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'You have cleared all alerts and updates.',
            style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
