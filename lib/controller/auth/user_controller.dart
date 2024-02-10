import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;

import '../../api/global_services.dart';
import '../../model/response/user_details_response.dart';

//
class UserDB {
  String? appBaseUrl = AppConstants.BASE_URL;
  late Map<String, String> _mainHeaders;
  String token = "";

  UserDB() {
    // Initialize headers without the token
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
  }

  Future<List<UserDetailsModel>> getUser() async {
    void updateHeaders(String newToken) {
      token = newToken;
      _mainHeaders['Authorization'] = 'Bearer $token';
    }

    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    try {
      final response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_USER),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Remove json.encode() from here
        // final jsonStr = json.encode(response.body); <-- Remove this line
        // print('jsonStr');
        // print(jsonStr);

        // Parse the JSON response directly
        final jsonBody = jsonDecode(response.body);
        print('jsonBody');
        print(jsonBody);
        print(UserProfileDetailsResponse.fromJson(jsonBody));
        print(UserProfileDetailsResponse.fromJson(jsonBody));
        UserProfileDetailsResponse responseBody =
            UserProfileDetailsResponse.fromJson(jsonBody);
        print(responseBody.userDetails);
        return responseBody.userDetails;
        // Other code...
      } else {
        print('response.body');
        print(response.body);
        throw Exception('Failed to load users: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      throw http.Response('Error: $e', 504);
    }
  }
}

class UserController extends GetxController {
  // final userDB = UserDB();
  final users = <UserDetailsModel>[].obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // user.bindStream(UserDB().getUser());
    // UserDB().getUser();
    // fetchUsers();
  }

  void login() {
    // Logic to perform login
    isLoggedIn.value = true;
  }

  void logout() {
    // Logic to perform logout
    isLoggedIn.value = false;
  }

  Future<void> fetchUsers() async {
    try {
      final List<UserDetailsModel> fetchedUsers = await UserDB().getUser();
      print('fetchedUsers');
      print(fetchedUsers);
      users.assignAll(fetchedUsers);
    } catch (e) {
      print('Error fetching users: $e');
      // Handle error (e.g., show error message)
    }
  }
}
