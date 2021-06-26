import 'package:flutter/material.dart';
import 'package:visual_schedular/AddTask.dart';
import 'dart:io';
import 'task_data.dart';
import 'package:path_provider/path_provider.dart';

// List Plan = [
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
//   {
//     'name': 'Dhruv',
//   },
// ];

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  List<TaskData> _taskList = [];

  _saveTaskList() {
    _saveTaskListAsync(_taskList).then((value) => print('save task list')).onError((error, stackTrace) => print(error));
  }

  _loadTaskList() {
    _loadTaskListAsync().then((value) =>
        setState(() {
          _taskList = value;
          for(int i=0;i<_taskList.length;i++)
            print(_taskList[i].path);
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

  Future<String> _getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/task_list.json';
    return filePath;
  }

  Future<void> _saveTaskListAsync(List<TaskData> taskList) async {
    File file = File(await _getFilePath());
    file.writeAsString(encodeTaskList(taskList));
  }
  
  Future<List<TaskData>> _loadTaskListAsync() async {
    File file = File(await _getFilePath());
    String fileContent = await file.readAsString();
    return decodeTaskList(fileContent);
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
        title: Text('Visual Schedular'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: ()=>_clearTaskList(),icon: Icon(Icons.delete),)
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(color: Colors.white),
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _taskList[index].name,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _taskList[index].time.hour.toString(),
                                  style: TextStyle(fontSize: 50),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ":",
                                  style: TextStyle(fontSize: 50),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _taskList[index].time.minute.toString(),
                                  style: TextStyle(fontSize: 50),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>AddTask()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

}
