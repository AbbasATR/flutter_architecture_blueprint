import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/sign_out.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SignOutUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignOutUseCase(mockAuthRepository);
  });

  group('SignOutUseCase', () {
    test('should call repository.signOut', () async {
      // arrange
      when(
        mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      // act
      await useCase();

      // assert
      verify(mockAuthRepository.signOut());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return unit when sign out is successful', () async {
      // arrange
      when(
        mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(unit));
    });

    test('should return CacheFailure when token cleanup fails', () async {
      // arrange
      const tCacheFailure = CacheFailure('Failed to clear tokens');
      when(
        mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Left(tCacheFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, const Left(tCacheFailure));
      verify(mockAuthRepository.signOut());
    });

    test('should handle offline sign out gracefully', () async {
      // arrange
      when(
        mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(unit));
    });
  });
}
