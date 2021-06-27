import 'package:flutter/material.dart';
import 'package:visual_schedular/AddTask.dart';
import 'package:visual_schedular/main.dart';
import 'dart:io';
import 'task_data.dart';
import 'package:path_provider/path_provider.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  List<TaskData> _taskList = [];

  _saveTaskList() {
    saveTaskListAsync(_taskList).then((value) => print('save task list')).onError((error, stackTrace) => print(error));
  }

  _loadTaskList() {
    loadTaskListAsync().then((value) =>
        setState(() {
          _taskList = value;
          for(int i=0;i<_taskList.length;i++)
            print(_taskList[i].name);
        })
    ).onError((error, stackTrace) => print(error));
  }

  _clearTaskList() {
    setState(() {
      _taskList.clear();
      _saveTaskList();
      _loadTaskList();
    });
  }

  void initState() {
    // TODO: implement initState
    _loadTaskList();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[600],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MyApp()));
          },
        ),
        title: Text(
          'Schedule',
          style: TextStyle(
            fontFamily: 'title',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()=>_clearTaskList(),icon: Icon(Icons.delete),
          )
        ],
      ),
      backgroundColor: Colors.indigo[50],
      body: Container(
        margin: EdgeInsets.all(15),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16,0,16,24),
          child: ListView.builder(
              itemBuilder: (context, index) {
                print(_taskList[index].path);
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 140,
                              height: 130,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(_taskList[index].path.substring(7,_taskList[index].path.length-1)))
                                  )
                              )
                          )
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _taskList[index].name,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _taskList[index].time.hour.toString(),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ":",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _taskList[index].time.minute.toString(),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ));
              },
              itemCount: _taskList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics()),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>AddTask()));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.deepPurple[600],
        ),
      ),
    );
  }

}
