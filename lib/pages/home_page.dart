// ignore_for_file: prefer_const_constructors

import 'package:attendence_app/pages/calender_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/subject_tile.dart';

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

  List subjectPercentage = [];

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_subject.get("subList") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadSubjectList();
    }
    subjectPercentage = db.listOfSubjectPercentage();

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
      //app bar
      appBar: AppBar(
        title: Text(
          'Subjects',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      //button for adding new subjects
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black.withOpacity(0.3),
        onPressed: createNewSubject,
        child: Icon(Icons.add),
      ),

      //list of subjects
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment(0, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset("lib/assets/reading-book.png"),
          ),
        ),
        ListView.builder(
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
              child: subjectTile(
                percentage: subjectPercentage[index],
                taskName: db.SubjectList[index],
                deleteFunction: (context) => deleteSubject(index),
              ),
            );
          },
        ),
      ]),
    );
  }
}
