import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

enum TabletType {
  Tablet,
  Capsule,
  Cream,
}

enum TabletFrequency {
  Everyday,
  Alternate,
  Weekly,
  Monthly,
}

enum TabletInDay {
  One,
  Two,
  Three,
}

enum TabletTime {
  BeforeFood,
  AfterFood,
  BeforeSleep,
}

const uuid = Uuid();

class UserMedicalReport {
  UserMedicalReport(
      {required this.startDate,
      required this.endDate,
      required this.coloring,
      required this.tabtype,
      required this.tabFreq,
      required this.tabDay,
      required this.tabTime,
      required this.compartment,
      required this.quantity,
      required this.totalcount});

  DateTime startDate;
  DateTime endDate;
  int compartment, quantity, totalcount;
  Color coloring;
  TabletType tabtype;
  TabletFrequency tabFreq;
  TabletInDay tabDay;
  TabletTime tabTime;
}
