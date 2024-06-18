import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Enum for Theme Modes
enum AppThemeMode { system, light, dark }

class ThemeController extends GetxController {
  // Observable variable for theme mode
  Rx<AppThemeMode> currentThemeMode = AppThemeMode.system.obs;

  // HiveBox for storing the theme setting
  final Box<dynamic> settingsHiveBox = Hive.box('settings');

  // Getting Theme State From HiveBox and Set it to the ThemeMode this will be used in main.dart file
  ThemeMode get themeStateFromHiveSettingBox {
    switch (_getThemeFromHiveBox()) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  @override
  void onInit() {
    // Getting the Theme State from the Hive Box and save it to the variable
    currentThemeMode.value = _getThemeFromHiveBox();
    super.onInit();
  }

  // Private Method to Get HiveBox Storage theme Setting value and Return it
  AppThemeMode _getThemeFromHiveBox() {
    String? themeModeString = settingsHiveBox.get('themeMode', defaultValue: 'system');
    switch (themeModeString) {
      case 'dark':
        return AppThemeMode.dark;
      case 'light':
        return AppThemeMode.light;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  // Private Method to update HiveBox Storage theme Setting value
  void _updateHiveThemeSetting(AppThemeMode themeMode) {
    settingsHiveBox.put('themeMode', themeMode.name);
  }

  // Method to change the Theme State when the user calls it via Theme Change Button
  void changeTheme(AppThemeMode themeMode) {
    currentThemeMode.value = themeMode;
    _updateHiveThemeSetting(themeMode);
    _changeThemeMode(themeStateFromHiveSettingBox);
  }

  // Private Method to change theme
  void _changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
}
