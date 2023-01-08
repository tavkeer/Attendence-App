// ignore_for_file: prefer_const_constructors

import 'package:attendence_app/data/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MonthsLayout extends StatefulWidget {
  final int indexofMonth;
  final String subName;
  const MonthsLayout(
      {super.key, required this.subName, required this.indexofMonth});

  @override
  State<MonthsLayout> createState() => _MonthsLayoutState();
}

class _MonthsLayoutState extends State<MonthsLayout> {
  final _month = Hive.box('cal');
  ToDoDataBase db = ToDoDataBase();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db.loadattendence(widget.subName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(db.monthName(widget.indexofMonth)),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: GridView.builder(
              itemCount: ToDoDataBase()
                  .getMonthDays(widget.subName, widget.indexofMonth),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      ToDoDataBase().presentToggle(
                          widget.subName, index, widget.indexofMonth);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (db.getColor(
                              widget.subName, index, widget.indexofMonth)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text((index + 1).toString())),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
