import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Custom navigation item widget for the bottom navigation bar
class CustomNavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final VoidCallback onTap;

  const CustomNavItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;

    return Flexible(
      flex: isActive ? 2 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        splashColor: cs.primary.withValues(alpha: 0.2),
        highlightColor: cs.primary.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 1.0 + (value * 0.1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Color.lerp(Colors.transparent, cs.secondary, value),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.3 * value),
                              blurRadius: 4 * value,
                              spreadRadius: 2 * value,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive ? activeIcon : inactiveIcon,
                        color: Color.lerp(cs.onSurface, cs.primary, value),
                        size: 24,
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 8),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          style: tt.labelMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                          child: Text(
                            label,
                            style: tt.buttonText.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
