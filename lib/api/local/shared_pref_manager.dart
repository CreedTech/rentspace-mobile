import 'package:shared_preferences/shared_preferences.dart';
import 'package:rentspace/constants/constants.dart';

class SharedPreferencesManager {
  late final SharedPreferences _prefs;

  Future<SharedPreferencesManager> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> removeToken() async {
    _prefs.remove('token');
  }

  Future<bool> hasSeenOnboarding() async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(HAS_SEEN_ONBOARDING) ?? false;
  }

  Future<bool> setHasSeenOnboarding({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(HAS_SEEN_ONBOARDING, value);
  }

  Future<bool> isFirstTimeSignUp() async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('IS_FIRST_TIME_SIGN_UP') ?? true;
  }

  Future<bool> setIsFirstTimeSignUp({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool('IS_FIRST_TIME_SIGN_UP', value);
  }

  Future<bool> hasCompletedHalfPopup() async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('HAS_COMPLETED_HALF_POPUP') ?? false;
  }

  Future<bool> setHasCompletedHalfPopup({required bool value}) async {
    // final _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool('HAS_COMPLETED_HALF_POPUP', value);
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
    _prefs.remove('fcm_token');
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
}
