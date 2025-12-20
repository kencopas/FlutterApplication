import 'package:flutter/material.dart';

class ColorSettings {
  ColorSettings._();

  // =========================
  // BRAND (MODE-INDEPENDENT)
  // =========================

  static const Color primary = Color(0xFF1E3A5F); // Deep blue
  static const Color accent = Color(0xFF2FA4A9);  // Muted teal

  static const Color positive = Color(0xFF3CB371);
  static const Color negative = Color(0xFFC94A4A);
  static const Color warning  = Color(0xFFF59E0B);

  // =========================
  // LIGHT MODE TOKENS
  // =========================

  static const Color _bgLight = Color(0xFFF7F9FC);
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _borderLight = Color(0xFFE2E8F0);

  static const Color _textPrimaryLight = Color(0xFF0F172A);
  static const Color _textSecondaryLight = Color(0xFF64748B);
  static const Color _textTertiaryLight = Color(0xFF94A3B8);

  static const Color _iconDefaultLight = _textSecondaryLight;
  static const Color _iconDisabledLight = Color(0xFFCBD5E1);

  // =========================
  // DARK MODE TOKENS
  // =========================

  static const Color _bgDark = Color(0xFF0E1116);
  static const Color _surfaceDark = Color(0xFF161B22);
  static const Color _borderDark = Color(0xFF2A2F3A);

  static const Color _textPrimaryDark = Color(0xFFE6EDF3);
  static const Color _textSecondaryDark = Color(0xFF9BA4B0);
  static const Color _textTertiaryDark = Color(0xFF6B7280);

  static const Color _iconDefaultDark = _textSecondaryDark;
  static const Color _iconDisabledDark = Color(0xFF475569);

  // =========================
  // MODE-AWARE GETTERS
  // =========================

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Backgrounds
  static Color background(BuildContext context) =>
      _isDark(context) ? _bgDark : _bgLight;

  static Color surface(BuildContext context) =>
      _isDark(context) ? _surfaceDark : _surfaceLight;

  static Color border(BuildContext context) =>
      _isDark(context) ? _borderDark : _borderLight;

  // Text
  static Color textPrimary(BuildContext context) =>
      _isDark(context) ? _textPrimaryDark : _textPrimaryLight;

  static Color textSecondary(BuildContext context) =>
      _isDark(context) ? _textSecondaryDark : _textSecondaryLight;

  static Color textTertiary(BuildContext context) =>
      _isDark(context) ? _textTertiaryDark : _textTertiaryLight;

  static Color textInteractive(BuildContext context) => primary;

  // Icons
  static Color iconDefault(BuildContext context) =>
      _isDark(context) ? _iconDefaultDark : _iconDefaultLight;

  static Color iconActive(BuildContext context) => primary;

  static Color iconDisabled(BuildContext context) =>
      _isDark(context) ? _iconDisabledDark : _iconDisabledLight;

  // Buttons
  static Color buttonPrimary(BuildContext context) => primary;
  static Color buttonDisabled(BuildContext context) =>
      _isDark(context) ? _iconDisabledDark : _iconDisabledLight;

  // Charts
  static Color chartYes(BuildContext context) => positive;
  static Color chartNo(BuildContext context) => negative;
  static Color chartNeutral(BuildContext context) =>
      _isDark(context) ? _textTertiaryDark : _textTertiaryLight;
  static Color chartHighlight(BuildContext context) => accent;

  static var colorMode = "Dark";
  static Color get secondary =>
      (colorMode == "Light") ? Colors.black : Colors.white;
  static Brightness get brightness =>
      (colorMode == "Light") ? Brightness.light : Brightness.dark;
}
