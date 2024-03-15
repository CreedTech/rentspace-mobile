import 'package:flutter/material.dart';
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
  Icon close = const Icon(Iconsax.eye_slash5);
  Icon open = const Icon(Iconsax.eye4);
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
