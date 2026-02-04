import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initCartDependencies(GetIt sl) async {
  // BLoC - Changed to LazySingleton so all screens share the same instance
  sl.registerLazySingleton(() => CartBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
}
