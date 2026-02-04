import 'package:flutter_architecture_blueprint/features/address/data/models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel?> getSelectedAddress();
  Future<void> selectAddress(String addressId);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  String? _selectedAddressId;

  // Fake Iraqi addresses data
  final List<AddressModel> _fakeAddresses = const [
    AddressModel(
      id: 'current',
      name: 'Deliver to current location',
      details: '',
      icon: 'location',
      isCurrentLocation: true,
    ),
    AddressModel(
      id: '1',
      name: 'Home',
      details: 'Al-Karada, Baghdad',
      icon: 'home',
      isCurrentLocation: false,
    ),
    AddressModel(
      id: '2',
      name: 'Work',
      details: 'Al-Mansour, Baghdad',
      icon: 'work',
      isCurrentLocation: false,
    ),
    AddressModel(
      id: '3',
      name: 'Others',
      details: 'Karrada Al-Sharqiya',
      icon: 'others',
      isCurrentLocation: false,
    ),
  ];

  @override
  Future<List<AddressModel>> getAddresses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _fakeAddresses;
  }

  @override
  Future<AddressModel?> getSelectedAddress() async {
    _selectedAddressId ??= _fakeAddresses.first.id;
    return _fakeAddresses.firstWhere(
      (address) => address.id == _selectedAddressId,
      orElse: () => _fakeAddresses.first,
    );
  }

  @override
  Future<void> selectAddress(String addressId) async {
    _selectedAddressId = addressId;
  }
}
