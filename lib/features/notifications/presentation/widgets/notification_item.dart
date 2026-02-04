import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart'
    as entities;
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class NotificationItem extends StatelessWidget {
  final entities.Notification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case entities.NotificationType.order:
        return IconsaxPlusBold.box;
      case entities.NotificationType.promotion:
        return IconsaxPlusBold.tag_2;
      case entities.NotificationType.general:
        return IconsaxPlusBold.notification;
      case entities.NotificationType.system:
        return IconsaxPlusBold.information;
    }
  }

  Color _getIconColor(BuildContext context) {
    final cs = context.cs;
    switch (notification.type) {
      case entities.NotificationType.order:
        return cs.primary;
      case entities.NotificationType.promotion:
        return Colors.orange;
      case entities.NotificationType.general:
        return cs.tertiary;
      case entities.NotificationType.system:
        return Colors.blue;
    }
  }

  String _getTimeAgo(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return context.l10n.justNow;
    } else if (difference.inMinutes < 60) {
      return context.l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return context.l10n.hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return context.l10n.daysAgo(difference.inDays);
    } else {
      return context.l10n.weeksAgo((difference.inDays / 7).floor());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.units.w(20),
          vertical: context.units.h(16),
        ),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.transparent
              : context.cs.secondaryContainer.withValues(alpha: 0.3),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: context.units.w(48),
              height: context.units.w(48),
              decoration: BoxDecoration(
                color: _getIconColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(),
                size: context.units.w(24),
                color: _getIconColor(context),
              ),
            ),
            SizedBox(width: context.units.w(16)),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: context.tt.titleMedium.copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!notification.isRead) ...[
                        SizedBox(width: context.units.w(8)),
                        Container(
                          width: context.units.w(8),
                          height: context.units.w(8),
                          decoration: BoxDecoration(
                            color: context.cs.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: context.units.h(4)),
                  Text(
                    notification.message,
                    style: context.tt.labelLarge.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.units.h(8)),
                  Text(
                    _getTimeAgo(context, notification.timestamp),
                    style: context.tt.labelMedium.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
