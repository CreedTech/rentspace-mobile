// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:rentspace/model/wallet_model.dart';
import 'package:http/http.dart' as http;
import 'package:rentspace/view/sucess/withdrawal_success_screen.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/utils/errorMessageExtraction.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';

class WalletController extends GetxController {
  var isLoading = true.obs;
  final wallet = <Wallet>[].obs;
  WalletModel? walletModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchWallet();
  }

  fetchWallet() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_WALLET),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        walletModel = WalletModel.fromJson(result);
        isLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else {}
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }

  Future walletWithdrawal(
      BuildContext context,
      beneficiaryAccountName,
      transactionAmount,
      narration,
      sourceAccountName,
      beneficiaryAccountNumber,
      beneficiaryBank,
      pin,
      bankName) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    isLoading(true);

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      var body = json.encode({
        "beneficiaryAccountName": beneficiaryAccountName,
        "transactionAmount": transactionAmount,
        "currencyCode": 'NGN',
        "narration": narration,
        "sourceAccountName": sourceAccountName,
        "beneficiaryAccountNumber": beneficiaryAccountNumber,
        "beneficiaryBank": beneficiaryBank,
        "pin": pin
      });

      var response = await http.post(
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.PROVIDUS_WALLET_WITHDRAWAL}'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WithdrawalSuccessfulScreen(
              name: beneficiaryAccountName,
              image: 'bank_icon',
              category: 'withdrawal',
              amount: transactionAmount,
              bank: bankName,
              number: beneficiaryAccountNumber,
              date: DateTime.now().toString(),
            ),
          ),
        );
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        EasyLoading.dismiss();
        isLoading(false);
        multipleLoginRedirectModal();
      } else {
        var errorResponse = jsonDecode(response.body);
        String errorMessage;
        if (response.body.contains('error') ||
            response.body.contains('message') ||
            response.body.contains('errors')) {
          errorMessage = extractErrorMessage(errorResponse);
          if (context.mounted) {
            customErrorDialog(context, 'Error', errorMessage);
          }
        }
        EasyLoading.dismiss();
        isLoading(false);
      }
    } on TimeoutException {
      if (context.mounted) {
        customErrorDialog(context, 'Error', 'Network Timeout');
      }
      EasyLoading.dismiss();
      isLoading(false);
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      if (context.mounted) {
        customErrorDialog(context, 'Error', 'Something went Wrong');
      }
      EasyLoading.dismiss();
      isLoading(false);
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (context.mounted) {
        customErrorDialog(
            context, 'Error', 'Something went Wrong. Try Again Later.');
      }

      EasyLoading.dismiss();
      isLoading(false);
      throw http.Response('Error: $e', 504);
    } finally {}
  }
}
