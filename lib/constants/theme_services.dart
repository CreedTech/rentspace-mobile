import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices extends GetxController {
  final _getStorage = GetStorage();
  final storageKey = "isDarkMode";

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.light : ThemeMode.light;
  }

  bool isSavedDarkMode() {
    return false;
  }
  // bool isSavedDarkMode() {
  //   return _getStorage.read(storageKey) ?? false;
  // }

  void saveThemeMode(bool isDarkMode) {
    _getStorage.write(storageKey, isDarkMode);
  }

  void changeThemeMode() {
    if (isSavedDarkMode()) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }

    saveThemeMode(!isSavedDarkMode());
  }
}
