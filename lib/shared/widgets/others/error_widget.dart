import 'package:flutter/material.dart';

class ErrorAppWidget extends StatelessWidget {
  final String message;

  const ErrorAppWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}
