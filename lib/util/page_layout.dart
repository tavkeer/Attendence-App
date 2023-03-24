import 'package:attendence_app/data/database.dart';
import 'package:attendence_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class MonthsLayout extends StatefulWidget {
  final int indexofMonth;
  final String subName;
  const MonthsLayout(
      {super.key, required this.subName, required this.indexofMonth});

  @override
  State<MonthsLayout> createState() => _MonthsLayoutState();
}

class _MonthsLayoutState extends State<MonthsLayout> {
  ToDoDataBase db = ToDoDataBase();
  @override
  void initState() {
    super.initState();
    db.loadattendence(widget.subName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.05),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false);
          },
        ),
        title: Text(
          db.monthName(widget.indexofMonth),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: GridView.builder(
                  itemCount: ToDoDataBase()
                      .getMonthDays(widget.subName, widget.indexofMonth),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          ToDoDataBase().presentToggle(
                              widget.subName, index, widget.indexofMonth);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
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
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                children: [
                  //present attendence
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'This Month :  ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${db.getMonthAttendence(widget.subName, widget.indexofMonth).toStringAsFixed(2)} %",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Overall :   ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${db.getOverallAttendence(widget.subName).toStringAsFixed(2)} %",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
