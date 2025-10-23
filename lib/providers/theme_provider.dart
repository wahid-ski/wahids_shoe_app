import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
   static const String _themeModeKey = 'theme_mode';

  // void toggleTheme() {
  //   if (_themeMode == ThemeMode.dark) {
  //     _themeMode = ThemeMode.light;
  //   } else {
  //     _themeMode = ThemeMode.dark;
  //   }
  //   notifyListeners();
  // }
  // void toggleTheme(){
  //   _themeMode =_themeMode==ThemeMode.light?ThemeMode.dark:ThemeMode.light;
  //   notifyListeners();
  // }
    Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(_themeModeKey);
    if (savedThemeMode != null) {
      _themeMode = savedThemeMode == 'dark' 
          ? ThemeMode.dark 
          : ThemeMode.light;
      notifyListeners();
    }
}
  Future<void> _saveTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode);

  }
  void toggleTheme() {
  _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
 _saveTheme(_themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}