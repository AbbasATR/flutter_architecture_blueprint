import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<Notification>> call() async {
    return await repository.getNotifications();
  }
}
