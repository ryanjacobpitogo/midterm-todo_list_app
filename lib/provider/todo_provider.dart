import 'package:flutter/material.dart';
import 'dart:collection';
import '../model/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todoList = [];
  int screenIndex = 0;
  UnmodifiableListView<Todo> get todoList => UnmodifiableListView(
      _todoList.where((todo) => todo.isCompleted == false).toList());
  UnmodifiableListView<Todo> get completedTodoList => UnmodifiableListView(
      _todoList.where((todo) => todo.isCompleted == true).toList());

  void add(Todo todo) {
    _todoList.add(todo);
    notifyListeners();
  }

  void setScreenIndex(int index) {
    screenIndex = index;
    notifyListeners();
  }

  bool toggleCompleted(Todo todo) {
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
    return todo.isCompleted;
  }

  void update(Todo todo, String label, String desc) {
    todo.label = label;
    todo.desc = desc;
    notifyListeners();
  }

  void remove(Todo todo) {
    _todoList.remove(todo);
    notifyListeners();
  }
}