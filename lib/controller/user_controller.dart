// import 'package:get/get.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/model/user_profile_model.dart';
// import 'package:rentspace/constants/firebase_auth_constants.dart';

// //
// class FirebaseDB {
//   Stream<List<User>> getUser() {
//     return firebaseFirestore
//         .collection('accounts')
//         .where("id", isEqualTo: userId)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
//     });
//   }
// }

// class UserController extends GetxController {
//   final user = <User>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     user.bindStream(FirebaseDB().getUser());
//   }
// }
