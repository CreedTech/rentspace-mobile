import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:rentspace/controller/app_controller.dart';
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

class BvnPage extends ConsumerStatefulWidget {
  const BvnPage({super.key});

  @override
  _BvnPageConsumerState createState() => _BvnPageConsumerState();
}

final TextEditingController _bvnController = TextEditingController();
final bvnformKey = GlobalKey<FormState>();

class _BvnPageConsumerState extends ConsumerState<BvnPage> {
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

  // bvnDebit() async {
  //   // var walletUpdate = FirebaseFirestore.instance.collection('accounts');

  //   // await walletUpdate.doc(userId).update({
  //   //   'wallet_balance':
  //   //       (walletController.wallet[0].wallet.mainBalance - 45).toString(),
  //   //   "activities": FieldValue.arrayUnion(
  //   //     [
  //   //       "$formattedDate\nBVN verification\nPaid ₦45",
  //   //     ],
  //   //   ),
  //   // }).then((value) async {
  //   //   var bvnUpdate = FirebaseFirestore.instance.collection('bvn_debit');
  //   //   await bvnUpdate.add({
  //   //     'user_id': userController.users[0].rentspaceID,
  //   //     'id': userController.users[0].id,
  //   //     'amount': "35",
  //   //     'charge': '10',
  //   //     'type': "BVN verification",
  //   //     'transaction_id': getRandom(8),
  //   //     'date': formattedDate,
  //   //   });
  //   // });
  // }

  // verifyBVN() async {
  //   setState(() {
  //     isChecking = true;
  //   });
  //   const String apiUrl = "https://api.watupay.com/v1/verify";
  //   const String bearerToken = "WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683";
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken',
  //       "Content-Type": "application/json"
  //     },
  //     body: jsonEncode(<String, String>{
  //       "channel": "bvn-data",
  //       "bvn": _bvnController.text.trim().toString(),
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     // Request successful, handle the response data
  //     final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     final fullName = jsonResponse['data']["first_name"] +
  //         " " +
  //         jsonResponse['data']["last_name"] +
  //         " " +
  //         jsonResponse['data']["middle_name"];
  //     final phoneNumber = jsonResponse['data']["mobile"];
  //     if (phoneNumber != "") {
  //       await bvnDebit();
  //       // await createNewDVA();
  //     }
  //     setState(() {
  //       isChecking = false;
  //       canProceed = true;
  //       _mssg = fullName;
  //     });
  //     print(fullName);
  //   } else {
  //     _mssg = response.body;
  //     // Error handling
  //     setState(() {
  //       isChecking = false;
  //       canProceed = false;
  //       _mssg = "Invalid BVN";
  //     });
  //     print(
  //         'Request failed with status: ${response.statusCode}, ${response.body}');
  //   }
  // }

  @override
  initState() {
    super.initState();
    canProceed = false;
    // isChecking = false;
    setState(() {
      _mssg = "";
    });
  }

  @override
  dispose() {
    super.dispose();
    _bvnController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appControllerProvider.notifier);
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
                        Align(
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
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (walletController.walletModel!.wallet![0]
                                            .mainBalance >=
                                        45) {
                                      if (bvnformKey.currentState!.validate()) {
                                        // verifyBVN();
                                        appState.verifyBVN(context,
                                            _bvnController.text.trim());
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
                                          builder: (BuildContext context) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                AlertDialog(
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 30, 30, 20),
                                                  elevation: 0,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  insetPadding:
                                                      const EdgeInsets.all(0),
                                                  scrollable: true,
                                                  title: null,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30),
                                                    ),
                                                  ),
                                                  content: SizedBox(
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
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
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    child: Text(
                                                                      'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .nunito(
                                                                        color:
                                                                            brandOne,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Get.back();
                                                                            Get.to(const FundWallet());
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Theme.of(context).colorScheme.secondary,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                                                            textStyle:
                                                                                const TextStyle(color: brandFour, fontSize: 13),
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            "Fund Wallet",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
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

                        // (canProceed)
                        //     ? Align(
                        //         alignment: Alignment.bottomCenter,
                        //         child: Container(
                        //           // width: MediaQuery.of(context).size.width * 2,
                        //           alignment: Alignment.center,
                        //           // height: 110.h,
                        //           child: Column(
                        //             children: [
                        //               ElevatedButton(
                        //                 style: ElevatedButton.styleFrom(
                        //                   minimumSize: const Size(400, 50),
                        //                   backgroundColor: Theme.of(context)
                        //                       .colorScheme
                        //                       .secondary,
                        //                   elevation: 0,
                        //                   shape: RoundedRectangleBorder(
                        //                     borderRadius: BorderRadius.circular(
                        //                       10,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 onPressed: () {
                        //                   if (bvnformKey.currentState!
                        //                       .validate()) {
                        //                     showTopSnackBar(
                        //                       Overlay.of(context),
                        //                       CustomSnackBar.success(
                        //                         backgroundColor: brandOne,
                        //                         message:
                        //                             'Your BVN has been verified successfully!!',
                        //                         textStyle: GoogleFonts.nunito(
                        //                           fontSize: 14,
                        //                           color: Colors.white,
                        //                           fontWeight: FontWeight.w700,
                        //                         ),
                        //                       ),
                        //                     );
                        //                     Get.to(Dashboard());
                        //                     // Get.to(KycPage(
                        //                     //   bvnValue:
                        //                     //       _bvnController.text.trim(),
                        //                     // ));
                        //                   } else {
                        //                     customErrorDialog(
                        //                         context,
                        //                         'Invalid! :)',
                        //                         'Please fill the form properly to proceed');
                        //                   }
                        //                 },
                        //                 child: const Text(
                        //                   'Proceed',
                        //                   textAlign: TextAlign.center,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     :

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
