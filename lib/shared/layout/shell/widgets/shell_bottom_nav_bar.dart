import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/bottom_tab.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/custom_nav_item.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';

/// Bottom navigation bar widget with custom styling and animations
class ShellBottomNavBar extends StatelessWidget {
  final BottomTab currentTab;
  final bool isVisible;
  final Function(int) onTapTab;

  const ShellBottomNavBar({
    super.key,
    required this.currentTab,
    required this.isVisible,
    required this.onTapTab,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isVisible ? 1.0 : 0.0,
        child: isVisible
            ? SafeArea(
                minimum: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: context.cs.surfaceBright,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomNavItem(
                        label: l10n.home,
                        isActive: currentTab == BottomTab.home,
                        activeIcon: IconsaxPlusBold.home_2,
                        inactiveIcon: IconsaxPlusLinear.home_2,
                        onTap: () => onTapTab(0),
                      ),
                      CustomNavItem(
                        label: l10n.cart,
                        isActive: currentTab == BottomTab.cart,
                        activeIcon: IconsaxPlusBold.shopping_cart,
                        inactiveIcon: IconsaxPlusLinear.shopping_cart,
                        onTap: () => onTapTab(1),
                      ),
                      CustomNavItem(
                        label: l10n.orders,
                        isActive: currentTab == BottomTab.orders,
                        activeIcon: IconsaxPlusBold.receipt_1,
                        inactiveIcon: IconsaxPlusLinear.receipt_1,
                        onTap: () => onTapTab(2),
                      ),
                      CustomNavItem(
                        label: l10n.profile,
                        isActive: currentTab == BottomTab.profile,
                        activeIcon: IconsaxPlusBold.user,
                        inactiveIcon: IconsaxPlusLinear.user,
                        onTap: () => onTapTab(3),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
