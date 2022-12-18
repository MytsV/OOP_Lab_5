import 'package:flutter/material.dart';
import 'shapes.dart';

class NotifiedList<T> extends ValueNotifier<List<T>> {
  NotifiedList() : super([]);

  add(T element) {
    value = List.from(value)..add(element);
  }

  remove(T element) {
    value = List.from(value)..remove(element);
  }
}

final shapes = NotifiedList<Shape>();