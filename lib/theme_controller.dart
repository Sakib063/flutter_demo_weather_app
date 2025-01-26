import 'package:shared_preferences/shared_preferences.dart';


class ThemeController{
  final prefs=SharedPreferencesAsync();
  bool _isDarkMode = false;

  bool get isDarkMode=>_isDarkMode;

  Future<void> load_theme() async{
    _isDarkMode=await prefs.getBool('theme_preference')??false;
  }

  Future<void> toggle_theme() async{
    _isDarkMode=!_isDarkMode;
    await prefs.setBool('theme_preference',_isDarkMode);
  }
}
