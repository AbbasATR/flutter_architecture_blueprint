import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_assets.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: AppStrings.heroTagFabLogo,
          child: Image.asset(
            AppAssets.appLogoWithTitle,
            width: context.units.screenW / 3,
            height: context.units.screenW / 3,
          ),
        ),
      ),
    );
  }
}
