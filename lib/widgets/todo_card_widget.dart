import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../model/todo_model.dart';
import '../page/edit_todo_page.dart';
import '../provider/todo_provider.dart';

class TodoCardWidget extends StatelessWidget {
  const TodoCardWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditTodoPage(todo: todo),
                  ),
                );
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                context.read<TodoProvider>().remove(todo);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTodoPage(todo: todo),
            ),
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 100),
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      context.read<TodoProvider>().toggleCompleted(todo);

                      final snackBar = SnackBar(
                        content: Text(todo.isCompleted ? 'Task completed' : 'Task marked incomplete'),
                        backgroundColor: (Colors.black),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.label,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(height: 8),
                        todo.desc.isNotEmpty
                            ? Text(
                                todo.desc,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
