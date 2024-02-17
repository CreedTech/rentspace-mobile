import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/model/response/activities_response.dart';
// import 'package:rentspace/model/user_details_model.dart';

import 'package:http/http.dart' as http;

import '../../api/global_services.dart';
import '../model/activities_model.dart';

//
// class ActivitiesDB {
//   String? appBaseUrl = AppConstants.BASE_URL;
//   late Map<String, String> _mainHeaders;
//   String token = "";

//   ActivitiesDB() {
//     // Initialize headers without the token
//     _mainHeaders = {
//       'Content-type': 'application/json; charset=UTF-8',
//       'Accept': 'application/json',
//     };
//   }
//   final List<Activities> activities = [];
//   Future<ActivitiesResultModel> getActivities() async {
//     String authToken =
//         await GlobalService.sharedPreferencesManager.getAuthToken();
//     try {
//       final response = await http.get(
//         Uri.parse(AppConstants.BASE_URL + AppConstants.GET_ACTIVITIES),
//         headers: {
//           'Content-type': 'application/json; charset=UTF-8',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $authToken'
//         },
//       ).timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200) {
//         final jsonBody = jsonDecode(response.body);
//         print('result');
//         print(jsonBody);
//         return ActivitiesResultModel.fromJson(jsonBody);
//       } else {
//         throw Exception('Failed to load activities: ${response.reasonPhrase}');
//       }
//     } on TimeoutException {
//       throw http.Response('Network Timeout', 500);
//     } on http.ClientException catch (e) {
//       throw http.Response('HTTP Client Exception: $e', 500);
//     } catch (e) {
//       throw http.Response('Error: $e', 504);
//     }
//   }

//   // Future<List<Activities>> getActivities() async {
//   //   void updateHeaders(String newToken) {
//   //     token = newToken;
//   //     _mainHeaders['Authorization'] = 'Bearer $token';
//   //   }

//   //   String authToken =
//   //       await GlobalService.sharedPreferencesManager.getAuthToken();
//   //   print('authToken here');
//   //   print(authToken);
//   //   try {
//   //     final response = await http.get(
//   //         Uri.parse(AppConstants.BASE_URL + AppConstants.GET_ACTIVITIES),
//   //         headers: {
//   //           'Content-type': 'application/json; charset=UTF-8',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $authToken'
//   //         }).timeout(const Duration(seconds: 30));

//   //     if (response.statusCode == 200) {
//   //       // Remove json.encode() from here
//   //       // final jsonStr = json.encode(response.body); <-- Remove this line
//   //       // print('jsonStr');
//   //       // print(jsonStr);

//   //       // Parse the JSON response directly
//   //       for (Map<String, dynamic> i in jsonDecode(response.body)) {
//   //         activities.add(Activities.fromJson(i));
//   //         print('i here');
//   //         print(i.toString());
//   //       }
//   //       // print(articles);
//   //       return activities;
//   //       // final jsonBody = jsonDecode(response.body);
//   //       // print('jsonBody');
//   //       // print(jsonBody['userActivities']);
//   //       // print(ActivitiesResponse.fromJson(jsonBody));
//   //       // print(ActivitiesResponse.fromJson(jsonBody));
//   //       // ActivitiesResponse responseBody = ActivitiesResponse.fromJson(jsonBody);
//   //       // print(responseBody.activities);
//   //       // return responseBody.activities;
//   //       // Other code...
//   //     } else {
//   //       print('response.body');
//   //       print(response.body);
//   //       throw Exception('Failed to load activities: ${response.reasonPhrase}');
//   //     }
//   //   } on TimeoutException {
//   //     throw http.Response('Network Timeout', 500);
//   //   } on http.ClientException catch (e) {
//   //     throw http.Response('HTTP Client Exception: $e', 500);
//   //   } catch (e) {
//   //     throw http.Response('Error: $e', 504);
//   //   }
//   // }
// }

class ActivitiesController extends GetxController {
  // final userDB = UserDB();
  var isLoading = false.obs;
  final activities = <Activities>[].obs;
  ActivitiesModel? activitiesModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchActivities();
  }

  fetchActivities() async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_ACTIVITIES),
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

        activitiesModel = ActivitiesModel.fromJson(result);
        print(activitiesModel!.activities);
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

  // Future<void> fetchActivities() async {
  //   try {
  //     final ActivitiesResultModel result = await ActivitiesDB().getActivities();
  //     activities.assignAll(result.activities);
  //   } catch (e) {
  //     print('Error fetching activities: $e');
  //     // Handle error (e.g., show error message)
  //   }
  // }
}
