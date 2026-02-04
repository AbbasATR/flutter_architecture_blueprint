import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.units.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: context.units.w(120),
              height: context.units.w(120),
              decoration: BoxDecoration(
                color: context.cs.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconsaxPlusLinear.notification,
                size: context.units.w(60),
                color: context.cs.onSurface.withValues(alpha: 0.3),
              ),
            ),
            SizedBox(height: context.units.h(24)),
            Text(
              context.l10n.noNotifications,
              style: context.tt.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.units.h(8)),
            Text(
              context.l10n.noNotificationsMessage,
              textAlign: TextAlign.center,
              style: context.tt.labelLarge.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
