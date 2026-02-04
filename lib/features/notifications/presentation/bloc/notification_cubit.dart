import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_notifications.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_unread_count.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_all_as_read.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_as_read.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotifications getNotifications;
  final GetUnreadCount getUnreadCount;
  final MarkAsRead markAsRead;
  final MarkAllAsRead markAllAsRead;

  NotificationCubit({
    required this.getNotifications,
    required this.getUnreadCount,
    required this.markAsRead,
    required this.markAllAsRead,
  }) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await getNotifications();
      final unreadCount = await getUnreadCount();
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await markAsRead(notificationId);

        // Update local state
        final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == notificationId) {
            return Notification(
              id: n.id,
              title: n.title,
              message: n.message,
              timestamp: n.timestamp,
              isRead: true,
              type: n.type,
              imageUrl: n.imageUrl,
              actionData: n.actionData,
            );
          }
          return n;
        }).toList();

        final newUnreadCount = await getUnreadCount();

        emit(
          NotificationLoaded(
            notifications: updatedNotifications,
            unreadCount: newUnreadCount,
          ),
        );
      } catch (e) {
        emit(NotificationError(message: e.toString()));
      }
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        await markAllAsRead();

        // Update local state
        final updatedNotifications = currentState.notifications.map((n) {
          return Notification(
            id: n.id,
            title: n.title,
            message: n.message,
            timestamp: n.timestamp,
            isRead: true,
            type: n.type,
            imageUrl: n.imageUrl,
            actionData: n.actionData,
          );
        }).toList();

        emit(
          NotificationLoaded(
            notifications: updatedNotifications,
            unreadCount: 0,
          ),
        );
      } catch (e) {
        emit(NotificationError(message: e.toString()));
      }
    }
  }

  Future<void> refreshUnreadCount() async {
    try {
      final unreadCount = await getUnreadCount();
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        emit(
          NotificationLoaded(
            notifications: currentState.notifications,
            unreadCount: unreadCount,
          ),
        );
      }
    } catch (e) {
      // Silently fail for background refresh
    }
  }
}
