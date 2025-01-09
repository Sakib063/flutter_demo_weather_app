import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggle_theme(){
    setState(() {
      _isDarkMode=!_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode?ThemeMode.dark:ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(toggle_theme: _toggle_theme),
    );
  }
}

