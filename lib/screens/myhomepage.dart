import 'package:sqflite35/utils/dbhelper.dart';
import 'package:sqflite35/models/car.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController=TextEditingController();
  TextEditingController milesController=TextEditingController();

  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(content: content)
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Car App - SQFLite'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'insert',
              ),
              Tab(
                text: 'view',
              ),
              Tab(
                text: 'Query',
              ),
              Tab(
                text: 'update',
              ),
              Tab(
                text: 'delete',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding:EdgeInsets.all(20.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Car Name',
                      ),
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.all(20.0),
                    child: TextField(
                      controller: milesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Car Mile',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        String name=nameController.text;
                        int miles=int.parse(milesController.text);
                        _insert(name,miles);
                      },
                      child: Text('Insert Car Details'),
                  ),
                ],
              ),
            ),
            Container(),
            Center(),
            Center(),
            Center(),
          ],
        ),
      ),
    );
  }

  void _insert(String name, int miles) async{
  Map<String,dynamic> row={
    DatabaseHelper.columnName:name,
    DatabaseHelper.columnMiles:miles
  };
  Car car=Car.fromMap(row);
  final id=await dbHelper.insert(car);
  _showMessageInScaffold('inserted row id: $id');
  }


}
