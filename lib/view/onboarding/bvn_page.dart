import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/controller/auth/auth_controller.dart';

import '../../widgets/custom_dialogs/index.dart';

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

bool isChecking = false;
bool canProceed = false;
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
  final form = intl.NumberFormat.decimalPattern();

  @override
  initState() {
    super.initState();
    canProceed = false;
    setState(() {});
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
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _bvnController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateBvn,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      // maxLength: 11,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
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
            width: 1.0,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 27,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        title: Text(
          'BVN Verification',
          style: GoogleFonts.lato(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Form(
                      key: bvnformKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 95.h,
                          ),
                          Image.asset(
                            'assets/bank_img.png',
                            width: 138.w,
                          ),
                          SizedBox(
                            height: 44.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Enter BVN',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Please input your 11-digit BVN number. Verification may require a few minutes.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Theme.of(context).primaryColorLight,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Bvn',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              bvn,
                            ],
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 24,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'Please confirm number before proceeding',
                                  softWrap: true,
                                  style: GoogleFonts.lato(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width -
                                              50,
                                          50),
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
