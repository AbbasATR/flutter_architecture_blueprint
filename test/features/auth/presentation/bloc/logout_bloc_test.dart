import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/logout_bloc/logout_bloc.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LogoutBloc logoutBloc;
  late MockSignOutUseCase mockSignOutUseCase;

  setUp(() {
    mockSignOutUseCase = MockSignOutUseCase();
    logoutBloc = LogoutBloc(mockSignOutUseCase);
  });

  tearDown(() {
    logoutBloc.close();
  });

  test('initial state should be LogoutInitial', () {
    expect(logoutBloc.state, equals(LogoutInitial()));
  });

  group('LogoutRequested', () {
    blocTest<LogoutBloc, LogoutState>(
      'should emit [Loading, Success] when logout succeeds',
      build: () {
        when(mockSignOutUseCase()).thenAnswer((_) async => const Right(unit));
        return logoutBloc;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [LogoutLoading(), LogoutSuccess()],
      verify: (_) {
        verify(mockSignOutUseCase()).called(1);
      },
    );

    blocTest<LogoutBloc, LogoutState>(
      'should emit [Loading, Failure] when logout fails with ServerFailure',
      build: () {
        when(
          mockSignOutUseCase(),
        ).thenAnswer((_) async => Left(ServerFailure('Logout failed')));
        return logoutBloc;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [LogoutLoading(), const LogoutFailure('Logout failed')],
    );

    blocTest<LogoutBloc, LogoutState>(
      'should emit [Loading, Failure] when logout fails with NetworkFailure',
      build: () {
        when(
          mockSignOutUseCase(),
        ).thenAnswer((_) async => Left(NetworkFailure()));
        return logoutBloc;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [
        LogoutLoading(),
        const LogoutFailure('No internet connection'),
      ],
    );

    blocTest<LogoutBloc, LogoutState>(
      'should emit [Loading, Failure] when logout fails with UnauthorizedFailure',
      build: () {
        when(
          mockSignOutUseCase(),
        ).thenAnswer((_) async => Left(UnauthorizedFailure('Token expired')));
        return logoutBloc;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [LogoutLoading(), const LogoutFailure('Token expired')],
    );

    blocTest<LogoutBloc, LogoutState>(
      'should emit [Loading, Failure] with unknown error message',
      build: () {
        when(
          mockSignOutUseCase(),
        ).thenAnswer((_) async => Left(UnknownFailure()));
        return logoutBloc;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [
        LogoutLoading(),
        const LogoutFailure('Unknown error occurred'),
      ],
    );
  });
}
