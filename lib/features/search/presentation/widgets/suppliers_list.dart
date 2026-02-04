import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/search_empty_state.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/supplier_result_item.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Widget that displays list of supplier search results
class SuppliersList extends StatelessWidget {
  final List<SearchSupplier> suppliers;

  const SuppliersList({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (suppliers.isEmpty) {
      return SearchEmptyState(
        icon: IconsaxPlusLinear.shop,
        message: l10n.searchNoSuppliersFound,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: context.units.h(8)),
      itemCount: suppliers.length,
      itemBuilder: (context, index) {
        return SupplierResultItem(supplier: suppliers[index]);
      },
    );
  }
}
