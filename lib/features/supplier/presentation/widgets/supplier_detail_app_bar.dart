import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/supplier_info_card.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Collapsing app bar with supplier banner and floating info card.
class SupplierDetailAppBar extends StatelessWidget {
  final Supplier supplier;
  final bool showTitle;

  const SupplierDetailAppBar({
    super.key,
    required this.supplier,
    required this.showTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: context.units.h(200),
      pinned: true,
      backgroundColor: context.cs.surface,
      leading: Card(
        color: context.cs.surfaceContainer.withValues(alpha: 0.5),
        child: IconButton(
          icon: const Icon(IconsaxPlusLinear.undo),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: AnimatedOpacity(
        opacity: showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(supplier.name, style: context.tt.titleMedium),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            // Banner image
            _BannerImage(supplier: supplier),
            // Gradient overlay
            _GradientOverlay(),
            // Supplier info card
            SupplierInfoCard(
              supplier: supplier,
              onInfoTap: () {
                debugPrint('Info tapped for ${supplier.name}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner image widget with error handling.
class _BannerImage extends StatelessWidget {
  final Supplier supplier;

  const _BannerImage({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      supplier.bannerURL,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: context.cs.surfaceContainerHighest,
          child: Icon(
            IconsaxPlusLinear.gallery,
            size: context.units.sp(64),
            color: context.cs.onSurfaceVariant,
          ),
        );
      },
    );
  }
}

/// Gradient overlay for better contrast with back button.
class _GradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
            ],
          ),
        ),
      ),
    );
  }
}
