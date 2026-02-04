import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/search/data/repositories/search_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_items.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_suppliers.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> initSearchDependencies() async {
  // BLoC
  sl.registerFactory(
    () => SearchBloc(searchItems: sl(), searchSuppliers: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchItems(sl()));
  sl.registerLazySingleton(() => SearchSuppliers(sl()));

  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(),
  );
}
