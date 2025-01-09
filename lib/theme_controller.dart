import 'package:flutter/material.dart';

class ThemeController extends StatefulWidget {
  const ThemeController({super.key});

  @override
  State<ThemeController> createState() => _ThemeControllerState();
}

class _ThemeControllerState extends State<ThemeController> {
  bool _isDarkTheme = false;

  ThemeData light=ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(color: Colors.blue),
  );

  ThemeData dark=ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(color: Colors.black),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme?dark:light,
    );
  }
}
