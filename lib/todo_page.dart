import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class TaskModel {
  final String id;
  final String title;
  final DateTime deadline;
  DateTime? reminder;
  bool isDone;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.deadline,
    this.reminder,
    this.isDone = false,
    this.isCompleted = false,
  });
}

class Kara extends StatefulWidget {
  @override
  _KaraState createState() => _KaraState();
}

class _KaraState extends State<Kara> {
  final List<TaskModel> _tasks = [];
  // final List<TaskModel> _completedTasks = [];///////////////////
  final TextEditingController _taskTextEditingController = TextEditingController();
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0);
  DateTime? _selectedReminder;

  void _createTask(TaskModel task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _removeTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
      // _completedTasks.removeWhere((task) => task.id == taskId);
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleTaskStatus(TaskModel task) {
    setState(() {
      task.isDone = !task.isDone;
      // if (task.isDone) {
      //   _completedTasks.add(task);
      // } else {
      //   _completedTasks.removeWhere((completedTask) => completedTask.id == task.id);
      // }
    });
  }

  Future<void> _selectDate(BuildContext context, {bool isDeadline = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
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
      // appBar: AppBar(
      //   title: Text('Tasks'),
      //   centerTitle: true,
      //   backgroundColor: Colors.pinkAccent,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Text(
            //     '${DateFormat('yMMMMd', 'en').format(DateTime.now())}',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: incompleteTasks.length + 1, // +1 for the Completed section
                // itemCount: _tasks.where((task) => !task.isDone).length + 1, // +1 for the Completed section
                itemBuilder: (context, index) {
                  if (index < incompleteTasks.length) {
                    final task = incompleteTasks[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            // decoration: task.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          'Deadline: ${DateFormat('h:mm a', 'en').format(task.deadline)}',
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
                                task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
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
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text('Add a new task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _taskTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('For:'),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(DateFormat('yMMMMd', 'en').format(_selectedDate)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('Hour:'),
                            SizedBox(height: 5),
                            DropdownButton<int>(
                              value: _selectedTime.hour,
                              items: List.generate(24, (index) {
                                return DropdownMenuItem(
                                  value: index,
                                  child: Text(index.toString()),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTime = TimeOfDay(hour: value!, minute: _selectedTime.minute);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Text('Minutes:'),
                            SizedBox(height: 5),
                            DropdownButton<int>(
                              value: _selectedTime.minute,
                              items: List.generate(60, (index) {
                                return DropdownMenuItem(
                                  value: index,
                                  child: Text(index.toString()),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: value!);
                                });
                              },
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
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: onTabTapped,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list),
      //       label: 'Todo',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       label: 'Classes',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'News',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.assignment),
      //       label: 'Tasks',
      //     ),
      //   ],
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.grey,
      //   backgroundColor: Color(0xFF2F1E9D),
      //   type: BottomNavigationBarType.fixed,
      // ),
    );
  }
}
