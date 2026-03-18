import 'package:flutter_architecture_blueprint/shared/localization/data/datasources/locale_local_data_source.dart';
import 'package:flutter_architecture_blueprint/shared/localization/data/repositories/locale_repository_impl.dart';
import 'package:flutter_architecture_blueprint/shared/localization/domain/repositories/locale_repository.dart';
import 'package:flutter_architecture_blueprint/shared/localization/locale_cubit.dart';
import 'package:get_it/get_it.dart';

Future<void> initLocalization(GetIt sl) async {
  sl.registerFactory(() => LocaleCubit(sl()));
  sl.registerLazySingleton<LocaleRepository>(() => LocaleRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<LocaleLocalDataSource>(() => LocaleLocalDataSourceImpl(sharedPreferences: sl()));
}
