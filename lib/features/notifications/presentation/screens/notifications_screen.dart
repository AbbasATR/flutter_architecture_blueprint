import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/widgets/notification_empty_state.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/widgets/notification_item.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        backgroundColor: context.cs.surface,
        elevation: 0,
        leading: custom.FloatingActionButton(
          icon: IconsaxPlusLinear.undo,
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.notifications,
          style: context.tt.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    context
                        .read<NotificationCubit>()
                        .markAllNotificationsAsRead();
                  },
                  child: Text(
                    context.l10n.markAllRead,
                    style: context.tt.labelLarge.copyWith(
                      color: context.cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconsaxPlusLinear.danger,
                    size: context.units.w(60),
                    color: context.cs.error,
                  ),
                  SizedBox(height: context.units.h(16)),
                  Text(
                    context.l10n.errorLoadingNotifications,
                    style: context.tt.titleMedium,
                  ),
                  SizedBox(height: context.units.h(8)),
                  Text(
                    state.message,
                    style: context.tt.labelMedium.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.units.h(24)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().loadNotifications();
                    },
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const NotificationEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationCubit>().loadNotifications();
              },
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: context.units.h(8)),
                itemCount: state.notifications.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: context.cs.outline.withValues(alpha: 0.1),
                ),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return NotificationItem(
                    notification: notification,
                    onTap: () {
                      if (!notification.isRead) {
                        context
                            .read<NotificationCubit>()
                            .markNotificationAsRead(notification.id);
                      }

                      // Navigate to relevant screen based on notification.actionData
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
