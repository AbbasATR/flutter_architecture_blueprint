import 'package:flutter_architecture_blueprint/features/address/data/datasources/address_local_data_source.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocalDataSource localDataSource;

  AddressRepositoryImpl(this.localDataSource);

  @override
  Future<List<Address>> getAddresses() async {
    return await localDataSource.getAddresses();
  }

  @override
  Future<Address?> getSelectedAddress() async {
    return await localDataSource.getSelectedAddress();
  }

  @override
  Future<void> selectAddress(String addressId) async {
    await localDataSource.selectAddress(addressId);
  }
}
