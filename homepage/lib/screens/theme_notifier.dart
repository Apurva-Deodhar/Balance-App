import 'package:flutter/material.dart';
import 'colors.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  ThemeData _currentTheme = lightTheme;

  bool get isDarkMode => _isDarkMode;
  ThemeData getTheme() => _currentTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }
}
