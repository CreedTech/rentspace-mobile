import 'package:cloud_firestore/cloud_firestore.dart';

class Rent {
  final String hasPaid;
  final int savedAmount;
  final List<String> history;
  final double targetAmount;
  final String status;
  final String userID;
  final String currentPayment;
  final String interval;
  final double intervalAmount;
  final String date;
  final String id;
  final String numPayment;
  final String rentId;
  const Rent({
    required this.hasPaid,
    required this.targetAmount,
    required this.savedAmount,
    required this.status,
    required this.userID,
    required this.currentPayment,
    required this.interval,
    required this.numPayment,
    required this.intervalAmount,
    required this.date,
    required this.id,
    required this.history,
    required this.rentId,
  });
  static Rent fromSnapshot(DocumentSnapshot data) {
    Rent rent = Rent(
      hasPaid: data['has_paid'],
      id: data['id'],
      userID: data['user_id'],
      rentId: data['rentspace_id'],
      currentPayment: data['current_payment'],
      numPayment: data['no_of_payments'],
      targetAmount: data['target_amount'],
      status: data['status'],
      interval: data['interval'],
      intervalAmount: data['interval_amount'],
      date: data['date'],
      history: List.from(data['history']),
      savedAmount: data['paid_amount'],
    );
    return rent;
  }
}
