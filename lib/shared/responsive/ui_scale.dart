import 'package:flutter/material.dart';

@immutable
class UIScaleData {
  final Size size;
  final EdgeInsets viewPadding;
  final double scaleW; // width-based scale
  final double scaleH; // height-based scale
  final double scale; // uniform (min of W/H)
  final double fontScale; // responsive × OS accessibility
  final bool isTablet;

  // Handy derived
  double get safeW => size.width - viewPadding.left - viewPadding.right;
  double get safeH => size.height - viewPadding.top - viewPadding.bottom;
  double get shortestSide => size.shortestSide;

  const UIScaleData({
    required this.size,
    required this.viewPadding,
    required this.scaleW,
    required this.scaleH,
    required this.scale,
    required this.fontScale,
    required this.isTablet,
  });

  static const double _baseWidth = 375;
  static const double _baseHeight = 812;
  static const double _minFont = 0.85;
  static const double _maxFont = 1.60;

  factory UIScaleData.fromMediaQuery(
    MediaQueryData mq, {
    double baseWidth = _baseWidth,
    double baseHeight = _baseHeight,
    double minFont = _minFont,
    double maxFont = _maxFont,
  }) {
    final size = mq.size;
    final sW = size.width / baseWidth;
    final sH = size.height / baseHeight;
    final s = sW < sH ? sW : sH;

    // OS accessibility multiplier
    final os = mq.textScaler.scale(1.0);
    final fs = (s * os).clamp(minFont, maxFont).toDouble();

    return UIScaleData(
      size: size,
      viewPadding: mq.viewPadding,
      scaleW: sW,
      scaleH: sH,
      scale: s,
      fontScale: fs,
      isTablet: size.shortestSide >= 600,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is UIScaleData &&
      other.size == size &&
      other.viewPadding == viewPadding &&
      other.fontScale == fontScale;

  @override
  int get hashCode => Object.hash(size, viewPadding, fontScale);
}

class UIScaleScope extends InheritedWidget {
  final UIScaleData data;

  const UIScaleScope({super.key, required this.data, required super.child});

  static UIScaleData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<UIScaleScope>();
    assert(
      scope != null,
      'UIScaleScope.of(context) was called with a context that does not contain a UIScaleScope.\n'
      'Wrap your MaterialApp.builder child with UIScaleScope.wrap(context, child).',
    );
    return scope!.data;
  }

  @override
  bool updateShouldNotify(UIScaleScope old) => data != old.data;

  /// Convenience wrapper so you don’t repeat the boilerplate.
  static Widget wrap(BuildContext context, Widget child) {
    final data = UIScaleData.fromMediaQuery(MediaQuery.of(context));
    return UIScaleScope(data: data, child: child);
  }
}
