import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/controller/auth/auth_controller.dart';

import '../../constants/widgets/custom_dialog.dart';

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

String _mssg = "";
bool isChecking = false;
bool canProceed = false;
const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();
String vName = "";
String vNum = "";
bool notLoading = true;

class BvnPage extends ConsumerStatefulWidget {
  const BvnPage({super.key, required this.email});
  final String email;

  @override
  _BvnPageConsumerState createState() => _BvnPageConsumerState();
}

final TextEditingController _bvnController = TextEditingController();
final bvnformKey = GlobalKey<FormState>();

class _BvnPageConsumerState extends ConsumerState<BvnPage> {
  // final UserController userController = Get.find();
  // final WalletController walletController = Get.find();
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
    final appState = ref.watch(authControllerProvider.notifier);
    validateBvn(bvnValue) {
      if (bvnValue.isEmpty) {
        return 'BVN cannot be empty';
      }
      if (bvnValue.length < 11) {
        return 'BVN is invalid';
      }
      if (bvnValue.length > 11) {
        return 'BVN can not be more than 11 digits';
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
      style: GoogleFonts.lato(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      // maxLength: 11,
      decoration: InputDecoration(
        // label: Text(
        //   "11 digits BVN",
        //   style: GoogleFonts.lato(
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        filled: false,
        // fillColor: brandThree,
        // hintText: 'e.g 12345678900',
        contentPadding: const EdgeInsets.all(14),
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: const Color(0xffFAFAFA),
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 27,
            color: colorBlack,
          ),
        ),
        centerTitle: true,
        title: Text(
          'BVN Verification',
          style: GoogleFonts.lato(
            color: colorBlack,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 23.w),
            child: Image.asset(
              'assets/icons/logo_icon.png',
              height: 35.7.h,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/bank_img.png',
                            width: 138.w,
                          ),
                          SizedBox(
                            height: 54.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Enter BVN',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          Text(
                            'Please input your 11-digit BVN number. Verification may require a few minutes.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: const Color(0xff4E4B4B),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          bvn,
                          SizedBox(
                            height: 23.h,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 14,
                                  color: Color(0xff4E4B4B),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'Please confirm number before proceeding',
                                  softWrap: true,
                                  style: GoogleFonts.lato(
                                    color: const Color(0xff828282),
                                    fontSize: 10,
                                    // fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 120.h,
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
                                      backgroundColor: brandTwo,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (bvnformKey.currentState!.validate()) {
                                        // verifyBVN();
                                        appState.verifyBVN(
                                            context,
                                            _bvnController.text.trim(),
                                            widget.email);
                                      } else {
                                        customErrorDialog(
                                            context,
                                            'Invalid! :)',
                                            'Please fill the form properly to proceed');
                                      }
                                    },
                                    child: Text(
                                      'Verify',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}
