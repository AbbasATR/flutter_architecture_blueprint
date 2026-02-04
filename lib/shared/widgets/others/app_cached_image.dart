import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_assets.dart';

class AppCachedImage extends StatelessWidget {
  final String url;
  final double size;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool showImage;
  final IconData? icon;
  const AppCachedImage({
    super.key,
    required this.url,
    this.size = 40,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.showImage = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final image = ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        height: size,
        width: size,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) {
          if (showImage) {
            return Image.asset(AppAssets.appLogo, height: size, width: size);
          } else {
            return Icon(icon ?? Icons.error, size: size / 2);
          }
        },
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: image,
      );
    }

    return image;
  }
}
