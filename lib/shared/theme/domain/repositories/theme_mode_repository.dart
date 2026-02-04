import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';

abstract class ThemeModeRepository {
  Future<Either<Failure, Unit>> saveThemeMode(ThemeMode mode);
  Future<Either<Failure, ThemeMode>> getThemeMode();
}
