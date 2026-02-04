import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/order_card_components/order_card_footer.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/order_card_components/order_card_header.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/order_card_components/order_card_items_list.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';

/// Order card widget displaying order summary with supplier info, items, and total
class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? context.cs.onSurface.withValues(alpha: 0.15)
                : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: context.cs.onSurface.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with supplier info and status
            OrderCardHeader(order: order),

            // Divider
            _buildDivider(context),

            // Order Items
            OrderCardItemsList(items: order.items),

            // Divider
            _buildDivider(context),

            // Footer with price and view details
            OrderCardFooter(totalAmount: order.totalAmount),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.cs.onSurface.withValues(alpha: 0.08),
    );
  }

  void _navigateToDetails(BuildContext context) {
    // Hide bottom bar before navigation
    context.read<BottomNavCubit>().hide();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)),
    ).then((_) {
      // Show bottom bar when returning
      // ignore: use_build_context_synchronously
      context.read<BottomNavCubit>().show();
    });
  }
}
