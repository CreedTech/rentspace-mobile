import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
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
}
