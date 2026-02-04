import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/error/handle_dio_failure.dart';

void main() {
  group('handleDioFailure', () {
    test('should return NetworkFailure for connectionTimeout', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<NetworkFailure>());
    });

    test('should return NetworkFailure for receiveTimeout', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<NetworkFailure>());
    });

    test('should return NetworkFailure for sendTimeout', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.sendTimeout,
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<NetworkFailure>());
    });

    test('should return NetworkFailure for connectionError', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<NetworkFailure>());
    });

    test('should return ServerFailure for badResponse with 404 status', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<ServerFailure>());
    });

    test('should return ServerFailure for badResponse with 307 status', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 307,
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<ServerFailure>());
      expect(
        (result as ServerFailure).message,
        contains('Redirected to another URL'),
      );
    });

    test('should return ValidationFailure for badResponse with 400 status', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {'error': 'Invalid input'},
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<ValidationFailure>());
      expect((result as ValidationFailure).message, equals('Invalid input'));
    });

    test('should return ValidationFailure for badResponse with 422 status', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 422,
          data: {'error': 'Unprocessable entity'},
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<ValidationFailure>());
      expect(
        (result as ValidationFailure).message,
        equals('Unprocessable entity'),
      );
    });

    test(
      'should return ValidationFailure with default message when 400 has no error field',
      () {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 400,
            data: {},
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
        );

        // act
        final result = handleDioFailure(dioException);

        // assert
        expect(result, isA<ValidationFailure>());
        expect(
          (result as ValidationFailure).message,
          equals('Validation error'),
        );
      },
    );

    test(
      'should return UnauthorizedFailure for badResponse with 401 status',
      () {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 401,
            data: {'error': 'Unauthorized'},
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
        );

        // act
        final result = handleDioFailure(dioException);

        // assert
        expect(result, isA<UnauthorizedFailure>());
        expect((result as UnauthorizedFailure).message, equals('Unauthorized'));
      },
    );

    test(
      'should return UnauthorizedFailure for badResponse with 403 status',
      () {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 403,
            data: {'error': 'Forbidden'},
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
        );

        // act
        final result = handleDioFailure(dioException);

        // assert
        expect(result, isA<UnauthorizedFailure>());
        expect((result as UnauthorizedFailure).message, equals('Forbidden'));
      },
    );

    test(
      'should return UnauthorizedFailure with default message when 401 has no error field',
      () {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 401,
            data: {},
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
        );

        // act
        final result = handleDioFailure(dioException);

        // assert
        expect(result, isA<UnauthorizedFailure>());
        expect(
          (result as UnauthorizedFailure).message,
          equals('Unauthorized access'),
        );
      },
    );

    test('should return ServerFailure for badResponse with 500 status', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
        ),
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<ServerFailure>());
    });

    test(
      'should return ServerFailure for badResponse with unknown status code',
      () {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 503,
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
          message: 'Service unavailable',
        );

        // act
        final result = handleDioFailure(dioException);

        // assert
        expect(result, isA<ServerFailure>());
      },
    );

    test('should return UnknownFailure for cancel type', () {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(path: '/test'),
      );

      // act
      final result = handleDioFailure(dioException);

      // assert
      expect(result, isA<UnknownFailure>());
    });

    test(
      'should return NetworkFailure for unknown type with SocketException',
      () {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: '/test'),
          message: 'SocketException: Failed host lookup',
        );

        // act
        final result = handleDioFailure(dioException);

        // assert
        expect(result, isA<NetworkFailure>());
      },
    );

    test(
      'should return UnknownFailure for unknown type without SocketException',
      () {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: '/test'),
          message: 'Unknown error occurred',
        );

        // act
        final result = handleDioFailure(dioException);

        // assert
        expect(result, isA<UnknownFailure>());
      },
    );
  });
}
