import 'package:shared_preferences/shared_preferences.dart';
import 'package:rentspace/constants/constants.dart';
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

  Future<bool> setAuthToken({required String value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(TOKEN, value);
  }

  Future<String> getAuthToken() async {
    // final prefs = await SharedPreferences.getInstance();
    return _prefs.getString(TOKEN) ?? '';
  }


}
