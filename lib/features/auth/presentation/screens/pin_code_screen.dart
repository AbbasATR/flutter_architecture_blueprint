import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/screens/shell_screen.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:pinput/pinput.dart';

class PinCodeScreen extends StatefulWidget {
  final String phoneNumber;
  const PinCodeScreen({super.key, required this.phoneNumber});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final TextEditingController _pinputController = TextEditingController();

  @override
  void dispose() {
    _pinputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.verification, style: context.tt.display),
              SizedBox(height: context.units.h(20)),
              Text(l10n.enterPinCode, style: context.tt.subTitleLarge),
              SizedBox(height: context.units.h(10)),
              Text(widget.phoneNumber, style: context.tt.titleMedium),
              SizedBox(height: context.units.h(40)),
              _pinPut(),
              Text(
                "${l10n.didntReceiveCode} 2222",
                style: context.tt.subTitleLarge,
              ),

              TextButton(
                onPressed: () {
                  // Add your resend logic here
                },
                child: Text(
                  l10n.resend,
                  style: context.tt.titleMedium.copyWith(
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: context.cs.primary,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pinPut() {
    final defaultPinTheme = PinTheme(
      width: context.units.w(60),
      height: context.units.w(60),
      textStyle: context.tt.titleLarge,
      decoration: BoxDecoration(
        border: Border.all(color: context.cs.onSurfaceVariant),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: context.cs.primary),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.cs.surfaceContainer,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Pinput(
        controller: _pinputController,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,

        validator: (s) {
          return s == '2222' ? null : 'Pin is incorrect';
        },
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        onCompleted: (pin) {
          if (pin == '2222') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShellScreen()),
            );
          }
        },
      ),
    );
  }
}
