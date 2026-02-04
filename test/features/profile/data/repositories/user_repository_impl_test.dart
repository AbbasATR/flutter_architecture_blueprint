import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';
import 'package:flutter_architecture_blueprint/features/profile/data/models/user_model.dart';
import 'package:flutter_architecture_blueprint/features/profile/data/repositories/user_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tUser = User(
    id: 1,
    name: 'Test User',
    dateOfBirth: DateTime(1990, 1, 1),
    state: UserState.active,
    phoneNo: '+971501234567',
    addresses: const [],
    credit: 100,
    avatarURL: 'https://example.com/avatar.jpg',
  );

  final tUpdatedUserModel = UserModel(
    id: 1,
    name: 'Updated User',
    dateOfBirth: DateTime(1990, 1, 1),
    state: UserState.active,
    phoneNo: '+971501234567',
    addresses: const [],
    credit: 150,
    avatarURL: 'https://example.com/updated-avatar.jpg',
  );

  group('updateUser', () {
    test(
      'should return updated user when device is online and update succeeds',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.updateUser(any),
        ).thenAnswer((_) async => tUpdatedUserModel);

        // act
        final result = await repository.updateUser(tUser);

        // assert
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.updateUser(tUser));
        expect(result, Right(tUpdatedUserModel));
      },
    );

    test(
      'should return ServerFailure when update throws ServerException',
      () async {
        // arrange
        const errorMessage = 'Update failed';
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.updateUser(any),
        ).thenThrow(ServerException(errorMessage));

        // act
        final result = await repository.updateUser(tUser);

        // assert
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.updateUser(tUser));
        expect(result, Left(ServerFailure(errorMessage)));
      },
    );

    test('should return NetworkFailure when device is offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.updateUser(tUser);

      // assert
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockRemoteDataSource.updateUser(any));
      expect(result, Left(NetworkFailure()));
    });
  });
}
