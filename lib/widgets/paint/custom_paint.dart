import 'package:flutter/material.dart';

class ZigzagClip extends CustomClipper<Path> {
  final int width;
  ZigzagClip({this.width = 20});
  @override
  Path getClip(Size size) {
    var path = Path();
    const double offset = 19.0;

    path.moveTo(0, offset);
    path.lineTo(0, size.height);
    double x = 0.0;

    for (int i = 0; i <= size.width / width; i++) {
      x += width;
      if (i.isEven) {
        path.lineTo(x, size.height - width);
      } else {
        path.lineTo(x, size.height);
      }
    }
    path.lineTo(size.width, offset);
    path.quadraticBezierTo(size.width, 0, size.width - offset, 0);
    path.lineTo(offset, 0);
    path.quadraticBezierTo(0, 0, 0, offset);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
