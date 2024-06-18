import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WishIcon {
  Icon normal = const Icon(Icons.favorite_border);
  Icon bold = const Icon(Icons.favorite);
}

class BookmarkIcon {
  Icon normal = const Icon(Icons.bookmark_border);
  Icon bold = const Icon(Icons.bookmark);
}

class LockIcon {
  Icon close = Icon(
    Iconsax.eye_slash,
    color: Theme.of(Get.context!).colorScheme.primary,
  );
  Icon open = Icon(
    Iconsax.eye,
    color: Theme.of(Get.context!).colorScheme.primary,
  );
}

class ThemeIcon {
  Icon dark = Icon(
    Icons.dark_mode,
    color: Theme.of(Get.context!).colorScheme.primary,
  );
  Icon light = Icon(
    Icons.light_mode,
    color: Theme.of(Get.context!).colorScheme.primary,
  );
}
