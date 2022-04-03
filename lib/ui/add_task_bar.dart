import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(new Duration(hours: 2)))
      .toString();
  bool _isEndTimeEdit = false;
  final int _defaultTimeDif = 2;
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
    30,
  ];
  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];
  final List<int> _colors = [
    primaryClr.value,
    yellowClr.value,
    pinkClr.value,
    greenClr.value,
    blueClr.value,
    orangeClr.value,
  ];
  int _selectedColor = primaryClr.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Tasks',
                  style: headingStyle,
                ),
                MyInputField(
                  title: 'Title',
                  hint: 'Enter your title',
                  controller: _titleController,
                ),
                MyInputField(
                  title: 'Note',
                  hint: 'Enter your note',
                  controller: _noteController,
                ),
                MyInputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: 'Start Time',
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: MyInputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minutes early',
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32.0,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedRemind = int.parse(value!);
                      });
                    },
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: 'Repeat',
                  hint: '$_selectedRepeat',
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32.0,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedRepeat = value!;
                      });
                    },
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                _colorPallet(),
                SizedBox(
                  height: 18.0,
                ),
                Center(
                  child: MyButton(
                    label: 'Create Task',
                    onTap: () {
                      _validateData();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fields are required!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        colorText: Colors.red,
      );
    }
  }

  _addTaskToDB() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print('My id is ' + value.toString());
  }

  _colorPallet() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: titleStyle,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _colorList(),
                  ),
                ),
              ),
              /*GestureDetector(
                onTap:
                    () {}, //TODO: Add color add to list (Maby some database save to remember color)
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[600],
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16.0,
                      )),
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  _colorList() {
    int length = _colors.length;
    return List<Widget>.generate(
      length,
      (index) {
        return index > length
            ? _addColorWidget() //TODO: Virker ikke...
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = _colors[index];
                  });
                },
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Color(_colors[index]),
                  child: _selectedColor == _colors[index]
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16.0,
                        )
                      : Container(),
                ),
              );
      },
    );
  }

  _addColorWidget() {
    return GestureDetector(
      onTap:
          () {}, //TODO: Add color add to list (Maby some database save to remember color)
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: CircleAvatar(
            radius: 14.0,
            backgroundColor:
                Get.isDarkMode ? Colors.grey[600] : Colors.grey[600],
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 16.0,
            )),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios,
          size: 20.0,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
            'images/img.png',
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2122),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {}
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker(isStartTime: isStartTime);
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time Cancled');
    } else if (isStartTime) {
      setState(() {
        _startTime = _formattedTime;
        if (!_isEndTimeEdit) {
          int twoHours =
              int.parse(_formattedTime.split(':')[0]) + _defaultTimeDif;
          _endTime = twoHours.toString() + ':' + _formattedTime.split(':')[1];
        }
        ;
      });
    } else if (!isStartTime) {
      _isEndTimeEdit = true;
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker({required bool isStartTime}) {
    bool isAm = _startTime.split(' ')[1] == 'AM';
    int endTimeStrat = int.parse(_startTime.split(':')[0]) + _defaultTimeDif;

    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay(
        hour: isStartTime
            ? isAm
                ? int.parse(_startTime.split(':')[0])
                : int.parse(_startTime.split(':')[0]) + 12
            : _isEndTimeEdit
                ? isAm
                    ? int.parse(_endTime.split(':')[0])
                    : int.parse(_endTime.split(':')[0]) + 12
                : isAm
                    ? endTimeStrat
                    : endTimeStrat > 12
                        ? 12
                        : endTimeStrat + 12,
        minute: isStartTime
            ? endTimeStrat >= 12
                ? 00
                : int.parse(_startTime.split(':')[1].split(' ')[0])
            : _isEndTimeEdit
                ? endTimeStrat >= 12
                    ? 00
                    : int.parse(_endTime.split(':')[1].split(' ')[0])
                : endTimeStrat >= 12
                    ? 00
                    : int.parse(_startTime.split(':')[1].split(' ')[0]),
      ),
    );
  }
}
