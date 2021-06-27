import 'dart:convert';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TimeData {
  final int hour;
  final int minute;

  TimeData(this.hour, this.minute);

  int toMinutes() {
    return hour * 60 + minute;
  }
}

class TaskData {
  final TimeData time;
  final String name;
  final String path;

  TaskData(this.time, this.name, this.path);

  TaskData.fromJson(Map<String, dynamic> json)
      : time = TimeData(json['time.hour'], json['time.minute']),
        name = json['name'],
        path = json['path'];

  Map<String, dynamic> toJson() {
    return {
      'time.hour': time.hour,
      'time.minute': time.minute,
      'name': name,
      'path': path,
    };
  }
}

String encodeTaskList(List<TaskData> tasks) {
  return jsonEncode(tasks);
}

List<TaskData> decodeTaskList(String json) {
  try {
    List<TaskData> result = [];
    List<dynamic> list = jsonDecode(json);
    for (final item in list) {
      try {
        Map<String, dynamic> map = item;
        result.add(TaskData.fromJson(map));
      } catch (exception) {
        print(exception);
      }
    }
    return result;
  } catch (exception){
    print(exception);
    return [];
  }
}

sortTaskList(List<TaskData> list) {
  list.sort((a, b) => a.time.toMinutes() - b.time.toMinutes());
}

Future<String> _getFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  String filePath = '$appDocumentsPath/task_list.json';
  return filePath;
}

Future<void> saveTaskListAsync(List<TaskData> taskList) async {
  File file = File(await _getFilePath());
  file.writeAsString(encodeTaskList(taskList));
}

Future<List<TaskData>> loadTaskListAsync() async {
  try {
    File file = File(await _getFilePath());
    String fileContent = await file.readAsString();
    return decodeTaskList(fileContent);
  } catch (err) {
    print(err);
    return [];
  }
}