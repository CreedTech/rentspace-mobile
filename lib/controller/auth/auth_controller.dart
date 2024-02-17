// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/view/auth/verify_user_screen.dart';
import 'package:rentspace/view/home_page.dart';
import 'package:rentspace/view/login_page.dart';

import '../../api/global_services.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../model/user_model.dart';
import '../../repo/auth_repo.dart';
import 'user_controller.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<bool>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});

class AuthController extends StateNotifier<AsyncValue<bool>> {
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
        email: email,
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
      print('Got here in auth contrl');
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      var response = await authRepository.signUp(user.toJson());
      EasyLoading.dismiss();
      state = const AsyncData(false);
      if (response.success == true) {
        // createWallet(context).then(
        //   (value) => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => SuccessfulScreen(
        //         email: email,
        //       ),
        //     ),
        //   ),
        // );
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
        print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("username is too short")) {
        EasyLoading.dismiss();
        message = 'username is too short';
        customErrorDialog(context, 'Error', message);

        return;
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
        print('This is the error $message');

        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      print('This is the error register$e');

      message = "Oops something went wrong";
      customErrorDialog(context, 'Oops', message);

      return;
      //  debugPrint(state.toString());
      // print(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future verifyOtp(BuildContext context, email, otp) async {
    print("Fields");
    print(email);
    print(otp);
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
    print("body");
    print(body);
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      final response = await authRepository.verifyOtp(body);
      EasyLoading.dismiss();
      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
        // Navigator.pushNamed(context, RouteList.login);
        return;
      } else if (response.success == false &&
          response.message.contains("Invalid OTP")) {
        message = "Invalid OTP";
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );
        return;
      } else if (response.success == false &&
          response.message.contains("This otp has expired")) {
        message = "This otp has expired";
        // custTomDialog(context, message);
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
      message = "Ooops something went wrong";
      // custTomDialog(context, message);
      customErrorDialog(context, 'Error', message);
      EasyLoading.dismiss();

      return;
    } finally {
      isLoading = false;
    }
  }

  Future resendOtp(BuildContext context, email) async {
    print(email);
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      // showSnackBar(context: context, content: 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {'email': email};
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      var response = await authRepository.resendOTP(mail);
      EasyLoading.dismiss();
      if (response.success) {
        // resendVerification(context);
        // resendVerification(context, 'Successfully Sent 🎉',
        //     'Your verification code is on its way to your email. Please check your inbox and follow the instructions. Thank you!');
        return;
      } else {
        print(response.message.toString());
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

  Future signIn(BuildContext context, email, password) async {
    isLoading = true;
    if (email.isEmpty || email == '' || password.isEmpty || password == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> user = {'email': email, 'password': password};
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      print('Got here in auth contrl');
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      var response = await authRepository.signIn(user);
      EasyLoading.dismiss();
      state = const AsyncData(false);
      print('response.message');
      print(response.message);
      if (response.success == true) {
        isLoading = false;
        // userController.login();
        // authStatus = AuthStatus.LOGGED_IN;

        // String pin = await GlobalService.sharedPreferencesManager.getPin();
        // print('pin');
        // print(pin);
        // if (pin.isEmpty) {
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //     RouteList.newPinfor_NewUser_Transaction,
        //     (route) => false,
        //   );
        // } else {
        // }
        // getUserData()
        // Get.put(UserController());
        // Future.delayed(const Duration(seconds: 2), () {
        //   Navigator.of(context).pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const HomePage(),
        //       ),
        //       (route) => false);
        // });
        // Get.put(UserController());
        // Get.put(WalletController());
        // Get.put(ActivitiesController());
        Get.offAll(FirstPage());
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => const FirstPage(),
        //     ),
        //     (route) => false);
        // getUserData(context).then(
        //   (value) => Navigator.of(context).pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const HomePage(),
        //       ),
        //       (route) => false),
        // );

        return;
      } else {
        print(response.message.toString());
      }
      // authStatus = AuthStatus.NOT_LOGGED_IN;

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("Incorrect credentials")) {
        // authStatus = AuthStatus.NOT_LOGGED_IN;
        message = "Incorrect credentials";
        customErrorDialog(context, 'Error', message);
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
              email: email,
            ),
          ),
        );
        // );
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => const HomePage(),
        //     ),
        //     (route) => false);

        // Navigator.of(context).pushNamed(RouteList.otp_verify, arguments: email);
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
      //  debugPrint(state.toString());
      // print(e.toString());
    } finally {
      isLoading = false;
      return;
    }
  }

  Future verifyForgotPasswordOtp(BuildContext context, email, otp) async {
    print("Fields");
    print(email);
    print(otp);
    isLoading = true;
    if (otp.isEmpty || otp == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }
    Map<String, dynamic> body = {'email': email, 'otp': otp};
    print("body");
    print(body);
    String message;

    try {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      final response = await authRepository.verifyForgotPasswordOtp(body);
      EasyLoading.dismiss();
      if (response.success) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ResetPassword(email: email)));
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
    }
    return;
  }

  Future forgotPassword(BuildContext context, email) async {
    print(email);
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {'email': email};
    print(mail);
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      var response = await authRepository.forgotPassword(mail);
      if (response.success) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             ForgetPasswordOtpVerification(email: email)));
        return;
      } else {
        print(response.message.toString());
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

  Future resetPassword(
      BuildContext context, email, newPassword, repeatPassword) async {
    print("email");
    print(email);
    print("newPassword");
    print(newPassword);
    print("repeatPassword");
    print(repeatPassword);
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
      'email': email,
      "newPassword": newPassword,
      'repeatPassword': repeatPassword
    };
    print('params');
    print(params);
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      var response = await authRepository.resetPassword(params);
      if (response.success) {
        // redirectingAlert(context, '🎉 Congratulations! 🎉',
        //     'Your password has been successfully set, and your account is now secure.');
        return;
      } else {
        print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User not found")) {
        message = "User not found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("Passwords do not match")) {
        message = "Oops! The Passwords you entered does not match!";
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

  Future resendPasswordOtp(BuildContext context, email) async {
    print(email);
    isLoading = true;
    if (email.isEmpty || email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');
      return;
    }

    Map<String, dynamic> mail = {'email': email};
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      var response = await authRepository.resendPasswordOtp(mail);
      if (response.success) {
        // resendVerification(context);
        // resendVerification(context, 'Successfully Sent 🎉',
        //     'Your verification code is on its way to your email. Please check your inbox and follow the instructions. Thank you!');
        return;
      } else {
        print(response.message.toString());
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

  Future getUserData(BuildContext context) async {
    isLoading = true;
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );
      var response = await authRepository.getUserData();
      if (response.success) {
        EasyLoading.dismiss();
        isLoading = false;
        // notifyListeners();
        state = const AsyncValue.data(true);
        return;
      } else {
        print(response.message.toString());
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
      return;
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
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true,
      );
      var response = await authRepository.logout();
      print('response message here');
      print(response.message);
      if (response.message.contains("User logged out successfully")) {
        EasyLoading.dismiss();
        isLoading = false;
        // notifyListeners();
        state = const AsyncValue.data(true);
        await GlobalService.sharedPreferencesManager.setAuthToken(value: '');
        Get.offAll(LoginPage());
        return;
      } else {
        print(response.message.toString());
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
      return;
    }
  }
}
