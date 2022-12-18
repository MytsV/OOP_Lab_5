import 'package:flutter/material.dart';

import 'editors.dart';
import 'shape_list.dart';
import 'shape_painter.dart';
import 'shapes.dart';
import 'variant_values.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  Editor _currentEditor = PointEditor();

  void _onMenuItemSelected(Editor value) {
    setState(() {
      _currentEditor = value;
    });
  }

  _getButtonChild(String text, Type editorType) {
    if (_currentEditor.runtimeType == editorType) {
      return Row(
        children: [
          Text(text),
          const SizedBox(width: 5,),
          const Icon(Icons.check, color: Colors.blue),
        ],
      );
    }
    return Text(text);
  }

  Widget _getMenuButton() => PopupMenuButton(
    child: IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Об\'єкти'),
          SizedBox(width: 5,),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    ),
    itemBuilder: (context) {
      return [
        PopupMenuItem<Editor>(
          value: PointEditor(),
          child: _getButtonChild('Крапка', PointEditor),
        ),
        PopupMenuItem<Editor>(
          value: LineEditor(),
          child: _getButtonChild('Лінія', LineEditor),
        ),
        PopupMenuItem<Editor>(
          value: RectangleEditor(),
          child: _getButtonChild('Прямокутник', RectangleEditor),
        ),
        PopupMenuItem<Editor>(
          value: EllipseEditor(),
          child: _getButtonChild('Еліпс', EllipseEditor),
        ),
      ];
    },
    onSelected: _onMenuItemSelected,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getMenuButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(style: BorderStyle.solid, color: Colors.blue, width: BASE_STROKE_WIDTH + 1)
          ),
          child: GestureDetector(
            onPanDown: _currentEditor.onPanDown,
            onPanUpdate: _currentEditor.onPanUpdate,
            onPanEnd: _currentEditor.onPanEnd,
            child: ClipRRect(
              child: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: ValueListenableBuilder<List<Shape>>(
                  valueListenable: shapes,
                  builder: (context, shapes, _) => CustomPaint(
                    painter: ShapePainter(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}