// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/widgets/custom_loader.dart';
import 'package:rentspace/controller/auth/user_controller.dart';

import '../../repo/app_repository.dart';
import '../../view/savings/spaceRent/spacerent_success_page.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../wallet/wallet_controller.dart';

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
  AppController(this.appRepository) : super(const AsyncLoading());

  Future createRent(BuildContext context, rentName, dueDate, interval,
      intervalAmount, amount, paymentCount, date, duration) async {
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

        var rentspaceId = response.message;
        if (date == DateFormat('dd/MM/yyyy').format(DateTime.now())) {
          if (walletController.walletModel!.wallet![0].mainBalance <
              intervalAmount) {
            context.pop();
            insufficientFundsDialog(context);
          } else {
            await walletDebit(context, intervalAmount, amount, rentspaceId,
                    date, interval)
                .then(
              (value) => context.go('/success'),
            );
          }
        } else {
          context.go('/spacerentSuccessfulPage', extra: {
            'rentValue': amount,
            'savingsValue': intervalAmount,
            'startDate': date,
            'durationType': interval,
            'paymentCount': paymentCount,
            'rentName': rentName,
            'duration': duration,
            'receivalDate': dueDate
          });
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
        message = "Something went wrong.";
        customErrorDialog(context, 'Error', message);

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      state = AsyncError(e, StackTrace.current);
      // //rint(e);
      message = "Oops something went wrong.\n Try again later.";
      customErrorDialog(context, 'Error', message);

      return;
    } finally {
      EasyLoading.dismiss();
      isLoading = false;
      // return;
    }
  }

  Future walletDebit(BuildContext context, intervalAmount, amount, rentspaceId,
      date, interval) async {
    isLoading = true;

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
        return;
      } else {}

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
}
