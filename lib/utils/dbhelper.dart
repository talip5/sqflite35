import 'package:sqflite35/models/car.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static final _databaseName='cardb.db';
  static final _databaseVersion=1;
  static final table='cars_table';
  static final columnId='id';
  static final columnName='name';
  static final columnMiles='miles';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance=DatabaseHelper._privateConstructor();
  static Database? _database;
}