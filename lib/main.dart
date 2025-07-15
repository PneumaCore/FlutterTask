import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

// Main colors of the task manager app.
const Color lightBackgroundColor = Color(0xFFF5F5F5);
const Color lightAppBarColor = Color(0xFF9C7CC3);
const Color lightPrimaryColor = Color(0xFFB99AD9);
const Color lightSecondaryColor = Color(0xFFD5F26D);
const Color lightTileColor = Color(0xFFFFFFFF);
const Color darkBackgroundColor = Color(0xFF121212);
const Color darkAppBarColor = Color(0xFF3A2D4D);
const Color darkPrimaryColor = Color(0xFF6B4C99);
const Color darkSecondaryColor = Color(0xFF8AA133);
const Color darkTileColor = Color(0xFF1E1E1E);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTask',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightBackgroundColor,
        colorScheme: ColorScheme.light(
          primary: lightPrimaryColor,
          onPrimary: Colors.white,
          secondary: lightSecondaryColor,
          onSecondary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black87,
          error: Colors.red.shade700,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: lightAppBarColor,
          foregroundColor: Colors.black,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightPrimaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightSecondaryColor,
          foregroundColor: Colors.black,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: lightTileColor,
          textColor: Colors.black87,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackgroundColor,
        colorScheme: ColorScheme.dark(
          primary: darkPrimaryColor,
          onPrimary: Colors.white,
          secondary: darkSecondaryColor,
          onSecondary: Colors.black87,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white70,
          error: Colors.red.shade400,
          onError: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkAppBarColor,
          foregroundColor: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white70),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkPrimaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: darkSecondaryColor,
          foregroundColor: Colors.black87,
        ),
        iconTheme: IconThemeData(color: Colors.white70),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white54),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: darkTileColor,
          textColor: Colors.white70,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
