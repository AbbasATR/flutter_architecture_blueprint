import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/utils/user_status_helper.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late DateTime _selectedDate;
  String? _avatarURL;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phoneNo);
    _selectedDate = widget.user.dateOfBirth;
    _avatarURL = widget.user.avatarURL.isNotEmpty
        ? widget.user.avatarURL
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // ignore: unused_local_variable
      final updatedUser = widget.user.copyWith(
        name: _nameController.text,
        phoneNo: _phoneController.text,
        dateOfBirth: _selectedDate,
        avatarURL: _avatarURL ?? '',
      );

      // TODO: Implement actual save via UserCubit when it's provided
      // context.read<cubit.UserCubit>().updateUserProfile(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profileUpdatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  void _changeAvatar() {
    final l10n = context.l10n;

    // TODO: Implement image picker functionality
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery picker
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.galleryPickerNotImplemented)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.cameraNotImplemented)),
                );
              },
            ),
            if (_avatarURL != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  l10n.removePhoto,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  setState(() {
                    _avatarURL = null;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        backgroundColor: context.cs.surface,
        elevation: 0,
        title: Text(l10n.editProfile, style: context.tt.titleLarge),
        centerTitle: true,
        leading: custom.FloatingActionButton(
          icon: IconsaxPlusLinear.undo,
          onTap: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              l10n.save,
              style: context.tt.titleMedium.copyWith(
                color: context.cs.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.units.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: context.units.w(120),
                    height: context.units.w(120),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: context.cs.outline, width: 2),
                    ),
                    child: ClipOval(
                      child: _avatarURL != null && _avatarURL!.isNotEmpty
                          ? Image.asset(
                              _avatarURL!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar(context);
                              },
                            )
                          : _buildDefaultAvatar(context),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _changeAvatar,
                      child: Container(
                        width: context.units.w(36),
                        height: context.units.w(36),
                        decoration: BoxDecoration(
                          color: context.cs.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.cs.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          IconsaxPlusLinear.camera,
                          color: context.cs.onPrimary,
                          size: context.units.sp(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.units.h(24)),

            // Account Status Card
            Card(
              color: context.cs.surfaceContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  UserStatusHelper.getStatusIcon(widget.user.state),
                  color: UserStatusHelper.getStatusColor(widget.user.state),
                ),
                title: Text(l10n.accountStatus, style: context.tt.labelMedium),
                subtitle: Text(
                  UserStatusHelper.getStatusText(widget.user.state),
                  style: context.tt.titleSmall.copyWith(
                    color: UserStatusHelper.getStatusColor(widget.user.state),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.units.h(24)),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      prefixIcon: const Icon(IconsaxPlusLinear.user),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: context.cs.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterYourName;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.units.h(25)),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      prefixIcon: const Icon(IconsaxPlusLinear.call),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: context.cs.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterYourPhoneNumber;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.units.h(25)),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.dateOfBirth,
                        prefixIcon: const Icon(IconsaxPlusLinear.calendar),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: context.cs.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: context.tt.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      color: context.cs.primaryContainer,
      child: Icon(
        IconsaxPlusLinear.user,
        size: context.units.w(60),
        color: context.cs.onPrimaryContainer,
      ),
    );
  }
}
