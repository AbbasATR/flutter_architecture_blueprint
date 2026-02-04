import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';

Failure handleDioFailure(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return NetworkFailure(); // Timeout errors

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode ?? 0;

      if (statusCode == 404) {
        return ServerFailure(error.response.toString());
      } else if (statusCode == 307) {
        return ServerFailure(
          'Redirected to another URL, please check the request URL.',
        );
      } else if (statusCode == 400 || statusCode == 422) {
        final message = error.response?.data["error"] ?? 'Validation error';
        return ValidationFailure(message);
      } else if (statusCode == 401 || statusCode == 403) {
        final message = error.response?.data["error"] ?? 'Unauthorized access';
        return UnauthorizedFailure(message);
      } else if (statusCode == 500) {
        final message =
            "لا يمكنك مسح هذا العنصر لأنه مرتبط بعناصر أخرى في النظام.";
        //"Status code: ${error.response?.statusCode} ${error.response?.data}";
        return ServerFailure(message);
      } else {
        final message = error.message ?? 'Server error';

        return ServerFailure(message);
      }

    case DioExceptionType.cancel:
      return UnknownFailure(); // Can create a custom CanceledFailure if needed

    case DioExceptionType.connectionError:
      return NetworkFailure(); // No internet

    case DioExceptionType.unknown:
    default:
      if (error.message?.contains('SocketException') == true) {
        return NetworkFailure();
      }
      return UnknownFailure();
  }
}
