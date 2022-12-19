import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oop_lab_2/shape_table.dart';

import 'drawing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторна №3',
      home: const MainView(),
      //Задаємо основний колір додатку
      theme:
      ThemeData(primaryColor: Colors.indigo, primarySwatch: Colors.indigo),
      //Вимикаємо відображення баннеру "Debug"
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _tableOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: DrawingPage()),
          SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _tableOpen = !_tableOpen;
                            });
                          },
                          icon: Icon(
                            _tableOpen
                                ? Icons.close_fullscreen
                                : Icons.table_chart_outlined,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  height: 50,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                if (_tableOpen) Expanded(child: TableView()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TableView extends StatelessWidget {
  TableView({Key? key}) : super(key: key);
  final ScrollController _controller = ScrollController();

  List<Widget> _getTableRowChildren(List<String> values, {bool main = false}) {
    return values
        .map((e) =>
        Padding(
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
          _controller.animateTo(_controller.position.maxScrollExtent, curve: Curves.linear, duration: const Duration(milliseconds: 300));
        });
        return SingleChildScrollView(
          controller: _controller,
          child: Table(
            children: [
              TableRow(
                  children: _getTableRowChildren(
                      ['Назва', 'x1', 'y1', 'x2', 'y2'],
                      main: true)),
              ...table.entries
                  .map((e) =>
                  TableRow(
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
          ),
        );
      },
    );
  }
}
