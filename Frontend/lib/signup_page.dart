import 'dart:io';

import 'package:ap_flutter/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart'; // Import the theme file

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _stuNumController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String response = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(18.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(height: 90),
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 70),
                  _buildTextFormField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    icon: Icons.person,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your first name' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _surnameController,
                    labelText: 'Surname',
                    icon: Icons.person,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your surname' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _stuNumController,
                    labelText: 'Student Number',
                    icon: Icons.person,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your student number' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.password,
                    obscureText: !_isPasswordVisible,
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
                    validator: (value) => _validatePassword(value),
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _signup,
                    child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Color(0xFF2F1E9D)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
      ),
    );
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final serverSocket = await Socket.connect("192.168.131.93", 8412);
        serverSocket.write(
            'signUp~${_firstNameController.text}~${_surnameController.text}~${_stuNumController.text}~${_passwordController.text}\u0000');

        serverSocket.listen((socketResponse) {
          setState(() {
            response = String.fromCharCodes(socketResponse);
          });
          print("---------    server response is: { $response }");
          if (response == "1") {
            setState(() {
              // Handle the user already exists case
              _isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('User already exists!'),
                backgroundColor: Colors.red,
              ));
            });
          } else if (response == "2") {
            setState(() {
              // Handle the successful signup case
              _isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Sign Up successful'),
                backgroundColor: Colors.green,
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            });
          }
        });

        await serverSocket.close();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
      return 'Password must have at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
      return 'Password must have at least one lowercase letter';
    }
    if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
      return 'Password must have at least one digit';
    }
    if (value.contains(_stuNumController.text)) {
      return 'Password should not include the student number';
    }
    return null;
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color(0xFFE6D6FF),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
