import 'package:sqflite35/utils/dbhelper.dart';
import 'dart:core';

class Car {
  int id = 0;
  String name = '';
  int miles = 0;

  Car(this.id, this.name, this.miles);

  Car.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    miles = map['milis'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnMiles:miles,
    };
  }
}
