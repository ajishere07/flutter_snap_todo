import 'package:flutter/material.dart';

class ListGrid extends StatefulWidget {
  const ListGrid({Key? key}) : super(key: key);

  @override
  _ListGridState createState() => _ListGridState();
}

class _ListGridState extends State<ListGrid> {
  List<String> superheroes = ['task 1', 'task 2', 'task 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnapTodo'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: superheroes.length,
          itemBuilder: ((context, index) => Card(
                child: ListTile(
                  title: Text(superheroes[index]),
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
