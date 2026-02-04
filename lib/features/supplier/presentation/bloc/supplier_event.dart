import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';

/// Base class for all supplier events.
abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load suppliers by business type.
class LoadSuppliers extends SupplierEvent {
  final SupplierBusinessType businessType;

  const LoadSuppliers(this.businessType);

  @override
  List<Object?> get props => [businessType];
}

/// Event to refresh suppliers.
class RefreshSuppliers extends SupplierEvent {
  final SupplierBusinessType businessType;

  const RefreshSuppliers(this.businessType);

  @override
  List<Object?> get props => [businessType];
}
