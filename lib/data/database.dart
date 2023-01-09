// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List SubjectList = [];
  Map Attendece = {};

  // reference our box
  final _subjects = Hive.box('subList');
  final _cal = Hive.box('cal');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    SubjectList = [];
  }

  // load the data from database
  void loadSubjectList() {
    SubjectList = _subjects.get("subList");
  }

  //load the calender data of attendence
  void loadattendence(String sub) {
    Attendece = _cal.get(sub);
  }

  // update the database
  void updateDataBase(String sub) {
    _subjects.put("subList", SubjectList);
    _cal.put(sub, createMap());
  }

  // void updateAttendence(String sub) {
  //   _cal.put(sub, Attendece);
  // }

  void presentToggle(String sub, int index, int month) {
    Map check = _cal.get(sub);
    if (check[month][index][1] == 0) {
      check[month][index][1] = 1;
    } else if (check[month][index][1] == 1) {
      check[month][index][1] = -1;
    } else {
      check[month][index][1] = 0;
    }
    _cal.put(sub, check);
  }

  Color getColor(String sub, int index, int month) {
    Map check = _cal.get(sub);
    if (check[month][index][1] == 1) {
      return Colors.green;
    } else if (check[month][index][1] == -1) {
      return Colors.red.shade400;
    }
    return Colors.black.withOpacity(0.05);
  }

  Map createMap() {
    Map fullcalender = {
      0: getdays(1),
      1: getdays(3),
      2: getdays(1),
      3: getdays(2),
      4: getdays(1),
      5: getdays(2),
      6: getdays(1),
      7: getdays(1),
      8: getdays(2),
      9: getdays(1),
      10: getdays(2),
      11: getdays(1),
    };
    return fullcalender;
  }

  List getdays(int n) {
    List days = [
      [1, 0],
      [2, 0],
      [4, 0],
      [3, 0],
      [5, 0],
      [7, 0],
      [6, 0],
      [8, 0],
      [9, 0],
      [10, 0],
      [11, 0],
      [12, 0],
      [13, 0],
      [14, 0],
      [15, 0],
      [16, 0],
      [17, 0],
      [18, 0],
      [19, 0],
      [20, 0],
      [21, 0],
      [22, 0],
      [23, 0],
      [24, 0],
      [25, 0],
      [26, 0],
      [27, 0],
      [28, 0],
      [29, 0],
      [30, 0],
      [31, 0],
    ];
    if (n == 1) {
      return days;
    } else if (n == 2) {
      return days.sublist(0, days.length - 1);
    } else {
      return days.sublist(0, days.length - 3);
    }
  }

  int getMonthDays(String sub, int month) {
    switch (month) {
      case 0:
        {
          return 31;
        }
      case 1:
        {
          return 28;
        }

      case 2:
        {
          return 31;
        }

      case 3:
        {
          return 30;
        }

      case 4:
        {
          return 31;
        }

      case 5:
        {
          return 30;
        }

      case 6:
        {
          return 31;
        }

      case 7:
        {
          return 31;
        }

      case 8:
        {
          return 30;
        }

      case 9:
        {
          return 31;
        }

      case 10:
        {
          return 30;
        }
    }
    return 31;
  }

  monthName(int monthIndex) {
    switch (monthIndex) {
      case 0:
        {
          return "January";
        }

      case 1:
        {
          return "Febuary";
        }

      case 2:
        {
          return "March";
        }

      case 3:
        {
          return "April";
        }

      case 4:
        {
          return "May";
        }

      case 5:
        {
          return "June";
        }

      case 6:
        {
          return "July";
        }

      case 7:
        {
          return "August";
        }

      case 8:
        {
          return "September";
        }

      case 9:
        {
          return "October";
        }

      case 10:
        {
          return "November";
        }

      case 11:
        {
          return "December";
        }
    }
  }

  //month attendence
  getMonthAttendence(String sub, int month) {
    Map check = _cal.get(sub);
    int present = 0;
    int absent = 0;
    //check[month][index][1];
    for (int i = 0; i < check[month].length; i++) {
      if (check[month][i][1] == 1) {
        present++;
      } else if (check[month][i][1] == -1) {
        absent++;
      }
    }
    double persentage = present / (present + absent);
    return persentage * 100;
  }

  getOverallAttendence(String sub) {
    Map check = _cal.get(sub);
    int present = 0;
    int absent = 0;
    //check[month][index][1];
    for (int j = 0; j < 12; j++) {
      for (int i = 0; i < check[j].length; i++) {
        if (check[j][i][1] == 1) {
          present++;
        } else if (check[j][i][1] == -1) {
          absent++;
        }
      }
    }
    double persentage = present / (present + absent);
    return persentage * 100;
  }

  listOfSubjectPercentage() {
    List listAttendence = [];
    for (int i = 0; i < SubjectList.length; i++) {
      listAttendence.add(getOverallAttendence(SubjectList[i]));
    }
    return listAttendence;
  }
}
