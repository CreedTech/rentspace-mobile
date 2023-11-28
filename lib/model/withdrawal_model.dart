import 'package:cloud_firestore/cloud_firestore.dart';

class Withdrawal {
  final String amount;
  final String userID;
  final String date;
  final String id;
  final String reason;
  final String status;

  const Withdrawal({
    required this.userID,
    required this.reason,
    required this.amount,
    required this.date,
    required this.id,
    required this.status,
  });
  static Withdrawal fromSnapshot(DocumentSnapshot data) {
    Withdrawal withdrawal = Withdrawal(
      id: data['id'],
      userID: data['user_id'],
      reason: data['reason'],
      amount: data['amount'],
      date: data['date'],
      status: data['status'],
    );
    return withdrawal;
  }
}
