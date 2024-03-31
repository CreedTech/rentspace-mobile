

import 'dart:io';

class NotificationState {
  List<dynamic> notification;
  NotificationState({this.notification = const []});

  NotificationState copyWith({List<dynamic>? notification, File? file}) {
    return NotificationState(
      notification: notification ?? this.notification,
    );
  }
}
