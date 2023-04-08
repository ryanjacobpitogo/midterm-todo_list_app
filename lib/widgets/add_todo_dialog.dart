import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo_model.dart';
import '../provider/todo_provider.dart';

Future<dynamic> displayAddDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddTodoDialog();
    },
  );
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late final TextEditingController _labelController;
  late final TextEditingController _descController;

  @override
  void initState() {
    _labelController = TextEditingController();
    _descController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _labelController = TextEditingController();
    _descController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Todo',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 1,
            controller: _labelController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          TextField(
            maxLines: 3,
            controller: _descController,
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
                final labelText = _labelController.text;
                final descText = _descController.text;

                if (labelText.isNotEmpty) {
                  final todo = Todo(
                    label: labelText,
                    desc: descText,
                    isCompleted: false,
                  );
                  context.read<TodoProvider>().add(todo);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}