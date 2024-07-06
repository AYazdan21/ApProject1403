import 'dart:math';

import 'package:flutter/material.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final List<Color> _colors = [Colors.purple, Colors.red, Colors.green, Colors.blue, Colors.greenAccent];
  final Random _random = Random();

  List<ClassCard> classCards = [
    ClassCard(
      title: 'AP',
      teacher: 'Mojataba Vahidi',
      unitCount: 3,
      remainingAssignments: 4,
      topStudent: 'Ali Alavi',
      color: Colors.purple,
    ),
    ClassCard(
      title: 'CA',
      teacher: 'Hamidreza Mahdiani',
      unitCount: 3,
      remainingAssignments: 4,
      topStudent: 'Ali Alavi',
      color: Colors.red,
    ),
    ClassCard(
      title: 'DS',
      teacher: 'Dr. Alidoost',
      unitCount: 3,
      remainingAssignments: 4,
      topStudent: 'Ali Alavi',
      color: Colors.green,
    ),
  ];

  void _addClass(String title) {
    setState(() {
      Color randomColor = _colors[_random.nextInt(_colors.length)];
      classCards.add(
        ClassCard(
          title: title,
          teacher: 'New Teacher',
          unitCount: 3,
          remainingAssignments: 4,
          topStudent: 'New Student',
          color: randomColor,
        ),
      );
    });
  }

  void _showAddClassDialog(BuildContext context) {
    final TextEditingController _textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a new class'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Enter Course ID...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addClass(_textController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Classes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
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
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.deepPurpleAccent,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.work),
      //       label: 'Todo',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       label: 'Classes',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.announcement),
      //       label: 'News',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.assignment),
      //       label: 'Tasks',
      //     ),
      //   ],
      // ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

