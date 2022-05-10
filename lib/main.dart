import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapTodo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SnapTodo'),
          backgroundColor: Colors.black,
        ),
        body: const Center(
          child: Text('hello'),
        ),
      ),
    );
  }
}
