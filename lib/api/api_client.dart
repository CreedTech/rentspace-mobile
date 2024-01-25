// auth_controller.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rentspace/constants/app_constants.dart';

class ApiClient extends GetxController {
  final String? appBaseUrl = AppConstants.BASE_URL;
  late Map<String, String> _mainHeaders;
  String token = "";

  final Rx<http.Response> postDataResponse =
      Rx<http.Response>(http.Response('', 500));

  @override
  void onInit() {
    super.onInit();
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
  }

  ApiClient() {
    // Initialize headers without the token
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
  }
  // Update headers with the token
  void updateHeaders(String newToken) {
    token = newToken;
    _mainHeaders['Authorization'] = 'Bearer $token';
  }

  Future<void> postData(String url, dynamic body) async {
    print('got to api client');

    try {
      final response = await http
          .post(
            Uri.parse(appBaseUrl! + url),
            headers: _mainHeaders,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Request was successful, return the response
        print(jsonDecode(response.body).toString());
        postDataResponse.value = response;
      } else {
        // Request failed with a non-2XX status code
        postDataResponse.value = http.Response(
            'Error: ${response.reasonPhrase}', response.statusCode);
        if (kDebugMode) {
          print(
              'Failed with non 2XX status code  ${jsonDecode(response.body)}');
        }
      }
    } on TimeoutException {
      postDataResponse.value = http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      postDataResponse.value = http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      var resp = http.Response('Error: $e', 504);
      print('Other exception  ${resp.reasonPhrase}');
      postDataResponse.value = resp;
    }
  }

  /*  Method to update data to backend  **/
  Future putData(url, body) async {
    //print("This is body" + body);
    print('This is token$token');
    http.Response response;
    try {
      response = await http
          .put(Uri.parse(AppConstants.BASE_URL + url),
              body: body, headers: _mainHeaders)
          .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      response = http.Response("Network Time out", 200);
    } catch (e) {
      print(e.toString());

      response = http.Response(e.toString(), 504);
    }
    return response;
    //var response = await http.put(url, body: body, headers: _mainHeaders);
  }

/*  Method to accept data from backend  **/
  Future getData(url) async {
    print('got to api client');
    try {
      final response = await http.get(Uri.parse(AppConstants.BASE_URL + url),
          headers: _mainHeaders);

      if (response.statusCode == 200) {
        // Request was successful, return the response
        print(jsonDecode(response.body).toString());
        return response;
      } else {
        // Request failed with a non-2XX status code
        http.Response('Error: ${response.reasonPhrase}', response.statusCode);
        print('Failed with non 2XX status code  ${jsonDecode(response.body)}');

        return response;
      }
    } on TimeoutException {
      return http.Response('Network Timeout', 500);
    } on http.ClientException catch (e) {
      return http.Response('HTTP Client Exception: $e', 500);
    } catch (e) {
      print('e');
      print(e);
      // Handle any other exceptions here
      var resp = http.Response('Error: $e', 504);
      print('Other exception  ${resp.reasonPhrase}');

      return resp;
    }

    // Response response = await get(url, headers: _mainHeaders);
    // return response;
  }

/*  Method to send photo to backend  **/
  Future postPhoto(String url, String imagePath) async {
    var headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'text/plain',
      'Authorization': 'Bearer $token'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(AppConstants.BASE_URL + url));
    request.fields.addAll({'URL': url});
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
