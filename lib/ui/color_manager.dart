import 'package:flutter/material.dart';


class ColorSettings {
  static var colorMode = "Dark";
  static Color get primary => (colorMode == "Light") ? Colors.white : Color(0xFF202020);
  static Color get secondary => (colorMode == "Light") ? Colors.black : Colors.white;
  static Color accent = Colors.blue;
  static Brightness get brightness => (colorMode == "Light") ? Brightness.light : Brightness.dark;
}
