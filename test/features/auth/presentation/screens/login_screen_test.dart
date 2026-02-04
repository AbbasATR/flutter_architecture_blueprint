import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/pin_code_screen.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/inputs/custom_text_field.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should render LoginScreen with all components', (
      tester,
    ) async {
      // Act
      await tester.pumpApp(const LoginScreen());

      // Assert
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(CustomTextField), findsOneWidget);
      expect(find.byType(SubmitButton), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should display welcome text and logo', (tester) async {
      // Act
      await tester.pumpApp(const LoginScreen());

      // Assert
      expect(find.textContaining('Welcome to'), findsOneWidget);
      expect(find.textContaining('JET'), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);
    });

    testWidgets('should display phone number input field', (tester) async {
      // Act
      await tester.pumpApp(const LoginScreen());

      // Assert
      expect(find.byType(CustomTextField), findsOneWidget);
      final textField = tester.widget<CustomTextField>(
        find.byType(CustomTextField),
      );
      expect(textField.keyboardType, TextInputType.phone);
      expect(textField.requiredField, isTrue);
    });

    testWidgets('should accept phone number input', (tester) async {
      // Arrange
      await tester.pumpApp(const LoginScreen());

      // Act
      await tester.enterText(find.byType(TextField), '7901234567');
      await tester.pump();

      // Assert
      expect(find.text('7901234567'), findsOneWidget);
    });

    testWidgets('should display Next button', (tester) async {
      // Act
      await tester.pumpApp(const LoginScreen());

      // Assert
      expect(find.byType(SubmitButton), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets(
      'should navigate to PinCodeScreen when form is valid and submitted',
      (tester) async {
        // Arrange
        await tester.pumpApp(const LoginScreen());

        // Act - Enter valid phone number
        await tester.enterText(find.byType(TextField), '7901234567');
        await tester.pump();

        // Tap submit button
        await tester.tap(find.byType(SubmitButton));
        await tester.pumpAndSettle();

        // Assert - Should navigate to PinCodeScreen
        expect(find.byType(PinCodeScreen), findsOneWidget);
        expect(find.byType(LoginScreen), findsNothing);
      },
    );
  });
}
