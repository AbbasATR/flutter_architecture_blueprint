import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_addresses.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/get_selected_address.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/usecases/select_address.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final GetAddresses getAddresses;
  final GetSelectedAddress getSelectedAddress;
  final SelectAddress selectAddress;

  AddressCubit({
    required this.getAddresses,
    required this.getSelectedAddress,
    required this.selectAddress,
  }) : super(AddressInitial());

  Future<void> loadAddresses() async {
    emit(AddressLoading());
    try {
      final addresses = await getAddresses();
      final selectedAddress = await getSelectedAddress();
      emit(
        AddressLoaded(addresses: addresses, selectedAddress: selectedAddress),
      );
    } catch (e) {
      emit(AddressError(message: e.toString()));
    }
  }

  Future<void> selectAddressById(String addressId) async {
    if (state is AddressLoaded) {
      final currentState = state as AddressLoaded;
      try {
        await selectAddress(addressId);
        final newSelectedAddress = currentState.addresses.firstWhere(
          (address) => address.id == addressId,
        );
        emit(
          AddressLoaded(
            addresses: currentState.addresses,
            selectedAddress: newSelectedAddress,
          ),
        );
      } catch (e) {
        emit(AddressError(message: e.toString()));
      }
    }
  }

  Future<void> loadSelectedAddress() async {
    try {
      final selectedAddress = await getSelectedAddress();
      if (state is AddressLoaded) {
        final currentState = state as AddressLoaded;
        emit(
          AddressLoaded(
            addresses: currentState.addresses,
            selectedAddress: selectedAddress,
          ),
        );
      }
    } catch (e) {
      emit(AddressError(message: e.toString()));
    }
  }
}
