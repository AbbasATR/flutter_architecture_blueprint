import 'package:flutter_architecture_blueprint/features/address/data/models/address_model.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.dateOfBirth,
    required super.state,
    required super.phoneNo,
    required super.addresses,
    required super.credit,
    required super.avatarURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      state: _userStateFromString(json['state'] as String),
      phoneNo: json['phoneNo'] as String,
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      credit: json['credit'] as int,
      avatarURL: json['avatarURL'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'state': _userStateToString(state),
      'phoneNo': phoneNo,
      'addresses': addresses.map((address) {
        if (address is AddressModel) {
          return address.toJson();
        }
        return AddressModel(
          id: address.id,
          name: address.name,
          details: address.details,
          icon: address.icon,
          isCurrentLocation: address.isCurrentLocation,
        ).toJson();
      }).toList(),
      'credit': credit,
      'avatarURL': avatarURL,
    };
  }

  static UserState _userStateFromString(String state) {
    switch (state.toLowerCase()) {
      case 'active':
        return UserState.active;
      case 'inactive':
        return UserState.inactive;
      case 'suspended':
        return UserState.suspended;
      default:
        return UserState.inactive;
    }
  }

  static String _userStateToString(UserState state) {
    switch (state) {
      case UserState.active:
        return 'active';
      case UserState.inactive:
        return 'inactive';
      case UserState.suspended:
        return 'suspended';
    }
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      dateOfBirth: user.dateOfBirth,
      state: user.state,
      phoneNo: user.phoneNo,
      addresses: user.addresses,
      credit: user.credit,
      avatarURL: user.avatarURL,
    );
  }
}
