import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'theme.dart'; // Import the theme file
import 'todo_page.dart';
import 'classes_page.dart';
import 'news_page.dart';
import 'tasks_page.dart';
import 'info.dart'; // Import the Personal Info page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeWidget(),
    Kara(), // Ensure the class name matches the imported page
    ClassesPage(),
    NewsPage(),
    AssignmentsPage(), // Assuming you have a TasksPage widget
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff9f8fe),
        title: Text('Summary',
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
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
            icon: Icon(Icons.announcement),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
        ],
        selectedItemColor: Colors.white, // Change selected item color
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF2F1E9D),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Summary',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              summaryCard(Icons.star, 'Highest grade : 19.25'),
              summaryCard(Icons.heart_broken, 'Upcoming Exams: 2'),
              summaryCard(Icons.access_alarm, 'Tasks remaining: 3'),
              summaryCard(Icons.access_time, 'Missed deadlines: 1'),
              summaryCard(Icons.sentiment_dissatisfied, 'Lowest grade: 12'),
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

class PersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info'),
      ),
      body: Center(
        child: Text(
          'Personal Info Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
