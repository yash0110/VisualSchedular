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
  // const HomePage({Key? key}) : super(key: key);

  var password="12345678";
  TextEditingController? textEditingControllerName;
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.calendar_today),
          title: Text('Visual Schedular'),
          centerTitle: true,
          actions: [
            FloatingActionButton(
              // onPressed: () {
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => Schedule(),
              //     ),
              //   );
              // },
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Enter Password'),
                  content: TextFormField(
                    controller: textEditingControllerName,
                    onChanged: (value) => name = value,
                    decoration: InputDecoration(
                        // labelText: "",
                        // counterText: "",
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
                    maxLength: 20,
                    keyboardType: TextInputType.name,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (name==password){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Schedule(),
                            ),
                          );
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              child: Icon(Icons.add),
            )
          ],
        ),
        body: TaskView());
  }
}
