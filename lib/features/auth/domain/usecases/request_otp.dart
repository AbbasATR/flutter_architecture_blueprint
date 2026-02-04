import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/auth/domain/repositories/auth_repository.dart';

class RequestOtp implements UseCase<Unit, RequestOtpParams> {
  final AuthRepository repository;

  RequestOtp(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RequestOtpParams params) async {
    return await repository.requestOtp(params.phoneNumber);
  }
}

class RequestOtpParams extends Equatable {
  final String phoneNumber;

  const RequestOtpParams({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
