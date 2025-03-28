// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/model/spacerent_model.dart';
import 'package:http/http.dart' as http;

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_dialogs/index.dart';

class RentController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  var isLoading = false.obs;
  SpaceRentModel? rentModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchRent();
  }

  fetchRent() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_RENT),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        rentModel = SpaceRentModel.fromJson(result);
        if (rentModel!.rents!.isEmpty) {
          // Show a message or handle the case where no space rent is found
          // For example, you can set a default value or display a message to the user
        }
        isLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
    
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting data is $e');
      }
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }
}
