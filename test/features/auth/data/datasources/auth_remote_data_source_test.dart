import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/constants/api_endpoints.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/auth/data/models/auth_tokens_model.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../../../helpers/json_reader.dart';

void main() {
  late AuthRemoteImplWithDio dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = AuthRemoteImplWithDio(mockDioClient);
  });

  group('requestOtp', () {
    const tPhoneNumber = '+1234567890';
    final tResponse = Response(
      data: json.decode(fixture('auth/otp_request_response.json')),
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.requestOtp),
    );

    test('should return Unit when OTP request is successful', () async {
      // arrange
      when(
        mockDioClient.post(
          ApiEndpoints.requestOtp,
          data: {'phoneNumber': tPhoneNumber},
        ),
      ).thenAnswer((_) async => tResponse);

      // act
      final result = await dataSource.requestOtp(tPhoneNumber);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left with failure: $failure'),
        (unit) => expect(unit, equals(unit)),
      );
      verify(
        mockDioClient.post(
          ApiEndpoints.requestOtp,
          data: {'phoneNumber': tPhoneNumber},
        ),
      );
      verifyNoMoreInteractions(mockDioClient);
    });

    test(
      'should return NetworkFailure when connection timeout occurs',
      () async {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ApiEndpoints.requestOtp),
        );
        when(
          mockDioClient.post(
            ApiEndpoints.requestOtp,
            data: {'phoneNumber': tPhoneNumber},
          ),
        ).thenThrow(dioException);

        // act
        final result = await dataSource.requestOtp(tPhoneNumber);

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (unit) => fail('Expected Left but got Right'),
        );
      },
    );

    test('should return UnknownFailure when unexpected error occurs', () async {
      // arrange
      when(
        mockDioClient.post(
          ApiEndpoints.requestOtp,
          data: {'phoneNumber': tPhoneNumber},
        ),
      ).thenThrow(Exception('Unexpected error'));

      // act
      final result = await dataSource.requestOtp(tPhoneNumber);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (unit) => fail('Expected Left but got Right'),
      );
    });
  });

  group('verifyOtp', () {
    const tPhoneNumber = '+1234567890';
    const tPinCode = '123456';
    final tTokenJson =
        json.decode(fixture('auth/verify_otp_response.json'))
            as Map<String, dynamic>;
    final tResponse = Response(
      data: tTokenJson,
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.verifyOtp),
    );

    test(
      'should return AuthTokensModel when OTP verification is successful',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiEndpoints.verifyOtp,
            data: {'phoneNumber': tPhoneNumber, 'pinCode': tPinCode},
          ),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.verifyOtp(tPhoneNumber, tPinCode);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) =>
              fail('Expected Right but got Left with failure: $failure'),
          (tokens) {
            expect(tokens, isA<AuthTokensModel>());
            expect(tokens.accessToken, isNotEmpty);
            expect(tokens.refreshToken, isNotEmpty);
          },
        );
        verify(
          mockDioClient.post(
            ApiEndpoints.verifyOtp,
            data: {'phoneNumber': tPhoneNumber, 'pinCode': tPinCode},
          ),
        );
      },
    );

    test('should return ValidationFailure when OTP is invalid', () async {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {'message': 'Invalid OTP'},
          requestOptions: RequestOptions(path: ApiEndpoints.verifyOtp),
        ),
        requestOptions: RequestOptions(path: ApiEndpoints.verifyOtp),
      );
      when(
        mockDioClient.post(
          ApiEndpoints.verifyOtp,
          data: {'phoneNumber': tPhoneNumber, 'pinCode': tPinCode},
        ),
      ).thenThrow(dioException);

      // act
      final result = await dataSource.verifyOtp(tPhoneNumber, tPinCode);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (tokens) => fail('Expected Left but got Right'),
      );
    });
  });

  group('refreshToken', () {
    const tRefreshToken = 'old_refresh_token';
    final tTokenJson =
        json.decode(fixture('auth/refresh_token_response.json'))
            as Map<String, dynamic>;
    final tResponse = Response(
      data: tTokenJson,
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
    );

    test(
      'should return new AuthTokensModel when token refresh is successful',
      () async {
        // arrange
        when(
          mockDioClient.post(
            ApiEndpoints.refreshToken,
            data: {'refreshToken': tRefreshToken},
          ),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.refreshToken(tRefreshToken);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) =>
              fail('Expected Right but got Left with failure: $failure'),
          (tokens) {
            expect(tokens, isA<AuthTokensModel>());
            expect(tokens.accessToken, isNotEmpty);
          },
        );
      },
    );

    test(
      'should return UnauthorizedFailure when refresh token is invalid',
      () async {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 401,
            data: {'error': 'Invalid refresh token'},
            requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
          ),
          requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
        );
        when(
          mockDioClient.post(
            ApiEndpoints.refreshToken,
            data: {'refreshToken': tRefreshToken},
          ),
        ).thenThrow(dioException);

        // act
        final result = await dataSource.refreshToken(tRefreshToken);

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnauthorizedFailure>()),
          (tokens) => fail('Expected Left but got Right'),
        );
      },
    );
  });

  group('signOut', () {
    final tResponse = Response(
      data: {'message': 'Logged out successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.logout),
    );

    test('should return Unit when logout is successful', () async {
      // arrange
      when(
        mockDioClient.post(ApiEndpoints.logout),
      ).thenAnswer((_) async => tResponse);

      // act
      final result = await dataSource.signOut();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left with failure: $failure'),
        (unit) => expect(unit, equals(unit)),
      );
      verify(mockDioClient.post(ApiEndpoints.logout));
    });

    test('should return ServerFailure when logout fails', () async {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ApiEndpoints.logout),
        ),
        requestOptions: RequestOptions(path: ApiEndpoints.logout),
      );
      when(mockDioClient.post(ApiEndpoints.logout)).thenThrow(dioException);

      // act
      final result = await dataSource.signOut();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (unit) => fail('Expected Left but got Right'),
      );
    });
  });

  group('appStart', () {
    const tAccessToken = 'test_access_token';
    final tResponse = Response(
      data: json.decode(fixture('home/home_bootstrap.json')),
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.userData),
    );

    test('should return AppBootstrap when app start is successful', () async {
      // arrange
      when(
        mockDioClient.get(ApiEndpoints.userData, options: anyNamed('options')),
      ).thenAnswer((_) async => tResponse);

      // act
      final result = await dataSource.appStart(tAccessToken);

      // assert
      expect(result.isRight(), true);
      verify(
        mockDioClient.get(ApiEndpoints.userData, options: anyNamed('options')),
      );
    });

    test('should return UnauthorizedFailure when token is invalid', () async {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 401,
          data: {'error': 'Invalid token'},
          requestOptions: RequestOptions(path: ApiEndpoints.userData),
        ),
        requestOptions: RequestOptions(path: ApiEndpoints.userData),
      );
      when(
        mockDioClient.get(ApiEndpoints.userData, options: anyNamed('options')),
      ).thenThrow(dioException);

      // act
      final result = await dataSource.appStart(tAccessToken);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnauthorizedFailure>()),
        (bootstrap) => fail('Expected Left but got Right'),
      );
    });
  });
}
