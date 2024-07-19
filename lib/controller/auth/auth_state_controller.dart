import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';
import '../../view/auth/registration/login_page.dart';
import 'package:path_provider/path_provider.dart';

class AuthState extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  var isLoading = false.obs;
  Future<void> logout(BuildContext context) async {
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

      var response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.LOGOUT}'),
        headers: headers,
        // body: body,
      );

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        isLoading(false);
        // Perform any additional logout operations here
        // For example, navigating to the login screen
        await GlobalService.sharedPreferencesManager
            .deleteLoginInfo()
            .then((value) => null);
        // await GlobalService.sharedPreferencesManager.deleteDeviceInfo();
        final prefs = await SharedPreferences.getInstance();
        prefs
            .setBool('hasSeenOnboarding', false)
            .then((value) =>
                GlobalService.sharedPreferencesManager.deleteLoginInfo())
            .then(
              (value) => GlobalService.sharedPreferencesManager
                  .deleteLoginInfo()
                  .then((value) {
                GetStorage().erase().then((value) {
                  _deleteCacheDir().then((value) {
                    _deleteAppDir().then((value) {
                      // Clear all routes from the navigation stack
                      while (context.canPop()) {
                        context.pop();
                      }
                      // Navigate to the first page
                      context.go('/login');
                    });
                  });
                });
              }),
              // Get.offAll(
              //   LoginPage(
              //   ),
              // ),
            );
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (response.body.contains('Server Error')) {
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
        }
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
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      EasyLoading.dismiss();
      isLoading(false);
      throw http.Response('Error: $e', 504);
    } finally {
      EasyLoading.dismiss();
      isLoading(false);
    }
  }
}

final authState = AuthState();

Future<void> logoutUser(BuildContext context) async {
  await authState.logout(context);
  // Ensure that the UI updates after logout
  Get.forceAppUpdate(); // Force the entire app to update
}

Future<void> _deleteCacheDir() async {
  final cacheDir = await getTemporaryDirectory();

  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}

Future<void> _deleteAppDir() async {
  final appDir = await getApplicationSupportDirectory();

  if (appDir.existsSync()) {
    appDir.deleteSync(recursive: true);
  }
}
