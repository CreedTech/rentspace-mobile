import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentspace/model/response/rent_response.dart';
import 'package:rentspace/model/spacerent_model.dart';
import 'package:http/http.dart' as http;

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';

class RentDB {
  String? appBaseUrl = AppConstants.BASE_URL;
  late Map<String, String> _mainHeaders;
  String token = "";

  RentDB() {
    // Initialize headers without the token
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
  }

  Future<List<SpaceRent>> getRent() async {
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
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_WALLET),
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
        print(SpaceRentResponse.fromJson(jsonBody));
        print(SpaceRentResponse.fromJson(jsonBody));
        SpaceRentResponse responseBody = SpaceRentResponse.fromJson(jsonBody);
        print(responseBody.rent);
        return responseBody.rent;
        // Other code...
      } else {
        print('response.body');
        print(response.body);
        throw Exception('Failed to load wallet: ${response.reasonPhrase}');
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

class RentController extends GetxController {
  final rent = <SpaceRent>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRent();
  }

  Future<void> fetchRent() async {
    try {
      final List<SpaceRent> fetchedRentInfo = await RentDB().getRent();
      print('fetchedRentInfo');
      print(fetchedRentInfo);
      rent.assignAll(fetchedRentInfo);
    } catch (e) {
      print('Error fetching rent: $e');
      // Handle error (e.g., show error message)
    }
  }
}
