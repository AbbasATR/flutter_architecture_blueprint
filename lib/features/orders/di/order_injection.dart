import 'package:get_it/get_it.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter_architecture_blueprint/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/orders/data/repositories/order_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/create_order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_active_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_past_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';

final sl = GetIt.instance;

Future<void> initOrderInjection() async {
  sl.registerLazySingleton(
    () => OrderBloc(
      getActiveOrders: sl(),
      getPastOrders: sl(),
      createOrder: sl(),
    ),
  );

  sl.registerFactory(() => GetActiveOrders(sl()));
  sl.registerFactory(() => GetPastOrders(sl()));
  sl.registerFactory(() => CreateOrder(sl()));

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(
      client: sl<http.Client>(),
      useMockData: true,
    ),
  );
}
