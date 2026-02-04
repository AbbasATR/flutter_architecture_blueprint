import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;

  const SubmitButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.units.h(50),

      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.units.w(20)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(text, style: context.tt.buttonText)],
              ),
            ),
          ),
          PositionedDirectional(
            end: context.units.w(20),
            child: icon != null
                ? Icon(
                    icon,
                    color: context.cs.primary,
                    size: context.units.r(28),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
