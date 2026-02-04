import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String name;
  final String details;
  final String icon;
  final bool isCurrentLocation;

  const Address({
    required this.id,
    required this.name,
    required this.details,
    required this.icon,
    this.isCurrentLocation = false,
  });

  @override
  List<Object?> get props => [id, name, details, icon, isCurrentLocation];
}
