import 'package:flutter/material.dart';
import 'login_page.dart';
import 'schedule_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false; // To track login state

  // Function to update login state
  void _updateLoginState(bool value) {
    setState(() {
      isLoggedIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Schedule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn
          ? SchedulePage() // Show SchedulePage if logged in
          : LoginPage(onLoginSuccess: _updateLoginState), // Otherwise show LoginPage
    );
  }
}
