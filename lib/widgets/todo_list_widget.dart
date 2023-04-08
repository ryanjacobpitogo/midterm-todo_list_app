import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/todo_provider.dart';
import 'todo_card_widget.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todoList =
        index == 0 ? provider.todoList : provider.completedTodoList;

    return todoList.isEmpty
        ? const Center(
            child: Text(
              'No entries',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final todo = todoList[index];
              return TodoCardWidget(todo: todo);
            },
          );
  }
}