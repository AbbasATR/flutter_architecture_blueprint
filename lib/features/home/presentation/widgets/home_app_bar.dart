import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/widgets/address_bottom_sheet.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cs.surface,
      padding: EdgeInsets.symmetric(
        horizontal: context.units.w(20),
        vertical: context.units.h(16),
      ),
      child: Row(
        children: [
          // Notification Icon with Badge
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final unreadCount = state is NotificationLoaded
                  ? state.unreadCount
                  : 0;

              return InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                  // Refresh unread count when returning
                  if (context.mounted) {
                    context.read<NotificationCubit>().refreshUnreadCount();
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: context.units.w(40),
                  height: context.units.w(40),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.cs.tertiary.withValues(alpha: 0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          IconsaxPlusLinear.notification,
                          size: context.units.w(20),
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(
                              unreadCount > 9
                                  ? context.units.w(2)
                                  : context.units.w(4),
                            ),
                            decoration: BoxDecoration(
                              color: context.cs.error,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: context.units.w(16),
                              minHeight: context.units.w(16),
                            ),
                            child: Center(
                              child: Text(
                                unreadCount > 9 ? '9+' : '$unreadCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(width: context.units.w(16)),
          // Location
          Expanded(
            child: BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                String locationText = 'Karbala, Alhussain';

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
                      Icon(
                        IconsaxPlusLinear.location,
                        size: context.units.w(18),
                      ),
                      SizedBox(width: context.units.w(8)),
                      Flexible(
                        child: Text(
                          locationText,
                          style: context.tt.labelLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: context.units.w(4)),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: context.units.w(20),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(width: context.units.w(16)),
          // Search Icon
          Container(
            width: context.units.w(40),
            height: context.units.w(40),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.cs.outline.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              IconsaxPlusLinear.search_normal,
              size: context.units.w(20),
            ),
          ),
        ],
      ),
    );
  }
}
