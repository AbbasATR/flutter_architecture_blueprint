import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/orders/data/repositories/order_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/create_order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_active_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_past_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';

Future<void> initOrderInjection(GetIt sl) async {
  sl.registerFactory(() => OrderBloc(getActiveOrders: sl(), getPastOrders: sl(), createOrder: sl()));

  sl.registerLazySingleton(() => GetActiveOrders(sl()));
  sl.registerLazySingleton(() => GetPastOrders(sl()));
  sl.registerLazySingleton(() => CreateOrder(sl()));

  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(dioClient: sl()));
}
