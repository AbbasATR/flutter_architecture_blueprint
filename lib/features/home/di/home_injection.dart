import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/usecases/get_home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/cubit/home_bootstrap_cubit.dart';

Future<void> initHomeFeature(GetIt sl) async {
  // Cubit
  sl.registerFactory(() => HomeBootstrapCubit(sl()));

  // Use Cases
  sl.registerFactory(() => GetHomeBootstrapUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
}
