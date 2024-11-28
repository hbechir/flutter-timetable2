import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  Future<void> _register() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    try {
    print("test");
      final response = await http.post(
        Uri.parse('http://192.168.167.44:5000/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      print("test");
      if (response.statusCode == 201) {
        setState(() {
          message = 'Registration successful! You can now log in.';
        });
      } else {
        setState(() {
          message = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'An error occurred. Check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(color: message.contains('successful') ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
