import 'package:flutter/material.dart';
import 'package:mobile_app/config/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black87,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black54,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 12),
      actions: actions.isEmpty
          ? null
          : actions.map((action) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: action,
              );
            }).toList(),
    );
  }
}
