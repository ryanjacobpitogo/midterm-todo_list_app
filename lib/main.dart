import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: const Color(0x00d52e54),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    ),
  );
}



//Model
class Todo {
  final String id;
  String label;
  String desc;
  bool isCompleted;

  Todo({
    required this.label,
    this.desc = '',
    required this.isCompleted,
  }) : id = const Uuid().v4();

  void checked() {
    isCompleted = true;
  }

  @override
  bool operator ==(covariant Todo other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//Provider
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

//Dialog
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

//Todo Widget

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
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        ),
                        todo.desc.isNotEmpty
                            ? Text(
                                todo.desc,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.3,
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

//First Screen
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final screenIndex = provider.screenIndex;
    String appBarTitle = screenIndex == 0 ? 'Todo App' : 'Todo App > Completed';
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 230, 230),
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: TodoListWidget(index: screenIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          displayAddDialog(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
        onTap: (index) => {
          context.read<TodoProvider>().setScreenIndex(index),
        },
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(173, 255, 255, 255),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}

//Second Screen
class EditTodoPage extends StatefulWidget {
  final Todo todo;

  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
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
                    context
                        .read<TodoProvider>()
                        .update(widget.todo, labelText, descText);
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
