import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/detail/driver_card.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/detail/order_items_section.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/detail/order_pricing_summary.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/detail/order_status_section.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/detail/order_tracking_section.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/detail/supplier_card.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isActive = order.isActive;

    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        backgroundColor: context.cs.surface,
        elevation: 0,
        centerTitle: true,
        leading: custom.FloatingActionButton(
          icon: IconsaxPlusLinear.undo,
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.viewOrder,
          style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: !isActive ? 80 : 0, // Add padding for fixed bottom button
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Supplier Card
            SupplierCard(
              supplierName: order.supplierName,
              supplierImage: order.supplierImage,
              timestamp: order.timestamp,
              showRating: !isActive,
            ),

            const SizedBox(height: 8),

            // Driver Card (if delivered)
            if (order.driverId != null)
              DriverCard(
                driverName: 'أحمد صلاح الموسوي', // Mock data
                showRating: !isActive,
              ),

            const SizedBox(height: 16),

            // Order Status
            OrderStatusSection(order: order),

            const SizedBox(height: 8),

            // Order Tracking (for active orders)
            if (isActive) OrderTrackingSection(order: order),

            // Order Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n.orderDetails,
                style: context.tt.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Order Items
            OrderItemsSection(
              items: order.items,
              dropoffAddress: order.dropoffAddress,
            ),

            const SizedBox(height: 16),

            // Pricing Summary
            OrderPricingSummary(
              subtotal: order.subtotalAmount,
              discount: order.discountTotal,
              deliveryFee: order.deliveryFee,
              total: order.totalAmount,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      // Fixed bottom bar for reorder button (past orders only)
      bottomNavigationBar: !isActive
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cs.surface,
                  boxShadow: [
                    BoxShadow(
                      color: context.cs.onSurface.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SubmitButton(
                  text: context.l10n.reorder,
                  icon: Icons.replay,
                  onPressed: () {},
                ),
              ),
            )
          : null,
    );
  }
}
