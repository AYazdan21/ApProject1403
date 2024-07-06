import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart'; 

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _stuNumController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool stuIDChecker = true;
  bool passwordChecker = true;
  String response = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(18.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(height: 70),
                const Column(
                  children: [
                    Text(
                      "Welcome to Golestan",
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _stuNumController,
                      decoration: InputDecoration(
                        labelText: 'Student Number',
                        filled: true,
                        fillColor: const Color(0xFFE6D6FF),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: BorderSide.none,
                        ),
                        errorText: stuIDChecker ? null : 'Invalid Student Number',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: const Color(0xFFE6D6FF),
                        prefixIcon: const Icon(Icons.password),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        errorText: passwordChecker ? null : 'Invalid Password',
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        logIn();
                      },
                      child: const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Color(0xFF2F1E9D)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                const SizedBox(
                  width: 250,
                  child: Divider(
                    thickness: 1,
                    color: Color(0xFF2F1E9D),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'images/Sbu-logo.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  'CE@SBU',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
}
