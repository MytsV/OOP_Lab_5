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
    if (_currentEditor.runtimeType != editorType) return Text(text);
    //Якщо тип кнопки співпадає з типом вибраного Editor'а, відображаємо прапорець
    return Row(
      children: [
        Text(text),
        const SizedBox(
          width: 5,
        ),
        Icon(Icons.check, color: Theme.of(context).primaryColor),
      ],
    );
  }

  Widget _getMenuChild() {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Об\'єкти'),
          SizedBox(width: 5,),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _getMenuButton() => PopupMenuButton(
    child: _getMenuChild(),
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

  //Отримуємо об'єкт, що задає стиль обведення поля малювання
  BoxDecoration _getDrawContainerDecoration() {
    return BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: Theme
            .of(context)
            .primaryColor, width: BASE_STROKE_WIDTH + 1)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getMenuButton(),
      ),
      body: Padding(
        //Робимо відступ між краями екрану й полем малювання
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: _getDrawContainerDecoration(),
          child: GestureDetector(
            onPanDown: _currentEditor.onPanDown,
            onPanUpdate: _currentEditor.onPanUpdate,
            onPanEnd: _currentEditor.onPanEnd,
            child: ClipRRect(
              child: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                //Оновлюємо поле малювання з кожним оновленням списку фігур
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