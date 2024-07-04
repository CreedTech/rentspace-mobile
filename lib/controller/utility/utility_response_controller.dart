// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/app_constants.dart';

import 'package:http/http.dart' as http;
import 'package:rentspace/model/response/utility_response_model.dart';

import '../../../api/global_services.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';
import '../../model/biller_item_model.dart';
import '../../model/response/customer_response_model.dart';
import '../../model/response/electricity_response_model.dart';

class UtilityResponseController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  final BuildContext context;

  UtilityResponseController(this.context);
  var isLoading = false.obs;
  var isValidationLoading = false.obs;
  final airtimes = <UtilityResponse>[].obs;
  UtilityResponseModel? utilityResponseModel;
  BillerItemResponseModel? billerItemResponseModel;
  CustomerResponseModel? customerResponseModel;
  ElectricityResponseModel? electricityResponseModel;

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
        utilityResponseModel = UtilityResponseModel.fromJson(result);
        isLoading(false);
        var billerLists = await Hive.openBox(categoryName);
        billerLists.put(categoryName, {
          'data':
              utilityResponseModel!.utilities!.map((x) => x.toJson()).toList(),
          'timestamp': categoryName
        });

        for (var i = 0; i < utilityResponseModel!.utilities!.length; i++) {
        }
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorResponse['error']);
        }
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      // print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }

  fetchBillerItem(String billerId, String divisionId, String productId) async {
    isLoading(true);
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      http.Response response = await http.get(
          Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.VFD_GET_BILLER_ITEMS}?billerId=$billerId&divisionId=$divisionId&productId=$productId',
          ),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        billerItemResponseModel = BillerItemResponseModel.fromJson(result);
        EasyLoading.dismiss();
        isLoading(false);
        var billerItems = await Hive.openBox(billerId);
        billerItems.put(billerId, {
          'data': billerItemResponseModel!.data.paymentItems
              .map((x) => x.toJson())
              .toList(),
          'timestamp': billerId
        });
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorResponse['error']);
        }
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      // print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      EasyLoading.dismiss();
      isLoading(false);
    }
  }

  Future validateCustomer(
    customerId,
    divisionId,
    paymentItem,
    productId,
    billerId,
  ) async {
    isValidationLoading(true);
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      http.Response response = await http.post(
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.VFD_VALIDATE_CUSTOMER}'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: json.encode(
          {
            "customerId": customerId,
            "divisionId": divisionId,
            "paymentItem": paymentItem,
            "productId": productId,
            "billerId": billerId
          },
        ),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        customerResponseModel = CustomerResponseModel.fromJson(result);
        EasyLoading.dismiss();
        isValidationLoading(false);
        var billerItems = await Hive.openBox('customerValidation_$billerId');

        var userData = customerResponseModel!.data.data;

        // Store the extracted data in the Hive box
        billerItems.put(billerId, {
          'data': userData.toJson(),
          'timestamp': DateTime.now().toIso8601String()
        });
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorResponse['error']);
        }
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      // print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      EasyLoading.dismiss();
      isValidationLoading(false);
    }
  }

  Future validateElectricityCustomer(
    customerId,
    divisionId,
    paymentItem,
    productId,
    billerId,
  ) async {
    isValidationLoading(true);
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    try {
      http.Response response = await http.post(
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.VFD_VALIDATE_CUSTOMER}'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: json.encode(
          {
            "customerId": customerId.toString(),
            "divisionId": divisionId.toString(),
            "paymentItem": paymentItem.toString(),
            "productId": productId.toString(),
            "billerId": billerId.toString()
          },
        ),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        electricityResponseModel = ElectricityResponseModel.fromJson(result);
        EasyLoading.dismiss();
        isValidationLoading(false);
        var billerItems =
            await Hive.openBox('customerElectricValidation_$billerId');

        var userData = electricityResponseModel!.data.data;

        // Store the extracted data in the Hive box
        billerItems.put(billerId, {
          'data': userData.toJson(),
          'timestamp': DateTime.now().toIso8601String()
        });
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorResponse['error']);
        }
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      // print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      EasyLoading.dismiss();
      isValidationLoading(false);
    }
  }
}
