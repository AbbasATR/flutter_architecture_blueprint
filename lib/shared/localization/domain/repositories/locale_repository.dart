import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';

abstract class LocaleRepository {
  Future<Either<Failure, Unit>> saveLocale(Locale locale);
  Future<Either<Failure, Locale>> getLocale();
}
