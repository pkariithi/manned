import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MannedPagesApp());
}

class MannedPagesApp extends StatefulWidget {
  const MannedPagesApp({super.key});

  @override
  State<MannedPagesApp> createState() => _MannedPagesAppState();
}

class _MannedPagesAppState extends State<MannedPagesApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      // Toggle between light and dark modes
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) {
        return MaterialApp(
          title: 'Manned Pages',
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          themeMode: _themeMode,
          debugShowCheckedModeBanner: false,
          home: MainScreen(onThemeToggle: toggleTheme),
        );
      },
    );
  }
}
