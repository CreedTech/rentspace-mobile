import 'package:flutter/material.dart';
import 'package:rentspace/main.dart';


import 'local/shared_pref_manager.dart';

class GlobalService {
  // all services should be initialized here
  static late SharedPreferencesManager sharedPreferencesManager;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    configLoading();

    sharedPreferencesManager = await SharedPreferencesManager().init();
  }
}
