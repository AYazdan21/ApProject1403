import 'dart:io';
import 'package:flutter/material.dart';
import 'info.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final TextEditingController _textController = TextEditingController();
  List<ClassCard> classCards = [];
  bool isLoading = true;
  bool hasError = false;
  String response = '';
  String response2 = '';
  bool classExists = true;
  bool alreadyInClass = false;

  @override
  void initState() {
    super.initState();
    classData();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> classData() async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      serverSocket.write('class~$stuID_info\u0000');

      serverSocket.listen((socketResponse) {
        response = String.fromCharCodes(socketResponse);
        print("---------    server response is: { $response }");

        setState(() {
          _parseResponse(response);
          isLoading = false;
          hasError = false;
        });
      });
      await serverSocket.close();
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> addCourse() async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      serverSocket.write('classAddCourse~$stuID_info~${_textController.text}\u0000');

      serverSocket.listen((socketResponse) {
        response2 = String.fromCharCodes(socketResponse);
        print("---------    server response is: { $response2 }");
        if (response2 == "0") {
          setState(() {
            classExists = false;
            _parseResponse2(response2);
          });
        } else if (response2 == "1") {
          setState(() {
            alreadyInClass = true;
            _parseResponse2(response2);
          });
        } else {
          setState(() {
            classExists = true;
            alreadyInClass = false;
            _parseResponse2(response2);
          });
        }
      });
      await serverSocket.close();
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _parseResponse(String response) {
    classCards.clear();
    final classes = response.split('-');
    for (var classInfo in classes) {
      final details = classInfo.split('/');
      if (details.length == 5) {
        final title = details[0];
        final teacher = details[1];
        final unitCount = int.parse(details[2]);
        final remainingAssignments = int.parse(details[3]);
        final topStudent = details[4];
        final color = Color(0xFF2F1E9D);
        classCards.add(
          ClassCard(
            title: title,
            teacher: teacher,
            unitCount: unitCount,
            remainingAssignments: remainingAssignments,
            topStudent: topStudent,
            color: color,
          ),
        );
      }
    }
  }

  void _parseResponse2(String response2) {
    if (classExists && !alreadyInClass) {
      final details = response2.split('/');
      if (details.length == 5) {
        final title = details[0];
        final teacher = details[1];
        final unitCount = int.parse(details[2]);
        final remainingAssignments = int.parse(details[3]);
        final topStudent = details[4];
        final color = Color(0xFF2F1E9D);
        classCards.add(
          ClassCard(
            title: title,
            teacher: teacher,
            unitCount: unitCount,
            remainingAssignments: remainingAssignments,
            topStudent: topStudent,
            color: color,
          ),
        );
      }
    } else {
      if (!classExists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('This class doesn\'t exist!'),
          backgroundColor: Colors.red,
        ));
      } else if (alreadyInClass) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You are already enrolled in this class!'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _showAddClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFE6D6FF), // Change this to your desired background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add a new class',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Enter Course ID...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Color(0xFFE6D6FF),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                addCourse();
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2F1E9D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      // _textController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
            ? Center(child: Text('Error loading classes'))
            : ListView(
          children: [
            SizedBox(height: 40),
            ...classCards,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddClassDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add a Class',
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final String teacher;
  final int unitCount;
  final int remainingAssignments;
  final String topStudent;
  final Color color;

  ClassCard({
    required this.title,
    required this.teacher,
    required this.unitCount,
    required this.remainingAssignments,
    required this.topStudent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teacher: $teacher',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 16.0,
              children: [
                Text(
                  'Units: $unitCount',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Remaining Tasks: $remainingAssignments',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Top Student: $topStudent',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
