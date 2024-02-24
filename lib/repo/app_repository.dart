import 'dart:convert';
import 'dart:developer';

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
    print('Got here in app repo');
    print(body);

    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.CREATE_RENT, jsonEncode(body));
    log("response");
    print(response);
    log(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Spacerent Creation successful", true);
      return responseModel;
    }

    log("Here in repo${jsonDecode(response.body)}");

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      log("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }
  }

    Future<ResponseModel> walletDebit(body) async {
    print('Got here in wallet app repo');
    print(body);

    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.FUND_RENT_WITH_WALLET, jsonEncode(body));
    log("response");
    print(response);
    log(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Wallet Debit successful", true);
      return responseModel;
    }

    log("Here in repo${jsonDecode(response.body)}");

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      log("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }
  }


  Future<ResponseModel> verifyBVN(body) async {
    print('Got here in app repo');
    print(body);

    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.VERFIY_BVN, jsonEncode(body));
    log("response");
    print(response);
    log(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("BVN Verification successful", true);
      return responseModel;
    }

    log("Here in repo${jsonDecode(response.body)}");

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      log("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> bvnDebit(body) async {
    print('Got here in app repo');
    print(body);

    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.BVN_DEBIT, jsonEncode(body));
    log("response");
    print(response);
    log(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("BVN Debit successful", true);
      return responseModel;
    }

    log("Here in repo${jsonDecode(response.body)}");

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      log("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> createDva(body) async {
    print('Got here in app repo');
    print(body);

    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.BVN_DEBIT, jsonEncode(body));
    log("response");
    print(response);
    log(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("DVA Creation successful", true);
      return responseModel;
    }

    log("Here in repo${jsonDecode(response.body)}");

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      log("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }
  }
}
