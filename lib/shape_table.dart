import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ShapeTable {
  ShapeTable._();

  static final ShapeTable _instance = ShapeTable._();

  static ShapeTable getInstance() => _instance;

  final List<TableEntry> _entries = [];

  List<TableEntry> get entries => List.from(_entries);

  final StreamController<void> _streamController =
      StreamController<void>.broadcast();

  void add(String name, {required int x1, required int x2, required int y1, required int y2}) {
    _entries.add(TableEntry._(name: name,
        x1: x1,
        x2: x2,
        y1: y1,
        y2: y2));
    _streamController.add(null);
    _TableFileManager.getInstance().write(_entries);
  }

  void remove(int index) {
    _entries.removeAt(index);
    _streamController.add(null);
    _TableFileManager.getInstance().write(_entries);
  }

  void clear() {
    _entries.clear();
    _streamController.add(null);
    _TableFileManager.getInstance().write(_entries);
  }

  get stream => _streamController.stream;
}

class TableEntry {
  TableEntry._(
      {required this.name, required this.x1, required this.x2, required this.y1, required this.y2});

  final String name;
  final int x1;
  final int x2;
  final int y1;
  final int y2;
}

class _TableFileManager {
  static final _TableFileManager _instance = _TableFileManager();

  static _TableFileManager getInstance() => _instance;

  void write(List<TableEntry> entries) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/table.txt');
    String text = entries
        .map((e) => [
              e.name,
              e.x1.toString(),
              e.y1.toString(),
              e.x2.toString(),
              e.y2.toString()
            ].join('\t'))
        .join('\n');
    file.writeAsString(text);
  }
}

class TableView extends StatelessWidget {
  final void Function(int) onHighlight;
  final void Function(int) onRemove;

  TableView({required this.onHighlight, required this.onRemove, Key? key}) : super(key: key);
  final ScrollController _controller = ScrollController();

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
    return StreamBuilder(
      stream: table.stream,
      builder: (context, _) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _controller.animateTo(_controller.position.maxScrollExtent,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 300));
        });
        return SingleChildScrollView(
          controller: _controller,
          child: Table(
            children: [
              TableRow(
                  children: _getTableRowChildren(
                      ['Назва', 'x1', 'y1', 'x2', 'y2', '', ''],
                      main: true)),
              ...table.entries.map((e) {
                return TableRow(children: [
                  ..._getTableRowChildren([
                    e.name,
                    e.x1.toString(),
                    e.y1.toString(),
                    e.x2.toString(),
                    e.y2.toString()
                  ]),
                  IconButton(onPressed: () {
                    onHighlight(table.entries.indexOf(e));
                  }, icon: Icon(Icons.highlight)),
                  IconButton(onPressed: () {
                    int index = table.entries.indexOf(e);
                    table.remove(index);
                    onRemove(index);
                  }, icon: Icon(Icons.clear))
                ]);
              }).toList()
            ],
            //Перший стовпчик буде ширшим у 4 рази за інші
            columnWidths: const {
              0: FlexColumnWidth(4),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(color: Colors.black),
          ),
        );
      },
    );
  }
}