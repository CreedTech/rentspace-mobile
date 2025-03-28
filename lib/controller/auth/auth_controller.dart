// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/view/auth/otp/change_transaction_pin_otp_page.dart';
import 'package:rentspace/view/auth/otp/forgot_password_otp_verification.dart';
import 'package:rentspace/view/onboarding/bvn_page.dart';
import 'package:rentspace/view/auth/multiple_device_login.dart';
import 'package:rentspace/view/auth/registration/verify_user_screen.dart';
import 'package:rentspace/view/auth/registration/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../constants/colors.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';
import '../../model/user_model.dart';
import '../../repo/auth_repo.dart';
import '../../view/onboarding/FirstPage.dart';
import '../../view/auth/pin/change_transaction_pin.dart';
import '../../view/auth/password/reset_password.dart';
import '../../view/auth/multiple_device_login_otp_page.dart';
// import 'user_controller.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<bool>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});

class AuthController extends StateNotifier<AsyncValue<bool>> {
  final sessionStateStream = StreamController<SessionState>();
  AuthRepository authRepository;
  bool isLoading = false;
  // bool get loading => _isLoading;
  AuthController(this.authRepository) : super(const AsyncLoading());

  Future signUp(BuildContext context, firstName, lastName, username, email,
      password, phone, dateOfBirth, address, gender,
      {String? referralCode}) async {
    isLoading = true;

    if (firstName.isEmpty ||
        firstName == '' ||
        lastName.isEmpty ||
        lastName == '' ||
        username.isEmpty ||
        username == '' ||
        email.isEmpty ||
        email == '' ||
        password.isEmpty ||
        password == '' ||
        phone.isEmpty ||
        phone == '' ||
        dateOfBirth.isEmpty ||
        dateOfBirth == '' ||
        address.isEmpty ||
        address == '' ||
        gender.isEmpty ||
        gender == '') {
      customErrorDialog(
          context, 'Error', 'Please fill in the required fields!!');
      // showSnackBar(context: context, content: 'All fields are required');
      return;
    }
    UserModel user = UserModel(
        firstName: firstName,
        lastName: lastName,
        userName: username,
        email: email.toString().toLowerCase(),
        phoneNumber: phone,
        password: password,
        dateOfBirth: dateOfBirth,
        residentialAddress: address,
        gender: gender,
        referralCode: referralCode);
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      // print('Got here in auth contrl');
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.signUp(user.toJson());
      EasyLoading.dismiss();
      state = const AsyncData(false);
      if (response.success == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyUserPage(
              email: email,
            ),
          ),
        );
        return;
      } else {
        // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("username is too short")) {
        EasyLoading.dismiss();
        message = 'username is too short';
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("Username already taken")) {
        EasyLoading.dismiss();
        message = 'Username is already taken';
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //     Overlay.of(context), CustomSnackBar.error(message: message));
      } else if (response.success == false &&
          response.message.contains("Phone Number already taken")) {
        EasyLoading.dismiss();
        message = "Phone Number already taken";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message
              .contains("String must contain at least 11 character(s)")) {
        EasyLoading.dismiss();
        message = "Phone Number must be at least 11";
        isLoading = false;
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("Password is too short")) {
        EasyLoading.dismiss();
        message = "Password is too short";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("Email is already taken")) {
        EasyLoading.dismiss();
        message = "Email is already taken";

        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("Invalid email")) {
        EasyLoading.dismiss();
        message = "Invalid email";
        customErrorDialog(context, 'Invalid', message);

        return;
      } else {
        // to capture other errors later
        EasyLoading.dismiss();
        message = "Something went wrong";
        // print('This is the error $message');

        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      // print(e);
      // print('This is the error register$e');

      message = "Oops something went wrong";
      customErrorDialog(context, 'Oops', message);

      return;
      //  debug// print(state.toString());
      // // print(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future verifyOtp(BuildContext context, email, otp) async {
    isLoading = true;
    if (otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {'email': email, 'otp': otp};
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await authRepository.verifyOtp(body);
      EasyLoading.dismiss();
      if (response.success) {
        while (context.canPop()) {
          context.pop();
        }
        // Navigate to the first page
        context.go('/login');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BvnPage(email: email),
          ),
        );
        // Get.offAll(BvnPage(email: email));

        return;
      } else if (response.success == false &&
          response.message.contains("Invalid OTP")) {
        message = "Invalid OTP";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("This otp has expired")) {
        message = "This otp has expired";
        // custTomDialog(context, message);
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User with mail not found";
        // custTomDialog(context, message);
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      message = "Ooops something went wrong";
      // custTomDialog(context, message);
      customErrorDialog(context, 'Error', message);
      EasyLoading.dismiss();

      return;
    } finally {
      isLoading = false;
    }
  }

  Future verifyBVN(BuildContext context, bvn, email) async {
    isLoading = true;
    if (bvn.isEmpty || bvn == '') {
      customErrorDialog(context, 'Error', 'Please input your bvn!!');
      return;
    }
    Map<String, dynamic> params = {'bvn': bvn, 'email': email};
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.verifyBVN(params);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        createProvidusDva(
          context,
          email.toString().toLowerCase(),
        );

        return;
      } else {
        // print('response.message.toString()');
      }
      // print(response.message.toString());

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User already has bvn verified")) {
        EasyLoading.dismiss();
        message = "User already has bvn verified";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("User with this BVN already exists")) {
        EasyLoading.dismiss();
        // print('response here');
        // // print(response.success);
        // // print(response);
        message = "Oops! User with this BVN already exists";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        print('error auth');
        multipleLoginRedirectModal();
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        // print('response again');
        // // print(response.success);
        // // print(response.message);
        message = "Something went wrong. Try Again later";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      //  return;
    }
  }

  Future createDva(BuildContext context, email) async {
    isLoading = true;

    Map<String, dynamic> params = {
      'email': email.toString().toLowerCase(),
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.createDva(params);
      if (response.success) {
        while (context.canPop()) {
          context.pop();
        }
        // Navigate to the first page
        context.go('/login');
        // Get.offAll(
        //   const LoginPage(),
        // );
        EasyLoading.dismiss();
        isLoading = false;
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: brandOne,
            message: 'Account Verified Successfully!!',
            textStyle: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        );

        return;
      } else {
        // print('response.message.toString()');
      }
      // print(response.message.toString());

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User already has DVA")) {
        EasyLoading.dismiss();
        message = "User already has a Virtual Account";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("User with this BVN already exists")) {
        EasyLoading.dismiss();
        // print('response here');
        // // print(response.success);
        // // print(response);
        message = "Oops! User with this BVN already exists";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        // print('response again');
        // // print(response.success);
        // // print(response.message);
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      //  return;
    }
  }

  Future createProvidusDva(BuildContext context, email) async {
    isLoading = true;

    Map<String, dynamic> params = {
      'email': email.toString().toLowerCase(),
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.createProvidusDva(params);
      if (response.success) {
        // await userController.fetchData();
        while (context.canPop()) {
          context.pop();
        }
        // Navigate to the first page
        context.go('/login');
        // Get.offAll(
        //   const LoginPage(),
        // );
        EasyLoading.dismiss();
        isLoading = false;
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: brandOne,
            message: 'Account Verified Successfully!!',
            textStyle: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        );

        return;
      } else {
        // print('response.message.toString()');
      }
      // print(response.message.toString());

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User already has DVA")) {
        EasyLoading.dismiss();
        message = "User already has a Virtual Account";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("User with this BVN already exists")) {
        EasyLoading.dismiss();
        // print('response here');
        // // print(response.success);
        // // print(response);
        message = "Oops! User with this BVN already exists";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        // print('response again');
        // // print(response.success);
        // // print(response.message);
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      //  return;
    }
  }

  Future resendOtp(BuildContext context, email) async {
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {
      'email': email.toString().toLowerCase(),
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.resendOTP(mail);
      EasyLoading.dismiss();
      if (response.success) {
        // resendVerification(context);
        // resendVerification(context, 'Successfully Sent 🎉',
        //     'Your verification code is on its way to your email. Please check your inbox and follow the instructions. Thank you!');
        return;
      } else {
        // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User not found";
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     message: message,
      //   ),
      // );

      return;
    } finally {
      isLoading = false;
    }
  }

  Future signIn(
      BuildContext context, email, password, fcmToken, deviceType, deviceModel,
      // loggedOutReason, sessionStateStream,
      {rememberMe = false}) async {
    isLoading = true;
    if (email.isEmpty || email == '' || password.isEmpty || password == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> user = {
      'email': email.toString().toLowerCase(),
      'password': password,
      'fcm_token': fcmToken,
      'deviceType': deviceType,
      "deviceName": deviceModel
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      // print('Got here in auth contrl');
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.signIn(user);
      EasyLoading.dismiss();
      state = const AsyncData(false);
      print('response.message');

      print(response.message);
      if (response.success == true) {
        isLoading = false;
        await GlobalService.sharedPreferencesManager.saveLoginInfo(
          email,
          password,
          rememberMe,
        );
        await GlobalService.sharedPreferencesManager
            .setHasSeenOnboarding(value: true);
        // sessionStateStream.add(SessionState.startListening);
        context.replace('/firstpage');
        // await Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (_) => const FirstPage(),
        //     ),
        //     (route) => false);

        return;
      } else {
        print(response.message.toString());
      }
      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("Incorrect credentials")) {
        message = "Incorrect credentials";
        customErrorDialog(context, 'Oops ):', message);

        return;
      } else if (response.success == false &&
          response.message
              .contains("User not verified, please verify your account")) {
        message = "User not verified, please verify your account";
        customErrorDialog(context, 'Error', message);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyUserPage(
              email: email.toString().toLowerCase(),
            ),
          ),
        );
        resendOtp(context, email);
        return;
      } else if (response.success == false &&
          response.message.contains(
              "BVN not verified, please verify your BVN to continue")) {
        message = "BVN not verified, please verify your bvn to continue";

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BvnPage(
              email: email.toString().toLowerCase(),
            ),
          ),
        );
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message
              .contains("User already logged in on another device")) {
        message = "User already logged in on another device";

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MultipleDeviceLogin(
              email: email,
            ),
          ),
        );
        return;
      } else {
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);
        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);
      return;
    } finally {
      isLoading = false;
      //  return;
    }
  }

  Future singleDeviceLoginOtp(BuildContext context, email) async {
    // // print(email);
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {
      'email': email.toString().toLowerCase(),
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.singleDeviceLoginOtp(mail);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        context.go(
          '/multipleDeviceLoginOtp',
          extra: {
            'email': email,
          },
        );

        return;
      } else if (response.success == false &&
          response.message.contains("User not found")) {
        EasyLoading.dismiss();
        message = "User not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Oops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
    }
  }

  Future verifySingleDeviceLoginOtp(BuildContext context, email, otp) async {
    isLoading = true;
    if (email.isEmpty || email == '' || otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> body = {
      'email': email.toString().toLowerCase(),
      'otp': otp
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.verifySingleDeviceLoginOtp(body);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        context.go('/login');
        return;
      } else if (response.success == false &&
          response.message.contains("Invalid OTP")) {
        message = "Invalid OTP";
        EasyLoading.dismiss();
        isLoading = false;
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("This otp has expired")) {
        message = "This otp has expired";
        EasyLoading.dismiss();
        isLoading = false;
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      message = "Ooops something went wrong";
      EasyLoading.dismiss();
      isLoading = false;
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      // return;
    }
  }

  Future verifyForgotPasswordOtp(BuildContext context, email, otp) async {
    isLoading = true;
    if (otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {
      'email': email.toString().toLowerCase(),
      'otp': otp
    };
    String message;

    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await authRepository.verifyForgotPasswordOtp(body);
      EasyLoading.dismiss();
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPassword(email: email)));
        return;
      } else if (response.success == false &&
          response.message.contains("Invalid OTP")) {
        message = "Invalid OTP";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("This otp has expired")) {
        message = "This otp has expired";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
    }
  }

  Future forgotPassword(BuildContext context, email) async {
    // print(email);
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {
      'email': email.toString().toLowerCase(),
    };
    // print(mail);
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.forgotPassword(mail);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ForgotPasswordOTPVerificationPage(email: email)));
        return;
      } else {
        // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
    }
  }

  Future resetPassword(
      BuildContext context, email, newPassword, repeatPassword) async {
    isLoading = true;
    if (email.isEmpty ||
        email == '' ||
        newPassword.isEmpty ||
        newPassword == '' ||
        repeatPassword.isEmpty ||
        repeatPassword == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> params = {
      'email': email.toString().toLowerCase(),
      "newPassword": newPassword,
      'repeatPassword': repeatPassword,
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.resetPassword(params);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        customRedirectingSuccessDialog(
            context, 'Success', 'Password changed successfully.');
        return;
      } else {
        // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("Passwords do not match")) {
        message = "Oops! The Passwords you entered does not match!";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains(
              "New Password cannot be the same as the previous one")) {
        message = "New Password cannot be the same as the previous one!";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);
      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      isLoading = false;
    }
  }

  Future resendPasswordOtp(BuildContext context, email) async {
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {
      'email': email.toString().toLowerCase(),
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.resendPasswordOtp(mail);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        resendVerification(context, 'Successfully Sent 🎉',
            'Your verification code is on its way to your email. Please check your inbox and follow the instructions. Thank you!');
        return;
      } else {
        // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);
        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
    }
  }

  Future logout(BuildContext context) async {
    final box = Hive.box('settings');

    isLoading = true;
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.logout();
      if (response.success == true) {
        context.pop();
        EasyLoading.dismiss();
        isLoading = false;
        state = const AsyncValue.data(false);
        final prefs = await SharedPreferences.getInstance();

        await GetStorage().erase();
        await prefs.clear();
        await box.clear();
        await GlobalService.sharedPreferencesManager.removeToken();
        await GlobalService.sharedPreferencesManager.deleteLoginInfo();
        await GlobalService.sharedPreferencesManager.deleteDeviceInfo();

        prefs.setBool('hasSeenOnboarding', false);

        while (context.canPop()) {
          context.pop();
        }
        // Navigate to the first page
        context.go('/login');
        // await Get.offAll(const LoginPage());
        return;
      } else {
        // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("invalid signature")) {
        message = "User info could not be retrieved , Try again later.";
        context.pop();
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        // to capture other errors later
        message = "Something went wrong";
        context.pop();
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Oops something went wrong";
      print(e);
      context.pop();
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
      // return;
    }
  }

  Future createPin(BuildContext context, pin) async {
    isLoading = true;
    if (pin.isEmpty || pin == '') {
      customErrorDialog(context, 'Error', 'Pin is required');
      return;
    }

    Map<String, dynamic> params = {
      'pin': pin,
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.createPin(params);
      if (response.success) {
        await userController.fetchData().then((value) {
          EasyLoading.dismiss();
          isLoading = false;
          context.go('/firstpage');
        });
        EasyLoading.dismiss();
        isLoading = false;
        return;
      } else {
        // print('response.message.toString()');
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("Wallet not found")) {
        EasyLoading.dismiss();
        message = "You don't have a wallet connected to your account";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("Pin was already set")) {
        EasyLoading.dismiss();
        message = "Oops! Pin has already been set for this account";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
    }
  }

  Future forgotPin(BuildContext context, email) async {
    isLoading = true;
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.forgotPin();
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChangetransactionPinOtpPage(email: email)));
        return;
      } else {
        // // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else {
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      isLoading = false;
    }
  }

  Future resendPinOtp(BuildContext context, email) async {
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {
      'email': email.toString().toLowerCase(),
    };
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await authRepository.resendPinOtp(mail);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        resendVerification(context, 'Successfully Sent 🎉',
            'Your verification code is on its way to your email. Please check your inbox and follow the instructions. Thank you!');
        return;
      } else {
        // // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        // to capture other errors later
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
    }
  }

  Future verifyForgotPinOtp(BuildContext context, email, otp) async {
    isLoading = true;
    if (otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {'otp': otp};
    String message;
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await authRepository.verifyForgotPinOtp(body);
      EasyLoading.dismiss();
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeTransactionPin(
              email: email.toString().toLowerCase(),
            ),
          ),
        );
        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("Invalid OTP")) {
        message = "Invalid OTP";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("This otp has expired")) {
        message = "This otp has expired";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      message = "Oops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    }
    return;
  }

  Future setNewPin(BuildContext context, newPin, confirmNewPin) async {
    isLoading = true;
    if (newPin.isEmpty ||
        newPin == '' ||
        confirmNewPin.isEmpty ||
        confirmNewPin == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {
      'newPin': newPin,
      'confirmNewPin': confirmNewPin
    };
    String message;
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await authRepository.setNewPin(body);
      EasyLoading.dismiss();
      if (response.success) {
        walletController.fetchWallet();
        userController.fetchData();
        EasyLoading.dismiss();
        isLoading = false;
        customSuccessDialog(
            context, 'Success', 'Transaction Pin changed successfully.');
        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("Wallet not found")) {
        message = "Wallet not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("New pin and confirm pin do not match")) {
        message = "Pin Mismatch error";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      message = "Oops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    }
    return;
  }

  Future changePin(BuildContext context, newPin, currentPin) async {
    isLoading = true;
    if (newPin.isEmpty || newPin == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {'newPin': newPin, 'currentPin': currentPin};
    String message;
    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await authRepository.changePin(body);
      EasyLoading.dismiss();
      if (response.success) {
        userController.fetchData();
        walletController.fetchWallet();
        EasyLoading.dismiss();
        isLoading = false;
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: 'Payment Pin Changed Successfully!!',
            textStyle: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        while (context.canPop() == true) {
          context.pop();
        }
        context.pushReplacement('/firstpage');
        // context.go('/firstpage');
        // Get.offAll(
        //   const FirstPage(),
        // );
        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("Wallet not found")) {
        message = "Wallet not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("New pin and confirm pin do not match")) {
        message = "Pin Mismatch error";
        customErrorDialog(context, 'Error', message);
        return;
      }
    } catch (e) {
      message = "Oops something went wrong";
      customErrorDialog(context, 'Error', message);
      return;
    }
    return;
  }
}
