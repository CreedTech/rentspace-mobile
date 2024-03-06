// import 'package:get/get.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:rentspace/model/rent_model.dart';
// import 'package:rentspace/constants/firebase_auth_constants.dart';

// class FirebaseDB {
//   Stream<List<Rent>> getRent() {
//     return firebaseFirestore
//         .collection('rent_space')
//         .where("id", isEqualTo: userId)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) => Rent.fromSnapshot(doc)).toList();
//     });
//   }
// }

// class RentController extends GetxController {
//   final rent = <Rent>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     rent.bindStream(FirebaseDB().getRent());
//   }
// }
