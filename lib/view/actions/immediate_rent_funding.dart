// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/controller/rent_controller.dart';
// import 'package:rentspace/controller/user_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../savings/spaceRent/spacerent_list.dart';

// final UserController userController = Get.find();
// final RentController rentController = Get.find();

// String fundedAmount = "0";
// String paidAmount = "0";
// String fundedDate = "0";
// String numPayment = "0";
// String fundWebhookID = "";
// String fundRentID = "";
// String token = "";
// var now = DateTime.now();
// var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);

// fgetImmediateRentFund() async {
//   CollectionReference collection1 =
//       FirebaseFirestore.instance.collection('webhook_collection');
//   CollectionReference collection2 =
//       FirebaseFirestore.instance.collection('rent_space');

//   QuerySnapshot snapshot1 = await collection1.get();
//   QuerySnapshot snapshot2 = await collection2.get();

//   for (var doc1 in snapshot1.docs) {
//     for (var doc2 in snapshot2.docs) {
//       if (doc1['trans_ref'] == doc2['rentspace_id']) {
//         fundWebhookID = doc1.id;
//         fundRentID = doc2.id;
//       }
//     }
//   }

//   if (fundWebhookID == "" || fundRentID == "") {
//     print("None found");
//   } else {
//     CollectionReference webhookRef =
//         FirebaseFirestore.instance.collection('webhook_collection');
//     DocumentReference webRef = webhookRef.doc(fundWebhookID);

//     CollectionReference rentdocRef =
//         FirebaseFirestore.instance.collection('rent_space');
//     DocumentReference rentRef = rentdocRef.doc(fundRentID);

//     // Get the document
//     DocumentSnapshot docSnapshotWeb = await webRef.get();
//     DocumentSnapshot docSnapshotRent = await rentRef.get();

//     if (docSnapshotWeb.exists && docSnapshotRent.exists) {
//       // Document exists, get the image field
//       paidAmount = (int.tryParse(docSnapshotRent.get('paid_amount').toString()))
//           .toString();
//       fundedAmount =
//           (int.tryParse(docSnapshotWeb.get('amount'))! ~/ 100).toString();
//       fundDate = docSnapshotWeb.get('date');
//       token = docSnapshotWeb.get('token_id');
//       numPayment = docSnapshotRent.get('no_of_payments');

//       await rentRef.update({
//         'has_paid': 'true',
//         'paid_amount':
//             (int.tryParse(paidAmount)! + int.tryParse(fundedAmount)!),
//         'token': token,
//         'no_of_payments': (int.tryParse(numPayment)! - 1).toString(),
//         'history': FieldValue.arrayUnion(
//           [
//             "$fundDate\nSpaceRent payment successful\n${ch8t.format(double.tryParse(fundedAmount)).toString()}",
//           ],
//         ),
//       }).then((value) async {
//         await webRef.delete();
//       });
//       Get.snackbar(
//         "Success!",
//         "New payment recorded!\nKeep it up 👍",
//         animationDuration: const Duration(seconds: 2),
//         backgroundColor: brandOne,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.TOP,
//       );
//     } else {
//       print('Document does not exist on the database');
//     }
//   }
// }
