import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/utils/order_status_helper.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class OrderStatusSection extends StatelessWidget {
  final Order order;

  const OrderStatusSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OrderStatusHelper.getStatusColor(
          order.status,
        ).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OrderStatusHelper.getStatusColor(
            order.status,
          ).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            OrderStatusHelper.getStatusIcon(order.status),
            color: OrderStatusHelper.getStatusColor(order.status),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              OrderStatusHelper.getStatusKey(order.status),
              style: context.tt.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: OrderStatusHelper.getStatusColor(order.status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
