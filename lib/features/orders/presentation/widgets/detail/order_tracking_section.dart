import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class OrderTrackingSection extends StatelessWidget {
  final Order order;

  const OrderTrackingSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TrackingStep(
        title: context.l10n.orderPlaced,
        isCompleted: true,
        timestamp: order.timestamp,
      ),
      _TrackingStep(
        title: context.l10n.confirmed,
        isCompleted: order.confirmedAt != null,
        timestamp: order.confirmedAt,
      ),
      _TrackingStep(
        title: context.l10n.preparing,
        isCompleted: order.preparedAt != null,
        timestamp: order.preparedAt,
      ),
      _TrackingStep(
        title: context.l10n.readyForPickup,
        isCompleted: order.pickedUpAt != null,
        timestamp: order.pickedUpAt,
      ),
      _TrackingStep(
        title: context.l10n.onTheWay,
        isCompleted: order.status == OrderStatus.onTheWay,
        timestamp: null,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.orderTracking,
            style: context.tt.titleSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return _buildTrackingStep(context, step, isLast: isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(
    BuildContext context,
    _TrackingStep step, {
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.isCompleted
                    ? context.cs.primary
                    : context.cs.onSurface.withValues(alpha: 0.2),
              ),
              child: step.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: step.isCompleted
                    ? context.cs.primary
                    : context.cs.onSurface.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: context.tt.titleSmall.copyWith(
                    fontWeight: step.isCompleted
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: step.isCompleted
                        ? context.cs.onSurface
                        : context.cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                if (step.timestamp != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(step.timestamp!),
                    style: context.tt.labelMedium.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}

class _TrackingStep {
  final String title;
  final bool isCompleted;
  final DateTime? timestamp;

  _TrackingStep({
    required this.title,
    required this.isCompleted,
    this.timestamp,
  });
}
