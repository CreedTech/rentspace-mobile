// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/app_constants.dart';

import 'package:http/http.dart' as http;
import 'package:rentspace/model/airtime_model.dart';
import 'package:rentspace/view/sucess/success_screen.dart';

import '../../../api/global_services.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';

class AirtimesController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  final BuildContext context;

  AirtimesController(this.context);
  var isLoading = false.obs;
  final airtimes = <Airtimes>[].obs;
  AirtimesModel? airtimesModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    // fetchAirtimes();
  }

  fetchAirtimes() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_AIRTIMES),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        airtimesModel = AirtimesModel.fromJson(result);
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
      if (kDebugMode) {
        print('Error while getting data activities is $e');
      }
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }

  payBill(customerId, amount, division, paymentItem, productId, billerId,
      category, name) async {
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
        "customerId": customerId,
        "amount": amount.toString(),
        "division": division,
        "paymentItem": paymentItem,
        "productId": productId,
        "billerId": billerId,
      });

      var response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.VFD_PAY_BILL}'),
        headers: headers,
        body: body,
      );
  

      if (jsonDecode(response.body)['status'] == '00') {
        var result = jsonDecode(response.body);
        EasyLoading.dismiss();
        isLoading(false);
        Get.to(
          SuccessFulScreen(
            name: name,
            image: name,
            category: category,
            amount: amount,
            billerId: billerId,
            number: customerId,
            date: DateTime.now().toString(),
            token: result['data']['token'],
          ),
        );
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else if (jsonDecode(response.body)['status'] == '99') {
        EasyLoading.dismiss();
        isLoading(false);
        var errorResponse = jsonDecode(response.body);
        Get.back();
        if (context.mounted) {
          // print('Context is mounted, showing dialog');
          customErrorDialog(context, 'Error', errorResponse['message']);
        } else {
          // print('Context is not mounted, cannot show dialog');
        }
      } else {
        EasyLoading.dismiss();
        isLoading(false);
        var errorResponse = jsonDecode(response.body);
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorResponse['error']);
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
}
