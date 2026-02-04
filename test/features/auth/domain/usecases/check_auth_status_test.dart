import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/check_auth_status.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CheckAuthStatusUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = CheckAuthStatusUseCase(mockAuthRepository);
  });

  const tHomeBootstrap = HomeBootstrap(
    categories: [],
    brands: [],
    savedItems: [],
    newListings: [],
  );
  const tAuthSession = AuthSession(
    appBootstrap: tHomeBootstrap,
    accessToken: 'test_access_token',
  );

  group('CheckAuthStatusUseCase', () {
    test('should call repository.checkAuthStatus', () async {
      // arrange
      when(
        mockAuthRepository.checkAuthStatus(),
      ).thenAnswer((_) async => const Right(tAuthSession));

      // act
      await useCase();

      // assert
      verify(mockAuthRepository.checkAuthStatus());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthSession when user is authenticated', () async {
      // arrange
      when(
        mockAuthRepository.checkAuthStatus(),
      ).thenAnswer((_) async => const Right(tAuthSession));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tAuthSession));
    });

    test('should return CacheFailure when no stored session', () async {
      // arrange
      const tCacheFailure = CacheFailure('No stored session');
      when(
        mockAuthRepository.checkAuthStatus(),
      ).thenAnswer((_) async => const Left(tCacheFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, const Left(tCacheFailure));
    });

    test('should return UnknownFailure when exception is thrown', () async {
      // arrange
      when(
        mockAuthRepository.checkAuthStatus(),
      ).thenThrow(Exception('Unexpected error'));

      // act
      final result = await useCase();

      // assert
      expect(result, Left(UnknownFailure()));
    });
  });
}
