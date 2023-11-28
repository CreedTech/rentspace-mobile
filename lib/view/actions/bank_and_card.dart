import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rentspace/view/actions/add_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/user_controller.dart';

class BankAndCard extends StatefulWidget {
  BankAndCard({
    Key? key,
  }) : super(key: key);

  @override
  _BankAndCardState createState() => _BankAndCardState();
}

var obxData = " ".obs;

class _BankAndCardState extends State<BankAndCard> {
  final UserController userController = Get.find();
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            '',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 80,
            ),

            //card
            (userController.user[0].cardHolder != "")
                ? Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: FlipCard(
                      front: Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                            depth: 0,
                            lightSource: LightSource.topLeft,
                            color: Colors.white),
                        child: Container(
                          height: 200,
                          padding: EdgeInsets.fromLTRB(30.0, 10.0, 20.0, 10.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                brandOne,
                                brandTwo,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/chip.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "XXXX XXXX XXXX " +
                                            userController.user[0].cardDigit
                                                .substring(5, 9),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          letterSpacing: 2.0,
                                          fontFamily: "DefaultFontFamily",
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        userController.user[0].cardHolder,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          letterSpacing: 2.0,
                                          fontFamily: "DefaultFontFamily",
                                          color: brandOne,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        //textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        userController.user[0].cardExpire,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          letterSpacing: 2.0,
                                          fontFamily: "DefaultFontFamily",
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      back: Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                            depth: 0,
                            lightSource: LightSource.topLeft,
                            color: Theme.of(context).canvasColor),
                        child: Container(
                          height: 200,
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                brandOne,
                                brandTwo,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 5.0),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: "DefaultFontFamily",
                                        //letterSpacing: 1.0,

                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.black,
                                height: 40,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 5.0),
                                child: Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      EdgeInsets.fromLTRB(5.0, 4.0, 5.0, 4.0),
                                  child: Text(
                                    userController.user[0].cardCVV,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "DefaultFontFamily",
                                      //letterSpacing: 1.0,

                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                                child: Text(
                                  "This card is the property of your Bank Name and is issued to the cardholder subject to the terms and conditions associated with the account. Unauthorized use, duplication, or disclosure of this card is strictly prohibited. If found, please return to your Bank Address. The cardholder is responsible for the safety and security of this card. Any loss, theft, or unauthorized use must be reported immediately to your Bank Customer Service Number",
                                  style: TextStyle(
                                    fontSize: 6.0,
                                    color: Colors.white,
                                    fontFamily: "DefaultFontFamily",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    "No card",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: "DefaultFontFamily",
                      letterSpacing: 2.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Bank details",
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: "DefaultFontFamily",
                letterSpacing: 2.0,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            (userController.user[0].accountName != "")
                ? Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userController.user[0].accountNumber,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "DefaultFontFamily",
                            letterSpacing: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          userController.user[0].bankName,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "DefaultFontFamily",
                            letterSpacing: 0.5,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          userController.user[0].accountName,
                          style: TextStyle(
                            fontSize: 15.0,
                            letterSpacing: 2.0,
                            fontFamily: "DefaultFontFamily",
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : Text(
                    "Not uploaded, click update to upload",
                    style: TextStyle(
                      fontSize: 15.0,
                      letterSpacing: 0.5,
                      fontFamily: "DefaultFontFamily",
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              child: GFButton(
                onPressed: () {
                  Get.to(AddCard());
                },
                shape: GFButtonShape.pills,
                child: Text(
                  (userController.user[0].cardHolder != "")
                      ? 'Update'
                      : 'Add New Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: "DefaultFontFamily",
                  ),
                ),
                color: brandOne,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
              child: GFButton(
                onPressed: () {
                  Get.bottomSheet(
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        child: Container(
                          color: Theme.of(context).canvasColor,
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                'Are you sure you want to delete this card?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "DefaultFontFamily",
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //card
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      decoration: BoxDecoration(
                                        color: brandTwo,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 5),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "DefaultFontFamily",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var userHealthUpdate = FirebaseFirestore
                                          .instance
                                          .collection('accounts');
                                      await userHealthUpdate
                                          .doc(userId)
                                          .update({
                                        'card_digit': '',
                                        'card_cvv': '',
                                        'card_expire': '',
                                        'card_holder': '',
                                      }).then((value) {
                                        Get.back();
                                        print(userId);
                                        Get.snackbar(
                                          "deleted!",
                                          'Your card has been deleted successfully',
                                          animationDuration:
                                              Duration(seconds: 1),
                                          backgroundColor: brandOne,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                        );
                                        Get.back();
                                      }).catchError((error) {
                                        Get.snackbar(
                                          "Error",
                                          error.toString(),
                                          animationDuration:
                                              Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      });
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 5),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "DefaultFontFamily",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //card
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                shape: GFButtonShape.pills,
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "DefaultFontFamily",
                    fontSize: 13,
                  ),
                ),
                color: Color(0xFFbf0b13),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
