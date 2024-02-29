import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentspace/model/spacerent_model.dart';
import 'package:http/http.dart' as http;

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';

class RentController extends GetxController {
  // final rent = <SpaceRent>[].obs;
  var isLoading = false.obs;
  // final rent = <Rent>[].obs;
  SpaceRentModel? rentModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchRent();
  }

  fetchRent() async {
    isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_RENT),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        print('result');
        print(result);
        print(SpaceRentModel.fromJson(result));

        rentModel = SpaceRentModel.fromJson(result);
        print('Rent data successfully fetched');
        print(rentModel!.rents!);
        if (rentModel!.rents!.isEmpty) {
          // Show a message or handle the case where no space rent is found
          // For example, you can set a default value or display a message to the user
          print('No space rent found');
        }
        isLoading(false);
      } else {
        // if (jsonDecode(response.body)['error'] == 'No Space Rent Found') {
        //   rentModel = ;
        // }
        print(response.body);
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
    }
  }
}
