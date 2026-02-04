import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_bloc.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_state.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/screens/item_detail_screen.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/widgets/item_card.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Sliver list displaying items with loading, error, and empty states.
class SupplierItemsList extends StatelessWidget {
  const SupplierItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return _LoadingState();
        }

        if (state is ItemError) {
          return _ErrorState(message: state.message);
        }

        if (state is ItemLoaded) {
          if (state.items.isEmpty) {
            return _EmptyState(message: l10n.noSuppliersAvailable);
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = state.items[index];
              return ItemCard(
                item: item,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(item: item),
                    ),
                  );
                },
              );
            }, childCount: state.items.length),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(color: context.cs.primary),
      ),
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: context.units.sp(64),
              color: context.cs.error,
            ),
            SizedBox(height: context.units.h(16)),
            Text(
              message,
              style: context.tt.labelLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state widget.
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusLinear.box,
              size: context.units.sp(64),
              color: context.cs.onSurfaceVariant,
            ),
            SizedBox(height: context.units.h(16)),
            Text(message, style: context.tt.labelLarge),
          ],
        ),
      ),
    );
  }
}
