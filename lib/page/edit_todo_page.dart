import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo_model.dart';
import '../provider/todo_provider.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;

  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 230, 230),
      appBar: AppBar(
        title: const Text('Edit Todo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<TodoProvider>().remove(widget.todo);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              maxLines: 1,
              initialValue: widget.todo.label,
              onChanged: (label) => setState(() => widget.todo.label = label),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Title',
                
              ),
            ),
            TextFormField(
              maxLines: 3,
              initialValue: widget.todo.desc,
              onChanged: (desc) => setState(() => widget.todo.desc = desc),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  if (widget.todo.label.isNotEmpty) {
                    context
                        .read<TodoProvider>()
                        .update(widget.todo, widget.todo.label, widget.todo.desc);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}