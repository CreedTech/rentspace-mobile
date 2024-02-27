// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/api/global_services.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/controller/activities_controller.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/view/home_page.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_payment.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/colors.dart';
import '../repo/app_repository.dart';
import '../view/actions/fund_wallet.dart';
import '../view/dashboard/dashboard.dart';
import 'wallet_controller.dart';

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
  final ActivitiesController activitiesController = Get.find();
  // bool get loading => _isLoading;
  AppController(this.appRepository) : super(const AsyncLoading());

  Future createRent(BuildContext context, dueDate, interval, intervalAmount,
      amount, paymentCount) async {
    isLoading = true;
    if (dueDate.isEmpty ||
            dueDate == '' ||
            interval.isEmpty ||
            interval == '' ||
            intervalAmount == '' ||
            amount == '' ||
            paymentCount.isEmpty ||
            paymentCount == ''
        // paymentType.isEmpty ||
        // paymentType == ''
        ) {
      customErrorDialog(
          context, 'Error', 'Please fill in the required fields!!');
      return;
    }
    Map<String, dynamic> params = {
      'due_date': dueDate,
      'interval': interval,
      'interval_amount': intervalAmount,
      'amount': amount,
      'payment_count': paymentCount,
      // 'payment_type': paymentType,
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

      var response = await appRepository.createRent(params);
      if (response.success) {
        EasyLoading.dismiss();
        // await GlobalService.
        if (walletController.walletModel!.wallet![0].mainBalance <
            intervalAmount) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                      elevation: 0,
                      alignment: Alignment.bottomCenter,
                      insetPadding: const EdgeInsets.all(0),
                      scrollable: true,
                      title: null,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      content: SizedBox(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                            color: brandOne,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                                Get.to(const FundWallet());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 60,
                                                        vertical: 15),
                                                textStyle: const TextStyle(
                                                    color: brandFour,
                                                    fontSize: 13),
                                              ),
                                              child: const Text(
                                                "Fund Wallet",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        } else {
          walletDebit(context);
        }
        // if (paymentType == "Debit Card") {
        //   Get.to(
        //     SpaceRentFunding(
        //       amount: intervalAmount,
        //       interval: interval,
        //     ),
        //   );
        // } else {

        // }

        return;
      } else {
        print('response.message.toString()');
      }
      print(response.message.toString());
      if (response.success == false &&
          response.message.contains("Space Rent already exists")) {
        EasyLoading.dismiss();
        message =
            "You already have an on-going space rent. Please restart app.";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains(
              "Due date must be between 6 and 8 months from the current date")) {
        EasyLoading.dismiss();
        print(response);
        message =
            "Oops! Due date must be between 6 and 8 months from the current date";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        print('response again');
        print(response.success);
        print(response.message);
        message = "Something went wrong.";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      print(e);
      message = "Oops something went wrong.\n Try again later.";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      isLoading = false;
    }
  }

  Future walletDebit(BuildContext context) async {
    isLoading = true;
    // if (bvn.isEmpty || bvn == '') {
    //   customErrorDialog(context, 'Error', 'Please input your bvn!!');
    //   return;
    // }
    Map<String, dynamic> params = {};
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
      var response = await appRepository.walletDebit(params);
      if (response.success) {
        EasyLoading.dismiss();

        // Get.offAll(const FirstPage());
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
        print('response.message.toString()');
      }
      print(response.message.toString());

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("Rent not found")) {
        EasyLoading.dismiss();
        message = "Space Rent Not Found";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        print('response again');
        print(response.success);
        print(response.message);
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

  Future verifyBVN(BuildContext context, bvn) async {
    isLoading = true;
    if (bvn.isEmpty || bvn == '') {
      customErrorDialog(context, 'Error', 'Please input your bvn!!');
      return;
    }
    Map<String, dynamic> params = {
      'bvn': bvn,
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
      var response = await appRepository.verifyBVN(params);
      if (response.success) {
        EasyLoading.dismiss();
        createDva(context);
        // bvnDebit(context, bvn).then(
        //   (value) => createDva(context),
        // );
        // Get.offAll(const FirstPage());
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
        print('response.message.toString()');
      }
      print(response.message.toString());

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User already has bvn verified")) {
        EasyLoading.dismiss();
        message = "User already has bvn verified";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("User with this BVN already exists")) {
        EasyLoading.dismiss();
        print('response here');
        print(response.success);
        print(response);
        message = "Oops! User with this BVN already exists";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        print('response again');
        print(response.success);
        print(response.message);
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

  Future bvnDebit(BuildContext context, bvn) async {
    isLoading = true;
    if (bvn.isEmpty || bvn == '') {
      customErrorDialog(context, 'Error', 'Please input your bvn!!');
      return;
    }
    Map<String, dynamic> params = {
      'bvn': bvn,
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
      var response = await appRepository.bvnDebit(params);
      if (response.success) {
        EasyLoading.dismiss();

        // Get.offAll(const FirstPage());
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
        print('response.message.toString()');
      }
      print(response.message.toString());

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User already has bvn verified")) {
        EasyLoading.dismiss();
        message = "User already has bvn verified";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("User with this BVN already exists")) {
        EasyLoading.dismiss();
        print('response here');
        print(response.success);
        print(response);
        message = "Oops! User with this BVN already exists";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        print('response again');
        print(response.success);
        print(response.message);
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

  Future createDva(BuildContext context) async {
    isLoading = true;
    // if (
    //   dvaName.isEmpty ||
    //     dvaName == ''
    //   customerEmail.isEmpty ||
    //     customerEmail == ''
    //   dvaName.isEmpty ||
    //     dvaName == ''
    //   dvaName.isEmpty ||
    //     dvaName == ''
    //   dvaName.isEmpty ||
    //     dvaName == ''
    //     ) {
    //   customErrorDialog(
    //       context, 'Error', 'Please input your bvn!!');
    //   return;
    // }
    Map<String, dynamic> params = {};
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
      var response = await appRepository.createDva(params);
      if (response.success) {
        EasyLoading.dismiss();
        // Get.offAll(const FirstPage());
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
        print('response.message.toString()');
      }
      print(response.message.toString());

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("User already has DVA")) {
        EasyLoading.dismiss();
        message = "User already has a Virtual Account";
        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message.contains("User with this BVN already exists")) {
        EasyLoading.dismiss();
        print('response here');
        print(response.success);
        print(response);
        message = "Oops! User with this BVN already exists";
        customErrorDialog(context, 'Error', message);

        return;
      } else {
        EasyLoading.dismiss();
        // to capture other errors later
        print('response again');
        print(response.success);
        print(response.message);
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

  Future buyAirtime(
      BuildContext context, amount, phoneNumber, network, biller) async {
    isLoading = true;
    print("Fields");
    print(amount);
    print(phoneNumber);
    print(network);
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
      final response = await appRepository.buyAirtime(body);
      if (response.success) {
        EasyLoading.dismiss();
        // Navigator.pushNamed(context, RouteList.login);
        // SucessfulReciept();
        // Navi
        return;
      } else if (response.success == false &&
          response.message
              .contains("String must contain at least 10 character(s)")) {
        EasyLoading.dismiss();
        message = "Phone Number must be up to 10 characters long!!";

        customErrorDialog(context, 'Error', message);

        return;
      } else if (response.success == false &&
          response.message
              .contains("Number must be greater than or equal to 50")) {
        EasyLoading.dismiss();
        message = "Amount must be greate than or equal to 50 naira";
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
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      print(e);
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
      isLoading = false;
    }
  }
}
