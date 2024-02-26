import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
// import 'package:rentspace/model/response/wallet_response.dart';
import 'package:rentspace/model/wallet_model.dart';
import 'package:http/http.dart' as http;

import '../api/global_services.dart';
import '../constants/app_constants.dart';

// class WalletDB {
//   String? appBaseUrl = AppConstants.BASE_URL;
//   late Map<String, String> _mainHeaders;
//   String token = "";

//   WalletDB() {
//     _mainHeaders = {
//       'Content-type': 'application/json; charset=UTF-8',
//       'Accept': 'application/json',
//     };
//   }

//   Future<List<Wallet>> getWallet() async {
//     void updateHeaders(String newToken) {
//       token = newToken;
//       _mainHeaders['Authorization'] = 'Bearer $token';
//     }

//     String authToken =
//         await GlobalService.sharedPreferencesManager.getAuthToken();
//     print('authToken here');
//     print(authToken);

//     try {
//       final response = await http.get(
//           Uri.parse(AppConstants.BASE_URL + AppConstants.GET_WALLET),
//           headers: {
//             'Content-type': 'application/json; charset=UTF-8',
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $authToken'
//           }).timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200) {
//         // Remove json.encode() from here
//         // final jsonStr = json.encode(response.body); <-- Remove this line
//         // print('jsonStr');
//         // print(jsonStr);

//         // Parse the JSON response directly
//         final jsonBody = jsonDecode(response.body);
//         print('jsonBody');
//         print(jsonBody);
//         print(WalletResponse.fromJson(jsonBody));
//         print(WalletResponse.fromJson(jsonBody));
//         WalletResponse responseBody = WalletResponse.fromJson(jsonBody);
//         print(responseBody.wallet);
//         return responseBody.wallet;
//         // Other code...
//       } else {
//         print('response.body');
//         print(response.body);
//         throw Exception('Failed to load wallet: ${response.reasonPhrase}');
//       }
//     } on TimeoutException {
//       throw http.Response('Network Timeout', 500);
//     } on http.ClientException catch (e) {
//       throw http.Response('HTTP Client Exception: $e', 500);
//     } catch (e) {
//       throw http.Response('Error: $e', 504);
//     }
//   }
// }

class WalletController extends GetxController {
  var isLoading = true.obs;
  final wallet = <Wallet>[].obs;
  WalletModel? walletModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchWallet();
  }


  // UserDB() {
  //   // Initialize headers without the token
  //   _mainHeaders = {
  //     'Content-type': 'application/json; charset=UTF-8',
  //     'Accept': 'application/json',
  //   };
  // }

  fetchWallet() async {
     isLoading(true);
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    try {
      isLoading(true);
      http.Response response = await http.get(
          Uri.parse(AppConstants.BASE_URL + AppConstants.GET_WALLET),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken'
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        print(result);

        walletModel = WalletModel.fromJson(result);
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

  // Future<void> fetchWallet() async {
  //   try {
  //     final List<Wallet> fetchedWalletInfo = await WalletDB().getWallet();
  //     print('fetchedWalletInfo');
  //     print(fetchedWalletInfo);
  //     wallet.assignAll(fetchedWalletInfo);
  //   } catch (e) {
  //     print('Error fetching wallet: $e');
  //     // Handle error (e.g., show error message)
  //   }
  // }
}
