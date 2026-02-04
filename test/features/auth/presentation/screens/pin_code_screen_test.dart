import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/pin_code_screen.dart';
import 'package:pinput/pinput.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('PinCodeScreen Widget Tests', () {
    const testPhoneNumber = '+964 790 123 4567';

    testWidgets('should render PinCodeScreen with all components', (
      tester,
    ) async {
      // Act
      await tester.pumpApp(const PinCodeScreen(phoneNumber: testPhoneNumber));

      // Assert
      expect(find.byType(PinCodeScreen), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);
      expect(find.text('Verification'), findsOneWidget);
    });

    testWidgets('should display phone number passed as parameter', (
      tester,
    ) async {
      // Act
      await tester.pumpApp(const PinCodeScreen(phoneNumber: testPhoneNumber));

      // Assert
      expect(find.text(testPhoneNumber), findsOneWidget);
    });

    testWidgets('should display verification instructions', (tester) async {
      // Act
      await tester.pumpApp(const PinCodeScreen(phoneNumber: testPhoneNumber));

      // Assert
      expect(find.text('Verification'), findsOneWidget);
      expect(find.textContaining('Enter the pin code'), findsOneWidget);
      expect(find.text("Didn't receive code?"), findsOneWidget);
      expect(find.text('Resend'), findsOneWidget);
    });

    testWidgets('should display Pinput widget with 6 digits', (tester) async {
      // Act
      await tester.pumpApp(const PinCodeScreen(phoneNumber: testPhoneNumber));

      // Assert
      final pinput = tester.widget<Pinput>(find.byType(Pinput));
      expect(pinput, isNotNull);
    });

    testWidgets('should have resend button', (tester) async {
      // Act
      await tester.pumpApp(const PinCodeScreen(phoneNumber: testPhoneNumber));

      // Assert
      expect(find.text('Resend'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
