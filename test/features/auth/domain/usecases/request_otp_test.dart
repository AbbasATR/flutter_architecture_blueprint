import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/usecases/request_otp.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late RequestOtp useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RequestOtp(mockAuthRepository);
  });

  const tPhoneNumber = '+971501234567';
  const tParams = RequestOtpParams(phoneNumber: tPhoneNumber);

  group('RequestOtp', () {
    test(
      'should call repository.requestOtp with correct phone number',
      () async {
        // arrange
        when(
          mockAuthRepository.requestOtp(any),
        ).thenAnswer((_) async => const Right(unit));

        // act
        await useCase(tParams);

        // assert
        verify(mockAuthRepository.requestOtp(tPhoneNumber));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('should return unit when OTP request is successful', () async {
      // arrange
      when(
        mockAuthRepository.requestOtp(any),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(unit));
    });

    test(
      'should return ServerFailure when repository returns ServerFailure',
      () async {
        // arrange
        const tServerFailure = ServerFailure('Server error');
        when(
          mockAuthRepository.requestOtp(any),
        ).thenAnswer((_) async => const Left(tServerFailure));

        // act
        final result = await useCase(tParams);

        // assert
        expect(result, const Left(tServerFailure));
        verify(mockAuthRepository.requestOtp(tPhoneNumber));
      },
    );

    test(
      'should return NetworkFailure when repository returns NetworkFailure',
      () async {
        // arrange
        final tNetworkFailure = NetworkFailure();
        when(
          mockAuthRepository.requestOtp(any),
        ).thenAnswer((_) async => Left(tNetworkFailure));

        // act
        final result = await useCase(tParams);

        // assert
        expect(result, Left(tNetworkFailure));
        verify(mockAuthRepository.requestOtp(tPhoneNumber));
      },
    );

    test(
      'should return ValidationFailure for invalid phone number format',
      () async {
        // arrange
        const invalidParams = RequestOtpParams(phoneNumber: 'invalid');
        const tValidationFailure = ValidationFailure('Invalid phone number');
        when(
          mockAuthRepository.requestOtp(any),
        ).thenAnswer((_) async => const Left(tValidationFailure));

        // act
        final result = await useCase(invalidParams);

        // assert
        expect(result, const Left(tValidationFailure));
        verify(mockAuthRepository.requestOtp('invalid'));
      },
    );
  });

  group('RequestOtpParams', () {
    test('should support value equality', () {
      // arrange
      const params1 = RequestOtpParams(phoneNumber: tPhoneNumber);
      const params2 = RequestOtpParams(phoneNumber: tPhoneNumber);
      const params3 = RequestOtpParams(phoneNumber: '+971509999999');

      // assert
      expect(params1, params2);
      expect(params1, isNot(params3));
    });

    test('should have correct props', () {
      // arrange
      const params = RequestOtpParams(phoneNumber: tPhoneNumber);

      // assert
      expect(params.props, [tPhoneNumber]);
    });
  });
}
