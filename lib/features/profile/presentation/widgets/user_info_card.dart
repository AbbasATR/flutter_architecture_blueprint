import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/profile/domain/entities/user.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/utils/user_status_helper.dart';
import 'package:intl/intl.dart';

class UserInfoCard extends StatelessWidget {
  final User user;

  const UserInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(icon: Icons.person, label: 'Name', value: user.name),
            const Divider(),
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: user.phoneNo,
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.cake,
              label: 'Date of Birth',
              value: DateFormat('MMM dd, yyyy').format(user.dateOfBirth),
            ),
            const Divider(),
            _buildInfoRow(
              icon: Icons.info,
              label: 'Status',
              value: UserStatusHelper.getStatusText(user.state),
              valueColor: UserStatusHelper.getStatusColor(user.state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
