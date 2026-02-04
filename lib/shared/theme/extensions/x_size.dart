import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/responsive/ui_scale.dart';

extension XSize on BuildContext {
  UiSize get units => UiSize(UIScaleScope.of(this));
}

class UiSize {
  UiSize(this._ui);
  final UIScaleData _ui;

  // base responsive units
  double w(num v) => v * _ui.scaleW; // width-based
  double h(num v) => v * _ui.scaleH; // height-based
  double r(num v) => v * _ui.scale; // uniform (icons/radii)
  double sp(num v, {double min = 10, double max = 64}) {
    final val = v * _ui.fontScale;
    return val.clamp(min, max).toDouble();
  }

  // screen/safe sizes
  double get screenW => _ui.size.width;
  double get screenH => _ui.size.height;
  double get shortestSide => _ui.size.shortestSide;

  double get safeW =>
      _ui.size.width - _ui.viewPadding.left - _ui.viewPadding.right;
  double get safeH =>
      _ui.size.height - _ui.viewPadding.top - _ui.viewPadding.bottom;

  // fractions
  double fw(double f) => screenW * f;
  double fh(double f) => screenH * f;
  double fsw(double f) => safeW * f;
  double fsh(double f) => safeH * f;

  // convenience
  bool get isTablet => _ui.isTablet;
}
