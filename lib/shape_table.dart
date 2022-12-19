class ShapeTable {
  ShapeTable._();
  static final ShapeTable _instance = ShapeTable._();
  static ShapeTable getInstance() => _instance;

  final List<TableEntry> _entries = [];
  List<TableEntry> get entries => List.from(_entries);

  void add(String name, {required int x1, required int x2, required int y1, required int y2}) {
    _entries.add(TableEntry._(name: name, x1: x1, x2: x2, y1: y1, y2: y2));
  }
}

class TableEntry {
  TableEntry._({required this.name, required this.x1, required this.x2, required this.y1, required this.y2});

  final String name;
  final int x1;
  final int x2;
  final int y1;
  final int y2;
}