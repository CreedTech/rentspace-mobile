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

import 'package:rentspace/controller/app_controller.dart';

import 'dart:math';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/controller/auth/auth_controller.dart';
import 'dart:async';

import '../../constants/widgets/custom_dialog.dart';

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
  const BvnPage({super.key,required this.email});
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
                                    FocusScope.of(context).unfocus();
                                    if (bvnformKey.currentState!.validate()) {
                                      // verifyBVN();
                                      appState.verifyBVN(
                                          context,
                                          _bvnController.text.trim(),
                                          widget.email);
                                    } else {
                                      customErrorDialog(context, 'Invalid! :)',
                                          'Please fill the form properly to proceed');
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
