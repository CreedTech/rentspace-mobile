import 'package:cloud_firestore/cloud_firestore.dart';

class Tank {
  final String hasPaid;
  final List<String> history;
  final double targetAmount;
  final double upfront;
  final String planName;
  final String status;
  final String userID;
  final String duration;
  final String endDate;
  final String date;
  final String id;
  final String tankId;
  const Tank({
    required this.hasPaid,
    required this.targetAmount,
    required this.status,
    required this.upfront,
    required this.userID,
    required this.duration,
    required this.endDate,
    required this.planName,
    required this.date,
    required this.id,
    required this.history,
    required this.tankId,
  });
  static Tank fromSnapshot(DocumentSnapshot data) {
    Tank tank = Tank(
      hasPaid: data['has_paid'],
      id: data['id'],
      userID: data['user_id'],
      duration: data['duration'],
      endDate: data['end_date'],
      upfront: data['upfront'],
      tankId: data['savings_id'],
      planName: data['plan_name'],
      targetAmount: data['target_amount'],
      status: data['status'],
      date: data['date'],
      history: List.from(data['history']),
    );
    return tank;
  }
}
