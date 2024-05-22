import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/app_constants.dart';
// import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;
import 'package:rentspace/model/airtime_model.dart';
import 'package:rentspace/model/utility_response_model.dart';

import '../../api/global_services.dart';
import '../constants/colors.dart';
import '../constants/widgets/custom_dialog.dart';
import '../view/login_page.dart';

class UtilityResponseController extends GetxController {
    final sessionStateStream = StreamController<SessionState>();
  // final userDB = UserDB();
  var isLoading = false.obs;
  final airtimes = <UtilityResponse>[].obs;
  UtilityResponseModel? utilityResponseModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    // fetchUtilitiesResponse();
  }

  fetchUtilitiesResponse(String categoryName) async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(
              '${AppConstants.BASE_URL}${AppConstants.VFD_GET_BILLER_LISTS}?categoryName=$categoryName'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        print("result");
        print(result);

        utilityResponseModel = UtilityResponseModel.fromJson(result);
        isLoading(false);
        print('printing utilites...');
        for (var i = 0; i < utilityResponseModel!.utilities!.length; i++) {
          print(utilityResponseModel!.utilities![i].name);
        }
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        print('error auth');
        multipleLoginRedirectModal();
      } else {
        print(response.body);
        print('error fetching data');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }
}
