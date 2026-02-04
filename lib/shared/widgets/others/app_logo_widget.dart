import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_assets.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.appTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Image.asset(AppAssets.appLogo, height: 100),
      ],
    );
  }
}
