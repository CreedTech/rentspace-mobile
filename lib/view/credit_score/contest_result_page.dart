import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../dashboard/dashboard.dart';

class ContestResultPage extends StatefulWidget {
  const ContestResultPage({super.key});

  @override
  State<ContestResultPage> createState() => _ContestResultPageState();
}

class _ContestResultPageState extends State<ContestResultPage> {
  bool isFilled = false;
  final TextEditingController _resultContestController =
      TextEditingController();
  final contestResultFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    validateContestResult(lastValue) {
      if (lastValue.isEmpty) {
        return 'Field cannot be empty';
      }

      return null;
    }

    final contestresult = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _resultContestController,
      onChanged: (String val) async {
        setState(() {
          isFilled = true;
        });
      },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.multiline,

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        contentPadding: const EdgeInsets.all(14),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      minLines: 8,
      // expands: true,
      maxLines: 20,
      validator: validateContestResult,
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
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Hi ${userController.userModel!.userDetails![0].firstName.capitalize}',
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0.h,
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please tell us why you aren’t satisfied with your credit score rating.',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Form(
                      key: contestResultFormKey,
                      child: contestresult,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 50, 50),
                    backgroundColor: (_resultContestController.text.isNotEmpty)
                        ? brandTwo
                        : const Color(0xffD0D0D0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (contestResultFormKey.currentState!.validate() &&
                        _resultContestController.text.isNotEmpty) {
                      customSuccessDialog(context, 'Success',
                          'Your complaint has been received and you will get a response shortly.');
                    }
                  },
                  child: Text(
                    'Send',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: (_resultContestController.text.isNotEmpty)
                          ? Colors.white
                          : colorBlack,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
