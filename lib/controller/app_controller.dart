// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/colors.dart';
import '../repo/app_repository.dart';
import '../view/actions/fund_wallet.dart';
import '../view/savings/spaceRent/spacerent_success_page.dart';
import 'wallet_controller.dart';

final sessionStateStream = StreamController<SessionState>();
final appControllerProvider =
    StateNotifierProvider<AppController, AsyncValue<bool>>((ref) {
  final repository = ref.watch(appRepositoryProvider);
  return AppController(repository);
});

class AppController extends StateNotifier<AsyncValue<bool>> {
  AppRepository appRepository;
  bool isLoading = false;
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  // final ActivitiesController activitiesController = Get.find();
  // bool get loading => _isLoading;
  AppController(this.appRepository) : super(const AsyncLoading());

  Future createRent(BuildContext context, rentName, dueDate, interval,
      intervalAmount, amount, paymentCount, date, duration) async {
    // //print("duration here");
    // //print(duration);
    isLoading = true;
    if (rentName.isEmpty ||
        rentName == '' ||
        interval.isEmpty ||
        interval == '' ||
        intervalAmount == '' ||
        amount == '' ||
        paymentCount.isEmpty ||
        paymentCount == '') {
      customErrorDialog(
          context, 'Error', 'Please fill in the required fields!!');
      return;
    }
    Map<String, dynamic> params = {
      'rentName': rentName,
      'due_date': dueDate.toString(),
      'interval': interval,
      'interval_amount': intervalAmount,
      'amount': amount,
      'payment_count': paymentCount,
      'date': date.toString(),
      'duration': duration.toString()
    };
    // //print('params');
    // //print(params);
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );

