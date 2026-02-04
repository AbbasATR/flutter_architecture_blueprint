import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/item_result_item.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/search_empty_state.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Widget that displays list of item search results
class ItemsList extends StatelessWidget {
  final List<SearchItem> items;

  const ItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (items.isEmpty) {
      return SearchEmptyState(
        icon: IconsaxPlusLinear.box,
        message: l10n.searchNoItemsFound,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: context.units.h(8)),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemResultItem(item: items[index]);
      },
    );
  }
}
