import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
      bill,
      landlordOrAgent,
      landlordOrAgentName,
      livesInSameProperty,
      // landlordOrAgentAddress,
      landlordOrAgentNumber,
      landlordAccountNumber,
      landlordBankName,
      // duration,
      propertyType,
      employmentStatus,
      position,
      netSalary,
      nameOfBusiness,
      cacNumber,
      estimatedMonthlyTurnOver,
      estimatedNetMonthlyProfit,
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
    print(spacerentId);
    print(reason);
    print(idCard);
    print(idNumber);
    print(bvn);
    print(phoneNumber);
    print(address);
    print(bill);
    print(landlordOrAgent);
    print(landlordOrAgentName);
    print(livesInSameProperty);
    // print(landlordOrAgentAddress);
    print(landlordOrAgentNumber);
    print(landlordAccountNumber);
    print(landlordBankName);
    // print(duration);
    print(propertyType);
    print(employmentStatus);
    print(position);
    print(netSalary);
    print(nameOfBusiness);
    print(cacNumber);
    print(estimatedMonthlyTurnOver);
    print(estimatedNetMonthlyProfit);
    print(guarantorName);
    print(guarantorRelationship);
    print(guarantorNumber);
    print(guarantorAddress);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    Map<String, dynamic> params = {
      "spaceRent": spacerentId,
      "reason": reason,
      "personalID": {
        "type": idCard,
        "idNumber": idNumber,
      },
      "landlordOrAgent": {
        "name": landlordOrAgentName,
        "livesInSameProperty":
            (livesInSameProperty.toString().toLowerCase() == 'yes'
                ? true
                : false),
        "address": address,
        "phoneNumber": landlordOrAgentNumber,
        "propertyType": propertyType,
        "accountNumber": landlordAccountNumber,
        "bankName": landlordBankName,
      },
      "occupation": {
        "status": employmentStatus,
        "details": {
          "position": position,
          "netSalary": num.tryParse(netSalary) ?? 0,
          'businessName': nameOfBusiness,
          'cacNumber': cacNumber,
          'estimatedMonthlyTurnover':
              num.tryParse(estimatedMonthlyTurnOver) ?? 0,
          'estimatedNetMonthlyProfit':
              num.tryParse(estimatedNetMonthlyProfit) ?? 0,
        }
      },
      "guarantor": {
        "name": guarantorName,
        "relationship": guarantorRelationship,
        "phoneNumber": guarantorNumber,
        "address": guarantorAddress
      }
    };
    print("params");
    print(params);
    // File imageFile = File(bill);
    // print(imageFile.path);
    try {
      http.Response response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.APPLY_FOR_LOAN}'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        var result = jsonDecode(response.body);
        print('result here');
        print(result);

        print('bill');
        print(bill);
        print('spacerentId');
        print(spacerentId);
        if (context.mounted) {
          uploadBill(context, bill, spacerentId);
        }
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
        print('error posting data');
        if (context.mounted) {
          customErrorDialog(context, 'Error', errorResponse['error']);
        }
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      print('Error while posting data is $e');
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

uploadBill(BuildContext context, dynamic bill, String rentspaceId) async {
  File imageFile = File(bill);
  print(imageFile);
  // Check if the file exists
  if (!await imageFile.exists()) {
    throw Exception("File not found: $bill");
  }
  print(imageFile.path);
  String authToken =
      await GlobalService.sharedPreferencesManager.getAuthToken();

  var headers = {'Authorization': 'Bearer $authToken'};
  EasyLoading.show(
    indicator: const CustomLoader(),
    maskType: EasyLoadingMaskType.black,
    dismissOnTap: false,
  );
  var request = http.MultipartRequest('POST',
      Uri.parse(AppConstants.BASE_URL + AppConstants.UPLOAD_UTILITY_BILL));
  request.files
      .add(await http.MultipartFile.fromPath('utility', imageFile.path));
  // request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  // request.fields['idType'] = idType;
  request.fields['spaceRent'] = rentspaceId;
  request.headers.addAll(headers);
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  EasyLoading.dismiss();
  if (response.statusCode == 200) {
    print(response);
    EasyLoading.dismiss();
    if (kDebugMode) {
      print('Image uploaded successfully');
    }
    // context.pop();

    // refreshController.refreshCompleted();
    // if (mounted) {
    //   setState(() {
    //     isRefresh = true;
    //   });
    // }

    // showTopSnackBar(
    //   Overlay.of(context),
    //   CustomSnackBar.success(
    //     backgroundColor: Colors.green,
    //     message: 'Your profile picture has been updated successfully. !!',
    //     textStyle: GoogleFonts.poppins(
    //       fontSize: 14,
    //       color: Colors.white,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );
    // await fetchUserData(refresh: true);
    // Get.to(FirstPage());
    if (context.mounted) {
      context.go('/loanApplicationSuccessPage');
    }
  } else {
    print(response);
    //  var errorResponse = jsonDecode(response.body);
    // print('Error: ${errorResponse['error']}');
    EasyLoading.dismiss();
    customErrorDialog(
        context, 'Error', response.reasonPhrase ?? 'Error Uploading');
    if (kDebugMode) {
      print(response.request);
    }
    if (kDebugMode) {
      print(response.reasonPhrase);
    }
    if (kDebugMode) {
      print('Image upload failed with status ${response.statusCode}');
    }
  }
}
