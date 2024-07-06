import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class AssignmentsPage extends StatelessWidget {
  final List<Assignment> assignments = [
    Assignment('تمرین مینی‌پروژه AP', DateTime.now().add(Duration(days: 2)), '4:00 عصر'),
    Assignment('تمرین مدار منطقی 1', DateTime.now().add(Duration(days: 4)), '6:00 عصر'),
    Assignment('تمرین ریاضی 2', DateTime.now().add(Duration(days: 5)), '12:00 ظهر'),
    Assignment('تمرین معادلات دیفرانسیل 2', DateTime.now().add(Duration(days: 6)), '9:00 صبح'),
    Assignment('تمرین معماری کامپیوتر', DateTime.now().add(Duration(days: 7)), '9:00 صبح'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تمرین‌ها'),
      ),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return AssignmentCard(assignment: assignments[index]);
        },
      ),
    );
  }
}

class Assignment {
  final String title;
  final DateTime dueDate;
  final String time;
  bool isCompleted;

  Assignment(this.title, this.dueDate, this.time, {this.isCompleted = false});
}

class AssignmentCard extends StatefulWidget {
  final Assignment assignment;

  const AssignmentCard({required this.assignment});

  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.assignment.isCompleted ? 0.5 : 1.0,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: Checkbox(
            value: widget.assignment.isCompleted,
            onChanged: (bool? value) {
              setState(() {
                widget.assignment.isCompleted = value ?? false;
              });
            },
          ),
          title: Text(widget.assignment.title),
          subtitle: Text('${DateFormat.yMMMMd('fa').format(widget.assignment.dueDate)} \n${widget.assignment.time}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignmentDetailsPage(assignment: widget.assignment),
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

  const AssignmentDetailsPage({required this.assignment});

  @override
  _AssignmentDetailsPageState createState() => _AssignmentDetailsPageState();
}

class _AssignmentDetailsPageState extends State<AssignmentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جزئیات تمرین'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عنوان: ${widget.assignment.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('ددلاین: ${DateFormat.yMMMMd('fa').format(widget.assignment.dueDate)}'),
            SizedBox(height: 10),
            Text('زمان تخمینی باقی‌مانده: 5 ساعت'),
            SizedBox(height: 10),
            Text('توضیحات: آشنایی با verilog و مدارهای آسنکرون'),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('علامت‌گذاری به عنوان تکمیل شده'),
              value: widget.assignment.isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  widget.assignment.isCompleted = value ?? false;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'توضیحات تحویل',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('ثبت'),
            ),
          ],
        ),
      ),
    );
  }
}
