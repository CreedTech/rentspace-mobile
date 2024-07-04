// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../api/global_services.dart';
import '../../../constants/app_constants.dart';
import '../../model/utility_model.dart';
import '../../widgets/custom_dialogs/index.dart';

class UtilityController extends GetxController {
  var isLoading = false.obs;
  UtilityHistoryModel? utilityHistoryModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchUtilityHistories();
  }

  fetchUtilityHistories() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.UTILITY_HISTORY),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        utilityHistoryModel = UtilityHistoryModel.fromJson(result);
        if (utilityHistoryModel!.utilityHistories!.isEmpty) {
          // Show a message or handle the case where no utility  is found
          // For example, you can set a default value or display a message to the user
          // print('N utility histories found');
        }
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
}
