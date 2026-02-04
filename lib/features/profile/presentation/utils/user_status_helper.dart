import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';

/// Utility class for user status-related operations
class UserStatusHelper {
  UserStatusHelper._();

  /// Returns the appropriate icon for a user state
  static IconData getStatusIcon(UserState state) {
    switch (state) {
      case UserState.active:
        return Icons.check_circle;
      case UserState.inactive:
        return Icons.cancel;
      case UserState.suspended:
        return Icons.warning;
    }
  }

  /// Returns the appropriate color for a user state
  static Color getStatusColor(UserState state) {
    switch (state) {
      case UserState.active:
        return Colors.green;
      case UserState.inactive:
        return Colors.grey;
      case UserState.suspended:
        return Colors.red;
    }
  }

  /// Returns the localized text for a user state
  static String getStatusText(UserState state) {
    switch (state) {
      case UserState.active:
        return 'Active';
      case UserState.inactive:
        return 'Inactive';
      case UserState.suspended:
        return 'Suspended';
    }
  }

  /// Returns a status badge widget
  static Widget buildStatusBadge(UserState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(state).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getStatusColor(state).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getStatusIcon(state), size: 16, color: getStatusColor(state)),
          const SizedBox(width: 4),
          Text(
            getStatusText(state),
            style: TextStyle(
              color: getStatusColor(state),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
