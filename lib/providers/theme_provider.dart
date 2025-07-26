import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark, system }

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme') ?? 2;
    state = AppTheme.values[themeIndex];
  }

  Future<void> setTheme(AppTheme theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', theme.index);
  }

  ThemeData getThemeData(BuildContext context) {
    switch (state) {
      case AppTheme.light:
        return _getLightTheme();
      case AppTheme.dark:
        return _getDarkTheme();
      case AppTheme.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark
            ? _getDarkTheme()
            : _getLightTheme();
    }
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF6366F1),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF6366F1)),
        titleTextStyle: TextStyle(
          color: Color(0xFF6366F1),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF6366F1),
      scaffoldBackgroundColor: const Color(0xFF1F2937),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF6366F1)),
        titleTextStyle: TextStyle(
          color: Color(0xFF6366F1),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardColor: const Color(0xFF374151),
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});
