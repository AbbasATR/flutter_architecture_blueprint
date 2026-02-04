import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/utils/order_status_helper.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Header section of order card showing supplier image, name, date and status badge
class OrderCardHeader extends StatelessWidget {
  final Order order;

  const OrderCardHeader({super.key, required this.order});

  String _getLocalizedStatus(BuildContext context, OrderStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case OrderStatus.ordered:
        return l10n.orderStatusOrdered;
      case OrderStatus.processing:
        return l10n.orderStatusProcessing;
      case OrderStatus.readyForPickup:
        return l10n.orderStatusReadyForPickup;
      case OrderStatus.onTheWay:
        return l10n.orderStatusOnTheWay;
      case OrderStatus.delivered:
        return l10n.orderStatusDelivered;
      case OrderStatus.canceled:
        return l10n.orderStatusCanceled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = OrderStatusHelper.getStatusColor(order.status);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Supplier Image
          _buildSupplierImage(context),
          const SizedBox(width: 12),
          // Supplier Name and Date
          Expanded(child: _buildSupplierInfo(context)),
          const SizedBox(width: 8),
          // Status Badge
          _buildStatusBadge(context, statusColor),
        ],
      ),
    );
  }

  Widget _buildSupplierImage(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: order.supplierImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(order.supplierImage!, fit: BoxFit.cover),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: context.cs.onSurface.withValues(alpha: 0.08),
              ),
              child: Icon(
                IconsaxPlusLinear.shop,
                color: context.cs.onSurface.withValues(alpha: 0.5),
                size: 28,
              ),
            ),
    );
  }

  Widget _buildSupplierInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.supplierName,
          style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              IconsaxPlusLinear.calendar,
              size: 14,
              color: context.cs.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 4),
            Text(
              DateFormat('dd MMM yyyy • hh:mm a').format(order.timestamp),
              style: context.tt.labelMedium.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            OrderStatusHelper.getStatusIcon(order.status),
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            _getLocalizedStatus(context, order.status),
            style: context.tt.labelMedium.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
