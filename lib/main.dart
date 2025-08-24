import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

// Main colors of the task manager app.
const Color darkAppBarColor = Color(0xFF457CA0);
const Color darkBackgroundColor = Color(0xFF121212);
const Color darkErrorColor = Color(0xFFB53A30);
const Color darkPrimaryColor = Color(0xFF1766AD);
const Color darkSecondaryColor = Color(0xFF8C6E00);
const Color darkTileColor = Color(0xFF6B5500);
const Color lightAppBarColor = Color(0xFF99D0F2);
const Color lightBackgroundColor = Color(0xFFF5F5F5);
const Color lightErrorColor = Color(0xFFE05A4F);
const Color lightPrimaryColor = Color(0xFF2B88D9);
const Color lightSecondaryColor = Color(0xFFF2B705);
const Color lightTileColor = Color(0xFFFFE08A);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTask',

      // Setting the theme for the app.
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
          error: lightErrorColor,
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
          tileColor: Colors.white,
          textColor: Colors.black87,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black87),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: lightErrorColor, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: lightErrorColor, width: 1.5),
          ),
        ),
      ),

      // Setting the dark theme for the app.
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
          error: darkErrorColor,
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
          tileColor: Colors.black,
          textColor: Colors.white70,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkErrorColor, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkErrorColor, width: 1.5),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
