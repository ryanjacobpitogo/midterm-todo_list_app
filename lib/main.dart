import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0x00d52e54),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/newTodo': (context) => const Material(),
      },
    ),
  );
}

//First Screen
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: Column(
        children: const [],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