      var response = await appRepository.createRent(params);
      if (response.success) {
        EasyLoading.dismiss();

        // //print('response.message');
        // //print(response.message);
        var rentspaceId = response.message;
        // await GlobalService.
        // //print(response.message);
        if (date == DateFormat('dd/MM/yyyy').format(DateTime.now())) {
          if (walletController.walletModel!.wallet![0].mainBalance <
              intervalAmount) {
            Get.back();
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: null,
                    scrollable: true,
                    elevation: 0,
                    content: SizedBox(
                      // height: 220.h,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        child: Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: colorBlack,
                                  size: 24,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Insufficient fund.',
                                  style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              'You need to fund your wallet to perform this transaction.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: colorBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 29,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width - 50,
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
                                  Navigator.of(context).pop();
                                  Get.to(FundWallet());
                                },
                                child: Text(
                                  'Ok',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            await walletDebit(context, intervalAmount, amount, rentspaceId,
                    date, interval)
                .then(
              (value) => Get.to(
                SpaceRentSuccessPage(
                    rentValue: amount,
                    savingsValue: intervalAmount,
                    startDate: date,
                    durationType: interval,
                    paymentCount: paymentCount,
                    rentName: rentName,
                    duration: duration,
                    receivalDate: dueDate),
              ),
            );
          }
        } else {
          Get.to(
            SpaceRentSuccessPage(
                rentValue: amount,
                savingsValue: intervalAmount,
                startDate: date,
                durationType: interval,
                paymentCount: paymentCount,
                rentName: rentName,
                duration: duration,
                receivalDate: dueDate),
          );
        }

        return;
      } else {
        // //print('response.message.toString()');
      }
      // //print(response.message.toString());
      if (response.success == false &&
          response.message.contains("Space Rent already exists")) {
        EasyLoading.dismiss();
        message =
            "You already have an on-going space rent. Please restart app.";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // //print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains(
              "Due date must be between 6 and 8 months from the current date")) {
        EasyLoading.dismiss();
        // //print(response);
        message =
            "Oops! Due date must be between 6 and 8 months from the current date";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        // //print('response again');
        // //print(response.success);
        // //print(response.message);
        message = "Something went wrong.";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      // //print(e);
      message = "Oops something went wrong.\n Try again later.";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      // return;
    }
  }

  Future walletDebit(BuildContext context, intervalAmount, amount, rentspaceId,
      date, interval) async {
    isLoading = true;
    // if (bvn.isEmpty || bvn == '') {
    //   customErrorDialog(context, 'Error', 'Please input your bvn!!');
    //   return;
    // }
    Map<String, dynamic> params = {
      'rentspaceId': rentspaceId,
      'interval_amount': intervalAmount,
      'amount': amount,
      'date': date,
      'interval': interval
    };
    // //print('params');
    // //print(params);
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await appRepository.walletDebit(params);
      EasyLoading.dismiss();
      state = const AsyncData(false);
      // //print(response.message.toString());
      if (response.success) {
        EasyLoading.dismiss();
        // Get.back();
        // Get.back();
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.success(
        //     backgroundColor: Colors.green,
        //     message: 'Space Rent Creation Successful',
        //     textStyle: GoogleFonts.lato(
        //       fontSize: 14,
        //       color: Colors.white,
        //       fontWeight: FontWeight.w700,
        //     ),
        //   ),
        // );
        // // Get.back();
        // Get.to(const RentSpaceList());
        // calculateNextPaymentDate(context, date, interval);
        // Get.to(const RentSpaceList());

        // Get.offAll(const FirstPage())!.then((value) => showTopSnackBar(
        //       Overlay.of(context),
        //       CustomSnackBar.success(
        //         backgroundColor: brandOne,
        //         message: 'Space Rent Successfully!!',
        //         textStyle: GoogleFonts.lato(
        //           fontSize: 14,
        //           color: Colors.white,
        //           fontWeight: FontWeight.w700,
        //         ),
        //       ),
        //     ));

        // redirectingAlert(context, '🎉 Congratulations! 🎉',
        //     'Your pin has been successfully set.');
        // await GlobalService.sharedPreferencesManager.setPin(value: pin);
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   RouteList.enable_user_notification,
        //   (route) => false,
        // );
        return;
      } else {
        // //print('response.message.toString()');
        // //print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("Rent not found")) {
        EasyLoading.dismiss();
        message = "Space Rent Not Found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // //print('error auth');
        multipleLoginRedirectModal();
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        // //print('response again');
        // //print(response.success);
        // //print(response.message);
        message = "Something went wrong during spacerent payment";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      // //print('wallet');
      // //print(e);
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong during space rent payment";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      // return;
    }
  }

  Future calculateNextPaymentDate(BuildContext context, date, interval) async {
    isLoading = true;
    // if (bvn.isEmpty || bvn == '') {
    //   customErrorDialog(context, 'Error', 'Please input your bvn!!');
    //   return;
    // }
    Map<String, dynamic> params = {
      'date': date,
      'interval': interval,
    };
    // //print('params');
    // //print(params);
    String message;
    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var response = await appRepository.calculateNextPaymentDate(params);
      EasyLoading.dismiss();
      state = const AsyncData(false);
      // //print(response.message.toString());
      if (response.success) {
        EasyLoading.dismiss();
        Get.back();
        Get.back();
        // Get.back();
        Get.to(const RentSpaceList());

        // Get.offAll(const FirstPage())!.then((value) => showTopSnackBar(
        //       Overlay.of(context),
        //       CustomSnackBar.success(
        //         backgroundColor: brandOne,
        //         message: 'Space Rent Successfully!!',
        //         textStyle: GoogleFonts.lato(
        //           fontSize: 14,
        //           color: Colors.white,
        //           fontWeight: FontWeight.w700,
        //         ),
        //       ),
        //     ));

        // redirectingAlert(context, '🎉 Congratulations! 🎉',
        //     'Your pin has been successfully set.');
        // await GlobalService.sharedPreferencesManager.setPin(value: pin);
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   RouteList.enable_user_notification,
        //   (route) => false,
        // );
        return;
      } else {
        // //print('response.message.toString()');
        // //print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("Rent not found")) {
        EasyLoading.dismiss();
        message = "Space Rent Not Found";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        // //print('error auth');
        multipleLoginRedirectModal();
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        // //print('response again');
        // //print(response.success);
        // //print(response.message);
        message = "Something went wrong";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      // //print('wallet');
      // //print(e);
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
      // return;
    }
  }

  Future buyAirtime(
      BuildContext context, amount, phoneNumber, network, biller) async {
    isLoading = true;

    isLoading = true;
    if (phoneNumber.isEmpty ||
        phoneNumber == '' ||
        network.isEmpty ||
        network == '') {
      customErrorDialog(context, 'Error', 'All fields are required');

      return;
    }
    Map<String, dynamic> body = {
      'amount': amount,
      'phoneNumber': phoneNumber,
      'network': network,
      'biller': biller
    };
    // //print("body");
    // //print(body);
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await appRepository.buyAirtime(body);
      if (response.success) {
        userController.fetchData();
        walletController.fetchWallet();
        EasyLoading.dismiss();
        // Navigator.pushNamed(context, RouteList.login);
        // successfulReceipt();
        // double earnedAmountNaira = 0.005 * amount;

        // // Convert the earned amount in naira to space points (1 space point = 2 naira)
        // double spacePoints = earnedAmountNaira / 2;

        // Calculate 0.5% of the recharge amount in naira
        int spacePoints = (0.0025 * amount).floor();

        // Convert the earned amount in naira to space points (1 space point = 2 naira)
        // double earnedAmountNaira = spacePoints * 2;

        // Check if spacePoints is a whole number
        // bool isWholeNumber = spacePoints % 1 == 0;

        // Format spacePoints based on whether it's a whole number or not
        // String formattedSpacePoints = isWholeNumber
        //     ? spacePoints.toStringAsFixed(0)
        //     : spacePoints.toStringAsFixed(2);
        if (amount >= 400) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              backgroundColor: Colors.green,
              message: 'You just earned $spacePoints Space point!',
              textStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        successfulReceipt(context, phoneNumber, amount, biller, 'Data to ');
        // Navi
        return;
      } else if (response.success == false &&
          response.message
              .contains("String must contain at least 10 character(s)")) {
        EasyLoading.dismiss();
        message = "Phone Number must be up to 10 characters long!!";
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        //print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message
              .contains("Number must be greater than or equal to 50")) {
        EasyLoading.dismiss();
        message = "Amount must be greate than or equal to 50 naira";
        // custTomDialog(context, message);
        Get.back();
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );

        return;
      } else if (response.success == false &&
          response.message.contains(
              "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again")) {
        EasyLoading.dismiss();
        message =
            "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again";
        // custTomDialog(context, message);
        Get.back();
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
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      //print(e);
      Get.back();
      message = "Ooops something went wrong";
      // custTomDialog(context, message);
      customErrorDialog(context, 'Error', message);
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     message: message,
      //   ),
      // );

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      // return;
    }
  }

  Future buyData(BuildContext context, amount, phoneNumber, selectDataPlan,
      network, validity) async {
    isLoading = true;
    //print("Fields");

    isLoading = true;
    if (phoneNumber.isEmpty ||
        phoneNumber == '' ||
        network.isEmpty ||
        network == '') {
      customErrorDialog(context, 'Error', 'All fields are required');

      return;
    }
    Map<String, dynamic> body = {
      'amount': amount,
      'phoneNumber': phoneNumber,
      'network': network,
      'selectDataPlan': selectDataPlan,
      'validity': validity,
    };
    //print("body");
    // //print(body);
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await appRepository.buyData(body);
      if (response.success) {
        userController.fetchData();
        walletController.fetchWallet();
        EasyLoading.dismiss();
        int spacePoints = (0.0025 * amount).floor();

        // Convert the earned amount in naira to space points (1 space point = 2 naira)
        // double earnedAmountNaira = spacePoints * 2;

        // Check if spacePoints is a whole number
        // bool isWholeNumber = spacePoints % 1 == 0;

        // Format spacePoints based on whether it's a whole number or not
        // String formattedSpacePoints = isWholeNumber
        //     ? spacePoints.toStringAsFixed(0)
        //     : spacePoints.toStringAsFixed(2);
        if (amount >= 400) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              backgroundColor: Colors.green,
              message: 'You just earned $spacePoints Space point!',
              textStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        successfulReceipt(context, phoneNumber, amount, network, 'Data to ');
        // Navi
        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        //print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message
              .contains("String must contain at least 10 character(s)")) {
        EasyLoading.dismiss();
        message = "Phone Number must be up to 10 characters long!!";
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message
              .contains("Number must be greater than or equal to 50")) {
        EasyLoading.dismiss();
        message = "Amount must be greate than or equal to 50 naira";
        // custTomDialog(context, message);
        Get.back();
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );

        return;
      } else if (response.success == false &&
          response.message.contains(
              "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again")) {
        EasyLoading.dismiss();
        message =
            "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again";
        // custTomDialog(context, message);
        Get.back();
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
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      //print(e);
      Get.back();
      message = "Ooops something went wrong";
      // custTomDialog(context, message);
      customErrorDialog(context, 'Error', message);
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     message: message,
      //   ),
      // );

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      // return;
    }
  }

  Future buyElectricity(BuildContext context, amount, phoneNumber, meterNumber,
      billingServiceID, email, electricityName) async {
    isLoading = true;
    //print("Fields");

    isLoading = true;
    if (phoneNumber.isEmpty ||
        phoneNumber == '' ||
        email.isEmpty ||
        email == '') {
      customErrorDialog(context, 'Error', 'All fields are required');

      return;
    }
    Map<String, dynamic> body = {
      'amount': amount,
      'phoneNumber': phoneNumber,
      'meterNumber': meterNumber,
      'billingServiceID': billingServiceID,
      'email': email,
    };
    //print("body");
    // //print(body);
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await appRepository.buyElectricity(body);
      if (response.success) {
        userController.fetchData();
        walletController.fetchWallet();
        EasyLoading.dismiss();
        var electricToken = response.message;
        int spacePoints = (0.0025 * amount).floor();
        Get.bottomSheet(
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 300.h,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        "Here is your Token: $electricToken",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          Get.back();
                          Share.share("Token: $electricToken");
                        },
                        child: Text(
                          'Copy to clipboard',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          elevation: 2,
          backgroundColor: Theme.of(context).canvasColor,
        );

        // Convert the earned amount in naira to space points (1 space point = 2 naira)
        // double earnedAmountNaira = spacePoints * 2;

        // Check if spacePoints is a whole number
        // bool isWholeNumber = spacePoints % 1 == 0;

        // Format spacePoints based on whether it's a whole number or not
        // String formattedSpacePoints = isWholeNumber
        //     ? spacePoints.toStringAsFixed(0)
        //     : spacePoints.toStringAsFixed(2);
        if (amount >= 400) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              backgroundColor: Colors.green,
              message: 'You just earned $spacePoints Space point!',
              textStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        // successfulReceipt(
        //     context, meterNumber, amount, electricityName, 'Electricity to ');
        // Navi
        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        //print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message
              .contains("String must contain at least 10 character(s)")) {
        EasyLoading.dismiss();
        message = "Phone Number must be up to 10 characters long!!";
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message
              .contains("Number must be greater than or equal to 500")) {
        EasyLoading.dismiss();
        message = "Amount must be greate than or equal to 500 naira";
        // custTomDialog(context, message);
        Get.back();
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );

        return;
      } else if (response.success == false &&
          response.message.contains(
              "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again")) {
        EasyLoading.dismiss();
        message =
            "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again";
        // custTomDialog(context, message);
        Get.back();
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
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      //print(e);
      Get.back();
      message = "Ooops something went wrong";
      // custTomDialog(context, message);
      customErrorDialog(context, 'Error', message);
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     message: message,
      //   ),
      // );

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      // return;
    }
  }

  Future buyCable(BuildContext context, amount, phoneNumber, smartCardNumber,
      billingServiceID, productCode, invoicePeriod, tvName) async {
    isLoading = true;
    //print("Fields");

    isLoading = true;
    if (phoneNumber.isEmpty || phoneNumber == '') {
      customErrorDialog(context, 'Error', 'All fields are required');

      return;
    }
    Map<String, dynamic> body = {
      'amount': amount,
      'phoneNumber': phoneNumber,
      'smartCardNumber': smartCardNumber,
      'billingServiceID': billingServiceID,
      'productCode': productCode,
      'invoicePeriod': invoicePeriod,
    };
    //print("body");
    // //print(body);
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await appRepository.buyCable(body);
      if (response.success) {
        userController.fetchData();
        walletController.fetchWallet();
        EasyLoading.dismiss();
        int spacePoints = (0.0025 * amount).floor();

        // Convert the earned amount in naira to space points (1 space point = 2 naira)
        // double earnedAmountNaira = spacePoints * 2;

        // Check if spacePoints is a whole number
        // bool isWholeNumber = spacePoints % 1 == 0;

        // Format spacePoints based on whether it's a whole number or not
        // String formattedSpacePoints = isWholeNumber
        //     ? spacePoints.toStringAsFixed(0)
        //     : spacePoints.toStringAsFixed(2);
        if (amount >= 400) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              backgroundColor: Colors.green,
              message: 'You just earned $spacePoints Space point!',
              textStyle: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        successfulReceipt(context, smartCardNumber, amount, tvName, 'Data to ');
        // Navi
        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        //print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message
              .contains("String must contain at least 10 character(s)")) {
        EasyLoading.dismiss();
        message = "Phone Number must be up to 10 characters long!!";
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message
              .contains("Number must be greater than or equal to 500")) {
        EasyLoading.dismiss();
        message = "Amount must be greate than or equal to 500 naira";
        // custTomDialog(context, message);
        Get.back();
        customErrorDialog(context, 'Error', message);
        // showTopSnackBar(
        //   Overlay.of(context),
        //   CustomSnackBar.error(
        //     message: message,
        //   ),
        // );

        return;
      } else if (response.success == false &&
          response.message.contains(
              "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again")) {
        EasyLoading.dismiss();
        message =
            "Duplicate Transaction. Please try again after 10 minutes if you want to perform the transaction again";
        // custTomDialog(context, message);
        Get.back();
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
        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      //print(e);
      Get.back();
      message = "Ooops something went wrong";
      // custTomDialog(context, message);
      customErrorDialog(context, 'Error', message);
      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     message: message,
      //   ),
      // );

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      // return;
    }
  }

  Future transferMoney(BuildContext context, bankCode, amount, accountNumber,
      pin, accountName, bankName) async {
    isLoading = true;
    //print("Fields");
    // //print(amount);
    // //print(bankCode);
    // //print(accountNumber);
    //print(pin);
    isLoading = true;
    if (bankCode.isEmpty ||
        bankCode == '' ||
        accountNumber.isEmpty ||
        accountNumber == '' ||
        pin.isEmpty ||
        pin == '' ||
        accountName.isEmpty ||
        accountName == '' ||
        bankName.isEmpty ||
        bankName == '') {
      customErrorDialog(context, 'Error', 'All fields are required');

      return;
    }
    Map<String, dynamic> body = {
      'bank_code': bankCode,
      'amount': amount,
      'accountNumber': accountNumber,
      'pin': pin
    };
    //print("body");
    // //print(body);
    String message;

    try {
      isLoading = true;
      state = const AsyncLoading();
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      final response = await appRepository.transferMoney(body);
      if (response.success) {
        EasyLoading.dismiss();
        state = const AsyncData(false);
        userController.fetchData();
        walletController.fetchWallet();
        Get.back();

        successfulReceipt(
            context, accountName, (amount + 20), bankName, 'Transfer to ');
        // Navigator.pushNamed(context, RouteList.login);
        // successfulReceipt();
        // Navi
        return;
      } else if (response.message.contains('Invalid token') ||
          response.message.contains('Invalid token or device')) {
        //print('error auth');
        multipleLoginRedirectModal();
      } else if (response.success == false &&
          response.message.contains("Incorrect PIN")) {
        EasyLoading.dismiss();
        message = "Incorrect PIN";

        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("Insufficient Balance")) {
        EasyLoading.dismiss();
        message = "Insufficient Balance";
        // custTomDialog(context, message);
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
        EasyLoading.dismiss();
        message = "Something went wrong";
        //print('This is the error $message');

        Get.back();
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      //print(e);
      message = "Ooops something went wrong";
      // custTomDialog(context, message);
      Get.back();
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
      //  return;
    }
  }
}
