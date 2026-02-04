import 'package:flutter/material.dart';

extension XText on BuildContext {
  AppTextStyles get tt => AppTextStyles(Theme.of(this));
}

class AppTextStyles {
  AppTextStyles(this._theme);

  final ThemeData _theme;
  TextTheme get base => _theme.textTheme;
  ColorScheme get _cs => _theme.colorScheme;

  //  custom tokens
  TextStyle get buttonText => base.labelLarge!.copyWith(
    color: _cs.onSecondary,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  TextStyle get jet => base.displayMedium!.copyWith(
    color: _cs.primary,
    fontWeight: FontWeight.w600,
    fontSize: 34,
  );
  TextStyle get display =>
      base.displayMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 30);
  TextStyle get titleLarge =>
      base.titleLarge!.copyWith(fontWeight: FontWeight.w600, fontSize: 22);
  TextStyle get titleMedium =>
      base.titleMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 16);
  TextStyle get titleSmall =>
      base.titleSmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 12);

  TextStyle get labelLarge => base.labelLarge!.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: _cs.onSurfaceVariant,
  );
  TextStyle get labelMedium => base.labelMedium!.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: _cs.onSurfaceVariant,
  );
  TextStyle get subTitleLarge => base.titleMedium!.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: _cs.tertiary,
  );
  TextStyle get subTitleMedium => base.titleSmall!.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: _cs.tertiary,
  );
  TextStyle get subTitleSmall => base.titleSmall!.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 9,
    color: _cs.tertiary,
  );
}
