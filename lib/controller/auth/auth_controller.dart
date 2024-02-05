// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/auth/verify_user_screen.dart';
import 'package:rentspace/view/login_page.dart';

import '../../constants/widgets/custom_loader.dart';
import '../../model/user_model.dart';
import '../../repo/auth_repo.dart';

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
        maskType: EasyLoadingMaskType.clear,
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
        maskType: EasyLoadingMaskType.clear,
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
        maskType: EasyLoadingMaskType.clear,
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
}
