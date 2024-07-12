import 'package:flutter/material.dart';
import 'news_page.dart';
import 'birthday_page.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFBF2FF),
          toolbarHeight: 5,
          elevation: 50,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: 'News',),
              Tab(text: 'Birthdays'),
            ],labelColor: Colors.black,
            unselectedLabelColor: Colors.black45,
          ),
        ),
        body: TabBarView(
          children: [
            NewsTab(),
            BirthdaysTab(),
          ],
        ),
      ),
    );
  }
}
