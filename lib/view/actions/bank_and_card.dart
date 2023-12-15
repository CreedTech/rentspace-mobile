import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
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
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: brandOne,
            ),
          ),
          title: Text(
            'Bank & Card Details',
            style: GoogleFonts.nunito(
                color: brandOne, fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (userController.user[0].cardHolder != "" ||
                      userController.user[0].accountNumber != "")
                  ? Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Text(
                        //     'Card Details',
                        //     style: GoogleFonts.nunito(
                        //       fontSize: 17,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
                        // ),

                        FlipCard(
                          front: Neumorphic(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(20)),
                                depth: 0,
                                // lightSource: LightSource.topLeft,
                                color: Colors.white),
                            child: Container(
                              height: 220,
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 10.0, 20.0, 0.0),
                              decoration: const BoxDecoration(color: brandOne),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "XXXX XXXX XXXX ${userController.user[0].cardDigit.substring(5, 9)}",
                                            style: GoogleFonts.nunito(
                                              fontSize: 20.0,
                                              // letterSpacing: 2.0,
                                              // fontFamily: "DefaultFontFamily",
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            userController.user[0].cardExpire,
                                            style: GoogleFonts.nunito(
                                              fontSize: 15.0,
                                              // letterSpacing: 2.0,
                                              // fontFamily: "DefaultFontFamily",
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            userController.user[0].cardHolder,
                                            style: GoogleFonts.nunito(
                                              fontSize: 20.0,
                                              // letterSpacing: 2.0,
                                              // fontFamily: "DefaultFontFamily",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            //textAlign: TextAlign.center,
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
                              height: 220,
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 10.0, 0.0, 0.0),
                              decoration: const BoxDecoration(color: brandOne),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 5.0),
                                        child: Text(
                                          "",
                                          style: GoogleFonts.nunito(
                                            fontSize: 14.0,
                                            // fontFamily: "DefaultFontFamily",
                                            //letterSpacing: 1.0,

                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    color: Colors.black,
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40.0, 20.0, 40.0, 5.0),
                                    child: Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 4.0, 5.0, 4.0),
                                      child: Text(
                                        userController.user[0].cardCVV,
                                        style: GoogleFonts.nunito(
                                          fontSize: 14.0,
                                          // fontFamily: "DefaultFontFamily",
                                          //letterSpacing: 1.0,

                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 5.0),
                                    child: Text(
                                      "This card is the property of your Bank Name and is issued to the cardholder subject to the terms and conditions associated with the account. Unauthorized use, duplication, or disclosure of this card is strictly prohibited. If found, please return to your Bank Address. The cardholder is responsible for the safety and security of this card. Any loss, theft, or unauthorized use must be reported immediately to your Bank Customer Service Number",
                                      style: GoogleFonts.nunito(
                                        fontSize: 6.0,
                                        color: Colors.white,
                                        // fontFamily: "DefaultFontFamily",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Bank Details',
                            style: GoogleFonts.nunito(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          decoration: BoxDecoration(
                            color: brandTwo.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userController.user[0].accountName,
                                style: GoogleFonts.nunito(
                                  fontSize: 16.0,
                                  // fontFamily: "DefaultFontFamily",
                                  // letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff828282),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                userController.user[0].bankName,
                                style: GoogleFonts.nunito(
                                  fontSize: 12.0,
                                  // fontFamily: "DefaultFontFamily",
                                  // letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                  color: brandOne,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                userController.user[0].accountNumber,
                                style: GoogleFonts.nunito(
                                  fontSize: 15.0,
                                  // fontFamily: "DefaultFontFamily",
                                  letterSpacing: 0.5,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(350, 50),
                            backgroundColor: brandTwo,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.to(const AddCard());
                          },
                          child: const Text(
                            'Update',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(350, 50),
                            backgroundColor: Colors.red,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            // _doSomething();
                            Get.bottomSheet(
                              SizedBox(
                                height: 250,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                  child: Container(
                                    color: Theme.of(context).canvasColor,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Text(
                                          'Are you sure you want to delete this card?',
                                          style: GoogleFonts.nunito(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            // fontFamily: "DefaultFontFamily",
                                            color: brandOne,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        //card
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  var userHealthUpdate =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'accounts');
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
                                                          const Duration(
                                                              seconds: 1),
                                                      backgroundColor: brandOne,
                                                      colorText: Colors.white,
                                                      snackPosition:
                                                          SnackPosition.TOP,
                                                    );
                                                    Get.back();
                                                  }).catchError((error) {
                                                    Get.snackbar(
                                                      "Error",
                                                      error.toString(),
                                                      animationDuration:
                                                          const Duration(
                                                              seconds: 2),
                                                      backgroundColor:
                                                          Colors.red,
                                                      colorText: Colors.white,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                    );
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 40,
                                                      vertical: 15),
                                                  textStyle: const TextStyle(
                                                      color: brandFour,
                                                      fontSize: 13),
                                                ),
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // InkWell(
                                            //   onTap: () async {
                                            //     var userHealthUpdate =
                                            //         FirebaseFirestore.instance
                                            //             .collection('accounts');
                                            //     await userHealthUpdate
                                            //         .doc(userId)
                                            //         .update({
                                            //       'card_digit': '',
                                            //       'card_cvv': '',
                                            //       'card_expire': '',
                                            //       'card_holder': '',
                                            //     }).then((value) {
                                            //       Get.back();
                                            //       print(userId);
                                            //       Get.snackbar(
                                            //         "deleted!",
                                            //         'Your card has been deleted successfully',
                                            //         animationDuration:
                                            //             const Duration(
                                            //                 seconds: 1),
                                            //         backgroundColor: brandOne,
                                            //         colorText: Colors.white,
                                            //         snackPosition:
                                            //             SnackPosition.TOP,
                                            //       );
                                            //       Get.back();
                                            //     }).catchError((error) {
                                            //       Get.snackbar(
                                            //         "Error",
                                            //         error.toString(),
                                            //         animationDuration:
                                            //             const Duration(
                                            //                 seconds: 2),
                                            //         backgroundColor: Colors.red,
                                            //         colorText: Colors.white,
                                            //         snackPosition:
                                            //             SnackPosition.BOTTOM,
                                            //       );
                                            //     });
                                            //   },
                                            //   child: Container(
                                            //     width: MediaQuery.of(context)
                                            //             .size
                                            //             .width /
                                            //         4,
                                            //     decoration: BoxDecoration(
                                            //       color: Colors.red,
                                            //       borderRadius:
                                            //           BorderRadius.circular(20),
                                            //     ),
                                            //     padding:
                                            //         const EdgeInsets.fromLTRB(
                                            //             20, 5, 20, 5),
                                            //     child: const Text(
                                            //       'Yes',
                                            //       style: TextStyle(
                                            //         fontSize: 12,
                                            //         fontFamily:
                                            //             "DefaultFontFamily",
                                            //         color: Colors.white,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),

                                            const SizedBox(
                                              width: 20,
                                            ),
                                            // InkWell(
                                            //   onTap: () {
                                            //     Get.back();
                                            //   },
                                            //   child: Container(
                                            //     width: MediaQuery.of(context)
                                            //             .size
                                            //             .width /
                                            //         4,
                                            //     decoration: BoxDecoration(
                                            //       color: brandTwo,
                                            //       borderRadius:
                                            //           BorderRadius.circular(20),
                                            //     ),
                                            //     padding:
                                            //         const EdgeInsets.fromLTRB(
                                            //             20, 5, 20, 5),
                                            //     child: const Text(
                                            //       'No',
                                            //       style: TextStyle(
                                            //         fontSize: 12,
                                            //         fontFamily:
                                            //             "DefaultFontFamily",
                                            //         color: Colors.white,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: brandTwo,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 40,
                                                      vertical: 15),
                                                  textStyle: const TextStyle(
                                                      color: brandFour,
                                                      fontSize: 13),
                                                ),
                                                child: const Text(
                                                  "No",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
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
                          child: const Text(
                            'Delete',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        children: [
                          Image.asset('assets/card_empty.png'),
                          Text(
                            'No Bank Details Or Card Details Added Yet',
                            style: GoogleFonts.nunito(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 50),
                              backgroundColor: brandTwo,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Get.to(const AddCard());
                            },
                            child: const Text(
                              'Add Details',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
