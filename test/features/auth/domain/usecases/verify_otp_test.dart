import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/verify_otp.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late VerifyOtp useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = VerifyOtp(mockAuthRepository);
  });

  const tPhoneNumber = '+971501234567';
  const tPinCode = '123456';
  const tParams = VerifyOtpParams(phoneNumber: tPhoneNumber, pinCode: tPinCode);
  const tAuthTokens = AuthTokens(
    accessToken: 'test_access_token',
    refreshToken: 'test_refresh_token',
  );

  group('VerifyOtp', () {
    test('should call repository.verifyOtp with correct parameters', () async {
      // arrange
      when(
        mockAuthRepository.verifyOtp(any, any),
      ).thenAnswer((_) async => const Right(tAuthTokens));

      // act
      await useCase(tParams);

      // assert
      verify(mockAuthRepository.verifyOtp(tPhoneNumber, tPinCode));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test(
      'should return AuthTokens when OTP verification is successful',
      () async {
        // arrange
        when(
          mockAuthRepository.verifyOtp(any, any),
        ).thenAnswer((_) async => const Right(tAuthTokens));

        // act
        final result = await useCase(tParams);

        // assert
        expect(result, const Right(tAuthTokens));
        verify(mockAuthRepository.verifyOtp(tPhoneNumber, tPinCode));
      },
    );

    test('should return ServerFailure when OTP is invalid', () async {
      // arrange
      const tServerFailure = ServerFailure('Invalid OTP');
      when(
        mockAuthRepository.verifyOtp(any, any),
      ).thenAnswer((_) async => const Left(tServerFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tServerFailure));
      verify(mockAuthRepository.verifyOtp(tPhoneNumber, tPinCode));
    });

    test('should return ServerFailure when OTP has expired', () async {
      // arrange
      const tServerFailure = ServerFailure('OTP expired');
      when(
        mockAuthRepository.verifyOtp(any, any),
      ).thenAnswer((_) async => const Left(tServerFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tServerFailure));
    });

    test('should return NetworkFailure when device is offline', () async {
      // arrange
      final tNetworkFailure = NetworkFailure();
      when(
        mockAuthRepository.verifyOtp(any, any),
      ).thenAnswer((_) async => Left(tNetworkFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, Left(tNetworkFailure));
      verify(mockAuthRepository.verifyOtp(tPhoneNumber, tPinCode));
    });

    test(
      'should return ValidationFailure for invalid pin code format',
      () async {
        // arrange
        const invalidParams = VerifyOtpParams(
          phoneNumber: tPhoneNumber,
          pinCode: '12', // Too short
        );
        const tValidationFailure = ValidationFailure('Invalid pin code');
        when(
          mockAuthRepository.verifyOtp(any, any),
        ).thenAnswer((_) async => const Left(tValidationFailure));

        // act
        final result = await useCase(invalidParams);

        // assert
        expect(result, const Left(tValidationFailure));
        verify(mockAuthRepository.verifyOtp(tPhoneNumber, '12'));
      },
    );
  });

  group('VerifyOtpParams', () {
    test('should support value equality', () {
      // arrange
      const params1 = VerifyOtpParams(
        phoneNumber: tPhoneNumber,
        pinCode: tPinCode,
      );
      const params2 = VerifyOtpParams(
        phoneNumber: tPhoneNumber,
        pinCode: tPinCode,
      );
      const params3 = VerifyOtpParams(
        phoneNumber: tPhoneNumber,
        pinCode: '654321',
      );

      // assert
      expect(params1, params2);
      expect(params1, isNot(params3));
    });

    test('should have correct props', () {
      // arrange
      const params = VerifyOtpParams(
        phoneNumber: tPhoneNumber,
        pinCode: tPinCode,
      );

      // assert
      expect(params.props, [tPhoneNumber, tPinCode]);
    });
  });
}
