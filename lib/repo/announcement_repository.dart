// // auth_repository.dart
// import 'dart:convert';

// import 'package:get/get.dart';

// import '../api/api_client.dart';
// import '../constants/app_constants.dart';
// import '../model/response_model.dart';

// final authRepositoryProvider = Provider((ref) {
//   final apiClient = ref.read(apiClientProvider);
//   return AnouncementRepository(apiClient);
// });
import 'dart:convert';

import 'package:get/get.dart';

import '../api/api_client.dart';
import '../constants/app_constants.dart';
import '../model/response_model.dart';

class AnouncementRepository   extends GetxController {
  final ApiClient _apiClient;

  AnouncementRepository(this._apiClient);

  RxString responseData = RxString('');

  Future<ResponseModel> fetchAnnouncementData(String url) async {
    print('Got here in announcement repo');
    ResponseModel responseModel;

    // String authToken =
    //     await GlobalService.sharedPreferencesManager.getAuthToken();
    // print('authToken');
    // print(authToken);

    // Update the headers in ApiClient with the obtained token
    // _apiClient.updateHeaders(authToken);
    Response response = await _apiClient.getData(AppConstants.GET_ANNOUNCEMENT);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      // List<dynamic> userDetails = responseBody['userDetails'];
      // await GlobalService.sharedPreferencesManager.saveUserDetails(userDetails);
      responseModel =
          ResponseModel('Announcement info retrieved successfully', true);
      return responseModel;
    }
    print("Here in get announcement repo${jsonDecode(response.body)}");
    var error = jsonDecode(response.body)['errors'].toString();

    //  print("Here in repo" + response.reasonPhrase.toString());
    return responseModel = ResponseModel(error, false);
  }
}


  // Future<ResponseModel> getUserData() async {
  //   print('Got here in user repo');
  //   ResponseModel responseModel;

  //   String authToken =
  //       await GlobalService.sharedPreferencesManager.getAuthToken();
  //   print('authToken');
  //   print(authToken);

  //   // Update the headers in ApiClient with the obtained token
  //   _apiClient.updateHeaders(authToken);
  //   Response response = await _apiClient.getData(AppConstants.GET_USER);
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responseBody = jsonDecode(response.body);
  //     List<dynamic> userDetails = responseBody['userDetails'];
  //     await GlobalService.sharedPreferencesManager.saveUserDetails(userDetails);
  //     responseModel = ResponseModel('User info retrieved successfully', true);
  //     return responseModel;
  //   }
  //   print(
  //       "Here in verify get user repo" + jsonDecode(response.body).toString());
  //   var error = jsonDecode(response.body)['errors'].toString();

  //   //  print("Here in repo" + response.reasonPhrase.toString());
  //   return responseModel = ResponseModel(error, false);
  // }