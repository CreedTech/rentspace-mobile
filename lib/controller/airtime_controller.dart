import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentspace/constants/app_constants.dart';
// import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;
import 'package:rentspace/model/airtime_model.dart';

import '../../api/global_services.dart';



class AirtimesController extends GetxController {
  // final userDB = UserDB();
  var isLoading = false.obs;
  final airtimes = <Airtimes>[].obs;
  AirtimesModel? airtimesModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchAirtimes();
  }

  fetchAirtimes() async {
     isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_AIRTIMES),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        print("result");
        // print(result);

        airtimesModel = AirtimesModel.fromJson(result);
        isLoading(false);
        print(airtimesModel!.airtimes);
      } else {
        print(response.body);
        print('error fetching data');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      print('Error while getting data activities is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }
}
