// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:local_session_timeout/local_session_timeout.dart';

import '../api/global_services.dart';
import '../constants/app_constants.dart';
import '../constants/widgets/custom_dialog.dart';
import '../model/data_bundle_model.dart';

class DataBundleController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  var isLoading = false.obs;
  DataBundleResponse? dataBundleResponse;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Initial data fetch if needed
  }

  Future<void> fetchDataBundles(String bundleType) async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      final response = await http
          .post(
            Uri.parse(
                '${AppConstants.BASE_URL}${AppConstants.GET_DATA_VARIATION_CODES}'),
            headers: {
              'Content-type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
            body: jsonEncode(<String, String>{
              "selectedNetwork": bundleType,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        var newDataBundleResponse = DataBundleResponse.fromJson(result);

        var bundleBox = await Hive.openBox('bundleData');
        var storedData = bundleBox.get(bundleType);

        if (storedData == null ||
            storedData['timestamp'] !=
                newDataBundleResponse.amountOptions[0].name) {
          // Save new data and timestamp/hash
          bundleBox.put(bundleType, {
            'data': newDataBundleResponse.amountOptions
                .map((x) => x.toJson())
                .toList(),
            'timestamp': newDataBundleResponse.amountOptions[0].name,
          });
          dataBundleResponse = newDataBundleResponse;
          // // print('Data bundle successfully fetched and updated');
        } else {
          // Load data from Hive
          var dataFromHive = storedData['data'];

          dataBundleResponse = DataBundleResponse(
            amountOptions: List<DataBundle>.from(
                dataFromHive.map((x) => DataBundle.fromJson(x))),
          );
          // // print('Data bundle loaded from Hive');
        }
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // // print('error auth');
        multipleLoginRedirectModal();
      } else {
        // // print('Error fetching data: ${response.statusCode}');
      }
    } on TimeoutException {
      // // print('Network Timeout');
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('HTTP Client Exception: $e');
      }
    } catch (e) {
      // // print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
