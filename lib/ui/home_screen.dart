import 'package:flutter/material.dart';
import 'color_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSettings.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mascot image
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Image.asset('assets/images/NOT_monopoly_man.png'),
            ),

            const SizedBox(height: 30),

            // Game title
            Text(
              "NOT Monopoly",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: ColorSettings.secondary,
              ),
            ),

            const SizedBox(height: 20),

            // Enter game button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/board');
              },
              child: const Text("Start Game"),
            ),
          ],
        ),
      ),
    );
  }
}
