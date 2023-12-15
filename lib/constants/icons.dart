import 'package:flutter/material.dart';

class WishIcon {
  Icon normal = Icon(Icons.favorite_border);
  Icon bold = Icon(Icons.favorite);
}

class BookmarkIcon {
  Icon normal = Icon(Icons.bookmark_border);
  Icon bold = Icon(Icons.bookmark);
}

class LockIcon {
  Icon close = Icon(
    Icons.visibility_off_outlined,
    color: Colors.grey,
    size: 18,
  );
  Icon open = Icon(
    Icons.visibility_outlined,
    color: Colors.grey,
    size: 18,
  );
}

class ThemeIcon {
  Icon dark = Icon(
    Icons.dark_mode,
    color: Colors.black,
  );
  Icon light = Icon(
    Icons.light_mode,
    color: Colors.black,
  );
}
