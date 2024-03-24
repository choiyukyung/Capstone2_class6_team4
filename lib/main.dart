import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/signup.dart';
import './pages/screen_time.dart';
import './pages/calendar.dart';
import './pages/statistics.dart';
import './pages/challenge.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGreen Time',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (BuildContext context) => LogIn(),
        '/login': (BuildContext context) => LogIn(),
        '/signup': (BuildContext context) => SignUp(),
        '/screen-time': (BuildContext context) => ScreenTime(),
        '/calendar': (BuildContext context) => Calendar(),
        '/statistics': (BuildContext context) => Statistics(),
        '/challenge': (BuildContext context) => Challenge(),
      }
    );
  }
}