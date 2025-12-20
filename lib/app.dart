import 'package:flutter/material.dart';
import 'ui/navigation.dart';
import 'ui/screens/board_screen.dart';
import 'theme/color_manager.dart';
import 'theme/theme_controller.dart';
import 'ui/screens/profile_screen.dart';

final themeController = ThemeController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (_, __) {
        return MaterialApp(
          title: 'Flutter WSS Demo',
          debugShowCheckedModeBanner: false,

          themeMode: themeController.themeMode,

          theme: ThemeData(
            colorSchemeSeed: ColorSettings.accent,
            brightness: Brightness.light,
          ),

          darkTheme: ThemeData(
            colorSchemeSeed: ColorSettings.accent,
            brightness: Brightness.dark,
          ),

          home: const Navigation(),
          routes: {
            '/board': (_) => const BoardScreen(),
            '/profile': (_) => const ProfileScreen(),
          },
        );
      },
    );
  }
}
