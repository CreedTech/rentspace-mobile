import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';

import '../savings/spaceBox/spacebox_list.dart';

String fundedAmount = "0";
String paidAmount = "0";
String fundedDate = "0";
String numPayment = "0";
String fundWebhookID = "";
String fundRentID = "";

fgetImmediateWalletFund() async {
  var walletInfo =
      FirebaseFirestore.instance.collection('paystack_wallet_history');
  final UserController userController = Get.find();
  CollectionReference collection1 =
      FirebaseFirestore.instance.collection('webhook_collection');
  CollectionReference collection2 =
      FirebaseFirestore.instance.collection('accounts');

  QuerySnapshot snapshot1 = await collection1.get();
  QuerySnapshot snapshot2 = await collection2.get();
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('webhook_collection');

  QuerySnapshot querySnapshot = await collectionRef.get();

  for (var doc in querySnapshot.docs) {
    if (doc.get('email') == userController.user[0].email) {
      fundWebhookID = doc.id;
      fundRentID = userController.user[0].id;
    }
  }

  if (fundWebhookID == "" || fundRentID == "") {
    print("None found");
  } else {
    CollectionReference webhookRef =
        FirebaseFirestore.instance.collection('webhook_collection');
    DocumentReference webRef = webhookRef.doc(fundWebhookID);

    CollectionReference rentdocRef =
        FirebaseFirestore.instance.collection('accounts');
    DocumentReference rentRef = rentdocRef.doc(fundRentID);
// Get the document
    DocumentSnapshot docSnapshotWeb = await webRef.get();
    DocumentSnapshot docSnapshotRent = await rentRef.get();
    fundedAmount = (docSnapshotWeb.get('amount')! ~/ 100).toString();
    fundDate = docSnapshotWeb.get('created_at');

    int newBalance = (int.tryParse(userController.user[0].userWalletBalance)! +
        (int.tryParse(fundedAmount)!));
    //actions
    await rentdocRef.doc(userId).update(
      {
        'wallet_balance': newBalance.toString(),
        "activities": FieldValue.arrayUnion(
          [
            "$formattedDate\nSpace Wallet funded\n${ch8t.format(int.tryParse(fundedAmount)!).toString()}",
          ],
        ),
      },
    ).then(
      (value) async {
        await webRef.delete();
        Get.snackbar(
          "Success!",
          "SpaceWallet Funded!\nNice 😉",
          animationDuration: Duration(seconds: 2),
          backgroundColor: brandOne,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      },
    ).then((value) => {
          walletInfo.add({
            'amount': int.tryParse(fundedAmount)!.toString(),
            'date': formattedDate,
            'name': userController.user[0].userFirst +
                " " +
                userController.user[0].userLast,
            'user_id': userController.user[0].userId,
            'wallet_balance': userController.user[0].userWalletBalance,
            'wallet_id': userController.user[0].userWalletNumber,
            'id': userController.user[0].id
          })
        });
  }
}
