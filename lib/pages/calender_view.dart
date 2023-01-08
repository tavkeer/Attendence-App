import 'package:attendence_app/months/page_layout.dart';
import 'package:flutter/material.dart';

class CalenderPageView extends StatefulWidget {
  final String subName;
  const CalenderPageView({super.key, required this.subName});

  @override
  State<CalenderPageView> createState() => _CalenderPageViewState();
}

class _CalenderPageViewState extends State<CalenderPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 222, 222),
        body: Center(
            child: PageView.builder(
                itemCount: 12,
                itemBuilder: ((context, index) {
                  return MonthsLayout(
                    subName: widget.subName,
                    indexofMonth: index,
                  );
                }))));
  }
}
