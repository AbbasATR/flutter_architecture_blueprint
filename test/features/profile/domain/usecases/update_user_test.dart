import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/usecases/update_user.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late UpdateUser useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = UpdateUser(mockUserRepository);
  });

  final tUser = User(
    id: 1,
    name: 'John Doe',
    dateOfBirth: DateTime(1990, 1, 1),
    state: UserState.active,
    phoneNo: '+971501234567',
    addresses: [],
    credit: 100,
    avatarURL: 'https://example.com/avatar.png',
  );

  final tUpdatedUser = User(
    id: 1,
    name: 'John Updated',
    dateOfBirth: DateTime(1990, 1, 1),
    state: UserState.active,
    phoneNo: '+971501234567',
    addresses: [],
    credit: 100,
    avatarURL: 'https://example.com/avatar.png',
  );

  final tParams = UpdateUserParams(user: tUser);

  group('UpdateUser', () {
    test('should call repository.updateUser with correct user', () async {
      // arrange
      when(
        mockUserRepository.updateUser(any),
      ).thenAnswer((_) async => Right(tUpdatedUser));

      // act
      await useCase(tParams);

      // assert
      verify(mockUserRepository.updateUser(tUser));
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return updated User when update is successful', () async {
      // arrange
      when(
        mockUserRepository.updateUser(any),
      ).thenAnswer((_) async => Right(tUpdatedUser));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Right(tUpdatedUser));
      result.fold((failure) => fail('Should not return failure'), (user) {
        expect(user.id, 1);
        expect(user.name, 'John Updated');
      });
    });

    test(
      'should return ServerFailure when repository returns ServerFailure',
      () async {
        // arrange
        const tServerFailure = ServerFailure('Failed to update user');
        when(
          mockUserRepository.updateUser(any),
        ).thenAnswer((_) async => const Left(tServerFailure));

        // act
        final result = await useCase(tParams);

        // assert
        expect(result, const Left(tServerFailure));
        verify(mockUserRepository.updateUser(tUser));
      },
    );

    test('should return NetworkFailure when device is offline', () async {
      // arrange
      final tNetworkFailure = NetworkFailure();
      when(
        mockUserRepository.updateUser(any),
      ).thenAnswer((_) async => Left(tNetworkFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Left(tNetworkFailure));
      verify(mockUserRepository.updateUser(tUser));
    });

    test('should return ValidationFailure for invalid user data', () async {
      // arrange
      const tValidationFailure = ValidationFailure('Invalid user data');
      when(
        mockUserRepository.updateUser(any),
      ).thenAnswer((_) async => const Left(tValidationFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tValidationFailure));
    });
  });

  group('UpdateUserParams', () {
    test('should support value equality', () {
      // arrange
      final params1 = UpdateUserParams(user: tUser);
      final params2 = UpdateUserParams(user: tUser);

      // assert
      expect(params1, params2);
    });

    test('props should contain user', () {
      // arrange
      final params = UpdateUserParams(user: tUser);

      // assert
      expect(params.props, [tUser]);
    });
  });
}
