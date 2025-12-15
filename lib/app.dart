import 'package:flutter/material.dart';
import 'package:dart_frontend/ui/board_screen.dart';
import 'package:dart_frontend/ui/home_screen.dart';
import 'package:dart_frontend/ui/dashboard.dart';
import 'ui/color_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WSS Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: ColorSettings.accent,
        brightness: Brightness.dark,
      ),
      home: const Dashboard(), // ← NEW
      routes: {
        '/board': (_) => const BoardScreen(), // ← Convenient named route
      },
    );
  }
}
