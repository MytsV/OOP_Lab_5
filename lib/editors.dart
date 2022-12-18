import 'package:flutter/material.dart';
import 'package:oop_lab_2/shape_list.dart';
import 'package:oop_lab_2/variant_values.dart';
import 'shapes.dart';

abstract class Editor {
  void onPanDown(DragDownDetails details);
  void onPanUpdate(DragUpdateDetails details);
  void onPanEnd(DragEndDetails details);

  void addShape(Shape shape) {
    shapes.value = List.from(shapes.value)..add(shape);
  }

  void removeShape(Shape shape) {
    shapes.value = List.from(shapes.value)..remove(shape);
  }
}

class PointEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = baseColor;
    paint.strokeWidth = baseStrokeWidth;
    return paint;
  }

  Offset? _lastPosition;

  @override
  void onPanDown(DragDownDetails details) {
    PointShape shape = PointShape(details.localPosition);
    shape.paint = _defaultPaint;
    super.addShape(shape);
    _lastPosition = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    LineShape shape = LineShape(_lastPosition!, details.localPosition);
    _lastPosition = details.localPosition;
    shape.paint = _defaultPaint;
    super.addShape(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    _lastPosition = null;
  }
}

class LineEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = baseColor;
    paint.strokeWidth = baseStrokeWidth;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = shadowColor;
    paint.strokeWidth = baseStrokeWidth;
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
      removeShape(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    addShape(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      removeShape(_oldShape!);
      addShape(_oldShape!);
    }
    _oldShape = null;
  }
}

class RectangleEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = baseColor;
    paint.strokeWidth = baseStrokeWidth;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = Colors.transparent;
    paint.strokeWidth = baseStrokeWidth;
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
      removeShape(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    addShape(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      removeShape(_oldShape!);
      addShape(_oldShape!);
    }
    _oldShape = null;
  }
}

class EllipseEditor extends Editor {
  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = ellipseFill;
    paint.strokeWidth = baseStrokeWidth;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = Colors.transparent;
    paint.strokeWidth = baseStrokeWidth;
    return paint;
  }

  Paint get _centerPaint {
    Paint paint = Paint();
    paint.color = strokeColor;
    paint.strokeWidth = baseStrokeWidth + 1;
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
    addShape(_centerShape!);
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    EllipseShape shape = EllipseShape(_center!, details.localPosition);
    if (_oldShape != null) {
      removeShape(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    addShape(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      removeShape(_oldShape!);
      addShape(_oldShape!);
    }
    removeShape(_centerShape!);
    _oldShape = null;
  }
}