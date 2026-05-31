import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'info.dart';



class AssignmentsPage extends StatefulWidget {
  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  List<Assignment> assignments = [];
  bool isLoading = true;
  bool hasError = false;
  String response = '';
  String response2 = '';

  @override
  void initState() {
    super.initState();
    taskData();
  }

  Future<void> taskData() async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      serverSocket.write('tasks~$stuID_info\u0000');

      serverSocket.listen((socketResponse) {
        response = String.fromCharCodes(socketResponse);
        print("---------    server response is: { $response }");
        if (mounted) {
          setState(() {
            _parseResponse(response);
            isLoading = false;
            hasError = false;
          });
        }
      });

      await Future.delayed(Duration(seconds: 2)); // Ensure we read the response completely
      await serverSocket.close();
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    }
  }

  Future<void> changeCompleted(String taskTitle) async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      serverSocket.write('taskChange~$stuID_info~$taskTitle\u0000');

      serverSocket.listen((socketResponse) async {
        response2 = String.fromCharCodes(socketResponse);
        print("---------    server response is: { $response2 }");
        await taskData();
      });
      await serverSocket.close();
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    }
  }

  void _parseResponse(String response) {
    assignments.clear();
    final tasks = response.split(',');
    for (var taskData in tasks) {
      final details = taskData.split('/');
      if (details.length == 5) {
        final title = "${details[0]} - ${details[1]}";
        final courseName = details[1];
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        final dueDate = dateFormat.parse(details[2]);
        final isActive = details[4] == '1';
        final description = details[3];
        assignments.add(
          Assignment(
            title: title,
            courseName: courseName,
            dueDate: dueDate,
            isActive: isActive,
            description: description,
          ),
        );
      }
    }
    assignments.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.dueDate.compareTo(a.dueDate);  // Flip the sorting order based on dueDate
    });
  }

  void _updateAssignmentCompletionStatus(Assignment assignment, bool isCompleted) {
    setState(() {
      assignment.isCompleted = isCompleted;
      assignment.isActive = !isCompleted;
    });
    changeCompleted(assignment.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
            ? Center(child: Text('Error loading assignments'))
            : assignments.isEmpty
            ? Center(child: Text('No assignments available'))
            : ListView(
          children: [
            SizedBox(height: 20),
            ...assignments.map((assignment) => AssignmentCard(
              assignment: assignment,
              onCompletedChanged: (isCompleted) =>
                  _updateAssignmentCompletionStatus(assignment, isCompleted),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class Assignment {
  final String title;
  final String courseName;
  final DateTime dueDate;
  final String description;
  bool isActive;
  bool isCompleted;

  Assignment({
    required this.title,
    required this.courseName,
    required this.dueDate,
    required this.description,
    required this.isActive,
  }) : isCompleted = !isActive;
}

class AssignmentCard extends StatefulWidget {
  final Assignment assignment;
  final ValueChanged<bool> onCompletedChanged;

  const AssignmentCard({required this.assignment, required this.onCompletedChanged});

  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.assignment.isCompleted ? 0.5 : 1.0,
      child: Card(
        color: Color(0xFF2F1E9D),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: Checkbox(
            value: widget.assignment.isCompleted,
            activeColor: Colors.white,
            checkColor: Color(0xFF2F1E9D),
            onChanged: (bool? value) {
              setState(() {
                widget.assignment.isCompleted = value ?? false;
              });
              widget.onCompletedChanged(value ?? false);
            },
          ),
          title: Text(widget.assignment.title,
            style: TextStyle(color: Colors.white),),
          subtitle: Text(DateFormat.yMMMMd('en').format(widget.assignment.dueDate), style: TextStyle(
            color: Colors.white,
          ),),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignmentDetailsPage(
                  assignment: widget.assignment,
                  onCompletedChanged: widget.onCompletedChanged,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AssignmentDetailsPage extends StatefulWidget {
  final Assignment assignment;
  final ValueChanged<bool> onCompletedChanged;

  const AssignmentDetailsPage({required this.assignment, required this.onCompletedChanged});

  @override
  _AssignmentDetailsPageState createState() => _AssignmentDetailsPageState();
}

class _AssignmentDetailsPageState extends State<AssignmentDetailsPage> {
  File? _pickedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff9f8fe),
        title: const Text(
          'Task Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${widget.assignment.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 40),
            Text('Deadline: ${DateFormat.yMMMMd('en').format(widget.assignment.dueDate)}'),
            SizedBox(height: 20),
            Text('Description: ${widget.assignment.description}'),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('Mark as completed'),
              value: widget.assignment.isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  widget.assignment.isCompleted = value ?? false;
                });
                widget.onCompletedChanged(value ?? false);
              },
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF2FF),
                labelText: 'Upload Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  child: Text('Upload PDF'),
                ),
                if (_pickedFile != null) ...[
                  SizedBox(height: 10),
                  Text('Selected file: ${_pickedFile!.path.split('/').last}'),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle file upload to server or storage
                  },
                  child: Text('Send'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
