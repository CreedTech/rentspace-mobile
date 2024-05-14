import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';

class WishIcon {
  Icon normal = const Icon(Icons.favorite_border);
  Icon bold = const Icon(Icons.favorite);
}

class BookmarkIcon {
  Icon normal = const Icon(Icons.bookmark_border);
  Icon bold = const Icon(Icons.bookmark);
}

class LockIcon {
  Icon close = const Icon(
    Iconsax.eye_slash,
    color: colorBlack,
  );
  Icon open = const Icon(
    Iconsax.eye,
    color: colorBlack,
  );
}

class ThemeIcon {
  Icon dark = const Icon(
    Icons.dark_mode,
    color: Colors.black,
  );
  Icon light = const Icon(
    Icons.light_mode,
    color: Colors.black,
  );
}
