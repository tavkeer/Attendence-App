// ignore_for_file: prefer_const_constructors

import 'package:attendence_app/pages/calender_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _subject = Hive.box('subList');

  //database object initialization
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_subject.get("subList") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadSubjectList();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // save new task
  void saveNewSubject() {
    setState(() {
      db.SubjectList.add(_controller.text);
      db.updateDataBase(_controller.text);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  // create a new task
  void createNewSubject() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewSubject,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteSubject(int index) {
    setState(() {
      db.SubjectList.removeAt(index);
    });
    db.updateDataBase(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],

      //app bar
      appBar: AppBar(
        title: Text('Subjects'),
        elevation: 0,
      ),

      //button for adding new subjects
      floatingActionButton: FloatingActionButton(
        onPressed: createNewSubject,
        child: Icon(Icons.add),
      ),

      //list of subjects
      body: ListView.builder(
        itemCount: db.SubjectList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalenderPageView(
                            subName: db.SubjectList[index],
                          )));
            },
            child: ToDoTile(
              taskName: db.SubjectList[index],
              deleteFunction: (context) => deleteSubject(index),
            ),
          );
        },
      ),
    );
  }
}
