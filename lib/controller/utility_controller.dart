import 'package:get/get.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:rentspace/model/utility_model.dart';

class FirebaseDB {
  Stream<List<Utility>> getUtility() {
    return firebaseFirestore
        .collection('utility')
        .where("id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Utility.fromSnapshot(doc)).toList();
    });
  }
}

class UtilityController extends GetxController {
  final utility = <Utility>[].obs;

  @override
  void onInit() {
    super.onInit();
    utility.bindStream(FirebaseDB().getUtility());
  }
}

/* .orderBy('timestamp', descending: true) */
        