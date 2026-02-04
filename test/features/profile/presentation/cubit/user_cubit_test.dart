import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart'
    as user_entity;
import 'package:flutter_architecture_blueprint/features/profile/domain/usecases/update_user.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/cubit/user_cubit.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late UserCubit userCubit;
  late MockUpdateUser mockUpdateUser;

  setUp(() {
    mockUpdateUser = MockUpdateUser();
    userCubit = UserCubit(updateUser: mockUpdateUser);
  });

  tearDown(() {
    userCubit.close();
  });

  final tUser = user_entity.User(
    id: 1,
    name: 'John Doe',
    dateOfBirth: DateTime(1990, 1, 1),
    state: user_entity.UserState.active,
    phoneNo: '+1234567890',
    addresses: [],
    credit: 100,
    avatarURL: 'https://example.com/avatar.jpg',
  );

  final tUpdatedUser = user_entity.User(
    id: 1,
    name: 'John Updated',
    dateOfBirth: DateTime(1990, 1, 1),
    state: user_entity.UserState.active,
    phoneNo: '+1234567890',
    addresses: [],
    credit: 100,
    avatarURL: 'https://example.com/new-avatar.jpg',
  );

  test('initial state should be UserInitial', () {
    expect(userCubit.state, equals(UserInitial()));
  });

  group('updateUserProfile', () {
    blocTest<UserCubit, UserState>(
      'should emit [Loading, Loaded] when user update succeeds',
      build: () {
        when(mockUpdateUser(any)).thenAnswer((_) async => Right(tUpdatedUser));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserProfile(tUser),
      expect: () => [UserLoading(), UserLoaded(tUpdatedUser)],
      verify: (_) {
        verify(mockUpdateUser(UpdateUserParams(user: tUser))).called(1);
      },
    );

    blocTest<UserCubit, UserState>(
      'should emit [Loading, Error] when user update fails with ServerFailure',
      build: () {
        when(
          mockUpdateUser(any),
        ).thenAnswer((_) async => Left(ServerFailure('Update failed')));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserProfile(tUser),
      expect: () => [UserLoading(), const UserError('Update failed')],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Loading, Error] when user update fails with NetworkFailure',
      build: () {
        when(
          mockUpdateUser(any),
        ).thenAnswer((_) async => Left(NetworkFailure()));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserProfile(tUser),
      expect: () => [UserLoading(), const UserError('No internet connection')],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Loading, Error] when user update fails with ValidationFailure',
      build: () {
        when(
          mockUpdateUser(any),
        ).thenAnswer((_) async => Left(ValidationFailure('Invalid data')));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserProfile(tUser),
      expect: () => [UserLoading(), const UserError('Invalid data')],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Loading, Error] with default message when failure has no message',
      build: () {
        when(
          mockUpdateUser(any),
        ).thenAnswer((_) async => Left(UnknownFailure()));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserProfile(tUser),
      expect: () => [UserLoading(), const UserError('Unknown error occurred')],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Loading, Error] when user update fails with UnauthorizedFailure',
      build: () {
        when(
          mockUpdateUser(any),
        ).thenAnswer((_) async => Left(UnauthorizedFailure('Not authorized')));
        return userCubit;
      },
      act: (cubit) => cubit.updateUserProfile(tUser),
      expect: () => [UserLoading(), const UserError('Not authorized')],
    );
  });
}
