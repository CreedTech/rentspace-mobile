// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:rentspace/main.dart';
import '../api/api_client.dart';
import '../api/global_services.dart';
import '../constants/app_constants.dart';
import '../model/response_model.dart';

final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRepository(apiClient);
});

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<ResponseModel> signUp(body) async {
    ResponseModel responseModel;
    Response response = await _apiClient.postData(AppConstants.SIGN_UP, body);

    if (response.statusCode == 201) {
      responseModel = ResponseModel('account created', true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyOtp(body) async {
    ResponseModel responseModel;

    Response response =
        await _apiClient.postData(AppConstants.VERIFY_CODE, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('User Verified', true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyBVN(body) async {
    ResponseModel responseModel;
    Response response =
        await _apiClient.postData(AppConstants.VERFIY_BVN, jsonEncode(body));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("BVN Verification successful", true);
      return responseModel;
    }

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> createDva(body) async {
    ResponseModel responseModel;

    Response response =
        await _apiClient.postData(AppConstants.CREATE_DVA, jsonEncode(body));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("DVA Creation successful", true);
      return responseModel;
    }

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> createProvidusDva(body) async {
    ResponseModel responseModel;
    Response response = await _apiClient.postData(
        AppConstants.PROVIDUS_CREATE_DVA, jsonEncode(body));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("DVA Creation successful", true);
      return responseModel;
    }

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> resendOTP(email) async {
    ResponseModel responseModel;

    Response response =
        await _apiClient.postData(AppConstants.RESENDOTP, jsonEncode(email));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> signIn(body) async {
    ResponseModel responseModel;
    Response response =
        await _apiClient.postData(AppConstants.LOGIN, jsonEncode(body));

    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['token'];
      await GlobalService.sharedPreferencesManager.setAuthToken(value: token);

      responseModel = ResponseModel('logged in', true);
      _apiClient.updateHeaders(token);
      return responseModel;
    }
    jsonDecode(response.body)['errors'].toString();
    if (jsonDecode(response.body)['error'] ==
        'User not verified, please verify your account') {}
    if (jsonDecode(response.body)['error'] ==
        'BVN not verified, please verify your bvn to continue') {}
    if (jsonDecode(response.body)['error'] ==
        'User already logged in on another device') {}
    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> singleDeviceLoginOtp(body) async {
    ResponseModel responseModel;

    Response response = await _apiClient.postData(
        AppConstants.SINGLE_DEVICE_LOGIN_OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified then login', true);
      return responseModel;
    }
    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> verifySingleDeviceLoginOtp(body) async {
    ResponseModel responseModel;
    Response response = await _apiClient.postData(
        AppConstants.VERIFY_SINGLE_DEVICE_LOGIN_OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> forgotPassword(email) async {
    ResponseModel responseModel;
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.FORGOTPASSWORD, jsonEncode(email));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> resetPassword(body) async {
    ResponseModel responseModel;
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.RESET_PASSWORD, jsonEncode(body));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Password Reset Successful", true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> resendPasswordOtp(email) async {
    ResponseModel responseModel;
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.RESEND_PASSWORD_OTP, jsonEncode(email));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyForgotPasswordOtp(body) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> logout() async {
    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(AppConstants.LOGOUT, '');

    if (response.statusCode == 200) {
      responseModel = ResponseModel('User logged out successfully', true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();
    print('error here');
    print(error);

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> createPin(body) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.CREATE_PIN, jsonEncode(body));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Pin Creation Successful", true);
      return responseModel;
    }
    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> forgotPin() async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(AppConstants.FORGOT_PIN, '');
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> resendPinOtp(email) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.RESEND_PIN_OTP, jsonEncode(email));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyForgotPinOtp(body) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.VERIFY_RESET_PIN_OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    // print("Here in verify forgot pin otp repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> setNewPin(body) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    // print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.SET_NEW_PIN_OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    // print("Here in set new pin otp repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> changePin(body) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.CHANGE_PIN, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Changing Pin', true);
      return responseModel;
    }
    // print("Here in change  pin  repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }
}
