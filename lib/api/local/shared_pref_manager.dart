import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:rentspace/constants/constants.dart';

import '../../model/response/user_details_response.dart';

class SharedPreferencesManager {
  late final SharedPreferences _prefs;

  Future<SharedPreferencesManager> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('Initialize');
    return this;
  }

  Future<bool> isLoggedIn() async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(IS_LOGGED_IN) ?? false;
  }

  Future<bool> setLoggedIn({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(IS_LOGGED_IN, value);
  }

  // Future<String> getPin() async {
  //   // final _prefs = await SharedPreferences.getInstance();
  //   return _prefs.getString(USER_TRANSACTION_PIN) ?? '';
  // }
  Future removeToken() async {}

  // Future<bool> setPin({required String value}) async {
  //   // final _prefs = await SharedPreferences.getInstance();
  //   return _prefs.setString(USER_TRANSACTION_PIN, value);
  // }

  Future<bool> hasSeenOnboarding() async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(HAS_SEEN_ONBOARDING) ?? false;
  }

  Future<bool> setHasSeenOnboarding({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(HAS_SEEN_ONBOARDING, value);
  }

  Future<bool> removeHasSeenOnboarding({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(HAS_SEEN_ONBOARDING, value);
  }

  Future<bool> setAuthToken({required String value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(TOKEN, value);
  }

  // Function to save login credentials and remember me status to shared preferences
  Future<void> saveLoginInfo(
      String email, String password, bool rememberMe) async {
    // final prefs = await SharedPreferences.getInstance();
    _prefs.setString('email', email);
    _prefs.setString('password', password);
    _prefs.setBool('rememberMe', rememberMe);
  }

  Future<void> deleteLoginInfo() async {
    // final prefs = await SharedPreferences.getInstance();
    _prefs.remove('email');
    _prefs.remove('password');
    _prefs.remove('rememberMe');
  }

  Future<String> getAuthToken() async {
    // final prefs = await SharedPreferences.getInstance();
    return _prefs.getString(TOKEN) ?? '';
  }

  Future<void> savePin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', newPin);
    // pin = newPin;
  }

  // Function to retrieve the user's PIN
  Future getPin() async {
    // final prefs = await SharedPreferences.getInstance();
    return _prefs.getString('pin');
  }

  // Function to update the user's PIN
  Future<void> updatePin(String newPin) async {
    await savePin(newPin);
    // Call your update PIN endpoint here
  }

  Future<bool> saveUserDetails(UserProfileDetailsResponse userDetails) async {
    try {
      String userDetailsJson = jsonEncode(userDetails.toJson());
      _prefs.setString(USER_DETAILS, userDetailsJson);
      print('printing ------');
      print(USER_DETAILS);
      getUserDetails();
      return true;
    } catch (e) {
      print('Error saving user details: $e');
      return false;
    }
  }

  Future<UserProfileDetailsResponse> getUserDetails() async {
    try {
      String userDetailsString = _prefs.getString(USER_DETAILS) ?? '';

      if (userDetailsString.isNotEmpty) {
        Map<String, dynamic> userDetailsMap = json.decode(userDetailsString);
        print('userDetailsMap');
        print(userDetailsMap);
        return UserProfileDetailsResponse.fromJson(userDetailsMap);
      } else {
        // Return a default or empty UserProfileDetailsResponse when no data is found
        return UserProfileDetailsResponse(msg: '', userDetails: []);
      }
    } catch (e) {
      print('Error getting user details: $e');

      return UserProfileDetailsResponse(msg: '', userDetails: []);
    }
  }
}
