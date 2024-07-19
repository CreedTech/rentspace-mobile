// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;
import 'package:rentspace/view/savings/spaceRent/spacerent_withdrawal.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_withdrawal_continuation_page.dart';
import 'package:rentspace/view/withdrawal/withdraw_continuation_page.dart';
import 'package:rentspace/view/auth/registration/login_page.dart';

import '../../api/global_services.dart';
import '../../constants/utils/errorMessageExtraction.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';
import '../../model/recent_transfers_model.dart';

class UserController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  var isLoading = false.obs;
  var isHomePageLoading = false.obs;
  final users = <UserDetailsModel>[].obs;
  var isLoadingRecentTransfers = false.obs;
  final List recentTempName = [];
  UserModel? userModel;
  RecentTransfersModel? recentTransfersModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchData();
    fetchInitialData();
  }

  Future changePassword(BuildContext context, currentPassword, newPassword,
      repeatNewPassword) async {
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
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "repeatNewPassword": repeatNewPassword,
      });

      var response = await http.put(
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.CHANGE_PASSWORD}'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        isLoading(false);
        if (context.mounted) {
          customSuccessDialog(
              context, 'Success', 'Password Changed Successfully');
          while (context.canPop()) {
            context.pop();
          }
          // Navigate to the first page
          context.go('/login');
        }
        // Get.offAll(
        //   const LoginPage(),
        // );
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else if (response.body.contains('Server Error')) {
        EasyLoading.dismiss();
        isLoading(false);
        if (context.mounted) {
          customErrorDialog(context, 'Oops', 'Something Went Wrong');
        } else {}
      } else {
        EasyLoading.dismiss();
        isLoading(false);
        var errorResponse = jsonDecode(response.body);
        String errorMessage;
        if (errorResponse.containsKey('errors') &&
            errorResponse['errors'].isNotEmpty) {
          errorMessage = errorResponse['errors'][0]['error'];
        } else {
          errorMessage = 'An unknown error occurred';
        }
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorMessage);
        }
      }
    } on TimeoutException {
      EasyLoading.dismiss();
      isLoading(false);
      if (context.mounted) {
        customErrorDialog(context, 'Error', 'Network Timeout');
      }
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      EasyLoading.dismiss();
      isLoading(false);
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      EasyLoading.dismiss();
      isLoading(false);
      // print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      EasyLoading.dismiss();
      isLoading(false);
    }
  }

  Future fetchData() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_USER),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        userModel = UserModel.fromJson(result);
        // final Box<dynamic> settingsHiveBox = Hive.box('settings');
        //     settingsHiveBox.put('userInfo', userModel!.userDetails![0]);

        final box = Hive.box('settings');
        final existingUser = box.get('userInfo') as String?;

        // if (existingUser == null || existingUser != userModel) {
        //   box.put('userInfo', userModel);
        // }
        if (existingUser == null || existingUser != jsonEncode(result)) {
          box.put('userInfo', jsonEncode(result));
        }

        // print(userModel);
        isLoading(false);
        return userModel;
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        print('error auth');
        multipleLoginRedirectModal();
      } else {
        // // print(response.body);
        if (kDebugMode) {
          print('error fetching data ${response.body}');
        }
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Error while getting data is $e');
      }
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting data is $e');
      }
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
      // print('done');
    }
  }

  fetchInitialData() async {
    isHomePageLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isHomePageLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_USER),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        // // print(result);

        userModel = UserModel.fromJson(result);
        isHomePageLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        // // print(response.body);
        // print('error fetching data');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isHomePageLoading(false);
      // print('done');
    }
  }

  fetchRecentTransfers() async {
    isLoadingRecentTransfers(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.RECENT_TRANSFERS),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        recentTransfersModel = RecentTransfersModel.fromJson(result);
        recentTempName.clear();

        // Iterate over recent transfers and fetch account details
        for (int i = 0;
            i < recentTransfersModel!.recentTransfers!.length;
            i++) {
          await getAccountDetails(
            recentTransfersModel!.recentTransfers![i].bankCode,
            recentTransfersModel!.recentTransfers![i].accountNumber,
          );
        }
        if (recentTransfersModel!.recentTransfers!.isEmpty) {
          // // print('No recent transfers found');
        }
        isLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        // print('error fetching data');
      }
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

  getAccountDetails(String bankCode, String accountNumber) async {
    isLoadingRecentTransfers(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    final response = await http.post(
        Uri.parse(AppConstants.BASE_URL + AppConstants.VERFIY_ACCOUNT_DETAILS),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode(
            {"financial_institution": bankCode, "account_id": accountNumber}));

    if (response.statusCode == 200) {
      // print('fetched successfully');
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final userBankName = jsonResponse['account'][0]["account_name"];
      final userBank = jsonResponse['account'][0]["bank"]['name'];
      final userBankAccountNo = jsonResponse['account'][0]["account_id"];

      final newEntry = [userBankName, userBank, userBankAccountNo];

      // Avoid adding duplicates
      if (!recentTempName.contains(newEntry)) {
        recentTempName.add(newEntry);
      }
    } else if (response.body.contains('Invalid token') ||
        response.body.contains('Invalid token or device')) {
      // print('error auth');
      multipleLoginRedirectModal();
    } else {
      // print('error fetching details');

      // print(
      // 'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  Future createWithdrawalAccount(
      BuildContext context,
      withdrawalType,
      String bankCode,
      String accountNumber,
      bankName,
      accountHolderName) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    isLoadingRecentTransfers(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      final response = await http.post(
        Uri.parse(AppConstants.BASE_URL +
            AppConstants.PROVIDUS_CREATE_WITHDRAWAL_ACCOUNT),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode(
          {
            "accountHolderName": accountHolderName,
            "bankName": bankName,
            "accountNumber": accountNumber,
            "bankCode": bankCode
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        isLoadingRecentTransfers(false);
        // if (context.mounted) {
        //   context.go('/firstpage');
        // }

        if (context.mounted) {
          (withdrawalType == 'space rent')
              ? context.go('/firstpage')
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawContinuationPage(
                      bankCode: bankCode,
                      accountNumber: accountNumber,
                      bankName: bankName,
                      accountHolderName: accountHolderName,
                    ),
                  ),
                );
        }
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        EasyLoading.dismiss();
        isLoadingRecentTransfers(false);
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        EasyLoading.dismiss();
        isLoadingRecentTransfers(false);
        var errorResponse = jsonDecode(response.body);
        String errorMessage;
        if (response.body.contains('error') ||
            response.body.contains('message') ||
            response.body.contains('errors')) {
          // setState(() {
          errorMessage = extractErrorMessage(errorResponse);
          if (context.mounted) {
            customErrorDialog(context, 'Error', errorMessage);
          }
          // });
        }
        // print('error fetching details');

        // print(
        // 'Request failed with status: ${response.statusCode}, ${response.body}');
      }
    } on TimeoutException {
      EasyLoading.dismiss();
      isLoadingRecentTransfers(false);
      if (context.mounted) {
        customErrorDialog(context, 'Error', 'Network Timeout');
      }
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      EasyLoading.dismiss();
      isLoadingRecentTransfers(false);
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      EasyLoading.dismiss();
      isLoadingRecentTransfers(false);
      // print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      EasyLoading.dismiss();
      isLoadingRecentTransfers(false);
    }
  }
}
