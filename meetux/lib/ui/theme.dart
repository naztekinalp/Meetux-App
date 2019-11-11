import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
   
      title: base.title.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 15.0,
        color: Colors.black,
      ),
      // Used for the recipes' duration:
      caption: base.caption.copyWith(
        color: Colors.black,
      ),
    );

  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();
  
  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    // New code:
    primaryColor: Colors.black,
    indicatorColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    accentColor: const Color(0xFFFFF8E1),
    iconTheme: IconThemeData(
      color: Colors.red,
      size: 20.0,
    ),
    buttonColor: const Color(0xFFF5F5F5),
    backgroundColor: Colors.white,
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: const Color(0xFF807A6B),
      unselectedLabelColor: const Color(0xFFCCC5AF),
    )
  );
}