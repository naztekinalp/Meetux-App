import 'package:flutter/material.dart';

import 'package:meetux/ui/screens/home.dart';
import 'package:meetux/ui/screens/login.dart';
import 'package:meetux/ui/theme.dart';

class MeetuxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meetux',
      theme: buildTheme(),

      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}