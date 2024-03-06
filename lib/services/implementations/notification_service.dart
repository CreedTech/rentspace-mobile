// // import 'package:flutter/material.dart';

// // import '../../model/notification_model.dart';

// // class NotificationService extends ChangeNotifier {
// //   final List<NotificationModel> _notifications = [];

// //   List<NotificationModel> get notifications => _notifications;

// //   bool get hasUnreadNotification => _notifications.isNotEmpty;

// //   void addNotification(NotificationModel notification) {
// //     _notifications.add(notification);
// //     notifyListeners();
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import '../../model/notification_model.dart';

// class NotificationService extends ChangeNotifier {
//   List<NotificationModel> _notifications = [];

//   List<NotificationModel> get notifications => _notifications;

//   bool get hasUnreadNotification => _notifications.isNotEmpty;

//   // Add a method to fetch notifications from Firestore
//   Future<void> fetchNotificationsFromFirestore() async {
//     print('fetching');
//     try {

//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('notifications').get();
//       List<QueryDocumentSnapshot> documents = querySnapshot.docs;



//       // Convert Firestore data to NotificationModel
//       List<NotificationModel> fetchedNotifications = documents
//           .map((data) => NotificationModel(
//               title: data['title'],
//               message: data['message'],
//               timestamp: (data['timestamp'] as Timestamp).toDate(),
//               isRead: data['isRead']))
//           .toList();
//       // print(fetchedNotifications);

//       // Update the _notifications list
//       _notifications = fetchedNotifications;

//       // Notify listeners to update the UI
//       notifyListeners();
//     } catch (error) {
//       print('Error fetching notifications: $error');
//     }
//   }
// }
