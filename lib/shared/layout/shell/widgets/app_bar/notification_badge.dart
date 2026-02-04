import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Notification badge component with unread count indicator.
///
/// Displays a notification icon with a badge showing unread count.
/// Taps navigate to the notifications screen and refresh the count on return.
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final unreadCount = state is NotificationLoaded ? state.unreadCount : 0;

        return InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<NotificationCubit>(),
                  child: const NotificationsScreen(),
                ),
              ),
            );
            if (context.mounted) {
              context.read<NotificationCubit>().refreshUnreadCount();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: context.units.w(40),
            height: context.units.w(40),
            decoration: BoxDecoration(
              border:
                  Border.all(color: context.cs.tertiary.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    IconsaxPlusLinear.notification,
                    size: context.units.w(20),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _UnreadBadge(count: unreadCount),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Private widget for displaying the unread count badge.
class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        count > 9 ? context.units.w(2) : context.units.w(4),
      ),
      decoration: BoxDecoration(
        color: context.cs.error,
        shape: BoxShape.circle,
      ),
      constraints: BoxConstraints(
        minWidth: context.units.w(16),
        minHeight: context.units.w(16),
      ),
      child: Center(
        child: Text(
          count > 9 ? '9+' : '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
