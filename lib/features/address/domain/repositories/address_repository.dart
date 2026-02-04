import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAddresses();
  Future<Address?> getSelectedAddress();
  Future<void> selectAddress(String addressId);
}
