import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/shared/localization/data/datasources/locale_local_data_source.dart';
import 'package:flutter_architecture_blueprint/shared/localization/domain/repositories/locale_repository.dart';
import 'package:flutter_architecture_blueprint/shared/localization/localization_strings.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  final LocaleLocalDataSource localDataSource;

  LocaleRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> saveLocale(Locale locale) async {
    try {
      await localDataSource.saveLocale(locale);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Locale>> getLocale() async {
    try {
      final locale = await localDataSource.getLocale();
      if (locale == null) {
        return Left(CacheFailure(LocalizationStrings.noCachedLocaleFound));
      }
      return Right(locale);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
