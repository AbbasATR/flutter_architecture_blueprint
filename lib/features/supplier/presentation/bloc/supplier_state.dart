import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';

/// Base class for all supplier states.
abstract class SupplierState extends Equatable {
  const SupplierState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any suppliers are loaded.
class SupplierInitial extends SupplierState {
  const SupplierInitial();
}

/// State when suppliers are being loaded.
class SupplierLoading extends SupplierState {
  const SupplierLoading();
}

/// State when suppliers have been successfully loaded.
class SupplierLoaded extends SupplierState {
  final List<Supplier> suppliers;

  const SupplierLoaded(this.suppliers);

  @override
  List<Object?> get props => [suppliers];
}

/// State when an error occurred while loading suppliers.
class SupplierError extends SupplierState {
  final String message;

  const SupplierError(this.message);

  @override
  List<Object?> get props => [message];
}
