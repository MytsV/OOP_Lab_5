import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oop_lab_2/shape_list.dart';
import 'package:oop_lab_2/shape_table.dart';
import 'package:oop_lab_2/shapes.dart';

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

  void _highlightShape(int index) {
    Shape shape = shapes.value[index];
    shape.type = shape.type == ShapeType.regular ? ShapeType.highlighted : ShapeType.regular;
    shapes.remove(shape);
    shapes.value.insert(index, shape);
  }

  void _removeShape(int index) {
    Shape shape = shapes.value[index];
    shapes.remove(shape);
  }

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
                          onPressed: () {
                          },
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            ShapeTable.getInstance().clear();
                            shapes.clear();
                          },
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
                if (_tableOpen) Expanded(child: TableView(onHighlight: _highlightShape, onRemove: _removeShape)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
