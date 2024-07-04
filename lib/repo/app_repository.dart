// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentspace/api/global_services.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/model/response_model.dart';
import 'package:http/http.dart';

import '../api/api_client.dart';

final appRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AppRepository(apiClient);
});

class AppRepository {
  final ApiClient _apiClient;

  AppRepository(this._apiClient);

  Future<ResponseModel> createRent(body) async {
    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.CREATE_RENT, jsonEncode(body));
    if (response.statusCode == 200) {
      responseModel = ResponseModel(
          jsonDecode(response.body)['createSpaceRent']['rentspace_id'], true);
      return responseModel;
    }

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      if (kDebugMode) {
        print("Here in error$error");
      }
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> walletDebit(body) async {
    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.FUND_RENT_WITH_WALLET, jsonEncode(body));
    if (kDebugMode) {
      print("response");
    }
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Wallet Debit successful", true);
      return responseModel;
    }

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      if (kDebugMode) {
        print("Here in error$error");
      }
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> uploadImage(body) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postPhoto(AppConstants.UPDATE_PHOTO, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Photo Updated', true);
      return responseModel;
    }
    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      if (kDebugMode) {
        print("Here in error$error");
      }
      return responseModel = ResponseModel(error, false);
    }
  }
}
