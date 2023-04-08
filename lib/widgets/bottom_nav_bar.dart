import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/todo_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.screenIndex,
  });

  final int screenIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}

//Second Screen

