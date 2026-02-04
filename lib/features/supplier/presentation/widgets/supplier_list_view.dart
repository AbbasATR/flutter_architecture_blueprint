import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_bloc.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_event.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_state.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/supplier_card.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget displaying a list of suppliers by business type.
class SupplierListView extends StatefulWidget {
  final SupplierBusinessType businessType;

  const SupplierListView({super.key, required this.businessType});

  @override
  State<SupplierListView> createState() => _SupplierListViewState();
}

class _SupplierListViewState extends State<SupplierListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load suppliers when the widget is created
    context.read<SupplierBloc>().add(LoadSuppliers(widget.businessType));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;

    return BlocBuilder<SupplierBloc, SupplierState>(
      builder: (context, state) {
        if (state is SupplierLoading) {
          return Center(
            child: CircularProgressIndicator(color: context.cs.primary),
          );
        }

        if (state is SupplierError) {
          return Center(
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
                  state.message,
                  style: context.tt.labelLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.units.h(16)),
                ElevatedButton(
                  onPressed: () {
                    context.read<SupplierBloc>().add(
                      RefreshSuppliers(widget.businessType),
                    );
                  },
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (state is SupplierLoaded) {
          if (state.suppliers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: context.units.sp(64),
                    color: context.cs.onSurfaceVariant,
                  ),
                  SizedBox(height: context.units.h(16)),
                  Text('No suppliers available', style: context.tt.labelLarge),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<SupplierBloc>().add(
                RefreshSuppliers(widget.businessType),
              );
            },
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: context.units.h(8),
                bottom: context.units.h(16),
              ),
              itemCount: state.suppliers.length,
              itemBuilder: (context, index) {
                final supplier = state.suppliers[index];
                return SupplierCard(
                  supplier: supplier,
                  // Remove onTap to use default navigation in SupplierCard
                );
              },
            ),
          );
        }

        // Initial state
        return const SizedBox.shrink();
      },
    );
  }
}
