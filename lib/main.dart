import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Лабораторна №2',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Editor _currentEditor = EllipseEditor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна №2'),
      ),
      body: GestureDetector(
        onPanDown: _currentEditor.onPanDown,
        onPanUpdate: _currentEditor.onPanUpdate,
        onPanEnd: _currentEditor.onPanEnd,
        child: SizedBox(
          width: 300,
          height: 300,
          child: ValueListenableBuilder<List<Shape>>(
            valueListenable: shapes,
            builder: (context, shapes, _) => CustomPaint(
              painter: ShapePainter(),
            ),
          ),
        ),
      ),
    );
  }
}

final ValueNotifier<List<Shape>> shapes = ValueNotifier([]);

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

const baseColor = Colors.deepOrange;
const shadowColor = Colors.black;
const strokeColor = Colors.black;
const ellipseFill = Colors.white;
const double baseStrokeWidth = 1;

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

  Offset? _center;
  EllipseShape? _oldShape;
  PointShape? _centerShape;

  @override
  void onPanDown(DragDownDetails details) {
    _center = details.localPosition;
    _centerShape = PointShape(_center!);
    _centerShape!.paint = _defaultPaint;
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
    _oldShape = null;
  }
}
