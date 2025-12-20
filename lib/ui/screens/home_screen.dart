import 'package:flutter/material.dart';
import 'color_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorSettings.background(context), // neutral background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Symbol
                SizedBox(
                  width: width * 0.28,
                  child: Image.asset(
                    'assets/images/NOT_monopoly_man.png',
                    color: ColorSettings.iconDefault(context), // muted icon color
                  ),
                ),

                const SizedBox(height: 32),

                // App Title
                Text(
                  "Foresee",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: ColorSettings.textPrimary(context),
                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle / Value Prop
                Text(
                  "Trade on real-world outcomes with transparent markets.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorSettings.textSecondary(context),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 40),

                // Primary CTA
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorSettings.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/board');
                    },
                    child: const Text("View Markets"),
                  ),
                ),

                const SizedBox(height: 16),

                // Secondary Action
                TextButton(
                  onPressed: () {
                    // e.g. Navigator.pushNamed(context, '/about');
                  },
                  child: Text(
                    "How it works",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorSettings.textSecondary(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
