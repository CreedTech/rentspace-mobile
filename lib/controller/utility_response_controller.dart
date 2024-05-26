// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/app_constants.dart';
// import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;
import 'package:rentspace/model/utility_response_model.dart';

import '../../api/global_services.dart';
import '../constants/widgets/custom_dialog.dart';
import '../constants/widgets/custom_loader.dart';
import '../model/biller_item_model.dart';
import '../model/response/customer_response_model.dart';
import '../model/response/electricity_response_model.dart';

class UtilityResponseController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  final BuildContext context;

  UtilityResponseController(this.context);
  // final userDB = UserDB();
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
        // print("result");
        // print(result);

        utilityResponseModel = UtilityResponseModel.fromJson(result);
        isLoading(false);
        // print('// printing utilites...');
        var billerLists = await Hive.openBox(categoryName);
        // print(categoryName);
        billerLists.put(categoryName, {
          'data':
              utilityResponseModel!.utilities!.map((x) => x.toJson()).toList(),
          'timestamp': categoryName
        });

        // print('biller lists herefff');
        // print(billerLists.values);

        for (var i = 0; i < utilityResponseModel!.utilities!.length; i++) {
          // print(utilityResponseModel!.utilities![i].name);

          // var storedData = bundleBox.get(bundleType);
        }
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        // print('Error: ${errorResponse['error']}');
        // print(response.body);
        // print('error fetching data');
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
              '${AppConstants.BASE_URL}${AppConstants.VFD_GET_BILLER_ITEMS}?billerId=$billerId&divisionId=$divisionId&productId=$productId'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        // print('result');
        // print(result);
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

        // print('biller items hererr');
        // print(billerItems.values);

        // print('// printing biller items...');
        // print(billerItemResponseModel);
        // for (var i = 0; i < utilityResponseModel!.utilities!.length; i++) {
        //   // print(utilityResponseModel!.utilities![i].name);
        // }
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        // print('Error: ${errorResponse['error']}');
        // print(response.body);
        // print('error fetching data');
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
        // print('result here');
        // print(result);
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

        // print('biller items here');
        // print(billerItems.values);

        // print('// printing biller items...');
        // print(billerItemResponseModel);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        // print('Error: ${errorResponse['error']}');
        // print(response.body);
        // print('error fetching data');
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
    // print('informations');
    // print(customerId);
    // print(divisionId);
    // print("paymentItem : $paymentItem");
    // print(productId);
    // print('biller id $billerId');
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
// 62419148424
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
        // print('result ');
        // print(result['data']['data']['user']['name']);
        electricityResponseModel = ElectricityResponseModel.fromJson(result);
        // print(electricityResponseModel);
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

        // print('biller items here');
        // print(billerItems.values);

        // // print('// printing biller items...');
        // // print(billerItemResponseModel);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        // print('Error: ${errorResponse['error']}');
        // print(response.body);
        // print('error fetching data');
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
