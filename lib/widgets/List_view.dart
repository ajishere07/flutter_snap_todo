import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ListGrid extends StatefulWidget {
  const ListGrid({Key? key}) : super(key: key);

  @override
  _ListGridState createState() => _ListGridState();
}

class Todo {
  String content = "";
  bool isChecked = false;

  Todo(String content, bool isChecked) {
    this.content = content;
    this.isChecked = isChecked;
  }
}

class _ListGridState extends State<ListGrid> {
  // List<String> superheroes = ['task 1', 'task 2', 'task 3'];
  // late TextEditingController textEditingController =
  //     new TextEditingController();
  late TextEditingController controller;
  ToastContext toast = ToastContext();
  List<Todo> todos = [];
  String name = '';

  bool isEmpty = false;
  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Your Name'),
            content: TextField(
                onChanged: (inputValue) {
                  if (inputValue.isEmpty) {
                    setValidator(true);
                  } else {
                    setValidator(false);
                  }
                },
                autofocus: true,
                // Add some other day

                // decoration: InputDecoration(
                //     hintText: 'Enter Name',
                //     errorText: isEmpty ? "Enter a todo" : null,
                //     errorStyle: TextStyle(color: Colors.red)),

                // Add some other day
                controller: controller),
            actions: [TextButton(onPressed: submit, child: Text('SUBMIT'))],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnapTodo'),
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: ((context, index) => Card(
              child: ListTile(
                tileColor: todos[index].isChecked ? Colors.green : null,
                title: Text(todos[index].content),
                trailing: IconButton(
                  icon: Icon(Icons.delete_forever_rounded),
                  onPressed: () {
                    setState(() {
                      todos.removeAt(index);
                    });
                  },
                ),
                leading: Checkbox(
                  activeColor: Colors.green,
                  value: todos[index].isChecked,
                  onChanged: (val) {
                    setState(() {
                      todos[index].isChecked = val!;
                    });
                  },
                ),
              ),
            )),

        //       Center(
        // child: Text(
        //   name,
        //   style: TextStyle(color: Colors.red),
        // ),
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          hoverColor: Colors.blue,
          onPressed: () async {
            final name = await openDialog();
            if (name == null || name.isEmpty) return;

            setState(() => this.name = name);
            Todo todo = new Todo(name, false);
            todos.add(todo);
            log(todos[todos.length - 1].content);
          }
          // () {
          //   createAlertDialog(context).then((onValue) {
          //     this.name = onValue;
          //     log(onValue);
          //   });
          // },
          ),
    );
  }

  void submit() {
    if (isEmpty) {
      showToast("It can not be empty");
      return;
    }
    Navigator.of(context).pop(controller.text);
    // getvalue = textEditingController.text;
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg,
        duration: duration, gravity: gravity, backgroundColor: Colors.red);
  }

  void setValidator(bool status) {
    setState(() {
      isEmpty = status;
    });
  }
}
