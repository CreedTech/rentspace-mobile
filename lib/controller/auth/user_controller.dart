import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;

import '../../api/global_services.dart';

class UserController extends GetxController {
  // final userDB = UserDB();
  var isLoading = false.obs;
  var isHomePageLoading = false.obs;
  final users = <UserDetailsModel>[].obs;
  // var isLoggedIn = false.obs;
  UserModel? userModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchData();
    fetchInitialData();
  }

  fetchData() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_USER),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        // print(result);

        userModel = UserModel.fromJson(result);
        isLoading(false);
      } else {
        // print(response.body);
        print('error fetching data');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      print('Error while getting data is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
      print('done');
    }
  }

  fetchInitialData() async {
    isHomePageLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isHomePageLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_USER),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        // print(result);

        userModel = UserModel.fromJson(result);
        isHomePageLoading(false);
      } else {
        // print(response.body);
        print('error fetching data');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      print('Error while getting data is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isHomePageLoading(false);
      print('done');
    }
  }
}
