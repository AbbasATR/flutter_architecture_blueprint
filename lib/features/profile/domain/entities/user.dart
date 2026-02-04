import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';

enum UserState { active, inactive, suspended }

class User extends Equatable {
  final int id;
  final String name;
  final DateTime dateOfBirth;
  final UserState state;
  final String phoneNo;
  final List<Address> addresses;
  final int credit;
  final String avatarURL;

  const User({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.state,
    required this.phoneNo,
    required this.addresses,
    required this.credit,
    required this.avatarURL,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    dateOfBirth,
    state,
    phoneNo,
    addresses,
    credit,
    avatarURL,
  ];

  User copyWith({
    int? id,
    String? name,
    DateTime? dateOfBirth,
    UserState? state,
    String? phoneNo,
    List<Address>? addresses,
    int? credit,
    String? avatarURL,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      state: state ?? this.state,
      phoneNo: phoneNo ?? this.phoneNo,
      addresses: addresses ?? this.addresses,
      credit: credit ?? this.credit,
      avatarURL: avatarURL ?? this.avatarURL,
    );
  }
}
