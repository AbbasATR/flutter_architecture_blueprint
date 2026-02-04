import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:flutter_architecture_blueprint/features/address/presentation/widgets/address_details_field.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/widgets/address_icon_selector.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/widgets/address_name_field.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/widgets/location_preview_card.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';

/// Screen for adding a new delivery address
class AddAddressScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const AddAddressScreen({super.key, this.latitude, this.longitude});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  String _selectedIcon = 'location';
  MapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.latitude != null && widget.longitude != null) {
      _mapController = MapController(
        initPosition: GeoPoint(
          latitude: widget.latitude!,
          longitude: widget.longitude!,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        backgroundColor: context.cs.surface,
        elevation: 0,
        leading: custom.FloatingActionButton(
          icon: IconsaxPlusLinear.undo,
          onTap: () => Navigator.pop(context),
        ),
        title: Text(context.l10n.addNewAddress, style: context.tt.titleLarge),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.units.w(20)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.latitude != null && widget.longitude != null)
                          LocationPreviewCard(
                            latitude: widget.latitude!,
                            longitude: widget.longitude!,
                            mapController: _mapController!,
                          ),
                        if (widget.latitude != null && widget.longitude != null)
                          SizedBox(height: context.units.h(20)),
                        AddressNameField(controller: _nameController),
                        SizedBox(height: context.units.h(20)),
                        AddressDetailsField(controller: _detailsController),
                        SizedBox(height: context.units.h(24)),
                        AddressIconSelector(
                          selectedIcon: _selectedIcon,
                          onIconSelected: (icon) {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the save button
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: SubmitButton(
        text: context.l10n.save,
        icon: IconsaxPlusLinear.archive,
        onPressed: _saveAddress,
      ),
    );
  }

  /// Handles saving the new address
  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      // Here you would typically call the AddressCubit to save the address
      // For now, we'll just show a success message and pop back

      // Example: context.read<AddressCubit>().addAddress(
      //   name: _nameController.text.trim(),
      //   details: _detailsController.text.trim(),
      //   icon: _selectedIcon,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.addressSavedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }
}
