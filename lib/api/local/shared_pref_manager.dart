import 'package:shared_preferences/shared_preferences.dart';
import 'package:rentspace/constants/constants.dart';

class SharedPreferencesManager {
  late final SharedPreferences _prefs;

  Future<SharedPreferencesManager> init() async {
    _prefs = await SharedPreferences.getInstance();
    // print('Initialize');
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
  Future<void> removeToken() async {
    _prefs.remove('token');
  }

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

  Future<bool> userAllowedNotifications({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool('USER_ALLOWED_NOTIFICATIONS', value);
  }

  Future<bool> removeHasSeenOnboarding({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(HAS_SEEN_ONBOARDING, value);
  }

  Future<bool> setAuthToken({required String value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(TOKEN, value);
  }

  Future<bool> setFCMToken({required String value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('fcm_token', value);
  }

  Future<void> setDevieInfo(String deviceType, String deviceModel) async {
    // final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('device_type', deviceType);
    _prefs.setString('device_model', deviceModel);
  }

  Future<void> deleteDeviceInfo() async {
    // final prefs = await SharedPreferences.getInstance();
    _prefs.remove('device_type');
    _prefs.remove('device_model');
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

  Future<String> getFCMToken() async {
    // final prefs = await SharedPreferences.getInstance();
    return _prefs.getString('fcm_token') ?? '';
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


}
