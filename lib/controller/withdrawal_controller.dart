import 'package:get/get.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:rentspace/model/withdrawal_model.dart';

class FirebaseDB {
  Stream<List<Withdrawal>> getWithdrawal() {
    return firebaseFirestore
        .collection('liquidation')
        .where("status", isEqualTo: "approved")
        .where("id", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Withdrawal.fromSnapshot(doc)).toList();
    });
  }
}

class WithdrawalController extends GetxController {
  final withdrawal = <Withdrawal>[].obs;

  @override
  void onInit() {
    super.onInit();
    withdrawal.bindStream(FirebaseDB().getWithdrawal());
  }
}
