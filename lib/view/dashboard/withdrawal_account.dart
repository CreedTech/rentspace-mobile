import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';

import '../../constants/colors.dart';
import '../../controller/auth/user_controller.dart';

class WithdrawalAccount extends StatefulWidget {
  const WithdrawalAccount({super.key});

  @override
  State<WithdrawalAccount> createState() => _WithdrawalAccountState();
}

class _WithdrawalAccountState extends State<WithdrawalAccount> {
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final UserController userController = Get.find();
  final withdrawalAccFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bankController.text = userController
        .userModel!.userDetails![0].withdrawalAccount!.bankName
        .toUpperCase();
    _accountNumberController.text = userController
        .userModel!.userDetails![0].withdrawalAccount!.accountNumber;
  }

  @override
  Widget build(BuildContext context) {
    final accountNumber = TextFormField(
      readOnly: true,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      controller: _accountNumberController,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        //prefix: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromRGBO(189, 189, 189, 30)
                  : const Color.fromRGBO(189, 189, 189, 100),
              width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 1.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        // enabled: false,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 27,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Withdrawal Account',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.h,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: withdrawalAccFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Opacity(
                              opacity: 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 3.w),
                                    child: Text(
                                      'Bank',
                                      style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                  TextFormField(
                                    // enabled: false,
                                    readOnly: true,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    enableSuggestions: true,
                                    cursorColor:
                                        Theme.of(context).colorScheme.primary,
                                    style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14),

                                    controller: _bankController,
                                    textAlignVertical: TextAlignVertical.center,
                                    // textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? const Color.fromRGBO(
                                                  189, 189, 189, 30)
                                              : const Color.fromRGBO(
                                                  189, 189, 189, 100),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? const Color.fromRGBO(
                                                        189, 189, 189, 30)
                                                    : const Color.fromRGBO(
                                                        189, 189, 189, 100),
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? const Color.fromRGBO(
                                                  189, 189, 189, 30)
                                              : const Color.fromRGBO(
                                                  189, 189, 189, 100),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red,
                                            width:
                                                2.0), // Change color to yellow
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 12),
                                        child: Image.asset(
                                          'assets/icons/bank_icon.png',
                                          width: 26,
                                          // Ensure the image fits inside the circle
                                        ),
                                      ),
                                      filled: false,
                                      fillColor: Colors.transparent,
                                      contentPadding: const EdgeInsets.all(14),
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Opacity(
                              opacity: 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 3.w),
                                    child: Text(
                                      'Account Number',
                                      style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                  accountNumber
                                ],
                              ),
                            ),
                            Opacity(
                              opacity: 0.6,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEEF8FF),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    userController.userModel!.userDetails![0]
                                        .withdrawalAccount!.accountHolderName,
                                    style: GoogleFonts.lato(
                                      color: brandOne,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 55,
                        ),
                        GestureDetector(
                          onTap: () {
                            customErrorDialog(context, 'Contact Support!',
                                'Please contact support on email support@rentspace.tech to change your withdrawal account');
                          },
                          child: Text(
                            'Change Account',
                            style: GoogleFonts.lato(
                                color: brandTwo,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
