import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/shared/theme/data/datasources/theme_mode_local_data_source.dart';
import 'package:flutter_architecture_blueprint/shared/theme/domain/repositories/theme_mode_repository.dart';
import 'package:flutter_architecture_blueprint/shared/theme/theme_strings.dart';

class ThemeModeRepositoryImpl implements ThemeModeRepository {
  final ThemeModeLocalDataSource localDataSource;

  ThemeModeRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, Unit>> saveThemeMode(ThemeMode mode) async {
    try {
      await localDataSource.saveThemeMode(mode);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ThemeMode>> getThemeMode() async {
    try {
      final mode = await localDataSource.getThemeMode();
      if (mode == null) {
        return Left(CacheFailure(ThemeStrings.noCachedThemeModeFound));
      }
      return Right(mode);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
