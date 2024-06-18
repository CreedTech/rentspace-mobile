import 'package:get/get.dart';

import '../controller/initial_controller.dart';
import '../controller/theme/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<InitialController>(() => InitialController());
  }
}
