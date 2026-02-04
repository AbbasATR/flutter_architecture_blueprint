import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/supplier/data/datasources/supplier_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/supplier/data/repositories/supplier_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/repositories/supplier_repository.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/usecases/get_suppliers_by_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_bloc.dart';

/// Initialize supplier feature dependencies.
Future<void> initSupplierDependencies(GetIt sl) async {
  // BLoC
  sl.registerFactory(() => SupplierBloc(getSuppliersByBusinessType: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetSuppliersByBusinessType(sl()));

  // Repository
  sl.registerLazySingleton<SupplierRepository>(
    () => SupplierRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SupplierRemoteDataSource>(
    () => SupplierRemoteDataSourceImpl(),
  );
}
