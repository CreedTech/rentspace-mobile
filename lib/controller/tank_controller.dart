// import 'package:get/get.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/model/tank_model.dart';
// import 'package:rentspace/constants/firebase_auth_constants.dart';

// class FirebaseDB {
//   Stream<List<Tank>> getTank() {
//     return firebaseFirestore
//         .collection('spacetank')
//         .where("id", isEqualTo: userId)
//         .where("has_paid", isEqualTo: "true")
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) => Tank.fromSnapshot(doc)).toList();
//     });
//   }
// }

// class TankController extends GetxController {
//   final tank = <Tank>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     tank.bindStream(FirebaseDB().getTank());
//   }
// }
