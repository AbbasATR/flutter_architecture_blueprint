import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/item/data/datasources/item_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/item/data/repositories/item_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/repositories/item_repository.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/usecases/get_items_by_supplier_id.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_bloc.dart';

/// Initialize item feature dependencies.
Future<void> initItemDependencies(GetIt sl) async {
  // BLoC
  sl.registerFactory(() => ItemBloc(getItemsBySupplierId: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetItemsBySupplierId(sl()));

  // Repository
  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ItemRemoteDataSource>(
    () => ItemRemoteDataSourceImpl(),
  );
}
