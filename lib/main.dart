import 'package:flutter/material.dart';

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
      home: const DrawingPage(),
      //Задаємо основний колір додатку
      theme:
          ThemeData(primaryColor: Colors.indigo, primarySwatch: Colors.indigo),
      //Вимикаємо відображення баннеру "Debug"
      debugShowCheckedModeBanner: false,
    );
  }
}
