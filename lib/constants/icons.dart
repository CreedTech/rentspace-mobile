import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LockIcon {
  Icon close(BuildContext context) {
    return Icon(
      Iconsax.eye_slash,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Icon open(BuildContext context) {
    return Icon(
      Iconsax.eye,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
