import 'package:flutter/material.dart';

import 'palette.dart';
import 'components.dart';

class AppTheme {
  static ThemeData light() => _base(
    brightness: Brightness.light,
    scaffoldBg: Palette.scaffoldLight,
    cardColor: Palette.cardLight,
    iconColor: Palette.iconLight,
    chipBg: Palette.chipLight,
    onSurface: Palette.textMainLight,
    onSurfaceVariant: Palette.textSubLight,
    tertiaryText: Palette.textHintLight,
    surfaceContainerColor: Colors.white,
    surfaceContainerLowColor: Palette.surfaceContainerLowLight,
    bottomBarColor: Palette.bottomBarLight,
  );

  static ThemeData dark() => _base(
    brightness: Brightness.dark,
    scaffoldBg: Palette.scaffoldDark,
    cardColor: Palette.cardDark,
    iconColor: Palette.iconDark,
    chipBg: Palette.chipDark,
    onSurface: Palette.textMainDark,
    onSurfaceVariant: Palette.textSubDark,
    tertiaryText: Palette.textHintDark,
    surfaceContainerColor: Colors.black,
    surfaceContainerLowColor: Palette.surfaceContainerLowDark,
    bottomBarColor: Palette.bottomBarDark,
  );

  static ThemeData _base({
    required Brightness brightness,
    required Color scaffoldBg,
    required Color cardColor,
    required Color iconColor,
    required Color chipBg,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color tertiaryText,
    required Color surfaceContainerColor,
    required Color surfaceContainerLowColor,
    required Color bottomBarColor,
  }) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: Palette.primary,
          brightness: brightness,
        ).copyWith(
          primary: Palette.primary,
          onPrimary: Colors.black,
          secondary: Palette.secondary,
          onSecondary: Colors.white,
          surface: scaffoldBg,
          onSurface: onSurface,
          onSurfaceVariant: onSurfaceVariant,
          tertiary: tertiaryText,
          onTertiary: onSurface,
          surfaceContainer: surfaceContainerColor,
          surfaceContainerLow: surfaceContainerLowColor,
          error: Colors.red.withValues(alpha: 0.7),
          surfaceBright: bottomBarColor,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: scaffoldBg,
      fontFamily: 'SF Pro',
      fontFamilyFallback: const ['RiyadBank', 'sans-serif'],
    );

    return base.copyWith(
      elevatedButtonTheme: buildElevatedButtonTheme(
        scheme,
        brandSecondary: Palette.secondary,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        margin: const EdgeInsets.all(8),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: IconThemeData(color: iconColor),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: chipBg,
        selectedColor: chipBg,
        disabledColor: chipBg,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bottomBarColor,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      // appBarTheme: buildAppBarTheme(scheme, tt),
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ).copyWith(backgroundColor: scheme.surface),
      inputDecorationTheme: buildInputDecorationTheme(scheme),
      dialogTheme: DialogThemeData(backgroundColor: scheme.surface),
    );
  }
}
