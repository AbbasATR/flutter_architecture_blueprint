import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/app_bar/notification_badge.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/app_bar/location_selector.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/app_bar/search_button.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Shell-level app bar with location selector, search button, and notifications.
class ShellAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShellAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 32);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cs.surface,
      margin: EdgeInsets.only(top: context.units.h(16)),
      padding: EdgeInsets.symmetric(
        horizontal: context.units.w(20),
        vertical: context.units.h(16),
      ),
      child: Row(
        children: [
          const NotificationBadge(),
          SizedBox(width: context.units.w(16)),
          const Expanded(child: LocationSelector()),
          SizedBox(width: context.units.w(16)),
          const SearchButton(),
        ],
      ),
    );
  }
}
