// import 'package:cloud_firestore/cloud_firestore.dart';

// class NotificationModel {
//   final String title;
//   final String message;
//   final DateTime timestamp;
//   final bool isRead;

//   const NotificationModel(
//       {required this.title,
//       required this.message,
//       required this.timestamp,
//       required this.isRead});
//   static NotificationModel fromSnapshot(DocumentSnapshot data) {
//     NotificationModel notificationModel = NotificationModel(
//       title: data['title'],
//       message: data['message'],
//       timestamp: (data['timestamp'] as Timestamp).toDate(),
//       isRead: data['isRead'],
//     );
//     return notificationModel;
//   }
// }
