import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class OrderItemsSection extends StatelessWidget {
  final List<OrderItem> items;
  final String dropoffAddress;

  const OrderItemsSection({
    super.key,
    required this.items,
    required this.dropoffAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Delivery Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: context.cs.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dropoffAddress,
                  style: context.tt.labelMedium.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Order Items
          ...items.map((item) => _buildOrderItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Item image placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: context.cs.onSurface.withValues(alpha: 0.05),
            ),
            child: Icon(
              Icons.fastfood,
              color: context.cs.onSurface.withValues(alpha: 0.3),
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // Item name
          Expanded(child: Text(item.name, style: context.tt.titleSmall)),

          // Quantity
          Text(
            'x${item.quantity}',
            style: context.tt.labelMedium.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
