import 'package:flutter/material.dart';
import 'package:oop_lab_2/shape_list.dart';
import 'package:oop_lab_2/variant_values.dart';

import 'shapes.dart';

abstract class Editor {
  void onPanDown(DragDownDetails details);
  void onPanUpdate(DragUpdateDetails details);
  void onPanEnd(DragEndDetails details);
}

class PointEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = BASE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Offset? _lastPosition;

  @override
  void onPanDown(DragDownDetails details) {
    PointShape shape = PointShape(details.localPosition);
    shape.paint = _defaultPaint;
    shapes.add(shape);
    _lastPosition = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    LineShape shape = LineShape(_lastPosition!, details.localPosition);
    _lastPosition = details.localPosition;
    shape.paint = _defaultPaint;
    shapes.add(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    _lastPosition = null;
  }
}

class LineEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = BASE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = SHADOW_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Offset? _startPosition;
  LineShape? _oldShape;

  @override
  void onPanDown(DragDownDetails details) {
    _startPosition = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    LineShape shape = LineShape(_startPosition!, details.localPosition);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shapes.add(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      shapes.add(_oldShape!);
      shapes.remove(_oldShape!);
    }
    _oldShape = null;
  }
}

class RectangleEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = BASE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = Colors.transparent;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Offset? _leftUpper;
  RectangleShape? _oldShape;

  @override
  void onPanDown(DragDownDetails details) {
    _leftUpper = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    RectangleShape shape = RectangleShape(_leftUpper!, details.localPosition);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shapes.add(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      shapes.remove(_oldShape!);
      shapes.add(_oldShape!);
    }
    _oldShape = null;
  }
}

class EllipseEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = ELLIPSE_FILL;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = Colors.transparent;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _centerPaint {
    Paint paint = Paint();
    paint.color = STROKE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH + 1;
    return paint;
  }

  Offset? _center;
  EllipseShape? _oldShape;
  PointShape? _centerShape;

  @override
  void onPanDown(DragDownDetails details) {
    _center = details.localPosition;
    _centerShape = PointShape(_center!);
    _centerShape!.paint = _centerPaint;
    shapes.add(_centerShape!);
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    EllipseShape shape = EllipseShape(_center!, details.localPosition);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shapes.add(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      shapes.remove(_oldShape!);
      shapes.add(_oldShape!);
    }
    shapes.remove(_centerShape!);
    _oldShape = null;
  }
}
