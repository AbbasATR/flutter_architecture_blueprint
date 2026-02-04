import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/widgets/account_settings/dark_mode_menu_item.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/widgets/account_settings/language_menu_item.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/widgets/account_settings/profile_header_card.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/widgets/account_settings/settings_menu_item.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  context.l10n.accountSettings,
                  style: context.tt.titleLarge,
                ),
              ),

              // Profile Card
              const ProfileHeaderCard(
                name: 'Salam Omer', // TODO: Get from user data
              ),

              // Settings List
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildDivider(context),
                    SettingsMenuItem(
                      icon: Icons.person_outline,
                      title: context.l10n.editProfile,
                      onTap: () {
                        // TODO: Replace with actual user data from UserCubit when it's provided
                        final mockUser = User(
                          id: 1,
                          name: 'Salam Omer',
                          dateOfBirth: DateTime(1990, 1, 1),
                          state: UserState.active,
                          phoneNo: '+964 750 123 4567',
                          addresses: [],
                          credit: 0,
                          avatarURL: '',
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(user: mockUser),
                          ),
                        );
                      },
                    ),
                    _buildDivider(context),
                    SettingsMenuItem(
                      icon: Icons.headset_mic_outlined,
                      title: context.l10n.contactSupport,
                      onTap: () {
                        // TODO: Navigate to contact support
                      },
                    ),
                    _buildDivider(context),
                    const LanguageMenuItem(),
                    _buildDivider(context),
                    const DarkModeMenuItem(),
                    _buildDivider(context),
                    SettingsMenuItem(
                      icon: Icons.favorite_border,
                      title: context.l10n.favorites,
                      onTap: () {
                        // TODO: Navigate to favorites
                      },
                    ),
                    _buildDivider(context),
                    SettingsMenuItem(
                      icon: Icons.location_on_outlined,
                      title: context.l10n.addresses,
                      onTap: () {
                        // TODO: Navigate to addresses
                      },
                    ),
                    _buildDivider(context),
                    SettingsMenuItem(
                      icon: Icons.delete_outline,
                      title: context.l10n.deleteAccount,
                      onTap: () {
                        // TODO: Show delete account dialog
                      },
                      iconColor: Colors.red,
                      textColor: Colors.red,
                    ),
                    _buildDivider(context),
                    SettingsMenuItem(
                      icon: Icons.logout,
                      title: context.l10n.signOut,
                      onTap: () {
                        // TODO: Show sign out dialog
                      },
                    ),
                    _buildDivider(context),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 4,
      thickness: 1,
      indent: 56,
      color: context.cs.onSurface.withValues(alpha: 0.1),
    );
  }
}
