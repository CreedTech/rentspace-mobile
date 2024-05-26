// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/actions/forgot_password_otp_verification.dart';
import 'package:rentspace/view/actions/forgot_pin_otp_verify.dart';
import 'package:rentspace/view/actions/onboarding_page.dart';
import 'package:rentspace/view/actions/reset_pin.dart';
import 'package:rentspace/view/auth/multiple_device_login.dart';
// import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/view/auth/verify_user_screen.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../constants/colors.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../model/user_model.dart';
import '../../repo/auth_repo.dart';
import '../../view/FirstPage.dart';
import '../../view/actions/reset_password.dart';
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
    // print("Fields");
    // // print(email);
    // // print(otp);
    isLoading = true;
    if (otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     message: 'All fields are required',
      //   ),
      // );
      return;
    }
    Map<String, dynamic> body = {'email': email, 'otp': otp};
    // print("body");
    // // print(body);
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
        Get.offAll(BvnPage(email: email));

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
    // // print(email);
    isLoading = true;
    if (bvn.isEmpty || bvn == '') {
      customErrorDialog(context, 'Error', 'Please input your bvn!!');
      return;
    }
    Map<String, dynamic> params = {'bvn': bvn, 'email': email};
    // print('params');
    // // print(params);
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
      // print(response.message.toString());
      if (response.success) {
        // EasyLoading.dismiss();
        createDva(
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
    // print('params');
    // // print(params);
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
      // // print(response.message.toString());
      if (response.success) {
        // await userController.fetchData();
        Get.offAll(
          LoginPage(
            sessionStateStream: sessionStateStream,
            // loggedOutReason: "Logged out because of user inactivity",
          ),
        );
        EasyLoading.dismiss();
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: brandOne,
            message: 'BVN Verified Successfully!!',
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
    // // print(email);
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      // showSnackBar(context: context, content: 'All fields are required');
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

  Future signIn(BuildContext context, email, password, fcmToken, deviceType,
      deviceModel, loggedOutReason, sessionStateStream,
      {rememberMe = false}) async {
    isLoading = true;
    if (email.isEmpty || email == '' || password.isEmpty || password == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    // print('fcmToken ======');
    // print(fcmToken);
    // print(deviceType);
    // print(deviceModel);
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
      // print('response.message');
      // // print(response.message);
      if (response.success == true) {
        isLoading = false;
        // final fcmToken =
        //     await GlobalService.sharedPreferencesManager.getFCMToken();
        // print('fcmToken');
        // // print(fcmToken);
        // postFcmToken(context, fcmToken);
        await GlobalService.sharedPreferencesManager.saveLoginInfo(
          email,
          password,
          rememberMe,
        );
        await GlobalService.sharedPreferencesManager
            .setHasSeenOnboarding(value: true);
        sessionStateStream.add(SessionState.startListening);
        // // print('session started');
        // // print('loggedOutReason');
        // print(sessionStateStream);
        loggedOutReason = await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const FirstPage(),
            ),
            (route) => false);
        // // print('loggedOutReason here');
        // // print(loggedOutReason);
        // Navigator.pushReplacementNamed(context, home);
        // Get.offAll(const FirstPage());

        return;
      } else {
        // print(response.message.toString());
      }
      // authStatus = AuthStatus.NOT_LOGGED_IN;

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("Incorrect credentials")) {
        // authStatus = AuthStatus.NOT_LOGGED_IN;
        message = "Incorrect credentials";
        customErrorDialog(context, 'Oops ):', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );

        return;
      } else if (response.success == false &&
          response.message
              .contains("User not verified, please verify your account")) {
        // authStatus = AuthStatus.NOT_LOGGED_IN;
        message = "User not verified, please verify your account";
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyUserPage(
              email: email.toString().toLowerCase(),
            ),
          ),
        );
        resendOtp(context, email);
        // );
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => const HomePage(),
        //     ),
        //     (route) => false);

        // Navigator.of(context).pushNamed(RouteList.otp_verify, arguments: email);
        return;
      } else if (response.success == false &&
          response.message.contains(
              "BVN not verified, please verify your bvn to continue")) {
        // authStatus = AuthStatus.NOT_LOGGED_IN;
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
        // customErrorDialog(context, 'Error', message);

        return;
      } else {
        // authStatus = AuthStatus.NOT_LOGGED_IN;
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
      // state = const AsyncLoading();

      // state = AsyncData(true);
    } catch (e) {
      // authStatus = AuthStatus.NOT_LOGGED_IN;
      // state = AsyncData(false);
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
      //  debug// print(state.toString());
      // // print(e.toString());
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
        Get.to(
            MultipleDeviceLoginOtpPage(email: email.toString().toLowerCase()));
        // resendVerification(context);
        // resendVerification(context, 'Successfully Sent 🎉',
        //     'Your verification code is on its way to your email. Please check your inbox and follow the instructions. Thank you!');
        return;
      } else if (response.success == false &&
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
      message = "Oops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
    }
  }

  Future verifySingleDeviceLoginOtp(BuildContext context, email, otp) async {
    // // print(email);
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
        Get.to(LoginPage(sessionStateStream: sessionStateStream));
        // resendVerification(context);
        // resendVerification(context, 'Successfully Sent 🎉',
        //     'Your verification code is on its way to your email. Please check your inbox and follow the instructions. Thank you!');
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

  Future postFcmToken(BuildContext context, fcmToken) async {
    // print('fcmToken here');
    // print(fcmToken);
    // isLoading = true;
    if (fcmToken.isEmpty || fcmToken == '') {
      return;
    }
    Map<String, dynamic> token = {
      'fcm_token': fcmToken,
    };
    // String message;
    try {
      // isLoading = true;
      state = const AsyncLoading();
      // print('Got here in fcm token contrl');
      // EasyLoading.show(
      //   indicator: const CustomLoader(),
      //   maskType: EasyLoadingMaskType.black,
      //   dismissOnTap: false,
      // );

      var response = await authRepository.postFcmToken(token);
      // EasyLoading.dismiss();
      state = const AsyncData(false);
      // print('response.message');
      // // print(response);
      // // print(response.message);
      if (response.success) {
        // print('posted');
        // isLoading = false;

        return;
      } else {
        // print(response.message.toString());
      }
      // if (response.success == false &&
      //     response.message.contains("Incorrect credentials")) {
      //   // authStatus = AuthStatus.NOT_LOGGED_IN;
      //   message = "Incorrect credentials";
      //   customErrorDialog(context, 'Error', message);
      //   // showTopSnackBar(
      //   //   Overlay.of(context),
      //   //   CustomSnackBar.error(
      //   //     message: message,
      //   //   ),
      //   // );

      //   return;
      // }
    } catch (e) {
      // authStatus = AuthStatus.NOT_LOGGED_IN;
      state = const AsyncData(false);
      // EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      // message = "Ooops something went wrong";
      // customErrorDialog(context, 'Error', message);
      // print('e');
      // print(e);

      return;
    } finally {
      // isLoading = false;
      // return;
    }
  }

  Future verifyForgotPasswordOtp(BuildContext context, email, otp) async {
    // print("Fields");
    // // print(email);
    // // print(otp);
    isLoading = true;
    if (otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {
      'email': email.toString().toLowerCase(),
      'otp': otp
    };
    // print("body");
    // // print(body);
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
    // print("email");
    // // print(email);
    // print("newPassword");
    // // print(newPassword);
    // print("repeatPassword");
    // // print(repeatPassword);
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
    // print('params');
    // // print(params);
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
        redirectingAlert(
            context,
            '🎉 Congratulations! 🎉',
            'Your password has been successfully set, and your account is now secure.',
            "Login");
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
        // print('error auth');
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
      var response = await authRepository.resendPasswordOtp(mail);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        // resendVerification(context);
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
      // print('response message here');
      // // print(response.message);
      if (response.success == true) {
        EasyLoading.dismiss();
        isLoading = false;
        // notifyListeners();
        state = const AsyncValue.data(false);
        // await GlobalService.sharedPreferencesManager.removeToken();
        await GlobalService.sharedPreferencesManager.deleteLoginInfo();
        // await GlobalService.sharedPreferencesManager.deleteDeviceInfo();
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasSeenOnboarding', false);
        // // print(prefs.get('hasSeenOnboarding'));
        // Get.offAll(const LoginPage());

        await Get.offAll(
          LoginPage(
            sessionStateStream: sessionStateStream,
            // loggedOutReason: "Logged out because of user inactivity",
          ),
        );
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const LoginPage()),
        //     (route) => false);
        return;
      } else {
        // print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("invalid signature")) {
        message = "User info could not be retrieved , Try again later.";
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
      EasyLoading.dismiss();
      // return;
    }
  }

  Future createPin(BuildContext context, pin) async {
    // print("pin");
    // // print(pin);
    isLoading = true;
    if (pin.isEmpty || pin == '') {
      customErrorDialog(context, 'Error', 'Pin is required');
      return;
    }

    Map<String, dynamic> params = {
      'pin': pin,
    };
    // print('params');
    // // print(params);
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
        // await userController.fetchData();
        // print(userController.userModel!.userDetails![0].isPinSet);
        // await GlobalService.sharedPreferencesManager.savePin(pin);
        await userController.fetchData();
        EasyLoading.dismiss();
        isLoading = false;
        redirectingAlert(context, '🎉 Congratulations! 🎉',
            'Your Transaction has been set successfully!!!.', "Home");
        return;
      } else {
        // print('response.message.toString()');
      }
      // print(response.message.toString());

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
        // print('response here');
        // // print(response.success);
        // // print(response);
        message = "Oops! Pin has already been set for this account";
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
    }
  }

  Future forgotPin(BuildContext context, email) async {
    // // print(email);
    isLoading = true;
    // if (email.isEmpty || email == '') {
    //   customErrorDialog(context, 'Error', 'All fields are required');
    //   return;
    // }

    // Map<String, dynamic> mail = {
    //   'email': email.toString().toLowerCase(),
    // };
    // // print(mail);
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
                    ForgotPinOTPVerificationPage(email: email)));
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
      EasyLoading.dismiss();
      isLoading = false;
      isLoading = false;
    }
  }

  Future resendPinOtp(BuildContext context, email) async {
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
      var response = await authRepository.resendPinOtp(mail);
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        // resendVerification(context);
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
    // print("Fields");
    // // print(email);
    // // print(otp);
    isLoading = true;
    if (otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {'otp': otp};
    // print("body");
    // // print(body);
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
                builder: (context) => ResetPIN(
                      email: email.toString().toLowerCase(),
                    )));
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
    // print("Fields");
    // // print(newPin);
    // // print(confirmNewPin);
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
    // print("body");
    // // print(body);
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
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: 'Payment Pin Reset Successful!!',
            textStyle: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        Get.offAll(
          const FirstPage(),
        );
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => ResetPIN(email: email)));
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
        // Get.back();
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
    // print("Fields");
    // // print(newPin);
    // // print(currentPin);
    isLoading = true;
    if (newPin.isEmpty || newPin == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {'newPin': newPin, 'currentPin': currentPin};
    // print("body");
    // // print(body);
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
        Get.offAll(
          const FirstPage(),
        );
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => ResetPIN(email: email)));
        return;
      } else if (response.success == false &&
          response.message.contains("Wallet not found")) {
        message = "Wallet not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("New pin and confirm pin do not match")) {
        message = "Pin Mismatch error";
        // Get.back();
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
