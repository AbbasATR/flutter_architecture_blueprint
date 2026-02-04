import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/refresh_token.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late RefreshToken useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RefreshToken(mockAuthRepository);
  });

  const tAuthTokens = AuthTokens(
    accessToken: 'new_access_token',
    refreshToken: 'new_refresh_token',
  );

  group('RefreshToken', () {
    test('should call repository.refreshToken', () async {
      // arrange
      when(
        mockAuthRepository.refreshToken(),
      ).thenAnswer((_) async => const Right(tAuthTokens));

      // act
      await useCase(NoParams());

      // assert
      verify(mockAuthRepository.refreshToken());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return new AuthTokens when refresh is successful', () async {
      // arrange
      when(
        mockAuthRepository.refreshToken(),
      ).thenAnswer((_) async => const Right(tAuthTokens));

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, const Right(tAuthTokens));
      result.fold((failure) => fail('Should not return failure'), (tokens) {
        expect(tokens.accessToken, 'new_access_token');
        expect(tokens.refreshToken, 'new_refresh_token');
      });
    });

    test('should return ServerFailure when refresh token is invalid', () async {
      // arrange
      const tServerFailure = ServerFailure('Invalid refresh token');
      when(
        mockAuthRepository.refreshToken(),
      ).thenAnswer((_) async => const Left(tServerFailure));

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, const Left(tServerFailure));
      verify(mockAuthRepository.refreshToken());
    });

    test(
      'should return ServerFailure when refresh token has expired',
      () async {
        // arrange
        const tServerFailure = ServerFailure('Refresh token expired');
        when(
          mockAuthRepository.refreshToken(),
        ).thenAnswer((_) async => const Left(tServerFailure));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Left(tServerFailure));
      },
    );

    test('should return NetworkFailure when device is offline', () async {
      // arrange
      final tNetworkFailure = NetworkFailure();
      when(
        mockAuthRepository.refreshToken(),
      ).thenAnswer((_) async => Left(tNetworkFailure));

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, Left(tNetworkFailure));
      verify(mockAuthRepository.refreshToken());
    });

    test(
      'should return CacheFailure when no refresh token is stored',
      () async {
        // arrange
        const tCacheFailure = CacheFailure('No refresh token found');
        when(
          mockAuthRepository.refreshToken(),
        ).thenAnswer((_) async => const Left(tCacheFailure));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Left(tCacheFailure));
      },
    );
  });
}
