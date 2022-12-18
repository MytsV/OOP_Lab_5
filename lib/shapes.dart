import 'dart:ui';

import 'package:flutter/material.dart';

import 'variant_values.dart';

abstract class Shape {
  late Paint paint;
  void show(Canvas canvas);
}

class PointShape extends Shape {
  @protected
  final Offset offset;

  PointShape(this.offset);

  @override
  void show(Canvas canvas) {
    canvas.drawPoints(PointMode.points, [offset], paint);
  }
}

class LineShape extends Shape {
  @protected
  final Offset start;
  @protected
  final Offset end;

  LineShape(this.start, this.end);

  @override
  void show(Canvas canvas) {
    canvas.drawLine(start, end, paint);
  }
}

class RectangleShape extends Shape {
  get _strokePaint {
    Paint paint = Paint();
    paint.color = strokeColor;
    paint.strokeWidth = baseStrokeWidth;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  @protected
  final Offset leftUpper;
  @protected
  final Offset rightLower;

  RectangleShape(this.leftUpper, this.rightLower);

  @override
  void show(Canvas canvas) {
    Rect rect = Rect.fromPoints(leftUpper, rightLower);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, _strokePaint);
  }
}

class EllipseShape extends Shape {
  get _strokePaint {
    Paint paint = Paint();
    paint.color = strokeColor;
    paint.strokeWidth = baseStrokeWidth;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  @protected
  final Offset center;
  @protected
  final Offset corner;

  EllipseShape(this.center, this.corner);

  @override
  void show(Canvas canvas) {
    double width = (center.dx - corner.dx).abs() * 2;
    double height = (center.dy - corner.dy).abs() * 2;
    Rect rect = Rect.fromCenter(center: center, width: width, height: height);
    canvas.drawOval(rect, paint);
    canvas.drawOval(rect, _strokePaint);
  }
}