import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/savings/spaceDeposit/space_deposit_amount_page.dart';
import 'package:typewritertext/typewritertext.dart';

import '../../../constants/colors.dart';

class SpaceDepositNamePage extends StatefulWidget {
  const SpaceDepositNamePage({super.key});

  @override
  State<SpaceDepositNamePage> createState() => _SpaceDepositNamePageState();
}

class _SpaceDepositNamePageState extends State<SpaceDepositNamePage> {
  final TextEditingController _planNameController = TextEditingController();
  final GlobalKey<FormState> nameformKey = GlobalKey<FormState>();
  bool showNextText = false;
  bool showForm = false;
  bool showNameText = false;
  // bool isTextFieldFocused = false;
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
            const Duration(seconds: 4),
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
    validateName(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }

      return null;
    }

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
                    "Hey Spacer",
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
                          "Let's get you started by getting informations about your target...",
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
                          "What is the depositing for?",
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
                              child: TextFormField(
                                enableSuggestions: true,
                                cursorColor: Theme.of(context).primaryColor,
                                controller: _planNameController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: validateName,
                                // update the state variable when the text changes
                                // onChanged: (text) => setState(() => _nameValue = text),
                                style: GoogleFonts.lato(
                                  color: Theme.of(context).primaryColor,
                                ),
                                keyboardType: TextInputType.text,
                                inputFormatters: const [],
                                decoration: InputDecoration(
                                  label: Text(
                                    "Enter name",
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
                                    borderSide: const BorderSide(
                                        color: brandOne, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xffE0E0E0),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.red,
                                        width: 2.0), // Change color to yellow
                                  ),
                                  filled: false,
                                  contentPadding: const EdgeInsets.all(14),
                                  hintText: 'E.g First deposit',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
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
                                    Get.to(SpaceDepositAmountPage(
                                        name: _planNameController.text));
                                    // Navigator.of(context).push(Mateg)
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
