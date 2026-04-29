


import 'package:flutter/material.dart';
import 'screens/common/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HireHive',
      theme: ThemeData(
        primaryColor: Color(0xFF021A54),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF021A54),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF021A54),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}
