import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/shared/theme/data/datasources/theme_mode_local_data_source.dart';
import 'package:flutter_architecture_blueprint/shared/theme/data/repositories/theme_mode_repository_impl.dart';
import 'package:flutter_architecture_blueprint/shared/theme/domain/repositories/theme_mode_repository.dart';
import 'package:flutter_architecture_blueprint/shared/theme/bloc/theme_mode_cubit.dart';

Future<void> initTheme(GetIt sl) async {
  // Blocs
  sl.registerFactory(() => ThemeModeCubit(sl()));

  // Repositories
  sl.registerLazySingleton<ThemeModeRepository>(
    () => ThemeModeRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ThemeModeLocalDataSource>(
    () => ThemeModeLocalDataSourceImpl(sl()),
  );
}
