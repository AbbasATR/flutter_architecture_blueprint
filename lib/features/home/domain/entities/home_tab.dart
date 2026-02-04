import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';

/// Enum representing the available tabs in the home screen.
enum HomeTab {
  /// JET tab - main category
  jet('JET'),

  /// Restaurants tab
  restaurants('Restaurants'),

  /// Shopping tab
  shopping('Shopping'),

  /// Grocery tab
  grocery('Grocery'),

  /// Flowers tab
  flowers('Flowers');

  const HomeTab(this.label);

  /// Display label for the tab
  final String label;

  /// Get the corresponding business type for supplier filtering.
  /// Returns null for JET tab (main dashboard).
  SupplierBusinessType? get businessType {
    switch (this) {
      case HomeTab.jet:
        return null; // JET tab shows dashboard, not suppliers
      case HomeTab.restaurants:
        return SupplierBusinessType.restaurant;
      case HomeTab.shopping:
        return SupplierBusinessType.shopping;
      case HomeTab.grocery:
        return SupplierBusinessType.grocery;
      case HomeTab.flowers:
        return SupplierBusinessType.flowers;
    }
  }
}
