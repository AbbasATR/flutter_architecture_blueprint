import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/error/handle_dio_failure.dart';

Failure mapExceptionToFailure(Object error) {
  if (error is Failure) return error;
  if (error is DioException) return handleDioFailure(error);
  if (error is UnauthorizedException) return UnauthorizedFailure(error.message);
  if (error is ValidationException || error is InvalidInputException) {
    return ValidationFailure((error as dynamic).message as String);
  }
  if (error is CacheException || error is EmptyCacheException) {
    return CacheFailure((error as dynamic).message as String);
  }
  if (error is ResourceNotFoundException || error is NotFoundException) {
    return NotFoundFailure((error as dynamic).message as String);
  }
  if (error is NetworkException) return const NetworkFailure();
  if (error is ServerException) return ServerFailure(error.message);
  if (error is UnknownException) return UnknownFailure();
  return ServerFailure(error.toString());
}
