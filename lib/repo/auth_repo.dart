import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../api/api_client.dart';
import '../api/global_services.dart';
import '../constants/app_constants.dart';
import '../model/response/user_details_response.dart';
import '../model/response_model.dart';

final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRepository(apiClient);
});

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<ResponseModel> signUp(body) async {
    print('Got here in auth repo');
    print(body);
    ResponseModel responseModel;
    Response response = await _apiClient.postData(AppConstants.SIGN_UP, body);

    if (response.statusCode == 201) {
      responseModel = ResponseModel('account created', true);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyOtp(body) async {
    print('Got here in otp repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    // String authToken =
    //     await GlobalService.sharedPreferencesManager.getAuthToken();
    // print('authToken');
    // print(authToken);

    // // Update the headers in ApiClient with the obtained token
    // _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.VERIFY_CODE, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('User Verified', true);
      return responseModel;
    }
    print("Here in verify otp repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyBVN(body) async {
    ResponseModel responseModel;

    // String authToken =
    //     await GlobalService.sharedPreferencesManager.getAuthToken();

    // _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.VERFIY_BVN, jsonEncode(body));
    print("response");
    print(response);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("BVN Verification successful", true);
      return responseModel;
    }

    print("Here in repo${jsonDecode(response.body)}");

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> createDva(body) async {
    ResponseModel responseModel;

    // String authToken =
    //     await GlobalService.sharedPreferencesManager.getAuthToken();

    // _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.CREATE_DVA, jsonEncode(body));
    print("response");
    print(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("DVA Creation successful", true);
      return responseModel;
    }

    print("Here in repo${jsonDecode(response.body)}");

    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }
  }

  Future<ResponseModel> resendOTP(email) async {
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    // String authToken =
    //     await GlobalService.sharedPreferencesManager.getAuthToken();
    // print('authToken');
    // print(authToken);

    // Update the headers in ApiClient with the obtained token
    // _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.RESENDOTP, jsonEncode(email));
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    } else {
      var error = jsonDecode(response.body)['errors'].toString();
      responseModel = ResponseModel(error, false);
      return responseModel;
    }
  }

  Future<ResponseModel> signIn(body) async {
    print('Got here in auth repo');
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
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();
    if (jsonDecode(response.body)['error'] ==
        'User not verified, please verify your account') {
      error = 'User not verified, please verify your account';
    }
    if (jsonDecode(response.body)['error'] ==
        'BVN not verified, please verify your bvn to continue') {
      error = 'BVN not verified, please verify your bvn to continue';
    }

//  Here in repo{error: User not verified, please verify your account}
    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }
  Future<ResponseModel> postFcmToken(body) async {
    print('Got here in auth repo');
    ResponseModel responseModel;
    Response response =
        await _apiClient.postData(AppConstants.FCM_TOKEN, jsonEncode(body));

    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['token'];
      await GlobalService.sharedPreferencesManager.setAuthToken(value: token);

      responseModel = ResponseModel('logged in', true);
      _apiClient.updateHeaders(token);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();
    if (jsonDecode(response.body)['error'] ==
        'User not verified, please verify your account') {
      error = 'User not verified, please verify your account';
    }
    if (jsonDecode(response.body)['error'] ==
        'BVN not verified, please verify your bvn to continue') {
      error = 'BVN not verified, please verify your bvn to continue';
    }

//  Here in repo{error: User not verified, please verify your account}
    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> forgotPassword(email) async {
    print('Got here in auth repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.FORGOTPASSWORD, jsonEncode(email));
    print('response');
    print(response);
    print(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> resetPassword(body) async {
    print('Got here in auth repo');
    print(body);
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.RESET_PASSWORD, jsonEncode(body));
    print('response');
    print(response);
    print(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Password Reset Successful", true);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> resendPasswordOtp(email) async {
    print('Got here in auth repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.RESEND_PASSWORD_OTP, jsonEncode(email));
    print('response');
    print(response);
    print(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyForgotPasswordOtp(body) async {
    print('Got here in otp repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    print("Here in verify otp repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> getUserData() async {
    print('Got here in user repo');
    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    // print('authToken');
    // print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.getData(AppConstants.GET_USER);

    if (response.statusCode == 200) {
      UserProfileDetailsResponse responseBody =
          UserProfileDetailsResponse.fromJson(jsonDecode(response.body));

      await GlobalService.sharedPreferencesManager
          .saveUserDetails(responseBody);
      responseModel = ResponseModel('User info retrieved successfully', true);
      return responseModel;
    }
    print("Here in verify get user repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> logout() async {
    print('Got here in user repo');
    ResponseModel responseModel;

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    // print('authToken');
    // print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(AppConstants.LOGOUT, '');

    if (response.statusCode == 200) {
      // responseModel = ResponseModel("Code sent to your email", true);
      // return responseModel;
      print('response on logout');
      print(response.body);
      responseModel = ResponseModel('User logged out successfully', true);
      return responseModel;
    }
    print("Here in verify logout repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> createPin(body) async {
    print('Got here in auth repo');
    print(body);
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.CREATE_PIN, jsonEncode(body));
    print('response');
    print(response);
    print(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Pin Creation Successful", true);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    // var error = jsonDecode(response.body)['errors'].toString();
    if (response.body.contains('errors')) {
      var error = jsonDecode(response.body)['errors'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    } else {
      var error = jsonDecode(response.body)['error'].toString();
      print("Here in error$error");
      return responseModel = ResponseModel(error, false);
    }

    //  print("Here in repo" + response.reasonPhrase.toString());
    // return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> forgotPin() async {
    print('Got here in auth repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(AppConstants.FORGOT_PIN, '');
    print('response');
    print(response);
    print(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> resendPinOtp(email) async {
    print('Got here in auth repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.RESEND_PIN_OTP, jsonEncode(email));
    print('response');
    print(response);
    print(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel("Code sent to your email", true);
      return responseModel;
    }
    print("Here in repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> verifyForgotPinOtp(body) async {
    print('Got here in verify forgot pin otp repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.VERIFY_RESET_PIN_OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    print("Here in verify forgot pin otp repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> setNewPin(body) async {
    print('Got here in set new pin otp repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.SET_NEW_PIN_OTP, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    print("Here in set new pin otp repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> walletTransfer(body) async {
    print('Got here in verify forgot pin otp repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.postData(
        AppConstants.WALLET_TRANSFER, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Otp Verified', true);
      return responseModel;
    }
    print("Here in verify forgot pin otp repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }

  Future<ResponseModel> changePin(body) async {
    print('Got here in change  pin  repo');
    ResponseModel responseModel;
    // Call signIn method in SharedPreferencesManager to get the token
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken');
    print(authToken);

    // Update the headers in ApiClient with the obtained token
    _apiClient.updateHeaders(authToken);
    Response response =
        await _apiClient.postData(AppConstants.CHANGE_PIN, jsonEncode(body));

    if (response.statusCode == 200) {
      responseModel = ResponseModel('Changing Pin', true);
      return responseModel;
    }
    print("Here in change  pin  repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }
}
