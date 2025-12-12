import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NOT Monopoly"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/board');
              },
              child: const Text("New Game", style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/board');
              },
              child: const Text("Join Game", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
