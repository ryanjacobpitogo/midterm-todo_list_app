

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/page/home_page.dart';
import 'package:todo_list/provider/todo_provider.dart';


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


