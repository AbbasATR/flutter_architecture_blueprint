import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/repositories/address_repository.dart';

class GetAddresses {
  final AddressRepository repository;

  GetAddresses(this.repository);

  Future<List<Address>> call() async {
    return await repository.getAddresses();
  }
}
