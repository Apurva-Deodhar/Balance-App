import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white, // Set the background color for light theme
  appBarTheme: AppBarTheme(
    color: Color(0xFF815ac0),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.white, // Set the drawer background color for light theme
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black, // Set the background color for dark theme
  appBarTheme: AppBarTheme(
    color: Colors.black,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.black, // Set the drawer background color for dark theme
  ),
);
