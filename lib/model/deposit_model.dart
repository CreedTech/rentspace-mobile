// import 'package:cloud_firestore/cloud_firestore.dart';

// class Deposit {
//   final String hasPaid;
//   final int savedAmount;
//   final double upfront;
//   final List<String> history;
//   final String planName;
//   final double targetAmount;
//   final String status;
//   final int withdrawalCount;
//   final String userID;
//   final String currentPayment;
//   final String interval;
//   final int interest;
//   final double intervalAmount;
//   final String date;
//   final String id;
//   final int numPayment;
//   final String depositId;
//   const Deposit({
//     required this.hasPaid,
//     required this.targetAmount,
//     required this.savedAmount,
//     required this.planName,
//     required this.status,
//     required this.userID,
//     required this.upfront,
//     required this.interest,
//     required this.withdrawalCount,
//     required this.currentPayment,
//     required this.interval,
//     required this.numPayment,
//     required this.intervalAmount,
//     required this.date,
//     required this.id,
//     required this.history,
//     required this.depositId,
//   });
//   static Deposit fromSnapshot(DocumentSnapshot data) {
//     Deposit deposit = Deposit(
//       hasPaid: data['has_paid'],
//       id: data['id'],
//       upfront: data['upfront'],
//       interest: data['interest'],
//       userID: data['user_id'],
//       planName: data['plan_name'],
//       depositId: data['savings_id'],
//       currentPayment: data['current_payment'],
//       numPayment: data['no_of_payments'],
//       targetAmount: data['target_amount'],
//       status: data['status'],
//       withdrawalCount: data['withdrawal_count'],
//       interval: data['interval'],
//       intervalAmount: data['interval_amount'],
//       date: data['date'],
//       history: List.from(data['history']),
//       savedAmount: data['paid_amount'],
//     );
//     return deposit;
//   }
// }
