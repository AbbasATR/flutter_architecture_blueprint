import 'package:flutter/material.dart';

ElevatedButtonThemeData buildElevatedButtonTheme(
  ColorScheme cs, {
  required Color brandSecondary,
}) {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(brandSecondary),
      foregroundColor: WidgetStateProperty.all(cs.onSecondary),
      overlayColor: WidgetStateProperty.resolveWith((s) {
        if (s.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.08);
        }
        return null;
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevation: WidgetStateProperty.all(0),
    ),
  );
}

CardTheme buildCardTheme(Color color) => CardTheme(
  color: color,
  elevation: 0,
  margin: const EdgeInsets.all(8),
  surfaceTintColor: Colors.transparent,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

AppBarTheme buildAppBarTheme(ColorScheme cs, TextTheme tt) => AppBarTheme(
  backgroundColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  foregroundColor: cs.onSurface,
  iconTheme: IconThemeData(color: cs.onSurface),
  titleTextStyle: tt.titleLarge?.copyWith(color: cs.onSurface),
);

InputDecorationTheme buildInputDecorationTheme(ColorScheme cs) =>
    InputDecorationTheme(
      labelStyle: TextStyle(color: cs.onSurface),
      hintStyle:
          TextStyle(color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
      filled: true,
      fillColor: cs.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
