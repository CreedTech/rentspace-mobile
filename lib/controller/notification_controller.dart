// import 'package:get/get.dart';
// import 'package:rentspace/model/notification_model.dart';

// import '../constants/firebase_auth_constants.dart';

// class FirebaseDB {
//   Stream<List<NotificationModel>> getNotifications() {
//     print(firebaseFirestore.collection('notifications'));
//     return firebaseFirestore
//         .collection('notifications')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs
//           .map((doc) => NotificationModel.fromSnapshot(doc))
//           .toList();
//     });
//   }
// }

// class NotificationController extends GetxController {
//   final notification = <NotificationModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     notification.bindStream(FirebaseDB().getNotifications());
//   }
// }
