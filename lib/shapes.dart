import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'variant_values.dart';

enum ShapeType { shadowed, regular }

final dashIntervals = CircularIntervalList<double>([10]);

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
      Paint newPaint = paint;
      if (paint.color == Colors.transparent) {
        newPaint = Paint();
        newPaint.strokeWidth = paint.strokeWidth;
        newPaint.color = Colors.black;
      }
      canvas.drawLine(start, end, newPaint);
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
      canvas.drawPath(dashPath(path, dashArray: dashIntervals), paint);
    }
  }
}

class OLineOShape extends Shape with LineMixin, EllipseMixin {
  @protected
  final Offset start;
  @protected
  final Offset end;

  OLineOShape(this.start, this.end);

  @override
  void show(Canvas canvas) {
    //Радіус еліпса буде дорівнювати 1/10 від довжини лінії
    const ellipseFraction = 10;
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;
    double lineLength = sqrt(dx * dx + dy * dy);
    double ellipseRadius = lineLength / ellipseFraction;
    double ellipseDx = dx / ellipseFraction;
    double ellipseDy = dy / ellipseFraction;
    showEllipse(
        canvas,
        Offset(start.dx - ellipseRadius, start.dy - ellipseRadius),
        Offset(start.dx + ellipseRadius, start.dy + ellipseRadius)
    );
    showLine(
        canvas,
        Offset(start.dx + ellipseDx, start.dy + ellipseDy),
        Offset(end.dx - ellipseDx, end.dy - ellipseDy)
    );
    showEllipse(
        canvas,
        Offset(end.dx - ellipseRadius, end.dy - ellipseRadius),
        Offset(end.dx + ellipseRadius, end.dy + ellipseRadius)
    );
  }
}

class CubeShape extends Shape with LineMixin, RectangleMixin {
  @protected
  final Offset start;
  @protected
  final Offset end;

  CubeShape(this.start, this.end);

  @override
  void show(Canvas canvas) {
    //У нас вводиться головна діагональ куба
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;
    double diagonalLength = sqrt(dx * dx + dy * dy);
    double side = diagonalLength / sqrt(3);
    showRectangle(canvas, Offset(start.dx + side / 2, start.dy + side / 2), start);
    showRectangle(canvas, Offset(end.dx - side / 2, end.dy - side / 2), end);
    showLine(canvas, start, Offset(end.dx - side, end.dy - side));
    showLine(canvas, Offset(start.dx + side, start.dy), Offset(end.dx, end.dy - side));
    showLine(canvas, Offset(start.dx, start.dy + side), Offset(end.dx - side, end.dy));
    showLine(canvas, Offset(start.dx + side, start.dy + side), end);
  }
}
