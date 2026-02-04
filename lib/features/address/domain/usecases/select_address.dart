import 'package:flutter_architecture_blueprint/features/address/domain/repositories/address_repository.dart';

class SelectAddress {
  final AddressRepository repository;

  SelectAddress(this.repository);

  Future<void> call(String addressId) async {
    return await repository.selectAddress(addressId);
  }
}
