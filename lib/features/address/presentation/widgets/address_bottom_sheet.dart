import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/screens/location_picker_screen.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';

/// A bottom sheet widget for displaying and selecting delivery addresses
class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  /// Shows the address bottom sheet modal
  static Future<void> show(BuildContext context) {
    // Hide bottom nav when opening
    final bottomNavCubit = context.read<BottomNavCubit>();
    bottomNavCubit.hide();

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AddressBottomSheet(),
    ).whenComplete(() {
      // Show bottom nav when closing
      bottomNavCubit.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          _buildTitle(context),
          _buildAddressList(),
          _buildAddNewAddressButton(context),
        ],
      ),
    );
  }

  /// Builds the drag handle at the top of the bottom sheet
  Widget _buildHandle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.units.h(12)),
      width: context.units.w(40),
      height: context.units.h(4),
      decoration: BoxDecoration(
        color: context.cs.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// Builds the title section
  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.units.h(20)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.units.w(20)),
          child: Text(
            context.l10n.whereToDeliver,
            style: context.tt.titleMedium,
          ),
        ),
        SizedBox(height: context.units.h(20)),
      ],
    );
  }

  /// Builds the address list section
  Widget _buildAddressList() {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          );
        }

        if (state is AddressLoaded) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.addresses.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: context.cs.outline.withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return _AddressItem(
                address: address,
                onTap: () => _onAddressSelected(context, address),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Builds the add new address button
  Widget _buildAddNewAddressButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.units.h(20)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.units.w(20)),
          child: SizedBox(
            width: double.infinity,
            child: SubmitButton(
              text: context.l10n.addNewAddress,
              icon: IconsaxPlusLinear.add_circle,
              onPressed: () => _navigateToAddAddress(context),
            ),
          ),
        ),
        SizedBox(height: context.units.h(20)),
      ],
    );
  }

  /// Navigates to the location picker screen
  void _navigateToAddAddress(BuildContext context) {
    Navigator.pop(context); // Close the bottom sheet first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );
  }

  /// Handles address selection
  void _onAddressSelected(BuildContext context, Address address) {
    context.read<AddressCubit>().selectAddressById(address.id);
    Navigator.pop(context);
  }
}

/// A widget representing an individual address item in the address list
class _AddressItem extends StatelessWidget {
  const _AddressItem({required this.address, required this.onTap});

  final Address address;
  final VoidCallback onTap;

  /// Returns the appropriate icon based on the address type
  IconData _getIcon() {
    switch (address.icon) {
      case 'home':
        return IconsaxPlusLinear.home;
      case 'work':
        return IconsaxPlusLinear.briefcase;
      case 'location':
        return IconsaxPlusLinear.location;
      default:
        return IconsaxPlusLinear.location_tick;
    }
  }

  /// Returns localized address type name
  String _getLocalizedAddressName(BuildContext context) {
    // Check if it's a standard address type that needs localization
    switch (address.name.toLowerCase()) {
      case 'home':
        return context.l10n.homeAddress;
      case 'work':
        return context.l10n.work;
      case 'other':
      case 'others':
        return context.l10n.other;
      case 'deliver to current location':
        return context.l10n.deliverToCurrentLocation;
      default:
        // Return the original name for custom addresses
        return address.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.units.w(20),
          vertical: context.units.h(16),
        ),
        child: Row(
          children: [
            _buildIcon(context),
            SizedBox(width: context.units.w(12)),
            _buildAddressDetails(context),
          ],
        ),
      ),
    );
  }

  /// Builds the address icon container
  Widget _buildIcon(BuildContext context) {
    return Container(
      width: context.units.w(40),
      height: context.units.w(40),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        _getIcon(),
        size: context.units.w(20),
        color: context.cs.onSurface,
      ),
    );
  }

  /// Builds the address details column
  Widget _buildAddressDetails(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getLocalizedAddressName(context),
            style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          if (address.details.isNotEmpty) ...[
            SizedBox(height: context.units.h(4)),
            Text(
              address.details,
              style: context.tt.labelLarge.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
