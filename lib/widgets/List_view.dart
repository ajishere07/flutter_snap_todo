import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  // List<Todo> ids = [];
  int a = 0;
  //firebase firestore initiliaze
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isEmpty = false;
  @override
  void initState() {
    super.initState();
    ToastContext().init(context);

    // int adf = fetchFromFirestore().then((value) => log("${ids.length}"));
    fetchFromFirestore();
    // db.collection("todosCollection/1/userTodo").get().then((event) {
    //   for (var doc in event.docs) {
    //     Todo todo = new Todo(doc.id, false);
    //     setState(() {
    //       ids.add(todo);
    //     });

    //     log("${doc.id} => ${doc.data()}");
    //     print("${doc.id} => ${doc.data()}");
    //   }
    // }) as List<Todo>;

    log("$a");
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
        itemCount: a,
        itemBuilder: ((context, index) => Card(
              child: ListTile(
                // changed todos=> ids
                tileColor: todos[index].isChecked ? Colors.green : null,
                title: Text(todos[index].content),
                // title: Text(ids[index].content),
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
                  //changed todos => ids
                  value: todos[index].isChecked,
                  onChanged: (val) {
                    setState(() {
                      // changed
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
            final todoData = <String, dynamic>{
              "content": todo.content,
              "isChecked": todo.isChecked,
            };
            //firebase firestore add data
            await db
                .collection("todosCollection")
                .doc("1")
                .collection("userTodo")
                .add(todoData);
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

  Future<void> fetchFromFirestore() async {
    setState(() {
      db.collection("todosCollection/1/userTodo").get().then((event) {
        for (var doc in event.docs) {
          Todo todo = new Todo(doc.get("content"), false);
          setState(() {
            todos.add(todo);
          });

          log("${doc.id} => ${doc.data()}");
          print("${doc.id} => ${doc.data()}");
          int b = todos.length;
          setList(b);
        }
      });
    });
  }

  void setList(int b) {
    setState(() {
      this.a = b;
    });
  }
}
