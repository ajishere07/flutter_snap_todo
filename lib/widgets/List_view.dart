import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ListGrid extends StatefulWidget {
  const ListGrid({Key? key}) : super(key: key);

  @override
  _ListGridState createState() => _ListGridState();
}

class Todo {
  String content = "";
  bool isChecked = false;
  String id = "";
  Todo(String content, bool isChecked, String id) {
    this.content = content;
    this.isChecked = isChecked;
    this.id = id;
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

  //firebase firestore initiliaze
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isEmpty = false;
  @override
  void initState() {
    super.initState();
    ToastContext().init(context);

    fetchFromFirestore().then((value) {
      setState(() {
        todos = value;
      });
    });

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
      body: todos.length != 0
          ? Container(
              child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: ((context, index) => Card(
                    child: ListTile(
                      // changed todos=> ids
                      tileColor: todos[index].isChecked ? Colors.green : null,
                      title: Text(todos[index].content),
                      // title: Text(ids[index].content),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever_rounded),
                        onPressed: () async {
                          await db
                              .collection("todosCollection")
                              .doc("1")
                              .collection("userTodo")
                              .doc(todos[index].id)
                              .delete();

                          fetchFromFirestore().then((value) {
                            setState(() {
                              todos = value;
                            });
                          });
                        },
                      ),
                      leading: Checkbox(
                        activeColor: Colors.green,
                        //changed todos => ids
                        value: todos[index].isChecked,
                        onChanged: (val) async {
                          bool value = val!;

                          await db
                              .collection("todosCollection")
                              .doc("1")
                              .collection("userTodo")
                              .doc(todos[index].id)
                              .update({"isChecked": value});

                          fetchFromFirestore().then((value) {
                            setState(() {
                              todos = value;
                            });
                          });
                        },
                      ),
                    ),
                  )),
            ))
          : Center(
              child: Wrap(children: [
                Container(
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.blueAccent)),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/no_todos.png',
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "No todos",
                        style:
                            TextStyle(color: Color(0xffCCCCCC), fontSize: 20),
                      )
                    ],
                  ),
                )
              ]),
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          hoverColor: Colors.blue,
          onPressed: () async {
            final name = await openDialog();
            if (name == null || name.isEmpty) return;

            setState(() => this.name = name);
            const uuid = Uuid();
            String id = uuid.v1();

            Todo todo = new Todo(name, false, id);
            todos.add(todo);
            final todoData = <String, dynamic>{
              "content": todo.content,
              "isChecked": todo.isChecked,
              "id": todo.id
            };
            //firebase firestore add data

            await db
                .collection("todosCollection")
                .doc("1")
                .collection("userTodo")
                .doc(todo.id)
                .set(todoData);

            print("${todos.length}");

            fetchFromFirestore().then((value) {
              setState(() {
                todos = value;
              });
            });
          }),
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

  Future<List<Todo>> fetchFromFirestore() async {
    List<Todo> todoss = [];
    db.collection("todosCollection/1/userTodo").get().then((event) {
      for (var doc in event.docs) {
        Todo todo = new Todo(doc.get("content"), doc.get("isChecked"), doc.id);
        setState(() {
          todoss.add(todo);
        });
      }
    });
    return todoss;
  }
}
