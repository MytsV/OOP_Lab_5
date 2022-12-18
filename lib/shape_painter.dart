import 'dart:ui';

import 'package:flutter/material.dart';

import 'shape_list.dart';
import 'shapes.dart';

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (Shape shape in shapes.value) {
      shape.show(canvas);
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) => true;
}
