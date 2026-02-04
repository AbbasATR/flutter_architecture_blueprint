import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    testWidgets('should render SplashScreen', (tester) async {
      // Act
      await tester.pumpApp(const SplashScreen());

      // Assert
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display logo with Hero animation', (tester) async {
      // Act
      await tester.pumpApp(const SplashScreen());

      // Assert
      expect(find.byType(Hero), findsOneWidget);
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, AppStrings.heroTagFabLogo);
    });

    testWidgets('should display centered logo image', (tester) async {
      // Act
      await tester.pumpApp(const SplashScreen());

      // Assert
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should have correct widget hierarchy', (tester) async {
      // Act
      await tester.pumpApp(const SplashScreen());

      // Assert - Verify widget tree structure
      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(Center), matching: find.byType(Hero)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(Hero), matching: find.byType(Image)),
        findsOneWidget,
      );
    });
  });
}
