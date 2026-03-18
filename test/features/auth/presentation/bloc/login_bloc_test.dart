import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/request_otp.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/verify_otp.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/get_app_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/app_bootstrap.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginBloc loginBloc;
  late MockRequestOtp mockRequestOtp;
  late MockVerifyOtp mockVerifyOtp;
  late MockGetAppBootstrap mockGetAppBootstrap;

  setUp(() {
    mockRequestOtp = MockRequestOtp();
    mockVerifyOtp = MockVerifyOtp();
    mockGetAppBootstrap = MockGetAppBootstrap();
    loginBloc = LoginBloc(
      requestOtpUseCase: mockRequestOtp,
      verifyOtpUseCase: mockVerifyOtp,
      getAppBootstrapUseCase: mockGetAppBootstrap,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  const tPhoneNumber = '+1234567890';
  const tPinCode = '123456';
  const tAuthTokens = AuthTokens(
    accessToken: 'test_access_token',
    refreshToken: 'test_refresh_token',
  );
  const tAppBootstrap = AppBootstrap(
    categories: [],
    brands: [],
    savedItems: [],
    newListings: [],
  );

  test('initial state should be LoginInitial', () {
    // assert
    expect(loginBloc.state, equals(LoginInitial()));
  });

  group('RequestOtpSubmitted', () {
    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, OtpRequested] when OTP request succeeds',
      build: () {
        when(mockRequestOtp(any)).thenAnswer((_) async => const Right(unit));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const RequestOtpSubmitted(tPhoneNumber)),
      expect: () => [LoginLoading(), const OtpRequested(tPhoneNumber)],
      verify: (_) {
        verify(
          mockRequestOtp(const RequestOtpParams(phoneNumber: tPhoneNumber)),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when phone number is empty',
      build: () => loginBloc,
      act: (bloc) => bloc.add(const RequestOtpSubmitted('')),
      expect: () => [
        LoginLoading(),
        const LoginFailure('Please enter a phone number'),
      ],
      verify: (_) {
        verifyNever(mockRequestOtp(any));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when OTP request fails with NetworkFailure',
      build: () {
        when(
          mockRequestOtp(any),
        ).thenAnswer((_) async => Left(NetworkFailure()));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const RequestOtpSubmitted(tPhoneNumber)),
      expect: () => [
        LoginLoading(),
        const LoginFailure('No internet connection'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when OTP request fails with ServerFailure',
      build: () {
        when(
          mockRequestOtp(any),
        ).thenAnswer((_) async => Left(ServerFailure('Server error')));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const RequestOtpSubmitted(tPhoneNumber)),
      expect: () => [LoginLoading(), const LoginFailure('Server error')],
    );
  });

  group('VerifyOtpSubmitted', () {
    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Success] when OTP verification and app bootstrap succeed',
      build: () {
        when(
          mockVerifyOtp(any),
        ).thenAnswer((_) async => const Right(tAuthTokens));
        when(
          mockGetAppBootstrap(any),
        ).thenAnswer((_) async => const Right(tAppBootstrap));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const VerifyOtpSubmitted(tPhoneNumber, tPinCode)),
      expect: () => [
        LoginLoading(),
        const LoginSuccess(tAuthTokens, tAppBootstrap),
      ],
      verify: (_) {
        verify(
          mockVerifyOtp(
            const VerifyOtpParams(phoneNumber: tPhoneNumber, pinCode: tPinCode),
          ),
        );
        verify(
          mockGetAppBootstrap(
            const GetAppBootstrapParams(accessToken: 'test_access_token'),
          ),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when phone number is empty',
      build: () => loginBloc,
      act: (bloc) => bloc.add(const VerifyOtpSubmitted('', tPinCode)),
      expect: () => [
        LoginLoading(),
        const LoginFailure('Phone number and PIN code are required'),
      ],
      verify: (_) {
        verifyNever(mockVerifyOtp(any));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when PIN code is empty',
      build: () => loginBloc,
      act: (bloc) => bloc.add(const VerifyOtpSubmitted(tPhoneNumber, '')),
      expect: () => [
        LoginLoading(),
        const LoginFailure('Phone number and PIN code are required'),
      ],
      verify: (_) {
        verifyNever(mockVerifyOtp(any));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when OTP verification fails',
      build: () {
        when(
          mockVerifyOtp(any),
        ).thenAnswer((_) async => Left(ValidationFailure('Invalid OTP')));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const VerifyOtpSubmitted(tPhoneNumber, tPinCode)),
      expect: () => [LoginLoading(), const LoginFailure('Invalid OTP')],
      verify: (_) {
        verify(
          mockVerifyOtp(
            const VerifyOtpParams(phoneNumber: tPhoneNumber, pinCode: tPinCode),
          ),
        );
        verifyNever(mockGetAppBootstrap(any));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when app bootstrap fails after successful OTP verification',
      build: () {
        when(
          mockVerifyOtp(any),
        ).thenAnswer((_) async => const Right(tAuthTokens));
        when(mockGetAppBootstrap(any)).thenAnswer(
          (_) async => Left(ServerFailure('Failed to load app data')),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.add(const VerifyOtpSubmitted(tPhoneNumber, tPinCode)),
      expect: () => [
        LoginLoading(),
        const LoginFailure('Failed to load app data'),
      ],
      verify: (_) {
        verify(
          mockVerifyOtp(
            const VerifyOtpParams(phoneNumber: tPhoneNumber, pinCode: tPinCode),
          ),
        );
        verify(
          mockGetAppBootstrap(
            const GetAppBootstrapParams(accessToken: 'test_access_token'),
          ),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [Loading, Failure] when OTP verification fails with NetworkFailure',
      build: () {
        when(
          mockVerifyOtp(any),
        ).thenAnswer((_) async => Left(NetworkFailure()));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const VerifyOtpSubmitted(tPhoneNumber, tPinCode)),
      expect: () => [
        LoginLoading(),
        const LoginFailure('No internet connection'),
      ],
    );
  });
}
