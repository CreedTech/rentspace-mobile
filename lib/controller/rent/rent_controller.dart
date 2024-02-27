import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentspace/model/spacerent_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';

// class RentDB {
//   final Duration _fetchInterval = Duration(seconds: 30);
//   final StreamController<SpaceRent> _rentStreamController =
//       StreamController<SpaceRent>.broadcast();

//   Stream<SpaceRent> get rentStream => _rentStreamController.stream;

//   // static const String _rentKey = 'rentData';

//   String? appBaseUrl = AppConstants.BASE_URL;
//   late Map<String, String> _mainHeaders;
//   String token = "";

//   RentDB() {
//     // Initialize headers without the token
//     _mainHeaders = {
//       'Content-type': 'application/json; charset=UTF-8',
//       'Accept': 'application/json',
//     };
//   }

//   Future<void> startFetchingRent() async {
//     String authToken =
//         await GlobalService.sharedPreferencesManager.getAuthToken();
//     print('authToken here');
//     print(authToken);
//     try {
//       final response = await http.get(
//         Uri.parse(AppConstants.BASE_URL + AppConstants.GET_RENT),
//         headers: {
//           'Content-type': 'application/json; charset=UTF-8',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $authToken'
//           // Add any necessary authorization headers here
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonBody = jsonDecode(response.body);
//         // final List<dynamic> jsonData = jsonDecode(response.body);
//         print("jsonData");
//         print(jsonBody);
//         SpaceRentResponse responseBody = SpaceRentResponse.fromJson(jsonBody);
//         // final List<SpaceRent> rents =
//         //     jsonData.map((data) => SpaceRent.fromJson(data)).toList();
//         print("rents");
//         print(responseBody);
//         _rentStreamController.add(responseBody.rent);
//         // print(_rentKey);
//       } else {
//         // await prefs.remove(_rentKey);
//         throw Exception('Failed to fetch rent data: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       print('Error fetching rent: $e');
//       // You can handle errors here, such as retrying or logging
//     }
//   }

//   // Future<List<SpaceRent>> getRent() async {
//   //   void updateHeaders(String newToken) {
//   //     token = newToken;
//   //     _mainHeaders['Authorization'] = 'Bearer $token';
//   //   }

//   //       String authToken =
//   //       await GlobalService.sharedPreferencesManager.getAuthToken();
//   //   print('authToken here');
//   //   print(authToken);

//   //   try {
//   //     final response = await http.get(
//   //         Uri.parse(AppConstants.BASE_URL + AppConstants.GET_RENT),
//   //         headers: {
//   //           'Content-type': 'application/json; charset=UTF-8',
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $authToken'
//   //         }).timeout(const Duration(seconds: 30));

//   //     if (response.statusCode == 200) {

//   //       // Parse the JSON response directly
//   //       final jsonBody = jsonDecode(response.body);
//   //       print('jsonBody');
//   //       print(jsonBody);
//   //       print(SpaceRentResponse.fromJson(jsonBody));
//   //       print(SpaceRentResponse.fromJson(jsonBody));
//   //       SpaceRentResponse responseBody = SpaceRentResponse.fromJson(jsonBody);
//   //       print(responseBody.rent);
//   //       return responseBody.rent;
//   //       // Other code...
//   //     } else {
//   //       print('response.body');
//   //       print(response.body);
//   //       throw Exception('Failed to load wallet: ${response.reasonPhrase}');
//   //     }
//   //   } on TimeoutException {
//   //     throw http.Response('Network Timeout', 500);
//   //   } on http.ClientException catch (e) {
//   //     throw http.Response('HTTP Client Exception: $e', 500);
//   //   } catch (e) {
//   //     throw http.Response('Error: $e', 504);
//   //   }

//   // }

//   void stopFetchingRent() {
//     _rentStreamController.close();
//   }
// }

class RentController extends GetxController {
  final rent = <SpaceRent>[].obs;
  // final RentDB _rentService = RentDB();
  // late StreamSubscription<SpaceRent> _rentSubscription;
  var isLoading = false.obs;
  // final rent = <Rent>[].obs;
  SpaceRentModel? rentModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchRent();
  }

  // @override
  // void onClose() {
  //   _stopFetchingRent();
  //   super.onClose();
  // }
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

        rentModel = SpaceRentModel.fromJson(result);
        print('rentModel');
        print(rentModel);
        isLoading(false);
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
      print('Error while getting data is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }

  // startFetchingRent() async {
  //   isLoading(true);
  //   // rent.bindStream(_rentService.rentStream);
  //   _rentSubscription = _rentService.rentStream.listen((rents) {
  //     rent.assignAll(rents);
  //   });
  //   _rentService.startFetchingRent();
  //   isLoading(false);
  // }

  // void _stopFetchingRent() {
  //   _rentSubscription.cancel();
  //   _rentService.stopFetchingRent();
  // }

  // static const String _rentKey = 'rentData';

  // Future<List<SpaceRent>> getCachedRentData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey(_rentKey)) {
  //     final String cachedData = prefs.getString(_rentKey)!;
  //     final List<SpaceRent> cachedRent =
  //         SpaceRentResponse.fromJson(jsonDecode(cachedData)).rent;
  //     return cachedRent;
  //   } else {
  //     return [];
  //   }
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchRent();
  // }

  // Future<void> fetchRent() async {
  //   try {
  //     final List<SpaceRent> fetchedRentInfo = await RentDB().getRent();
  //     print('fetchedRentInfo');
  //     print(fetchedRentInfo);
  //     rent.assignAll(fetchedRentInfo);
  //   } catch (e) {
  //     print('Error fetching rent: $e');
  //     // Handle error (e.g., show error message)
  //   }
  // }
}
