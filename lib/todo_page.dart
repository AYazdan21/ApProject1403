import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'info.dart';

class TaskModel {
  final String id;
  final String title;
  final DateTime deadline;
  DateTime? reminder;
  bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.deadline,
    this.reminder,
    this.isDone = false,
  });
}

class Kara extends StatefulWidget {
  @override
  _KaraState createState() => _KaraState();
}

class _KaraState extends State<Kara> {
  final List<TaskModel> _tasks = [];
  final TextEditingController _taskTextEditingController = TextEditingController();
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0);
  DateTime? _selectedReminder;
  String response = '';

  @override
  void initState() {
    super.initState();
    _fetchTasksFromServer();
  }

  Future<void> _fetchTasksFromServer() async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      serverSocket.write('todos~$stuID_info\u0000');

      serverSocket.listen((socketResponse) {
        response = String.fromCharCodes(socketResponse);
        print("Server response: $response");
        _parseAndAddTasks(response);
      });
    } catch (e) {
      print("Error connecting to server: $e");
    }
  }

  void _parseAndAddTasks(String data) {
    List<String> tasksData = data.split(',');
    for (var taskData in tasksData) {
      List<String> taskDetails = taskData.split('/');
      if (taskDetails.length == 4) {
        String title = taskDetails[0];
        DateTime deadline = DateFormat('yyyy-MM-dd h:mm a').parse('${taskDetails[1]} ${taskDetails[2]}');
        bool isDone = taskDetails[3] == '0';

        TaskModel newTask = TaskModel(
          id: DateTime.now().toString(),
          title: title,
          deadline: deadline,
          isDone: isDone,
        );

        setState(() {
          _tasks.add(newTask);
        });
      }
    }
  }

  Future<void> _sendTaskToServer(TaskModel task) async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      String formattedDate = DateFormat('yyyy-MM-dd').format(task.deadline);
      String formattedTime = DateFormat('h:mm a').format(task.deadline);
      serverSocket.write('addTodo~${task.title}~$formattedDate~$formattedTime~$stuID_info\u0000');
      await serverSocket.flush();
      serverSocket.close();
    } catch (e) {
      print("Error connecting to server: $e");
    }
  }

  void _createTask(TaskModel task) {
    setState(() {
      _tasks.add(task);
    });
    _sendTaskToServer(task); // Call the method to send the task to the server
  }

  Future<void> _removeTask(String taskId) async {
    final task = _tasks.firstWhere((task) => task.id == taskId);
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      serverSocket.write('deleteTodo~${task.title}~$stuID_info\u0000');
      await serverSocket.flush();
      serverSocket.close();
    } catch (e) {
      print("Error connecting to server: $e");
    }

    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  Future<void> _toggleTaskStatus(TaskModel task) async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      String status = task.isDone ? '0' : '1';
      serverSocket.write('updateTodo~${task.title}~$status~$stuID_info\u0000');
      await serverSocket.flush();
      serverSocket.close();
    } catch (e) {
      print("Error connecting to server: $e");
    }

    setState(() {
      task.isDone = !task.isDone;
    });
  }

  Future<void> _selectDate(BuildContext context, {bool isDeadline = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _selectedDate = picked;
        } else {
          _selectedReminder = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, {bool isDeadline = true}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isDeadline ? _selectedTime : TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _selectedTime = picked;
        } else {
          _selectedReminder = DateTime(
            _selectedReminder!.year,
            _selectedReminder!.month,
            _selectedReminder!.day,
            picked.hour,
            picked.minute,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = _tasks.where((task) => !task.isDone).toList();
    final completedTasks = _tasks.where((task) => task.isDone).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: incompleteTasks.length + 1, // +1 for the Completed section
                itemBuilder: (context, index) {
                  if (index < incompleteTasks.length) {
                    final task = incompleteTasks[index];
                    return Card(
                      color: Color(0xFF2F1E9D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Deadline: ${DateFormat('h:mm a', 'en').format(task.deadline)}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeTask(task.id);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                task.isDone ? Icons.check_box : Icons.radio_button_unchecked,
                                color: task.isDone ? Colors.green : Colors.grey,
                              ),
                              onPressed: () {
                                _toggleTaskStatus(task);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Show Completed section
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Completed',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: completedTasks.length,
                          itemBuilder: (context, index) {
                            final completedTask = completedTasks[index];
                            return ListTile(
                              title: Text(
                                completedTask.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: completedTask.isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Text(
                                'Deadline: ${DateFormat('h:mm a', 'en').format(completedTask.deadline)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _removeTask(completedTask.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      completedTask.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: completedTask.isDone ? Colors.green : Colors.grey,
                                    ),
                                    onPressed: () {
                                      _toggleTaskStatus(completedTask);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF2F1E9D),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  'Add a new task',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _taskTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Title...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('For:'),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text(DateFormat('yMMMMd', 'en').format(_selectedDate)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2F1E9D),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('Select Time:'),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _selectTime(context),
                              child: Text(DateFormat('hh:mm a').format(DateTime(
                                0,
                                0,
                                0,
                                _selectedTime.hour,
                                _selectedTime.minute,
                              ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_taskTextEditingController.text.isNotEmpty) {
                        final TaskModel newTask = TaskModel(
                          id: DateTime.now().toString(),
                          title: _taskTextEditingController.text,
                          deadline: DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTime.hour,
                            _selectedTime.minute,
                          ),
                          reminder: _selectedReminder,
                        );
                        _createTask(newTask);
                        _taskTextEditingController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add', style: TextStyle(color: Colors.pinkAccent)),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
