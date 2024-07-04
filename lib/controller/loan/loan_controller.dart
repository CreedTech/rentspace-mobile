import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';

class LoanController extends GetxController {
  final BuildContext context;

  LoanController(this.context);
  var isLoading = false.obs;
  var isValidationLoading = false.obs;
  // final airtimes = <UtilityResponse>[].obs;
  // UtilityResponseModel? utilityResponseModel;
  // BillerItemResponseModel? billerItemResponseModel;
  // CustomerResponseModel? customerResponseModel;
  // ElectricityResponseModel? electricityResponseModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    // fetchUtilitiesResponse();
  }

  Future applyForLoan(
      spacerentId,
      reason,
      idCard,
      idNumber,
      bvn,
      phoneNumber,
      address,
      landlordOrAgent,
      landlordOrAgentName,
      livesInSameProperty,
      landlordOrAgentAddress,
      landlordOrAgentNumber,
      duration,
      propertyType,
      employmentStatus,
      position,
      netSalary,
      nameOfBusiness,
      cacNumber,
      estimatedMonthlyTurnOver,
      estimatedNetMonthlyProfit,
      hasExistingLoans,
      howMuch,
      where,
      loanDuration,
      guarantorName,
      guarantorRelationship,
      guarantorNumber,
      guarantorAddress) async {
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
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.APPLY_FOR_LOAN}'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: json.encode({
          "spaceRent": "6658b3c978a8ffa66879bf6e",
          "reason": "Medical emergency",
          "landlordOrAgent": {
            "name": "John Doe",
            "livesInSameProperty": false,
            "address": "123 Main St, Anytown",
            "phoneNumber": "1234567890",
            "duration": "1 year",
            "propertyType": "Residential"
          },
          "occupation": {
            "status": "Employed",
            "details": {"position": "Software Engineer", "netSalary": 60000}
          },
          "guarantor": {
            "name": "Jane Smith",
            "relationship": "Friend",
            "phoneNumber": "9876543210",
            "address": "456 Elm St, Othertown"
          }
        }),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('result here');
        print(result);
        EasyLoading.dismiss();
        isValidationLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        isValidationLoading(false);
        var errorResponse = jsonDecode(response.body);
        print('Error: ${errorResponse['error']}');
        print(response.body);
        print('error fetching data');
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorResponse['error']);
        }
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
      EasyLoading.dismiss();
      isValidationLoading(false);
    }
  }
}
