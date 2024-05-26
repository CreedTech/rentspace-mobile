// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;

import '../../api/global_services.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../model/recent_transfers_model.dart';

class UserController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  // final userDB = UserDB();
  var isLoading = false.obs;
  var isHomePageLoading = false.obs;
  final users = <UserDetailsModel>[].obs;
  var isLoadingRecentTransfers = false.obs;
  final List recentTempName = [];
  // var isLoggedIn = false.obs;
  UserModel? userModel;
  RecentTransfersModel? recentTransfersModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchData();
    fetchInitialData();
    // fetchRecentTransfers();
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
      // // print(body);

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      // print('Response Headers: ${response.headers}');
      if (response.statusCode == 200) {
        // var result = jsonDecode(response.body);
        EasyLoading.dismiss();
        isLoading(false);
        // print('result success');
        if (context.mounted) {
          customSuccessDialog(
              context, 'Success', 'Password Changed Successfully');
        }
        // print(result);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      }
      // else if (response.body.contains('error')) {
      //   EasyLoading.dismiss();
      //   isLoading(false);
      //   var errorResponse = jsonDecode(response.body)['error'];
      //   // print('Status: ${errorResponse['error']}');
      //   // print(response.body);
      //   // print('status fetching data');
      //   if (context.mounted) {
      //     // print('Context is mounted, showing dialog');
      //     customErrorDialog(context, 'Error', errorResponse);
      //   } else {
      //     // print('Context is not mounted, cannot show dialog');
      //   }
      // }
      else if (response.body.contains('Server Error')) {
        EasyLoading.dismiss();
        isLoading(false);
        if (context.mounted) {
          // print('Context is mounted, showing dialog');
          customErrorDialog(context, 'Oops', 'Something Went Wrong');
        } else {
          // print('Context is not mounted, cannot show dialog');
        }
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
        // print('Error: $errorMessage');
        // print(response.body);
        // print('error fetching data');
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

  fetchData() async {
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
        // // print(result);

        userModel = UserModel.fromJson(result);
        isLoading(false);
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
        // // print('result');
        // // print(result);
        // // print(SpaceRentModel.fromJson(result));

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
          // // print('Fetched details:');
        }
        // // print(recentTempName);
        // // print('recent transfers data successfully fetched');
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
}
