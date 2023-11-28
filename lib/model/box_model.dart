import 'package:cloud_firestore/cloud_firestore.dart';

class Box {
  final String hasPaid;
  final int savedAmount;
  final List<String> history;
  final double targetAmount;
  final String planName;
  final String status;
  final int interest;
  final String userID;
  final String currentPayment;
  final String interval;
  final double intervalAmount;
  final double upfront;
  final String date;
  final String id;
  final int numPayment;
  final String boxId;
  const Box({
    required this.hasPaid,
    required this.targetAmount,
    required this.savedAmount,
    required this.status,
    required this.interest,
    required this.planName,
    required this.userID,
    required this.currentPayment,
    required this.interval,
    required this.numPayment,
    required this.upfront,
    required this.intervalAmount,
    required this.date,
    required this.id,
    required this.history,
    required this.boxId,
  });
  static Box fromSnapshot(DocumentSnapshot data) {
    Box box = Box(
      hasPaid: data['has_paid'],
      id: data['id'],
      planName: data['plan_name'],
      userID: data['user_id'],
      upfront: data['upfront'],
      boxId: data['savings_id'],
      currentPayment: data['current_payment'],
      numPayment: data['no_of_payments'],
      targetAmount: data['target_amount'],
      status: data['status'],
      interval: data['interval'],
      interest: data['interest'],
      intervalAmount: data['interval_amount'],
      date: data['date'],
      history: List.from(data['history']),
      savedAmount: data['paid_amount'],
    );
    return box;
  }
}
