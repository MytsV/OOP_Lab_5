import 'dart:async';
import 'dart:io';

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

  void clear() {
    _entries.clear();
    _streamController.add(null);
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
    String text = entries.map((e) =>
    [
      e.name,
      e.x1.toString(),
      e.y1.toString(),
      e.x2.toString(),
      e.y2.toString()
    ].join('\t')).join('\n');
    file.writeAsString(text);
  }
}