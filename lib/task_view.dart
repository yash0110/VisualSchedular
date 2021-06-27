import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visual_schedular/task_data.dart';

class TaskView extends StatefulWidget {
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView>  with TickerProviderStateMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TaskData? _currentTask;
  List<TaskData> _taskList = [];
  FlutterTts flutterTts = FlutterTts();

  Future<DateTime?> _getProcessedTime() async {
    final SharedPreferences prefs = await _prefs;
    int? timestamp = prefs.getInt('process');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      return null;
    }
  }

  Future<void> _saveProcessedTime(TimeData timeData) async {
    final SharedPreferences prefs = await _prefs;
    DateTime now = DateTime.now();
    await prefs.setInt(
        'process',
        DateTime(now.year, now.month, now.day, timeData.hour, timeData.minute)
            .millisecondsSinceEpoch);
  }

  Future<TaskData?> _getCurrentTask(List<TaskData> list) async {
    TaskData? result;
    DateTime nowDate = _eraseTime(DateTime.now());
    TimeData nowTime = _getTime(DateTime.now());
    DateTime? _processedTime = await _getProcessedTime();
    TimeData processedTime = TimeData(0, 0);
    if (_processedTime != null) {
      DateTime processedDate = _eraseTime(_processedTime);
      if (processedDate.isAtSameMomentAs(nowDate)) {
        processedTime = _getTime(_processedTime);
      }
    }
    for (final task in list) {
      if (task.time.toMinutes() > processedTime.toMinutes()) {
        result = task;
        break;
      }
    }
    print("processedTime ${processedTime.hour}:${processedTime.minute}");
    if (result != null) {
      if (result.time.toMinutes() <= nowTime.toMinutes()) {
        return result;
      }
    }
  }

  Future<void> _longPress() async {
    if (_currentTask != null) {
      await _saveProcessedTime(_currentTask!.time);
    }
    await _updateState();
  }

  Future<void> _updateState() async {
    _taskList = await loadTaskListAsync();
    if (_taskList.isEmpty) {
      await _saveProcessedTime(TimeData(0, 0));
    }

    TaskData? task = await _getCurrentTask(_taskList);
    if (task != _currentTask && mounted) {
      setState(() {
        _currentTask = task;
        print('update current task');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      _updateState();
    });
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if (_currentTask != null) {
      TaskData task = _currentTask!;

      // Widget when we find a task
      return Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        margin: EdgeInsets.fromLTRB(15, 15,15, 0),
        padding: EdgeInsets.all(20),
        child: GestureDetector(
          onLongPress: _longPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ScaleTransition(
                scale: _animation,
                child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: FileImage(
                                File(
                                  task.path.substring(7, task.path.length - 1),
                              ),
                            ),
                        ),
                    ),
                ),
              ),
              //Image.file(File(task.path.substring(7, task.path.length - 1))),
              Center(
                  child: Text(
                    task.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  )),
              Center(
                  child: Text(
                'Longpress screen after task is done',
                style: TextStyle(
                  fontSize: 18,
                ),
              )),

            ],
          ),
        ),
      );
    } else {

      // Widget when no task available
      return Center(
          child: Text(
        'No Pending Tasks, Good Job!!!',
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
      ));
    }

    // Widget
  }
}

DateTime _eraseTime(DateTime t) {
  return DateTime(t.year, t.month, t.day);
}

TimeData _getTime(DateTime t) {
  return TimeData(t.hour, t.minute);
}
