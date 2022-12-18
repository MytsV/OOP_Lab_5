import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'variant_values.dart';

enum ShapeType { shadowed, regular }
final dashIntervals = CircularIntervalList<double>([15]);

abstract class Shape {
  late Paint paint;
  ShapeType type = ShapeType.regular;

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

class LineShape extends Shape with LineMixin {
  @protected
  final Offset start;
  @protected
  final Offset end;

  LineShape(this.start, this.end);

  @override
  void show(Canvas canvas) {
    showLine(canvas, start, end);
  }
}

mixin LineMixin on Shape {
  void showLine(Canvas canvas, Offset start, Offset end) {
    if (type == ShapeType.regular) {
      canvas.drawLine(start, end, paint);
    } else {
      Path path = Path();
      path.moveTo(start.dx, start.dy);
      path.lineTo(end.dx, end.dy);
      canvas.drawPath(
          dashPath(path, dashArray: dashIntervals), paint);
    }
  }
}

class RectangleShape extends Shape with RectangleMixin {
  @protected
  final Offset center;
  @protected
  final Offset corner;

  RectangleShape(this.center, this.corner);

  @override
  void show(Canvas canvas) {
    showRectangle(canvas, center, corner);
  }
}

mixin RectangleMixin on Shape {
  get _strokePaint {
    Paint paint = Paint();
    paint.color = STROKE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  void showRectangle(Canvas canvas, Offset center, Offset corner) {
    double width = (center.dx - corner.dx).abs() * 2;
    double height = (center.dy - corner.dy).abs() * 2;
    Rect rect = Rect.fromCenter(center: center, width: width, height: height);
    if (type == ShapeType.shadowed) {
      Path path = Path();
      path.addRect(rect);
      canvas.drawPath(
          dashPath(path, dashArray: dashIntervals), paint);
    } else {
      canvas.drawRect(rect, paint);
      if (paint.style != PaintingStyle.stroke) {
        canvas.drawRect(rect, _strokePaint);
      }
    }
  }
}

class EllipseShape extends Shape with EllipseMixin {
  @protected
  final Offset leftUpper;
  @protected
  final Offset rightLower;

  EllipseShape(this.leftUpper, this.rightLower);

  @override
  void show(Canvas canvas) {
    showEllipse(canvas, leftUpper, rightLower);
  }
}

mixin EllipseMixin on Shape {
  get _strokePaint {
    Paint paint = Paint();
    paint.color = STROKE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  void showEllipse(Canvas canvas, Offset leftUpper, Offset rightLower) {
    Rect rect = Rect.fromPoints(leftUpper, rightLower);
    if (type == ShapeType.regular) {
      canvas.drawOval(rect, paint);
      if (paint.style != PaintingStyle.stroke) {
        canvas.drawOval(rect, _strokePaint);
      }
    } else {
      Path path = Path();
      path.addOval(rect);
      canvas.drawPath(
          dashPath(path, dashArray: dashIntervals), paint);
    }
  }
}
