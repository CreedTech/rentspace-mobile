import 'package:get/get.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/model/auto_model.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';

class FirebaseDB {
  Stream<List<Auto>> getAuto() {
    return firebaseFirestore
        .collection('spaceauto')
        .where("id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Auto.fromSnapshot(doc)).toList();
    });
  }
}

class AutoController extends GetxController {
  final auto = <Auto>[].obs;

  @override
  void onInit() {
    super.onInit();
    auto.bindStream(FirebaseDB().getAuto());
  }
}
