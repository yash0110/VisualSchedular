import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_schedular/DisplayTasks.dart';
import 'dart:io';
import 'task_data.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //Storing Data

  List<TaskData> _taskList = [];

  _addTask() {
    setState(() {
      _taskList.add(TaskData(TimeData(_time.hour, _time.minute),
          name.toString(), imageFile.toString()));
      sortTaskList(_taskList);
    });
  }

  _saveTaskList() {
    _addTask();
    saveTaskListAsync(_taskList)
        .then((value) => print('save task list'))
        .onError((error, stackTrace) => print(error));
    _loadTaskList();
  }

  _loadTaskList() {
    loadTaskListAsync()
        .then((value) => setState(() {
              _taskList = value;
              for (int i = 0; i < _taskList.length; i++)
                print(_taskList[i].path);
            }))
        .onError((error, stackTrace) => print(error));
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print(imageFile);
        print("PRINTLINE HELLO");
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  ////

  final _formKey = GlobalKey<FormState>();

  File? imageFile;

  TextEditingController? textEditingControllerName;
  String? name;

  TimeOfDay _time = TimeOfDay.now();

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
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
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Schedule()));
          },
        ),
        title: Text('Add Task',
          style: TextStyle(
            fontFamily: 'title',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {},
                child: Container(
                  height: 300,
                  width: 300,
                  child: imageFile == null
                      ? Image.network(
                          "https://www.pngitem.com/pimgs/m/289-2892105_empty-task-empty-icon-task-illustration-hd-png.png")
                      : Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      _getFromCamera();
                    },
                    child: Text(
                        'TAKE A PICTURE',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple[600],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      _getFromGallery();
                    },
                    child: Text("PICK FROM GALLERY"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple[600],
                    ),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40,8,40,8),
              child: TextFormField(
                controller: textEditingControllerName,
                onChanged: (value) => name = value,
                decoration: InputDecoration(
                    labelText: 'Task Name',
                    counterText: "",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
                maxLength: 20,
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text('SELECT TIME'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Selected time: ${_time.format(context)}',
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: Container(
                height: 40,
                width: 150,
                child: RaisedButton(
                  color: Colors.deepPurple[600],
                  onPressed: () {
                    _saveTaskList();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Schedule()));
                  },
                  child: Text(
                    "SAVE",
                    style: TextStyle(fontSize: 20, color: Colors.white),

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    toggleableActiveColor: shrinePink400,
    accentColor: shrineBrown900,
    primaryColor: shrinePink100,
    buttonColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: shrineBackgroundWhite,
    textSelectionColor: shrinePink100,
    errorColor: shrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        caption: base.caption!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: shrineBrown900,
        bodyColor: shrineBrown900,
      );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink400,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;
