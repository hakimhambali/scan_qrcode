import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/theme_config.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;
  late SharedPreferences _prefs;
  
  ThemeMode get themeMode => _themeMode;
  
  ThemeProvider() {
    _loadThemeMode();
  }
  
  Future<void> _loadThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    final savedThemeMode = _prefs.getString(_themeModeKey);
    if (savedThemeMode != null) {
      if (savedThemeMode == 'ThemeMode.dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    }
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeModeKey, mode.toString());
    notifyListeners();
  }
  
  ThemeData getTheme(BuildContext context) {
    return _themeMode == ThemeMode.dark
        ? AppThemes.darkTheme
        : AppThemes.lightTheme;
  }
  
  bool isDarkMode(BuildContext context) {
    return _themeMode == ThemeMode.dark;
  }
  
  LinearGradient getBackgroundGradient(BuildContext context) {
    return _themeMode == ThemeMode.dark
        ? AppColors.darkGradientBackground 
        : AppColors.lightGradient;
  }
  
  LinearGradient getLightGradient(BuildContext context) {
    return _themeMode == ThemeMode.dark
        ? AppColors.darkLightGradient 
        : AppColors.lightGradient;
  }
  
  Color getTextColor(BuildContext context) {
    return _themeMode == ThemeMode.dark
        ? AppColors.darkTextPrimary 
        : AppColors.textPrimary;
  }
  
  Color getTextSecondaryColor(BuildContext context) {
    return _themeMode == ThemeMode.dark
        ? AppColors.darkTextSecondary 
        : AppColors.textSecondary;
  }
}

// Legacy theme class for backward compatibility
class MyThemes {
  static final darkTheme = AppThemes.darkTheme;
  static final lightTheme = AppThemes.lightTheme;
}