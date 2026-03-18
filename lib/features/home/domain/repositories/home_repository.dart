import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';

import '../entities/home_bootstrap.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeBootstrap>> fetchHomeBootstrap();
}
