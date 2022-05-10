import 'package:flutter/material.dart';

class ListGrid extends StatefulWidget {
  const ListGrid({Key? key}) : super(key: key);

  @override
  _ListGridState createState() => _ListGridState();
}

class _ListGridState extends State<ListGrid> {
  List<String> superheroes = ['task 1', 'task 2', 'task 3'];
  late TextEditingController textEditingController;
 Future<Null> exitDialog() async {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: Text('ToDo List'),
              content: TextField(
              cursorColor: Colors.black,
              // style: TextStyle(
              //   color: Colors.white
              // ),
              
              decoration: InputDecoration(
                filled:true,
                hintText: 'Enter todo item',
                // fillColor: Colors.blueAccent,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                  
                ),
              ),
            ),
              actions: [FlatButton(onPressed: null, child: Text('Add'))],
            ));
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

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
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        hoverColor: Colors.blue,
        onPressed:exitDialog,
      ),
    );
  }
}
