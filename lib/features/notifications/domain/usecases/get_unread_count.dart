import 'package:flutter_architecture_blueprint/features/notifications/domain/repositories/notification_repository.dart';

class GetUnreadCount {
  final NotificationRepository repository;

  GetUnreadCount(this.repository);

  Future<int> call() async {
    return await repository.getUnreadCount();
  }
}
