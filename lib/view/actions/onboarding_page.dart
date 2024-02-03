import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/actions/add_card.dart';

import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
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
    const String apiUrl = 'https://api-d.squadco.com/virtual-account';
    const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "customer_identifier":
            "SPACER/${userController.user[0].dvaUsername} ${userController.user[0].userFirst} ${userController.user[0].userLast}",
        "first_name": "SPACER/ - ${userController.user[0].dvaUsername}",
        "last_name": userController.user[0].userLast,
        "mobile_num":
            "0${userController.user[0].userPhone.replaceFirst('+234', '')}",
        "email": userController.user[0].email,
        "bvn": _bvnController.text.trim().toString(),
        "dob": userController.user[0].date_of_birth!,
        "address": userController.user[0].address,
        "gender": userController.user[0].gender!
      }),
    );
    // EasyLoading.dismiss();
    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      var updateLiquidate = FirebaseFirestore.instance.collection('dva');
      setState(() {
        vNum = parsedJson['data']['virtual_account_number'];
        vName = parsedJson['data']['customer_identifier'];
      });
      await updateLiquidate.add({
        'dva_name': vName,
        'dva_date': formattedDate,
        'dva_number': vNum,
        'dva_username': userController.user[0].dvaUsername,
      }).then((value) async {
        var walletUpdate = FirebaseFirestore.instance.collection('accounts');
        await walletUpdate.doc(userId).update({
          'has_dva': 'true',
          'dva_name': vName,
          'dva_number': vNum,
          'dva_username': userController.user[0].dvaUsername,
          'dva_date': formattedDate,
          "activities": FieldValue.arrayUnion(
            [
              "$formattedDate \nDVA Created",
            ],
          ),
        });
        setState(() {
          notLoading = true;
        });
        EasyLoading.dismiss();
        if (!context.mounted) return;
        Get.bottomSheet(
          isDismissible: false,
          SizedBox(
            height: 400,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                color: Theme.of(context).canvasColor,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    // const Icon(
                    //   Icons
                    //       .check_circle_outline,
                    //   color: brandOne,
                    //   size: 80,
                    // ),
                    Image.asset(
                      'assets/check.png',
                      width: 80,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Wallet Successfully Created',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        // fontFamily:
                        //     "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'DVA Name: $vName',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // fontFamily:
                        //     "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'DVA Number: $vNum',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // fontFamily:
                        //     "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'DVA Bank: GTBank',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // fontFamily:
                        //     "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
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
                                minimumSize: const Size(300, 50),
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
                                Get.to(const HomePage());
                                // for (int i = 0; i < 2; i++) {
                                //   Get.to(HomePage());
                                // }
                              },
                              child: Text(
                                'Go to HomePage',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // GFButton(
                    //   onPressed: () {
                    //     Get.to(
                    //         HomePage());
                    //     // for (int i = 0; i < 2; i++) {
                    //     //   Get.to(HomePage());
                    //     // }
                    //   },
                    //   icon: const Icon(
                    //     Icons
                    //         .arrow_right_outlined,
                    //     size: 30,
                    //     color:
                    //         Colors.white,
                    //   ),
                    //   color: brandOne,
                    //   text: "Done",
                    //   shape: GFButtonShape
                    //       .pills,
                    //   fullWidthButton:
                    //       true,
                    // ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).catchError((error) {
        setState(() {
          notLoading = true;
        });
        EasyLoading.dismiss();
        customErrorDialog(
            context, "Oops", "Something went wrong, try again later");
        // Get.snackbar(
        //   "Oops",
        //   "Something went wrong, try again later",
        //   animationDuration: const Duration(seconds: 2),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      });
    } else {
      setState(() {
        notLoading = true;
      });
      EasyLoading.dismiss();
      if (!context.mounted) return;
      customErrorDialog(context, "Error!", "Something went wrong");
      // Get.snackbar(
      //   "Error!",
      //   "something went wrong",
      //   animationDuration: const Duration(seconds: 1),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  bvnDebit() async {
    var walletUpdate = FirebaseFirestore.instance.collection('accounts');

    await walletUpdate.doc(userId).update({
      'wallet_balance':
          (((int.tryParse(userController.user[0].userWalletBalance))!) - 45)
              .toString(),
      "activities": FieldValue.arrayUnion(
        [
          "$formattedDate\nBVN verification\nPaid ₦45",
        ],
      ),
    }).then((value) async {
      var bvnUpdate = FirebaseFirestore.instance.collection('bvn_debit');
      await bvnUpdate.add({
        'user_id': userController.user[0].rentspaceID,
        'id': userController.user[0].id,
        'amount': "35",
        'charge': '10',
        'type': "BVN verification",
        'transaction_id': getRandom(8),
        'date': formattedDate,
      });
    });
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
                                            Get.to(KycPage(
                                              bvnValue:
                                                  _bvnController.text.trim(),
                                            ));
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
                                          if ((int.tryParse(userController
                                                  .user[0]
                                                  .userWalletBalance)!) >=
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

class KycPage extends StatefulWidget {
  String bvnValue;
  KycPage({super.key, required this.bvnValue});

  @override
  _KycPageState createState() => _KycPageState();
}

final TextEditingController _kycController = TextEditingController();
final TextEditingController kycController = TextEditingController();
final _kycformKey = GlobalKey<FormState>();
bool _isUploading = false;

List<String> item = const <String>[
  'NIN',
  'Driver\'s Liscense',
  'Passport Photograph',
  'Voters Card',
  // 'Friends',
];

class _KycPageState extends State<KycPage> {
//upload image
  File? selectedImage;
  PlatformFile? _platformFile;
  Future selectFile(context) async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (file != null) {
      setState(() {
        selectedImage = File(file.files.single.path!);
        _platformFile = file.files.first;
      });
      uploadImg(context);
    }
  }

  Future uploadImg(context) async {
    setState(() {
      _isUploading = true;
    });
    var userIdUpdate = FirebaseFirestore.instance.collection('accounts');
    print('userIdUpdate');
    print(userIdUpdate);

    FirebaseStorage storage = FirebaseStorage.instance;
    print('storage');
    print(storage);
    String fileName = p.basename(selectedImage!.path);
    print('fileName');
    print(fileName);
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(selectedImage!);
    var downloadURL =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    var url = downloadURL.toString();
    await userIdUpdate.doc(userId).update({
      'id_card': url,
    }).then((value) {
      setState(() {
        _IDImage = url.toString();
        _isUploading = false;
      });

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Your ID card image has been uploaded successfully!!',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }).catchError((error) {
      print(error.toString());
      customErrorDialog(context, 'Error', error.toString());
    });
  }

  //Phone number
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kyc = TextFormField(
      enableSuggestions: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).primaryColor,
      controller: _kycController,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        // label: Text(
        //   "KYC : residential address",
        //   style: GoogleFonts.nunito(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
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
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        fillColor: brandThree,
        hintText: 'Enter your KYC : residential address...',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      minLines: 3,
      maxLines: 5,
      maxLength: 200,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Address cannot be empty cannot be empty';
        }

        return null;
      },
    );

// final kyc_select_dropdown = DropdownButtonFormField(items: items, onChanged: onChanged)
    return ModalProgressHUD(
      inAsyncCall: _isUploading,
      progressIndicator: const Center(
        child: CustomLoader(),
      ),
      child: Scaffold(
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
            'KYC Details',
            style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _kycformKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 12,
                              ),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Select Your ID verification Type',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            CustomDropdown(
                              selectedStyle:
                                  GoogleFonts.nunito(color: brandOne),
                              hintText: 'Select an option?',
                              fillColor: brandThree,
                              items: item,
                              controller: kycController,
                              fieldSuffixIcon: Icon(
                                Iconsax.arrow_down5,
                                size: 25.h,
                                color: brandOne,
                              ),
                              onChanged: (String val) {
                                print(val);
                              },
                            ),
                            // kyc,
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),

                      Text(
                        "Provide your national identity information. Make sure your face is properly shown on the ID card. Image upload dimension should be 800px x 500px.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AlertDialog.adaptive(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          30, 30, 30, 20),
                                      elevation: 0,
                                      alignment: Alignment.bottomCenter,
                                      insetPadding: const EdgeInsets.all(0),
                                      scrollable: true,
                                      title: null,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                      ),
                                      content: SizedBox(
                                        child: SizedBox(
                                          width: 400.w,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 40.h),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15.h),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Text(
                                                          'Upload Valid Id Card',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            color: brandOne,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                selectFile(
                                                                    context);
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                minimumSize:
                                                                    const Size(
                                                                        200,
                                                                        50),
                                                                maximumSize:
                                                                    const Size(
                                                                        200,
                                                                        50),
                                                                backgroundColor:
                                                                    brandOne,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            brandFour,
                                                                        fontSize:
                                                                            13),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(
                                                                    Iconsax
                                                                        .folder_open,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    "Open File",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12.sp,
                                                                    ),
                                                                  ),
                                                                ],
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

                          // showDialog(context: context, builder: (_){

                          // });
                        },
                        child: selectedImage == null
                            ? DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                color: Theme.of(context).colorScheme.secondary,
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Icon(
                                        Iconsax.folder_open,
                                        color: Theme.of(context).colorScheme.secondary,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Select You File [ jpg, png, jpeg ]",
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected File',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: const Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 2,
                                              )
                                            ]),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  selectedImage!,
                                                  width: 70,
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _platformFile!.name,
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${(_platformFile!.size / 1024).ceil()} KB',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      // selectedImage != null
                      //     ? Container(
                      //         padding: const EdgeInsets.all(20),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'Selected File',
                      //               style: TextStyle(
                      //                 color: Colors.grey.shade400,
                      //                 fontSize: 15,
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 10,
                      //             ),
                      //             Container(
                      //                 padding: const EdgeInsets.all(8),
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   color: Colors.white,
                      //                   boxShadow: [
                      //                     BoxShadow(
                      //                       color: Colors.grey.shade200,
                      //                       offset: const Offset(0, 1),
                      //                       blurRadius: 3,
                      //                       spreadRadius: 2,
                      //                     )
                      //                   ],
                      //                 ),
                      //                 child: Row(
                      //                   children: [
                      //                     ClipRRect(
                      //                         borderRadius:
                      //                             BorderRadius.circular(8),
                      //                         child: Image.file(
                      //                           selectedImage!,
                      //                           width: 70,
                      //                         )),
                      //                     const SizedBox(
                      //                       width: 10,
                      //                     ),
                      //                     Expanded(
                      //                       child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Text(
                      //                             _platformFile!.name,
                      //                             style: GoogleFonts.nunito(
                      //                               fontSize: 13,
                      //                               color: Colors.grey.shade800,
                      //                             ),
                      //                           ),
                      //                           const SizedBox(
                      //                             height: 5,
                      //                           ),
                      //                           Text(
                      //                             '${(_platformFile!.size / 1024).ceil()} KB',
                      //                             style: TextStyle(
                      //                               fontSize: 13,
                      //                               color: Colors.grey.shade800,
                      //                             ),
                      //                           ),
                      //                           const SizedBox(
                      //                             height: 5,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 10,
                      //                     ),
                      //                   ],
                      //                 )),
                      //             const SizedBox(
                      //               height: 20,
                      //             ),
                      //           ],
                      //         ))
                      //     : Container(),
                      // const SizedBox(
                      //   height: 40,
                      // ),

                      // const SizedBox(
                      //   height: 30,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
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
                            if (_kycformKey.currentState!.validate() &&
                                _IDImage != "") {
                              Get.to(BvnAndKycConfirmPage(
                                  bvnValue: widget.bvnValue,
                                  kycValue: _kycController.text.trim(),
                                  idCardValue: _IDImage));
                            } else {
                              customErrorDialog(context, 'Error',
                                  'Please fill in your KYC correctly and upload a valid ID card image to verify.');
                            }
                          },
                          child: const Text(
                            'Next',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BvnAndKycConfirmPage extends StatefulWidget {
  String bvnValue, kycValue, idCardValue;
  BvnAndKycConfirmPage({
    super.key,
    required this.bvnValue,
    required this.kycValue,
    required this.idCardValue,
  });

  @override
  _BvnAndKycConfirmPageState createState() => _BvnAndKycConfirmPageState();
}

final TextEditingController _passwordController = TextEditingController();
final _kycBvnPasswordFormKey = GlobalKey<FormState>();
bool obscurity = true;
Icon lockIcon = LockIcon().open;
String _userPassword = "";
String _cardHolder = "";
String _cardCvv = "";
String _cardExpire = "";
String _cardNumber = "";

class _BvnAndKycConfirmPageState extends State<BvnAndKycConfirmPage> {
  void visibility() {
    if (obscurity == true) {
      setState(() {
        obscurity = false;
        lockIcon = LockIcon().close;
      });
    } else {
      setState(() {
        obscurity = true;
        lockIcon = LockIcon().open;
      });
    }
  }

  getUser() async {
    var collection = FirebaseFirestore.instance.collection('accounts');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        _userPassword = data?['password'];
        _cardCvv = data?['card_cvv'];
        _cardExpire = data?['card_expire'];
        _cardHolder = data?['card_holder'];
        _cardNumber = data?['card_digit'];
      });
    }
  }

  Future verify(context) async {
    var userUpdate = FirebaseFirestore.instance.collection('accounts');

    await userUpdate.doc(userId).update({
      'kyc_details': widget.kycValue,
      'bvn': widget.bvnValue,
      'has_verified_bvn': 'true',
      'id_card': widget.idCardValue,
      'status': 'verified'
    }).then((value) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'BVN & KYC updated !!.',
          textStyle: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AlertDialog.adaptive(
                  contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                  elevation: 0,
                  alignment: Alignment.bottomCenter,
                  insetPadding: const EdgeInsets.all(0),
                  scrollable: true,
                  title: null,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  content: SizedBox(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'Your BVN & KYC has been updated successfully.\n Proceed to add Card',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            Get.to(const AddCard());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 15),
                                            textStyle: const TextStyle(
                                                color: brandFour, fontSize: 13),
                                          ),
                                          child: const Text(
                                            "Proceed",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            for (int i = 0; i < 4; i++) {
                                              Get.back();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 15),
                                            textStyle: const TextStyle(
                                                color: brandFour, fontSize: 13),
                                          ),
                                          child: const Text(
                                            "Dismiss",
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
    }).catchError((error) {
      customErrorDialog(context, 'Error', error.toString());
    });
  }

  //Textform field

  @override
  initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscurity,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
        suffixIconColor: Colors.black,
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Enter Password to Submit',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Input your password';
        }
        return null;
      },
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
          'Confirm Details',
          style: GoogleFonts.nunito(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.3,
          //     child: Image.asset(
          //       'assets/icons/RentSpace-icon.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          ListView(
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            gradientOne,
                            gradientTwo,
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BVN: ${widget.bvnValue}",
                            style: GoogleFonts.nunito(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "KYC: ${widget.kycValue}",
                            style: GoogleFonts.nunito(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5, 0, 5),
                      child: Text(
                        "ID card:",
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //ID Cardvalue
                    Container(
                      decoration: BoxDecoration(
                        color: brandTwo,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                      child: Image.network(
                        widget.idCardValue,
                        height: 200,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Form(
                      key: _kycBvnPasswordFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Enter Password to Submit',
                              style: GoogleFonts.nunito(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          password,
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),

                    Center(
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
                                    // _kycBvnPasswordFormKey
                                    //         .currentState!
                                    //         .validate()
                                    //     ?
                                    Theme.of(context).colorScheme.secondary
                                // : brandThree
                                ,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_kycBvnPasswordFormKey.currentState!
                                        .validate() &&
                                    _userPassword != "" &&
                                    _passwordController.text.trim() ==
                                        _userPassword) {
                                  verify(context);
                                } else {
                                  customErrorDialog(
                                      context,
                                      'Incorrect password! ',
                                      'Please enter the correct password to proceed.');
                                }
                              },
                              child: const Text(
                                'Submit',
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
            ],
          ),
        ],
      ),
    );
  }
}
