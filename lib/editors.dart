import 'package:flutter/material.dart';
import 'package:oop_lab_2/shape_list.dart';
import 'package:oop_lab_2/variant_values.dart';

import 'shapes.dart';

abstract class Editor {
  final void Function(Offset, Offset) onDrawingEnd;

  Editor(this.onDrawingEnd);

  void onPanDown(DragDownDetails details);
  void onPanUpdate(DragUpdateDetails details);
  void onPanEnd(DragEndDetails details);
}

class PointEditor extends Editor {
  PointEditor(void Function(Offset, Offset) onDrawingEnd) : super(onDrawingEnd);

  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = BASE_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH + 1;
    return paint;
  }

  Offset? _start;

  @override
  void onPanDown(DragDownDetails details) {
    PointShape shape = PointShape(details.localPosition);
    shape.paint = _defaultPaint;
    shapes.add(shape);
    _start = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
  }

  @override
  void onPanEnd(DragEndDetails details) {
    onDrawingEnd(_start!, _start!);
    _start = null;
  }
}

class LineEditor extends Editor {
  LineEditor(void Function(Offset, Offset) onDrawingEnd) : super(onDrawingEnd);

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
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  Offset? _start;
  Offset? _end;
  LineShape? _oldShape;

  @override
  void onPanDown(DragDownDetails details) {
    _start = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    _end = details.localPosition;
    LineShape shape = LineShape(_start!, _end!);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shape.type = ShapeType.shadowed;
    shapes.add(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    onDrawingEnd(_start!, _end!);
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      _oldShape!.type = ShapeType.regular;
      shapes.add(_oldShape!);
      shapes.remove(_oldShape!);
    }
    _oldShape = null;
  }
}

class RectangleEditor extends Editor {
  RectangleEditor(void Function(Offset, Offset) onDrawingEnd) : super(onDrawingEnd);

  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = RECTANGLE_FILL;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = SHADOW_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  Paint get _centerPaint {
    Paint paint = Paint();
    paint.color = SHADOW_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH + 1;
    return paint;
  }

  Offset? _center;
  Offset? _corner;
  RectangleShape? _oldShape;
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
    _corner = details.localPosition;
    RectangleShape shape = RectangleShape(_center!, _corner!);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shape.type = ShapeType.shadowed;
    shapes.add(shape);
  }

  void _finishDrawing() {
    double dx = _corner!.dx - _center!.dx;
    double dy = _corner!.dy - _center!.dy;
    Offset _oppositeCorner = Offset(_center!.dx - dx, _center!.dy - dy);
    onDrawingEnd(_oppositeCorner, _corner!);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    _finishDrawing();
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      _oldShape!.type = ShapeType.regular;
      shapes.remove(_oldShape!);
      shapes.add(_oldShape!);
    }
    _oldShape = null;
    shapes.remove(_centerShape!);
  }
}

class EllipseEditor extends Editor {
  EllipseEditor(void Function(Offset, Offset) onDrawingEnd) : super(onDrawingEnd);

  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = ELLIPSE_FILL;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = SHADOW_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  Offset? _start;
  Offset? _end;
  EllipseShape? _oldShape;

  @override
  void onPanDown(DragDownDetails details) {
    _start = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    _end = details.localPosition;
    EllipseShape shape = EllipseShape(_start!, _end!);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shape.type = ShapeType.shadowed;
    shapes.add(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    onDrawingEnd(_start!, _end!);
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      _oldShape!.type = ShapeType.regular;
      shapes.remove(_oldShape!);
      shapes.add(_oldShape!);
    }
    _oldShape = null;
  }
}

class OLineOEditor extends Editor {
  OLineOEditor(void Function(Offset, Offset) onDrawingEnd) : super(onDrawingEnd);

  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = ELLIPSE_FILL;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = SHADOW_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  Offset? _start;
  Offset? _end;
  OLineOShape? _oldShape;

  @override
  void onPanDown(DragDownDetails details) {
    _start = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    _end = details.localPosition;
    OLineOShape shape = OLineOShape(_start!, _end!);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shape.type = ShapeType.shadowed;
    shapes.add(shape);
  }
  
  @override
  void onPanEnd(DragEndDetails details) {
    onDrawingEnd(_start!, _end!);
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      _oldShape!.type = ShapeType.regular;
      shapes.remove(_oldShape!);
      shapes.add(_oldShape!);
    }
    _oldShape = null;
  }
}

class CubeEditor extends Editor {
  CubeEditor(void Function(Offset, Offset) onDrawingEnd) : super(onDrawingEnd);

  Paint get _defaultPaint {
    Paint paint = Paint();
    paint.color = ELLIPSE_FILL;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    return paint;
  }

  Paint get _shadowPaint {
    Paint paint = Paint();
    paint.color = SHADOW_COLOR;
    paint.strokeWidth = BASE_STROKE_WIDTH;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  Offset? _start;
  Offset? _end;
  CubeShape? _oldShape;

  @override
  void onPanDown(DragDownDetails details) {
    _start = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    _end = details.localPosition;
    CubeShape shape = CubeShape(_start!, _end!);
    if (_oldShape != null) {
      shapes.remove(_oldShape!);
    }
    _oldShape = shape;
    shape.paint = _shadowPaint;
    shape.type = ShapeType.shadowed;
    shapes.add(shape);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    onDrawingEnd(_start!, _end!);
    if (_oldShape != null) {
      _oldShape!.paint = _defaultPaint;
      _oldShape!.type = ShapeType.regular;
      shapes.remove(_oldShape!);
      shapes.add(_oldShape!);
    }
    _oldShape = null;
  }
}
