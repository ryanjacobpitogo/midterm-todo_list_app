import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/todo_provider.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/todo_list_widget.dart';

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
      bottomNavigationBar: BottomNavBar(screenIndex: screenIndex),
    );
  }
}

