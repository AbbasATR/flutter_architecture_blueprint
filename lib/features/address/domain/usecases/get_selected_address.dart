import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/repositories/address_repository.dart';

class GetSelectedAddress {
  final AddressRepository repository;

  GetSelectedAddress(this.repository);

  Future<Address?> call() async {
    return await repository.getSelectedAddress();
  }
}
