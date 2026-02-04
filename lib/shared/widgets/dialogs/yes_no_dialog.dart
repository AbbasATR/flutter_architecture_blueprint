import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';

Future<bool> yesNoDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text(AppStrings.no),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text(AppStrings.yes),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
