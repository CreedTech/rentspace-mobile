// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/app_constants.dart';

import 'package:http/http.dart' as http;

import '../../../api/global_services.dart';
import '../../model/activities_model.dart';
import '../../widgets/custom_dialogs/index.dart';

class ActivitiesController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  var isLoading = false.obs;
  final activities = <Activities>[].obs;
  ActivitiesModel? activitiesModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchActivities();
  }

  fetchActivities() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_ACTIVITIES),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        activitiesModel = ActivitiesModel.fromJson(result);
        isLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else {
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }
}
