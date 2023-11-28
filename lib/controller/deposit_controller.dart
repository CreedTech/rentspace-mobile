import 'package:get/get.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/model/deposit_model.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';

class FirebaseDB {
  Stream<List<Deposit>> getDeposit() {
    return firebaseFirestore
        .collection('spacedeposit')
        .where("id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Deposit.fromSnapshot(doc)).toList();
    });
  }
}

class DepositController extends GetxController {
  final deposit = <Deposit>[].obs;

  @override
  void onInit() {
    super.onInit();
    deposit.bindStream(FirebaseDB().getDeposit());
  }
}
