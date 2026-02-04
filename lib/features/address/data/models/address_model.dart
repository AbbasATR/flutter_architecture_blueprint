import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.name,
    required super.details,
    required super.icon,
    super.isCurrentLocation,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      name: json['name'] as String,
      details: json['details'] as String,
      icon: json['icon'] as String,
      isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'icon': icon,
      'isCurrentLocation': isCurrentLocation,
    };
  }

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      name: address.name,
      details: address.details,
      icon: address.icon,
      isCurrentLocation: address.isCurrentLocation,
    );
  }
}
