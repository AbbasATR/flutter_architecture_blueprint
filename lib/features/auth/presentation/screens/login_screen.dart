import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_assets.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/pin_code_screen.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/inputs/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: AppStrings.heroTagFabLogo,
                      child: Image.asset(
                        AppAssets.appLogoWithTitle,
                        width: context.units.screenW / 3.6,
                        height: context.units.screenW / 3.6,
                      ),
                    ),
                    SizedBox(height: context.units.h(40)),
                    Text.rich(
                      TextSpan(
                        text: context.l10n.welcomeTo,
                        style: context.tt.display,
                        children: [
                          TextSpan(
                            text: "  ${AppStrings.appTitle}",
                            style: context.tt.jet,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  CustomTextField(
                    requiredField: true,
                    keyboardType: TextInputType.phone,
                    icon: Padding(
                      padding: EdgeInsets.all(context.units.w(10)),
                      child: _countryFlag(),
                    ),
                    isNumeric: true,
                    suffix: Icon(IconsaxPlusBroken.call),
                    controller: _phoneController,
                    label: context.l10n.phoneNumber,
                    hint: context.l10n.enterYourPhoneNumber,
                  ),
                  SizedBox(height: context.units.h(20)),
                  SubmitButton(
                    text: context.l10n.next,
                    icon: IconsaxPlusBroken.next,
                    onPressed: onSubmit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _countryFlag() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppAssets.iqFlag,
          width: context.units.h(25),
          height: context.units.h(17),
          fit: BoxFit.cover,
        ),
        SizedBox(width: context.units.w(7)),
        Text(AppStrings.iraqCountryCode),
      ],
    );
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      String phoneNumber =
          "${AppStrings.iraqCountryCode}${_phoneController.text.trim()}";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinCodeScreen(phoneNumber: phoneNumber),
        ),
      );
    }
  }
}
