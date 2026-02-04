import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/widgets/address_bottom_sheet.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Location selector component that displays current address.
///
/// Shows the selected delivery address with a dropdown icon.
/// Taps open the address selection bottom sheet.
class LocationSelector extends StatelessWidget {
  const LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        String locationText = 'Select location';

        if (state is AddressLoaded && state.selectedAddress != null) {
          final address = state.selectedAddress!;
          locationText = address.details.isNotEmpty
              ? address.details
              : address.name;
        }

        return InkWell(
          onTap: () async {
            await AddressBottomSheet.show(context);
            if (context.mounted) {
              context.read<AddressCubit>().loadSelectedAddress();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconsaxPlusLinear.location, size: context.units.w(18)),
              SizedBox(width: context.units.w(8)),
              Flexible(
                child: Text(
                  locationText,
                  style: context.tt.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: context.units.w(4)),
              Icon(Icons.keyboard_arrow_down, size: context.units.w(20)),
            ],
          ),
        );
      },
    );
  }
}
