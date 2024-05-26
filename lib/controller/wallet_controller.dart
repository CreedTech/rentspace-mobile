// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
// import 'package:rentspace/model/response/wallet_response.dart';
import 'package:rentspace/model/wallet_model.dart';
import 'package:http/http.dart' as http;

import '../api/global_services.dart';
import '../constants/app_constants.dart';
import '../constants/widgets/custom_dialog.dart';

class WalletController extends GetxController {
  final sessionStateStream = StreamController<SessionState>();
  var isLoading = true.obs;
  final wallet = <Wallet>[].obs;
  WalletModel? walletModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchWallet();
  }

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
      // // print('fetching here');
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        // // print(result);

        walletModel = WalletModel.fromJson(result);
        isLoading(false);
      } else if (response.body.contains('Invalid token') ||
          response.body.contains('Invalid token or device')) {
        // print('error auth');
        multipleLoginRedirectModal();
      } else {
        // // print(response.body);
        // print('error fetching data');
      }
    } on TimeoutException {
      throw http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      // print('Error while getting data is $e');
      throw http.Response('Error: $e', 504);
    } finally {
      isLoading(false);
    }
  }
}
