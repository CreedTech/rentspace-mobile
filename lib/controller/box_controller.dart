// import 'package:get/get.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/model/box_model.dart';
// import 'package:rentspace/constants/firebase_auth_constants.dart';

// class FirebaseDB {
//   Stream<List<Box>> getBox() {
//     return firebaseFirestore
//         .collection('spacebox')
//         .where("id", isEqualTo: userId)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) => Box.fromSnapshot(doc)).toList();
//     });
//   }
// }

// class BoxController extends GetxController {
//   final box = <Box>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     box.bindStream(FirebaseDB().getBox());
//   }
// }
