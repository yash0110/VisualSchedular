import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visual_schedular/task_data.dart';

class TaskView extends StatefulWidget {
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TaskData? _currentTask;

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

  Future<DateTime?> _getProcessedTime() async {
    final SharedPreferences prefs = await _prefs;
    int? timestamp = prefs.getInt('process');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      return null;
    }
  }

  Future<void> _saveProcessedTime() async {
    final SharedPreferences prefs = await _prefs;
    DateTime now_date_time = DateTime.now();
    await prefs.setInt('process', now_date_time.millisecondsSinceEpoch);
  }

  Future<void> _timeoutNotify(TaskData task) async {
    print('timeout ${task.name}, ${task.time.hour}:${task.time.minute}');
  }

  Future<List<TaskData>> _getTimeoutTask() async {
    DateTime? processedTime = await _getProcessedTime();
    List<TaskData> list = await _loadTaskListAsync();
    DateTime nowDateTime = DateTime.now();
    List<TaskData> result = [];
    TaskData? lastTask;

    for (final task in list) {
      DateTime endDateTime = DateTime(nowDateTime.year, nowDateTime.month,
          nowDateTime.day, task.time.hour, task.time.minute);
      if (lastTask != null) {
        DateTime startDateTime = DateTime(nowDateTime.year, nowDateTime.month,
            nowDateTime.day, lastTask.time.hour, lastTask.time.minute);
        if (endDateTime.isBefore(nowDateTime)) {
          if (processedTime != null) {
            if (startDateTime.isAfter(processedTime)) {
              result.add(lastTask);
            }
          } else {
            result.add(lastTask);
          }
        }
      }
      lastTask = task;
    }
    return result;
  }

  Future<TaskData?> _getCurrentTask() async {
    List<TaskData> list = await _loadTaskListAsync();
    sortTaskList(list);
    TimeOfDay now = TimeOfDay.now();
    int minute = TimeData(now.hour, now.minute).toMinutes();
    TaskData? result;
    DateTime nowDateTime = DateTime.now();
    DateTime? processedTime = await _getProcessedTime();
    for (final task in list) {
      if (task.time.toMinutes() > minute) {
        break;
      }
      result = task;
    }
    DateTime taskDateTime = DateTime(nowDateTime.year, nowDateTime.month,
        nowDateTime.day, result!.time.hour, result.time.minute);
    if (processedTime != null) {
      if (processedTime.isBefore(taskDateTime)) {
        return result;
      } else {
        return null;
      }
    } else {
      return result;
    }
  }

  _longPress() {
    print('long press');
    _updateCurrentTask().then((value) {
      setState(() {
        _saveProcessedTime();
      });
      print('save');
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _updateCurrentTask() async {
    print('update');
    List<TaskData> timeout = await _getTimeoutTask();
    if (timeout.isNotEmpty) {
      TaskData last = timeout.last;
      for (final task in timeout) {
        await _timeoutNotify(task);
      }
      var nowDateTime = DateTime.now();
      DateTime newProc = DateTime(nowDateTime.year, nowDateTime.month,
          nowDateTime.day, last.time.hour, last.time.minute);
      final SharedPreferences prefs = await _prefs;

      await prefs.setInt('process', newProc.millisecondsSinceEpoch);
    }

    _getCurrentTask()
        .then((value) => setState(() {
              _currentTask = value;
            }))
        .catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateCurrentTask();
    Timer.periodic(Duration(seconds: 10), (timer) {
      _updateCurrentTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateCurrentTask().then((value) {setState(() {
    });});

    Widget child = Center(
        child: Text(
      'No Tasks, Good Job!!!',
      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
    ));
    if (_currentTask != null) {
      TaskData task = _currentTask!;
      child = Column(
        children: [
          Center(
              child: Text(
            task.name,
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),
          )),
          Center(
              child: Text(
            '${task.time.hour}:${task.time.minute}',
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
          )),
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                      image: FileImage(File(
                          task.path.substring(7, task.path.length - 1)))))),
          Image.file(File(task.path.substring(7, task.path.length - 1))),

          // Temp Button to set process time

          // TextButton(onPressed: () async {
          //   DateTime nowDateTime = DateTime.now();
          //   DateTime endDateTime = DateTime(nowDateTime.year, nowDateTime.month,
          //       nowDateTime.day, 2, 47);
          //   final SharedPreferences prefs = await _prefs;
          //
          //   await prefs.setInt('process', endDateTime.millisecondsSinceEpoch);
          // }, child: Text("proc"))
        ],
      );
    }
    return GestureDetector(
      onLongPress: _longPress,
      child: child,
    );
  }
}
