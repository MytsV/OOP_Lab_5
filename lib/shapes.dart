import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'variant_values.dart';

enum ShapeType { shadowed, regular, highlighted }

final dashIntervals = CircularIntervalList<double>([10]);

abstract class Shape {
  ShapeType type = ShapeType.regular;

  void show(Canvas canvas);
}

class PointShape extends Shape {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = BASE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH + 1;
    return paint;
  }

  Paint get _highlightedPaint {
    Paint paint = Paint();
    paint.color = HIGHLIGHT_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH + 2;
    return paint;
  }

  @protected
  final Offset offset;

  PointShape(this.offset);

  @override
  void show(Canvas canvas) {
    Paint paint;
    switch (type) {
      case ShapeType.shadowed:
        paint = _defaultPaint;
        break;
      case ShapeType.regular:
        paint = _defaultPaint;
        break;
      case ShapeType.highlighted:
        paint = _highlightedPaint;
        break;
    }
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
    Paint defaultPaint = Paint();
    defaultPaint.color = BASE_COLOR;
    defaultPaint.strokeWidth = BASE_STROKE_WIDTH;
    defaultPaint.style = PaintingStyle.stroke;

    Paint shadowedPaint = Paint();
    shadowedPaint.color = SHADOW_COLOR;
    shadowedPaint.strokeWidth = BASE_STROKE_WIDTH;
    shadowedPaint.style = PaintingStyle.stroke;

    Paint highlightedPaint = Paint();
    highlightedPaint.color = HIGHLIGHT_COLOR;
    highlightedPaint.strokeWidth = BASE_STROKE_WIDTH + 1;
    highlightedPaint.style = PaintingStyle.stroke;

    if (type != ShapeType.shadowed) {
      Paint paint = type == ShapeType.regular ? defaultPaint : highlightedPaint;
      canvas.drawLine(start, end, paint);
    } else {
      Path path = Path();
      path.moveTo(start.dx, start.dy);
      path.lineTo(end.dx, end.dy);
      canvas.drawPath(dashPath(path, dashArray: dashIntervals), shadowedPaint);
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
  void showRectangle(Canvas canvas, Offset center, Offset corner) {
    Paint defaultPaint = Paint();
    defaultPaint.color = RECTANGLE_FILL;
    defaultPaint.strokeWidth = BASE_STROKE_WIDTH;

    Paint shadowedPaint = Paint();
    shadowedPaint.color = SHADOW_COLOR;
    shadowedPaint.strokeWidth = BASE_STROKE_WIDTH;
    shadowedPaint.style = PaintingStyle.stroke;

    Paint highlightedPaint = Paint();
    highlightedPaint.color = HIGHLIGHT_COLOR;
    highlightedPaint.strokeWidth = BASE_STROKE_WIDTH;

    Paint strokePaint = Paint();
    strokePaint.color = STROKE_COLOR;
    strokePaint.strokeWidth = BASE_STROKE_WIDTH;
    strokePaint.style = PaintingStyle.stroke;

    double width = (center.dx - corner.dx).abs() * 2;
    double height = (center.dy - corner.dy).abs() * 2;
    Rect rect = Rect.fromCenter(center: center, width: width, height: height);
    if (type == ShapeType.shadowed) {
      Path path = Path();
      path.addRect(rect);
      canvas.drawPath(
          dashPath(path, dashArray: dashIntervals), shadowedPaint);
    } else {
      Paint paint = type == ShapeType.regular ? defaultPaint : highlightedPaint;
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, strokePaint);
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
  void showEllipse(Canvas canvas, Offset leftUpper, Offset rightLower) {
    Paint defaultPaint = Paint();
    defaultPaint.color = ELLIPSE_FILL;
    defaultPaint.strokeWidth = BASE_STROKE_WIDTH;

    Paint shadowedPaint = Paint();
    shadowedPaint.color = SHADOW_COLOR;
    shadowedPaint.strokeWidth = BASE_STROKE_WIDTH;
    shadowedPaint.style = PaintingStyle.stroke;

    Paint highlightedPaint = Paint();
    highlightedPaint.color = HIGHLIGHT_COLOR;
    highlightedPaint.strokeWidth = BASE_STROKE_WIDTH;

    Paint strokePaint = Paint();
    strokePaint.color = STROKE_COLOR;
    strokePaint.strokeWidth = BASE_STROKE_WIDTH;
    strokePaint.style = PaintingStyle.stroke;

    Rect rect = Rect.fromPoints(leftUpper, rightLower);
    if (type != ShapeType.shadowed) {
      Paint paint = type == ShapeType.regular ? defaultPaint : highlightedPaint;
      canvas.drawOval(rect, paint);
      canvas.drawOval(rect, strokePaint);
    } else {
      Path path = Path();
      path.addOval(rect);
      canvas.drawPath(dashPath(path, dashArray: dashIntervals), shadowedPaint);
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
    void _showFrontRect() =>
        showRectangle(
            canvas, Offset(start.dx + side / 2, start.dy + side / 2), start);
    void _showBackRect() =>
        showRectangle(
            canvas, Offset(end.dx - side / 2, end.dy - side / 2), end);
    if (dx <= 0) {
      _showFrontRect();
    } else {
      _showBackRect();
    }
    showLine(canvas, start, Offset(end.dx - side, end.dy - side));
    showLine(canvas, Offset(start.dx + side, start.dy),
        Offset(end.dx, end.dy - side));
    showLine(canvas, Offset(start.dx, start.dy + side),
        Offset(end.dx - side, end.dy));
    showLine(canvas, Offset(start.dx + side, start.dy + side), end);
    if (dx <= 0) {
      _showBackRect();
    } else {
      _showFrontRect();
    }
  }
}
