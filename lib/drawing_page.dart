import 'package:flutter/material.dart';
import 'package:oop_lab_2/shape_list.dart';
import 'package:oop_lab_2/shape_painter.dart';
import 'package:oop_lab_2/shape_table.dart';

import 'editors.dart';
import 'variant_values.dart';

class _Tool {
  final String name;
  final String imagePath;
  final Editor editor;

  _Tool({required this.name, required this.imagePath, required this.editor});
}

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  late Editor _currentEditor;
  late final List<_Tool> _tools;

  @override
  void initState() {
    super.initState();
    _currentEditor = PointEditor(_onDrawingEnd);
    _tools = [
      _Tool(
          name: 'Крапка',
          imagePath: 'assets/dot.png',
          editor: PointEditor(_onDrawingEnd)),
      _Tool(
          name: 'Лінія',
          imagePath: 'assets/line.png',
          editor: LineEditor(_onDrawingEnd)),
      _Tool(
          name: 'Прямокутник',
          imagePath: 'assets/rectangle.png',
          editor: RectangleEditor(_onDrawingEnd)),
      _Tool(
          name: 'Еліпс',
          imagePath: 'assets/ellipse.png',
          editor: EllipseEditor(_onDrawingEnd)),
      _Tool(
          name: 'О-лінія-О',
          imagePath: 'assets/o-line-o.png',
          editor: OLineOEditor(_onDrawingEnd)),
      _Tool(
          name: 'Куб',
          imagePath: 'assets/cube.png',
          editor: CubeEditor(_onDrawingEnd)),
    ];
  }

  void _onDrawingEnd(Offset start, Offset end) {
    _Tool tool = _tools.firstWhere(
        (element) => element.editor.runtimeType == _currentEditor.runtimeType);
    ShapeTable.getInstance().add(tool.name,
        x1: start.dx.toInt(),
        x2: end.dx.toInt(),
        y1: start.dy.toInt(),
        y2: end.dy.toInt());
  }

  void _onMenuItemSelected(Editor value) {
    setState(() {
      _currentEditor = value;
    });
  }

  _getButtonChild(_Tool tool) => Text(tool.name);

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
          return _tools
              .map((e) =>
              PopupMenuItem<Editor>(
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
    _Tool tool = _tools.firstWhere((element) =>
    element.editor.runtimeType == _currentEditor.runtimeType);
    return tool.name;
  }

  Widget _getToolbarButton(_Tool tool) {
    bool isSelected =
        tool.editor.runtimeType == _currentEditor.runtimeType;
    return Tooltip(
      message: tool.name,
      child: GestureDetector(
          onTap: () => _onMenuItemSelected(tool.editor),
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
                tool.imagePath,
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
      Row(children: _tools.map((e) => _getToolbarButton(e)).toList()),
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

class TableView extends StatelessWidget {
  const TableView({Key? key}) : super(key: key);

  List<Widget> _getTableRowChildren(List<String> values, {bool main = false}) {
    return values
        .map((e) => Padding(
          //Додаємо відступи від тексту
          padding: const EdgeInsets.all(5),
          child: Text(
                e,
                style: main
                    ? const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)
                    : null,
              ),
        ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ShapeTable table = ShapeTable.getInstance();
    return Table(
      children: [
        TableRow(
            children: _getTableRowChildren(['Назва', 'x1', 'y1', 'x2', 'y2'],
                main: true)),
        ...table.entries
            .map((e) => TableRow(
                    children: _getTableRowChildren([
                  e.name,
                  e.x1.toString(),
                  e.y1.toString(),
                  e.x2.toString(),
                  e.y2.toString()
                ])))
            .toList()
      ],
      //Перший стовпчик буде ширшим у 4 рази за інші
      columnWidths: const {
        0: FlexColumnWidth(4),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.black),
    );
  }
}
