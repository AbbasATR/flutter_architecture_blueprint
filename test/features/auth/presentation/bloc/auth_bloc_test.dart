import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

  setUp(() {
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    authBloc = AuthBloc(mockCheckAuthStatusUseCase);
  });

  tearDown(() {
    authBloc.close();
  });

  const tHomeBootstrap = HomeBootstrap(
    categories: [],
    brands: [],
    savedItems: [],
    newListings: [],
  );
  const tAccessToken = 'test_access_token';
  const tAuthSession = AuthSession(
    appBootstrap: tHomeBootstrap,
    accessToken: tAccessToken,
  );

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, equals(AuthInitial()));
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [Loading, Authenticated] when auth check succeeds with valid session',
      build: () {
        when(
          mockCheckAuthStatusUseCase(),
        ).thenAnswer((_) async => const Right(tAuthSession));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      wait: const Duration(seconds: 3),
      expect: () => [
        AuthLoading(),
        const AuthAuthenticated(tHomeBootstrap, tAccessToken),
      ],
      verify: (_) {
        verify(mockCheckAuthStatusUseCase()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [Loading, Unauthenticated] when auth check returns null session',
      build: () {
        when(
          mockCheckAuthStatusUseCase(),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      wait: const Duration(seconds: 3),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
      verify: (_) {
        verify(mockCheckAuthStatusUseCase()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [Loading, Unauthenticated] when auth check fails',
      build: () {
        when(
          mockCheckAuthStatusUseCase(),
        ).thenAnswer((_) async => Left(UnknownFailure()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      wait: const Duration(seconds: 3),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [Loading, Unauthenticated] when network failure occurs',
      build: () {
        when(
          mockCheckAuthStatusUseCase(),
        ).thenAnswer((_) async => Left(NetworkFailure()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      wait: const Duration(seconds: 3),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [Loading, Unauthenticated] when server failure occurs',
      build: () {
        when(
          mockCheckAuthStatusUseCase(),
        ).thenAnswer((_) async => Left(ServerFailure('Server error')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      wait: const Duration(seconds: 3),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );
  });

  group('AuthLoggedIn', () {
    blocTest<AuthBloc, AuthState>(
      'should emit Authenticated when user logs in',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthLoggedIn(tHomeBootstrap, tAccessToken)),
      expect: () => [const AuthAuthenticated(tHomeBootstrap, tAccessToken)],
      verify: (_) {
        // Should not call use case for direct login event
        verifyNever(mockCheckAuthStatusUseCase());
      },
    );
  });

  group('AuthLoggedOut', () {
    blocTest<AuthBloc, AuthState>(
      'should emit Unauthenticated when user logs out',
      build: () => authBloc,
      seed: () => const AuthAuthenticated(tHomeBootstrap, tAccessToken),
      act: (bloc) => bloc.add(const AuthLoggedOut()),
      expect: () => [AuthUnauthenticated()],
      verify: (_) {
        // Should not call use case for logout event
        verifyNever(mockCheckAuthStatusUseCase());
      },
    );
  });
}
