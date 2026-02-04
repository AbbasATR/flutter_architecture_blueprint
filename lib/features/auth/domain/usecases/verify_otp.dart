import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/entities/auth_tokens.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtp implements UseCase<AuthTokens, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, AuthTokens>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.phoneNumber, params.pinCode);
  }
}

class VerifyOtpParams extends Equatable {
  final String phoneNumber;
  final String pinCode;

  const VerifyOtpParams({required this.phoneNumber, required this.pinCode});

  @override
  List<Object> get props => [phoneNumber, pinCode];
}
