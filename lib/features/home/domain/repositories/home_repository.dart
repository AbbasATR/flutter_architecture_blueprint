import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, AppBootstrap>> fetchHomeBootstrap();
}
