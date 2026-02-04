import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_notifications.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/get_unread_count.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_all_as_read.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/usecases/mark_as_read.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';

Future<void> initNotificationsFeature(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => GetUnreadCount(sl()));
  sl.registerLazySingleton(() => MarkAsRead(sl()));
  sl.registerLazySingleton(() => MarkAllAsRead(sl()));

  // Cubit
  sl.registerFactory(
    () => NotificationCubit(
      getNotifications: sl(),
      getUnreadCount: sl(),
      markAsRead: sl(),
      markAllAsRead: sl(),
    ),
  );
}
