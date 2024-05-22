import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:local_session_timeout/local_session_timeout.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../constants/colors.dart';
import '../constants/widgets/custom_dialog.dart';
import '../model/utility_model.dart';
import '../view/login_page.dart';

class UtilityController extends GetxController {
    final sessionStateStream = StreamController<SessionState>();
  var isLoading = false.obs;
  // final rent = <Rent>[].obs;
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
        print('result');
        // print(result);
        print(UtilityHistoryModel.fromJson(result));

        utilityHistoryModel = UtilityHistoryModel.fromJson(result);
        print('Rent data successfully fetched');
        print(utilityHistoryModel!.utilityHistories!);
        if (utilityHistoryModel!.utilityHistories!.isEmpty) {
          // Show a message or handle the case where no space rent is found
          // For example, you can set a default value or display a message to the user
          print('No utility histories found');
        }
        isLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        print('error auth');
        multipleLoginRedirectModal();
      } else {
        // if (jsonDecode(response.body)['error'] == 'No Space Rent Found') {
        //   rentModel = ;
        // }
        // print(response.body);
        print('error fetching data');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      print('Error while getting data is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }
}
