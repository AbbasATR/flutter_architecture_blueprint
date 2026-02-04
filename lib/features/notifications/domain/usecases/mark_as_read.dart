import 'package:flutter_architecture_blueprint/features/notifications/domain/repositories/notification_repository.dart';

class MarkAsRead {
  final NotificationRepository repository;

  MarkAsRead(this.repository);

  Future<void> call(String notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}
