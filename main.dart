import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('بوستان'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'ورود'),
                Tab(text: 'ثبت نام'),
                Tab(text: 'اطلاعات کاربری'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LoginCard(),
              SignupCard(),
              InfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'شماره دانشجویی'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'رمز عبور'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                },
                child: Text('ورود'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'نام و نام خانوادگی'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'شماره دانشجویی'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'رمز عبور'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                },
                child: Text('ثبت نام'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'نام و نام خانوادگی: منیره'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'شماره دانشجویی: 402243000'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'تعداد واحدها: 0'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                },
                child: Text('ویرایش'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

