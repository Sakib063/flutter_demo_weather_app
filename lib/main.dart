import 'package:flutter/material.dart';
import 'package:weather_app/chart.dart';
import 'package:weather_app/theme_controller.dart';
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
  ThemeController _themeController=ThemeController();
  bool _isDarkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async{
    await _themeController.load_theme();
    setState(() {
      _isDarkMode=_themeController.isDarkMode;
    });
  }

  Future<void> _toggleTheme() async{
    await _themeController.toggle_theme();
    setState(() {
      _isDarkMode=_themeController.isDarkMode;
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
      home: WeatherScreen(toggle_theme: _toggleTheme),
    );
  }
}

