import 'package:flutter/material.dart';
import '../../theme/color_manager.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Alerts",
        style: TextStyle(
          fontSize: 18,
          color: ColorSettings.textPrimary(context),
        ),
      ),
    );
  }
}
