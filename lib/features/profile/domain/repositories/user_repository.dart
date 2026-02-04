import 'package:dartz/dartz.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> updateUser(User user);
}
