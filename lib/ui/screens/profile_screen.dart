import 'package:flutter/material.dart';
import 'package:dart_frontend/theme/color_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSettings.background(context),
      appBar: AppBar(
        backgroundColor: ColorSettings.surface(context),
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: ColorSettings.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(
          color: ColorSettings.iconActive(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // PROFILE HEADER
            // =========================
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorSettings.surface(context),
                    border: Border.all(
                      color: ColorSettings.border(context),
                    ),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 36,
                    color: ColorSettings.iconDefault(context),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Guest User",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorSettings.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "guest@foresee.app",
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorSettings.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // =========================
            // ACTIONS
            // =========================
            _ProfileAction(
              context: context,
              icon: Icons.settings_outlined,
              label: "Account Settings",
              onTap: () {},
            ),
            _ProfileAction(
              context: context,
              icon: Icons.dark_mode_outlined,
              label: "Appearance",
              onTap: () {},
            ),
            _ProfileAction(
              context: context,
              icon: Icons.logout,
              label: "Log Out",
              isDestructive: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileAction({
    required this.context,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? ColorSettings.negative
        : ColorSettings.textPrimary(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ColorSettings.surface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorSettings.border(context)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
