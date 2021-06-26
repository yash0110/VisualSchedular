import 'dart:convert';

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