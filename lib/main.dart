import 'package:flutter/material.dart';
import 'package:visual_schedular/DisplayTasks.dart';
import 'package:visual_schedular/task_view.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.calendar_today),
        backgroundColor: Colors.deepPurple[600],
        title: Text(
          'Visual Schedular',
          style: TextStyle(
            fontFamily: 'title',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Schedule()));
              },
              child: Icon(
                Icons.edit,

              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple[600],
            ),
          )
        ],
      ),
        body: TaskView(),
      bottomNavigationBar: new Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.fromLTRB(20, 0,20,20),
        height: 40.0,
        child: Text(
            'Scheduling made Accessible',
          style: TextStyle(
            fontFamily: 'italic',
            fontSize: 20,
            color: Colors.deepPurple[600],
          ),

        ),
      ),
      backgroundColor: Colors.indigo[50],
    );
  }
}


