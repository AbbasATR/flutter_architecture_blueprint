import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class HomeBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.units.w(16),
          vertical: context.units.h(8),
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(context.units.r(50)),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : context.cs.onSurface,
              size: context.units.r(24),
            ),
            SizedBox(height: context.units.h(4)),
            Text(
              label,
              style: context.tt.labelMedium.copyWith(
                color: isSelected ? Colors.white : context.cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
      padding: EdgeInsets.symmetric(
        horizontal: context.units.w(20),
        vertical: context.units.h(5),
      ),
      decoration: BoxDecoration(
        color: context.cs.surfaceBright,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.units.r(150)),
          bottom: Radius.circular(context.units.r(150)),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha:0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: IconsaxPlusBold.home,
              label: l10n.home,
              isSelected: selectedIndex == 0,
              onTap: () => onItemSelected(0),
            ),
            _buildNavItem(
              context: context,
              icon: IconsaxPlusBold.shopping_cart,
              label: l10n.cart,
              isSelected: selectedIndex == 1,
              onTap: () => onItemSelected(1),
            ),
            _buildNavItem(
              context: context,
              icon: IconsaxPlusBold.receipt_2,
              label: l10n.orders,
              isSelected: selectedIndex == 2,
              onTap: () => onItemSelected(2),
            ),
            _buildNavItem(
              context: context,
              icon: IconsaxPlusBold.user,
              label: l10n.profile,
              isSelected: selectedIndex == 3,
              onTap: () => onItemSelected(3),
            ),
          ],
        ),
      ),
    );
  }
}
