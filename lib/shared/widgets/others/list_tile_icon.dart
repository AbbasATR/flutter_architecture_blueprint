import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

class ListTileIcon extends StatelessWidget {
  final bool reverse;
  final String title;
  final String subTitle;
  final IconData iconData;
  final void Function()? onTap;
  const ListTileIcon({
    super.key,
    this.reverse = false,
    required this.title,
    required this.subTitle,
    required this.iconData,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(subTitle),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: context.units.w(20),
          ),
          leading: Icon(iconData, size: context.units.h(28)),
          onTap: onTap,
        ),
        Divider(thickness: 0.8, height: context.units.h(10)),
      ],
    );
  }
}
