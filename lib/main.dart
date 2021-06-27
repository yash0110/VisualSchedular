import 'package:flutter/material.dart';
import 'package:visual_schedular/DisplayTasks.dart';
import 'package:visual_schedular/task_view.dart';
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
        title: Text('Visual Schedular'),
        centerTitle: true,
        actions: [
          FloatingActionButton(onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Schedule()));
          },
            child: Icon(Icons.add),)
        ],
      ),
      body: TaskView()
    );
  }
}


