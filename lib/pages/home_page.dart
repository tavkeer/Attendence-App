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

  //no data in hive
  bool noData = true;

  //database object initialization
  ToDoDataBase db = ToDoDataBase();

  List subjectPercentage = [];

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_subject.get("subList") == null) {
      db.createInitialData();
      noData = true;
    } else {
      // there already exists data
      db.loadSubjectList();
      subjectPercentage = db.listOfSubjectPercentage();
      noData = false;
    }
    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
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
        child: const Icon(Icons.add),
      ),

      //list of subjects
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: const Alignment(0, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Image.asset(
                "lib/assets/reading-book.png",
              ),
            ),
          ),
          (noData)
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  alignment: const Alignment(0, -1),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.add_circle,
                        size: 30,
                      ),
                      Text(
                        "Add a New Subject",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: db.SubjectList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalenderPageView(
                              subName: db.SubjectList[index],
                            ),
                          ),
                        );
                      },
                      child: SubjectTile(
                        percentage: subjectPercentage[index],
                        taskName: db.SubjectList[index],
                        deleteFunction: (context) => deleteSubject(index),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  // save new task
  void saveNewSubject() {
    setState(() {
      db.SubjectList.add(_controller.text);
      db.updateDataBase(_controller.text);
      _controller.clear();
      subjectPercentage = db.listOfSubjectPercentage();
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
    setState(() {
      noData = false;
    });
  }

  // delete task
  void deleteSubject(int index) {
    setState(() {
      db.SubjectList.removeAt(index);
    });
    db.updateDataBase(_controller.text);
  }
}
