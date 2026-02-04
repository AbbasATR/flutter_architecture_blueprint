import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget displaying cart error state with retry option
class CartErrorState extends StatelessWidget {
  final String message;

  const CartErrorState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            IconsaxPlusLinear.danger,
            size: context.units.sp(64),
            color: context.cs.error,
          ),
          SizedBox(height: context.units.h(16)),
          Text(
            context.l10n.error,
            style: context.tt.titleLarge.copyWith(color: context.cs.error),
          ),
          SizedBox(height: context.units.h(8)),
          Text(
            message,
            style: context.tt.labelMedium.copyWith(
              color: context.cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.units.h(16)),
          ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(const LoadCartEvent());
            },
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}
