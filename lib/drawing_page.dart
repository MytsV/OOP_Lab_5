import 'package:flutter/material.dart';

import 'editors.dart';
import 'shape_list.dart';
import 'shape_painter.dart';
import 'variant_values.dart';

class Instrument {
  final String name;
  final String imagePath;
  final Editor editor;

  Instrument(
      {required this.name, required this.imagePath, required this.editor});
}

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  Editor _currentEditor = PointEditor();
  final instruments = [
    Instrument(
        name: 'Крапка', imagePath: 'assets/dot.png', editor: PointEditor()),
    Instrument(
        name: 'Лінія', imagePath: 'assets/line.png', editor: LineEditor()),
    Instrument(
        name: 'Прямокутник',
        imagePath: 'assets/rectangle.png',
        editor: RectangleEditor()),
    Instrument(
        name: 'Еліпс',
        imagePath: 'assets/ellipse.png',
        editor: EllipseEditor()),
    Instrument(
        name: 'О-лінія-О',
        imagePath: 'assets/o-line-o.png',
        editor: OLineOEditor()),
    Instrument(
        name: 'Куб', imagePath: 'assets/cube.png', editor: CubeEditor()),
  ];

  void _onMenuItemSelected(Editor value) {
    setState(() {
      _currentEditor = value;
    });
  }

  _getButtonChild(Instrument instrument) => Text(instrument.name);

  Widget _getMenuChild() {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Об\'єкти'),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _getMenuButton() => PopupMenuButton(
        child: _getMenuChild(),
        itemBuilder: (context) {
          return instruments
              .map((e) => PopupMenuItem<Editor>(
                  value: e.editor, child: _getButtonChild(e)))
              .toList();
        },
        onSelected: _onMenuItemSelected,
      );

  //Отримуємо об'єкт, що задає стиль обведення поля малювання
  BoxDecoration _getDrawContainerDecoration() {
    return BoxDecoration(
        border: Border.all(
            style: BorderStyle.solid,
            color: Theme.of(context).primaryColor,
            width: BASE_STROKE_WIDTH + 1));
  }

  String _getAppBarText() {
    Instrument instrument = instruments.firstWhere((element) => element.editor.runtimeType == _currentEditor.runtimeType);
    return instrument.name;
  }

  Widget _getToolbarButton(Instrument instrument) {
    bool isSelected =
        instrument.editor.runtimeType == _currentEditor.runtimeType;
    return Tooltip(
      message: instrument.name,
      child: GestureDetector(
          onTap: () => _onMenuItemSelected(instrument.editor),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo, width: 4),
              color: Colors.indigo[200],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                instrument.imagePath,
                color: isSelected ? Colors.indigo[900] : Colors.white,
                filterQuality: FilterQuality.medium,
              ),
            ),
          )),
    );
  }

  PreferredSizeWidget _getToolbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child:
          Row(children: instruments.map((e) => _getToolbarButton(e)).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_getAppBarText()),
          actions: [_getMenuButton()],
          bottom: _getToolbar()),
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
                child: ValueListenableBuilder<List>(
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
