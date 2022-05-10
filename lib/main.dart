import 'package:flutter/material.dart';
import 'package:snap_todo/widgets/List_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapTodo',
      home: ListGrid(),
    );
  }
}
