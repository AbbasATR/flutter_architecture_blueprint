import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/address/data/datasources/address_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/address/data/repositories/address_repository_impl.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/repositories/address_repository.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_addresses.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_selected_address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/select_address.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';

Future<void> initAddressFeature(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<AddressLocalDataSource>(
    () => AddressLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAddresses(sl()));
  sl.registerLazySingleton(() => GetSelectedAddress(sl()));
  sl.registerLazySingleton(() => SelectAddress(sl()));

  // Cubit
  sl.registerFactory(
    () => AddressCubit(
      getAddresses: sl(),
      getSelectedAddress: sl(),
      selectAddress: sl(),
    ),
  );
}
