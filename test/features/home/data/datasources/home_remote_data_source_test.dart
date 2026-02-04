import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/constants/api_endpoints.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_bootstrap_model.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../../../helpers/json_reader.dart';

void main() {
  late HomeRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = HomeRemoteDataSourceImpl(mockDioClient);
  });

  group('fetchHomeBootstrap', () {
    final tHomeBootstrapJson =
        json.decode(fixture('home/home_bootstrap.json'))
            as Map<String, dynamic>;

    final tResponse = Response(
      data: tHomeBootstrapJson,
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.homeBootstrap),
    );

    test(
      'should return HomeBootstrapModel when the API call is successful',
      () async {
        // arrange
        when(
          mockDioClient.get(ApiEndpoints.homeBootstrap),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.fetchHomeBootstrap();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (failure) =>
              fail('Expected Right but got Left with failure: $failure'),
          (model) {
            expect(model, isA<HomeBootstrapModel>());
            expect(model.categories, isNotEmpty);
          },
        );
        verify(mockDioClient.get(ApiEndpoints.homeBootstrap));
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test(
      'should return NetworkFailure when connection timeout occurs',
      () async {
        // arrange
        final dioException = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ApiEndpoints.homeBootstrap),
        );
        when(
          mockDioClient.get(ApiEndpoints.homeBootstrap),
        ).thenThrow(dioException);

        // act
        final result = await dataSource.fetchHomeBootstrap();

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (model) => fail('Expected Left but got Right with model: $model'),
        );
        verify(mockDioClient.get(ApiEndpoints.homeBootstrap));
        verifyNoMoreInteractions(mockDioClient);
      },
    );

    test('should return ServerFailure when server returns 500', () async {
      // arrange
      final dioException = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ApiEndpoints.homeBootstrap),
        ),
        requestOptions: RequestOptions(path: ApiEndpoints.homeBootstrap),
      );
      when(
        mockDioClient.get(ApiEndpoints.homeBootstrap),
      ).thenThrow(dioException);

      // act
      final result = await dataSource.fetchHomeBootstrap();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (model) => fail('Expected Left but got Right with model: $model'),
      );
    });

    test('should return UnknownFailure when unexpected error occurs', () async {
      // arrange
      when(
        mockDioClient.get(ApiEndpoints.homeBootstrap),
      ).thenThrow(Exception('Unexpected error'));

      // act
      final result = await dataSource.fetchHomeBootstrap();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnknownFailure>()),
        (model) => fail('Expected Left but got Right with model: $model'),
      );
    });
  });
}
