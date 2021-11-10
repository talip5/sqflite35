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

  List<Car> cars=[];
  List<Car> carsByName=[];

  TextEditingController nameController=TextEditingController();
  TextEditingController milesController=TextEditingController();
  TextEditingController queryController=TextEditingController();
  TextEditingController idUpdateController=TextEditingController();
  TextEditingController nameUpdateController=TextEditingController();
  TextEditingController milesUpdateController=TextEditingController();
  TextEditingController idDeleteController=TextEditingController();

  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(content: Text(message)),
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
            Container(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                  itemCount:cars.length+1 ,
                  itemBuilder: (BuildContext context,int index){
                  if(index==cars.length){
                    return ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _queryAll();
                          });
                        },
                        child: Text('Refresh'),
                    );
                  }
                  return Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        '[${cars[index].id}] - ${cars[index].name} - ${cars[index].miles}',style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  );
                  }),
            ),
            Center(
              child: (Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: queryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Car Name',
                      ),
                      onChanged: (text){
                        if(text.length >=2){
                          setState(() {
                            print(text);
                            _query(text);
                          });
                        }else{
                          setState(() {
                            carsByName.clear();
                          });
                        }
                      },
                    ),
                    height: 100,
                  ),
                  Expanded(
                    child: Container(
                      height: 300,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                          itemCount: carsByName.length,
                          itemBuilder: (BuildContext context,int index){
                            return Container(
                              height: 50,
                              margin: EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  '[${carsByName[index].id} - ${carsByName[index].name} - ${carsByName[index].miles}]',style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              )
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:EdgeInsets.all(20.0),
                      child: TextField(
                        controller: idUpdateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Car ID',
                        ),
                      ),
                    ),
                    Container(
                      padding:EdgeInsets.all(20.0),
                      child: TextField(
                        controller: nameUpdateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Car Name',
                        ),
                      ),
                    ),
                    Container(
                      padding:EdgeInsets.all(20.0),
                      child: TextField(
                        controller: milesUpdateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Car Mile',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        int id=int.parse(idUpdateController.text);
                        String name=nameUpdateController.text;
                        int miles=int.parse(milesUpdateController.text);
                        _update(id,name,miles);
                      },
                      child: Text('Update Car Details'),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding:EdgeInsets.all(20.0),
                    child: TextField(
                      controller: idDeleteController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Car ID',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      int id=int.parse(idDeleteController.text);
                      _delete(id);
                    },
                    child: Text('Update Car Details'),
                  ),
                ],
              ),
            ),
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

  void _queryAll() async{
    final allRows=await dbHelper.queryAllRows();
    cars.clear();
    allRows.forEach((row)=>cars.add(Car.fromMap(row)));
    _showMessageInScaffold('Query done.');
    setState(() {
    });
  }

  void _query(name) async{
    print(name);
    final allRows=await dbHelper.queryRows(name);
    print(allRows.length);
    carsByName.clear();
    allRows.forEach((row) =>carsByName.add(Car.fromMap(row)));

  }

  void _update(int id, String name, int miles) async{
    Car car=Car(id, name, miles);
   final rowsAffeted=await dbHelper.update(car);
   _showMessageInScaffold('updeted $rowsAffeted row(s)');
  }

  void _delete(int id) async{
    final rowsDeleted=await dbHelper.delete(id);
    _showMessageInScaffold('deleted $rowsDeleted row(s) : rows $id');
  }


}
