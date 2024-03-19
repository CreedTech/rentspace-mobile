import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final Map<String, dynamic>? notificationData;

  const NotificationDialog({super.key, this.notificationData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notification Received'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: ${notificationData?['amount']}'),
            Text('Body: ${notificationData?['name']}'),
            Text('Notification Type: ${notificationData?['notificationType']}'),
            // Add more Text widgets to display other data as needed
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
