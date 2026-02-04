import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class OrderPricingSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;

  const OrderPricingSummary({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
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
        children: [
          _buildPriceRow(
            context,
            context.l10n.subtotal,
            discount > 0 ? '-${discount.toStringAsFixed(0)} IQD' : '',
            '${subtotal.toStringAsFixed(0)} IQD',
            isStrikethrough: discount > 0,
          ),
          const SizedBox(height: 12),
          _buildPriceRow(context, 'Tax:', '', '0.0 IQD'),
          const SizedBox(height: 12),
          _buildPriceRow(
            context,
            context.l10n.deliveryFee,
            '',
            '${deliveryFee.toStringAsFixed(0)} IQD',
          ),
          const SizedBox(height: 12),
          // Dotted divider
          CustomPaint(
            size: const Size(double.infinity, 1),
            painter: DottedLinePainter(
              color: context.cs.onSurface.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            context,
            context.l10n.total,
            '',
            '${total.toStringAsFixed(0)} IQD',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String discount,
    String amount, {
    bool isBold = false,
    bool isStrikethrough = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.tt.labelLarge.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: context.cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Row(
          children: [
            if (discount.isNotEmpty) ...[
              Text(
                discount,
                style: context.tt.labelMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              amount,
              style: context.tt.labelLarge.copyWith(
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                decoration: isStrikethrough ? TextDecoration.lineThrough : null,
                color: isStrikethrough
                    ? context.cs.onSurface.withValues(alpha: 0.4)
                    : context.cs.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
