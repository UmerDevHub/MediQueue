import 'package:flutter/material.dart';
import '../theme.dart';

enum BadgeType { success, warning, danger, neutral, primary }

class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = BadgeType.neutral,
    this.icon,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case BadgeType.success:
        return AppColors.success.withOpacity(0.1);
      case BadgeType.warning:
        return AppColors.warning.withOpacity(0.1);
      case BadgeType.danger:
        return AppColors.danger.withOpacity(0.1);
      case BadgeType.primary:
        return AppColors.primary.withOpacity(0.1);
      case BadgeType.neutral:
      default:
        return AppColors.textMuted.withOpacity(0.1);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case BadgeType.success:
        return AppColors.success;
      case BadgeType.warning:
        return AppColors.warning;
      case BadgeType.danger:
        return AppColors.danger;
      case BadgeType.primary:
        return AppColors.primary;
      case BadgeType.neutral:
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: _getTextColor()),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
