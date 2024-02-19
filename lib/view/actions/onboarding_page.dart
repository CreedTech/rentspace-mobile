import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:rentspace/view/actions/add_card.dart';

import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:rentspace/view/dashboard/dashboard.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';
import '../home_page.dart';

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

String _IDImage = "";
String _mssg = "";
bool isChecking = false;
bool canProceed = false;
const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();
String vName = "";
String vNum = "";
bool notLoading = true;

class BvnPage extends StatefulWidget {
  const BvnPage({super.key});

  @override
  _BvnPageState createState() => _BvnPageState();
}

final TextEditingController _bvnController = TextEditingController();
final bvnformKey = GlobalKey<FormState>();

class _BvnPageState extends State<BvnPage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final form = intl.NumberFormat.decimalPattern();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'dva';
  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  createNewDVA() async {
    setState(() {
      notLoading = false;
    });
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
    // const String apiUrl = 'https://api-d.squadco.com/virtual-account';
    // const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
    // final response = await http.post(
    //   Uri.parse(apiUrl),
    //   headers: {
    //     'Authorization': 'Bearer $bearerToken',
    //     "Content-Type": "application/json"
    //   },
    //   body: jsonEncode(<String, String>{
    //     "customer_identifier":
    //         "SPACER/${userController.users[0].dvaUsername} ${userController.users[0].firstName} ${userController.users[0].lastName}",
    //     "first_name": "SPACER/ - ${userController.users[0].dvaUsername}",
    //     "last_name": userController.users[0].lastName,
    //     "mobile_num":
    //         "0${userController.users[0].phoneNumber.replaceFirst('+234', '')}",
    //     "email": userController.users[0].email,
    //     "bvn": _bvnController.text.trim().toString(),
    //     "dob": userController.users[0].dateOfBirth,
    //     "address": userController.users[0].residentialAddress,
    //     "gender": userController.users[0].gender
    //   }),
    // );

    // EasyLoading.dismiss();
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> parsedJson = json.decode(response.body);
    //   // var updateLiquidate = FirebaseFirestore.instance.collection('dva');
    //   setState(() {
    //     vNum = parsedJson['data']['virtual_account_number'];
    //     vName = parsedJson['data']['customer_identifier'];
    //   });
    //   await updateLiquidate.add({
    //     'dva_name': vName,
    //     'dva_date': formattedDate,
    //     'dva_number': vNum,
    //     'dva_username': userController.users[0].dvaUsername,
    //   }).then((value) async {
    //     var walletUpdate = FirebaseFirestore.instance.collection('accounts');
    //     await walletUpdate.doc(userId).update({
    //       'has_dva': 'true',
    //       'dva_name': vName,
    //       'dva_number': vNum,
    //       'dva_username': userController.users[0].dvaUsername,
    //       'dva_date': formattedDate,
    //       "activities": FieldValue.arrayUnion(
    //         [
    //           "$formattedDate \nDVA Created",
    //         ],
    //       ),
    //     });
    //     setState(() {
    //       notLoading = true;
    //     });
    //     EasyLoading.dismiss();
    //     if (!context.mounted) return;
    //     Get.bottomSheet(
    //       isDismissible: false,
    //       SizedBox(
    //         height: 400,
    //         child: ClipRRect(
    //           borderRadius: const BorderRadius.only(
    //             topLeft: Radius.circular(30.0),
    //             topRight: Radius.circular(30.0),
    //           ),
    //           child: Container(
    //             color: Theme.of(context).canvasColor,
    //             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 const SizedBox(
    //                   height: 30,
    //                 ),
    //                 // const Icon(
    //                 //   Icons
    //                 //       .check_circle_outline,
    //                 //   color: brandOne,
    //                 //   size: 80,
    //                 // ),
    //                 Image.asset(
    //                   'assets/check.png',
    //                   width: 80,
    //                 ),
    //                 const SizedBox(
    //                   height: 10,
    //                 ),
    //                 Text(
    //                   'Wallet Successfully Created',
    //                   style: GoogleFonts.nunito(
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.w700,
    //                     // fontFamily:
    //                     //     "DefaultFontFamily",
    //                     color: Theme.of(context).primaryColor,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 Text(
    //                   'DVA Name: $vName',
    //                   style: GoogleFonts.nunito(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w500,
    //                     // fontFamily:
    //                     //     "DefaultFontFamily",
    //                     color: Theme.of(context).primaryColor,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 Text(
    //                   'DVA Number: $vNum',
    //                   style: GoogleFonts.nunito(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w500,
    //                     // fontFamily:
    //                     //     "DefaultFontFamily",
    //                     color: Theme.of(context).primaryColor,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 Text(
    //                   'DVA Bank: GTBank',
    //                   style: GoogleFonts.nunito(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.w500,
    //                     // fontFamily:
    //                     //     "DefaultFontFamily",
    //                     color: Theme.of(context).primaryColor,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //                 const SizedBox(
    //                   height: 30,
    //                 ),
    //                 Align(
    //                   alignment: Alignment.bottomCenter,
    //                   child: Container(
    //                     // width: MediaQuery.of(context).size.width * 2,
    //                     alignment: Alignment.center,
    //                     // height: 110.h,
    //                     child: Column(
    //                       children: [
    //                         ElevatedButton(
    //                           style: ElevatedButton.styleFrom(
    //                             minimumSize: const Size(300, 50),
    //                             backgroundColor:
    //                                 Theme.of(context).colorScheme.secondary,
    //                             elevation: 0,
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(
    //                                 10,
    //                               ),
    //                             ),
    //                           ),
    //                           onPressed: () {
    //                             Get.to(const HomePage());
    //                             // for (int i = 0; i < 2; i++) {
    //                             //   Get.to(HomePage());
    //                             // }
    //                           },
    //                           child: Text(
    //                             'Go to HomePage',
    //                             textAlign: TextAlign.center,
    //                             style: GoogleFonts.nunito(
    //                               color: Colors.white,
    //                               fontSize: 16,
    //                               fontWeight: FontWeight.w700,
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 // GFButton(
    //                 //   onPressed: () {
    //                 //     Get.to(
    //                 //         HomePage());
    //                 //     // for (int i = 0; i < 2; i++) {
    //                 //     //   Get.to(HomePage());
    //                 //     // }
    //                 //   },
    //                 //   icon: const Icon(
    //                 //     Icons
    //                 //         .arrow_right_outlined,
    //                 //     size: 30,
    //                 //     color:
    //                 //         Colors.white,
    //                 //   ),
    //                 //   color: brandOne,
    //                 //   text: "Done",
    //                 //   shape: GFButtonShape
    //                 //       .pills,
    //                 //   fullWidthButton:
    //                 //       true,
    //                 // ),

    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   }).catchError((error) {

    //     setState(() {
    //       notLoading = true;
    //     });
    //     EasyLoading.dismiss();
    //     customErrorDialog(
    //         context, "Oops", "Something went wrong, try again later");

    //   });
    // } else {
    //   setState(() {
    //     notLoading = true;
    //   });
    //   EasyLoading.dismiss();
    //   if (!context.mounted) return;
    //   customErrorDialog(context, "Error!", "Something went wrong");

    //   print(
    //       'Request failed with status: ${response.statusCode}, ${response.body}');
    // }
  }

  bvnDebit() async {
    // var walletUpdate = FirebaseFirestore.instance.collection('accounts');

    // await walletUpdate.doc(userId).update({
    //   'wallet_balance':
    //       (walletController.wallet[0].wallet.mainBalance - 45).toString(),
    //   "activities": FieldValue.arrayUnion(
    //     [
    //       "$formattedDate\nBVN verification\nPaid ₦45",
    //     ],
    //   ),
    // }).then((value) async {
    //   var bvnUpdate = FirebaseFirestore.instance.collection('bvn_debit');
    //   await bvnUpdate.add({
    //     'user_id': userController.users[0].rentspaceID,
    //     'id': userController.users[0].id,
    //     'amount': "35",
    //     'charge': '10',
    //     'type': "BVN verification",
    //     'transaction_id': getRandom(8),
    //     'date': formattedDate,
    //   });
    // });
  }

  verifyBVN() async {
    setState(() {
      isChecking = true;
    });
    const String apiUrl = "https://api.watupay.com/v1/verify";
    const String bearerToken = "WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "channel": "bvn-data",
        "bvn": _bvnController.text.trim().toString(),
      }),
    );

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final fullName = jsonResponse['data']["first_name"] +
          " " +
          jsonResponse['data']["last_name"] +
          " " +
          jsonResponse['data']["middle_name"];
      final phoneNumber = jsonResponse['data']["mobile"];
      if (phoneNumber != "") {
        await bvnDebit();
        await createNewDVA();
      }
      setState(() {
        isChecking = false;
        canProceed = true;
        _mssg = fullName;
      });
      print(fullName);
    } else {
      // Error handling
      setState(() {
        isChecking = false;
        canProceed = false;
        _mssg = "Invalid BVN";
      });
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _mssg = "";
    });
    _bvnController.clear();
  }

  @override
  Widget build(BuildContext context) {
    validateBvn(bvnValue) {
      if (bvnValue.isEmpty) {
        return 'BVN cannot be empty';
      }
      if (bvnValue.length < 11) {
        return 'BVN is invalid';
      }
      if (int.tryParse(bvnValue) == null) {
        return 'enter valid BVN';
      }
      return null;
    }

    //Phone number
    final bvn = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _bvnController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateBvn,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "11 digits BVN",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        filled: false,
        // fillColor: brandThree,
        hintText: 'e.g 12345678900',
        contentPadding: const EdgeInsets.all(14),
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
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
        centerTitle: true,
        title: Text(
          'BVN Details',
          style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                (isChecking)
                    ? const LinearProgressIndicator(
                        color: brandOne,
                        minHeight: 4,
                      )
                    : const SizedBox(),
                // const SizedBox(
                //   height: 100,
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Form(
                    key: bvnformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(
                        //   height: 50,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            'Enter BVN',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        bvn,
                        Text(
                          _mssg,
                          style: GoogleFonts.nunito(
                            color: brandOne,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "This BVN verification will attract a charge of ₦45 from your SpaceWallet",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 120,
                        ),
                        (canProceed)
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 2,
                                  alignment: Alignment.center,
                                  // height: 110.h,
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(400, 50),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (bvnformKey.currentState!
                                              .validate()) {
                                            showTopSnackBar(
                                              Overlay.of(context),
                                              CustomSnackBar.success(
                                                backgroundColor: brandOne,
                                                message:
                                                    'Your BVN has been verified successfully!!',
                                                textStyle: GoogleFonts.nunito(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            );
                                            Get.to(Dashboard());
                                            // Get.to(KycPage(
                                            //   bvnValue:
                                            //       _bvnController.text.trim(),
                                            // ));
                                          } else {
                                            customErrorDialog(
                                                context,
                                                'Invalid! :)',
                                                'Please fill the form properly to proceed');
                                          }
                                        },
                                        child: const Text(
                                          'Proceed',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 2,
                                  alignment: Alignment.center,
                                  // height: 110.h,
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(400, 50),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (walletController.wallet[0]
                                                  .mainBalance >=
                                              45) {
                                            if (bvnformKey.currentState!
                                                .validate()) {
                                              verifyBVN();
                                            } else {
                                              customErrorDialog(
                                                  context,
                                                  'Invalid! :)',
                                                  'Please fill the form properly to proceed');
                                            }
                                          } else {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      AlertDialog.adaptive(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                30, 30, 30, 20),
                                                        elevation: 0,
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        scrollable: true,
                                                        title: null,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    30),
                                                            topRight:
                                                                Radius.circular(
                                                                    30),
                                                          ),
                                                        ),
                                                        content: SizedBox(
                                                          child: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                15),
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topCenter,
                                                                          child:
                                                                              Text(
                                                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              color: brandTwo,
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(3),
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Get.back();
                                                                                  Get.to(const FundWallet());
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                                  textStyle: const TextStyle(color: brandFour, fontSize: 13),
                                                                                ),
                                                                                child: const Text(
                                                                                  "Fund Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                });
                                          }
                                        },
                                        child: const Text(
                                          'Verify BVN',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
