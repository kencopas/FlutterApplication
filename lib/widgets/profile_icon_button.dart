import 'package:flutter/material.dart';
import '../theme/color_manager.dart';

class ProfileIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const ProfileIconButton({
    super.key,
    this.onTap,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // 👈 required
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: ColorSettings.surface(context),
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorSettings.border(context),
            ),
          ),
          child: Icon(
            Icons.person_outline,
            size: size * 0.6,
            color: ColorSettings.iconDefault(context),
          ),
        ),
      ),
    );
  }
}
