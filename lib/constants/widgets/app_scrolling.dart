// if this gridview used on flutter web need below class for scrolling
import 'dart:ui';

import 'package:flutter/material.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}