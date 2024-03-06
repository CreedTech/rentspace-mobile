// import 'package:cloud_firestore/cloud_firestore.dart';

// class Auto {
//   final String hasPaid;
//   final int savedAmount;
//   final String planName;
//   final List<String> history;
//   final double targetAmount;
//   final String status;
//   final String userID;
//   final int interest;
//   final String currentPayment;
//   final String interval;
//   final double intervalAmount;
//   final String date;
//   final String id;
//   final int numPayment;
//   final String autoId;
//   const Auto({
//     required this.hasPaid,
//     required this.targetAmount,
//     required this.savedAmount,
//     required this.planName,
//     required this.status,
//     required this.userID,
//     required this.currentPayment,
//     required this.interval,
//     required this.numPayment,
//     required this.intervalAmount,
//     required this.date,
//     required this.id,
//     required this.interest,
//     required this.history,
//     required this.autoId,
//   });
//   static Auto fromSnapshot(DocumentSnapshot data) {
//     Auto auto = Auto(
//       hasPaid: data['has_paid'],
//       id: data['id'],
//       planName: data['plan_name'],
//       userID: data['user_id'],
//       autoId: data['savings_id'],
//       currentPayment: data['current_payment'],
//       numPayment: data['no_of_payments'],
//       targetAmount: data['target_amount'],
//       status: data['status'],
//       interest: data['interest'],
//       interval: data['interval'],
//       intervalAmount: data['interval_amount'],
//       date: data['date'],
//       history: List.from(data['history']),
//       savedAmount: data['paid_amount'],
//     );
//     return auto;
//   }
// }
