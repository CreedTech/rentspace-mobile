import 'package:cloud_firestore/cloud_firestore.dart';

class Utility {
  final String amount;
  final String biller;
  final String userID;
  final String description;
  final String transactionId;
  final String date;
  final String id;

  const Utility({
    required this.userID,
    required this.description,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.id,
    required this.biller,
  });
  static Utility fromSnapshot(DocumentSnapshot data) {
    Utility utility = Utility(
      id: data['id'],
      userID: data['user_id'],
      description: data['description'],
      transactionId: data['transaction_id'],
      amount: data['amount'],
      date: data['date'],
      biller: data['biller'],
    );
    return utility;
  }
}
