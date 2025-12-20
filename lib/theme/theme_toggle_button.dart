import 'package:flutter/material.dart';
import 'color_manager.dart';
import '../app.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => themeController.toggleTheme(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Icon(
          themeController.isDark
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
          key: ValueKey(themeController.isDark),
          color: ColorSettings.iconDefault(context),
        ),
      ),
      tooltip: "Toggle theme",
    );
  }
}
