import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/api/global_services.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/view/actions/forgot_pin.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/auth/user_controller.dart';
// import '../../controller/user_controller.dart';

class ForgotPinIntro extends ConsumerStatefulWidget {
  const ForgotPinIntro({super.key});

  @override
  ConsumerState<ForgotPinIntro> createState() => _ForgotPinIntroConsumerState();
}

class _ForgotPinIntroConsumerState extends ConsumerState<ForgotPinIntro> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _passwordController = TextEditingController();
  final passwordformKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
  }

  void doSomething() async {
    // String userPin = await GlobalService.sharedPreferencesManager.getPin();
  }

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authControllerProvider.notifier);
    validatePass(passValue) {
      if (passValue == null || passValue.isEmpty) {
        return 'Input a valid password';
      } else {
        return null;
      }
    }

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
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Enter your password',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validatePass,
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
          'Forgot PIN',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Form(
                    key: passwordformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Enter your Password',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        password,
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
                                    backgroundColor: brandOne,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (passwordformKey.currentState!
                                        .validate()) {
                                     
                                      if (!BCrypt.checkpw(
                                        _passwordController.text.trim(),
                                        userController.userModel!
                                            .userDetails![0].password,
                                      )) {
                                        // ignore: use_build_context_synchronously
                                        customErrorDialog(context, "Invalid!",
                                            "Password is incorrect");
                                      } else {
                                        print('email');
                                        print(userController
                                            .userModel!.userDetails![0].email);
                                        authState.forgotPin(
                                          context,
                                          userController
                                              .userModel!.userDetails![0].email,
                                        );
                                      }
                                    } else {
                                      customErrorDialog(context, "Invalid!",
                                          "Please fill the form properly to proceed");
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
