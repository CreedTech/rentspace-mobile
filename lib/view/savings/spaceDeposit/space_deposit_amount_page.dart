import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:rentspace/view/savings/spaceDeposit/space_deposit_interval_page.dart';
import 'package:typewritertext/typewritertext.dart';

import '../../../constants/colors.dart';

class SpaceDepositAmountPage extends StatefulWidget {
  const SpaceDepositAmountPage({super.key, required this.name});
  final String name;

  @override
  State<SpaceDepositAmountPage> createState() => _SpaceDepositAmountPageState();
}

class _SpaceDepositAmountPageState extends State<SpaceDepositAmountPage> {
  final TextEditingController _depositAmountController =
      TextEditingController();
  final GlobalKey<FormState> nameformKey = GlobalKey<FormState>();
  bool showNextText = false;
  bool showForm = false;
  bool showNameText = false;
  void _startTypingAnimation() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        // _startNextAnimation();
        setState(
          () {
            showNextText = true;
          },
        );
      },
    )
        .then(
          (value) => Future.delayed(
            const Duration(seconds: 2),
            () {
              // _startNextAnimation();
              setState(() {
                showNameText = true;
              });
            },
          ),
        )
        .then(
          (value) => Future.delayed(
            const Duration(seconds: 4),
            () {
              // _startNextAnimation();
              setState(() {
                showForm = true;
              });
            },
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  @override
  Widget build(BuildContext context) {
    //validation function
    validateAmount(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if ((int.tryParse(text.replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.replaceAll(',', ''))! < 500)) {
        return 'minimum amount is ₦500';
      }
      if (int.tryParse(text.replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(text.replaceAll(',', '')) == 0) {
        return 'number cannot be zero';
      }
      if (int.tryParse(text.replaceAll(',', ''))!.isNegative) {
        return 'enter positive number';
      }
      return null;
    }

    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _depositAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      style: GoogleFonts.lato(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        label: Text(
          "Target Amount",
          style: GoogleFonts.lato(
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Amount in Naira',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        prefix: Text(
          "₦ ",
          style: GoogleFonts.lato(
            fontSize: 15,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            // resetCalculator();
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypeWriterText.builder(
                    "Nice Start...",
                    repeat: false,
                    builder: (context, value) {
                      return AutoSizeText(
                        value,
                        maxLines: 2,
                        minFontSize: 2.0,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                    duration: const Duration(milliseconds: 50),
                  ),
                  (showNextText == true)
                      ? TypeWriterText.builder(
                          "Let's take a look at your desired amount",
                          repeat: false,
                          builder: (context, value) {
                            return AutoSizeText(
                              value,
                              maxLines: 2,
                              minFontSize: 2.0,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 50),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 70.h,
                  ),
                  (showNameText == true)
                      ? TypeWriterText.builder(
                          "What is the total amount you aim to save by the end of your target?",
                          repeat: false,
                          builder: (context, value) {
                            return AutoSizeText(
                              value,
                              maxLines: 2,
                              minFontSize: 2.0,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 50),
                        )
                      : const SizedBox(),
                  (showForm == true)
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: nameformKey,
                              child: amount,
                            ),
                            SizedBox(
                              height: 70.h,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(300, 50),
                                  maximumSize: const Size(400, 50),
                                  backgroundColor: brandOne,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (nameformKey.currentState!.validate()) {
                                    Get.to(
                                      SpaceDepositIntervalPage(
                                        name: widget.name,
                                        amount: _depositAmountController.text
                                            .trim()
                                            .replaceAll(',', ''),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Next",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
