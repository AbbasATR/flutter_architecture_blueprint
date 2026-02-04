import 'package:flutter_architecture_blueprint/features/notifications/domain/repositories/notification_repository.dart';

class MarkAllAsRead {
  final NotificationRepository repository;

  MarkAllAsRead(this.repository);

  Future<void> call() async {
    return await repository.markAllAsRead();
  }
}
