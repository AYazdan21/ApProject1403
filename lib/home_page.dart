import 'package:flutter/material.dart';
import 'dart:io';
import 'theme.dart';
import 'todo_page.dart';
import 'classes_page.dart';
import 'news_page.dart';
import 'tasks_page.dart';
import 'info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String response = '';
  String highestGrade = '';
  String lowestGrade = '';
  String upcomingExams = '';
  String tasksRemaining = '';
  String missedDeadlines = '';

  @override
  void initState() {
    super.initState();
    homeData();
  }

  Future<void> homeData() async {
    try {
      final serverSocket = await Socket.connect("192.168.131.93", 8412);
      serverSocket.write('home~$stuID_info\u0000');

      serverSocket.listen((socketResponse) {
        response = String.fromCharCodes(socketResponse);
        print("---------    server response is: { $response }");
        setState(() {
          List<String> parts = response.split('-');
          if (parts.length == 5) {
            highestGrade = parts[0];
            lowestGrade = parts[1];
            upcomingExams = parts[2];
            tasksRemaining = parts[3];
            missedDeadlines = parts[4];

            _children[0] = HomeWidget(
              highestGrade: highestGrade,
              lowestGrade: lowestGrade,
              upcomingExams: upcomingExams,
              tasksRemaining: tasksRemaining,
              missedDeadlines: missedDeadlines,
            );
          }
        });
      });
        await serverSocket.close();
    } catch (e) {
      print("Error: $e");
    }
  }

  final List<Widget> _children = [
    HomeWidget(
      highestGrade: '',
      lowestGrade: '',
      upcomingExams: '',
      tasksRemaining: '',
      missedDeadlines: '',
    ),
    Kara(),
    ClassesPage(),
    NewsPage(),
    AssignmentsPage(),
  ];

  final List<String> _titles = [
    'Summary',
    'Todo',
    'Classes',
    'News',
    'Tasks',
  ];

  void onTabTapped(int index) {
    setState(() {
      if (index == 0) {
        homeData(); // Update home data when the Home tab is selected
      }
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff9f8fe),
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_2_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoPage()),
              );
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF2F1E9D),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final String highestGrade;
  final String lowestGrade;
  final String upcomingExams;
  final String tasksRemaining;
  final String missedDeadlines;

  HomeWidget({
    required this.highestGrade,
    required this.lowestGrade,
    required this.upcomingExams,
    required this.tasksRemaining,
    required this.missedDeadlines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              summaryCard(Icons.star, 'Highest grade: $highestGrade'),
              summaryCard(Icons.heart_broken, 'Upcoming Exams: $upcomingExams'),
              summaryCard(Icons.access_alarm, 'Tasks remaining: $tasksRemaining'),
              summaryCard(Icons.access_time, 'Missed deadlines: $missedDeadlines'),
              summaryCard(Icons.sentiment_dissatisfied, 'Lowest grade: $lowestGrade'),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Current Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          taskCard('DLD - HW1', false),
          const SizedBox(height: 5),
          taskCard('AP - HW6', false),
          const SizedBox(height: 20),
          const Text(
            'Completed Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          taskCard('DS - HW3', true),
          const SizedBox(height: 5),
          taskCard('AP - HW5', true),
        ],
      ),
    );
  }

  Widget summaryCard(IconData icon, String text) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF2F1E9D)),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget taskCard(String text, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDone ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Icon(
            isDone ? Icons.check_circle : Icons.cancel,
            color: isDone ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}


