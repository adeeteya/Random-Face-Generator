import 'package:flutter/material.dart';
import 'package:random_face_generator/constants.dart';

class CustomTheme with ChangeNotifier {
  static bool _isDark = ThemeMode.system == ThemeMode.dark;

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  IconData get icon => (_isDark) ? Icons.light_mode : Icons.dark_mode;
  Color get sourceColor => (_isDark) ? kDarkSourceColor : kLightSourceColor;
  Color get shadowColor => (_isDark) ? kDarkShadowColor : kLightShadowColor;
  Color get backgroundColor =>
      (_isDark) ? kDarkBackgroundColor : kLightBackgroundColor;
  List<BoxShadow> get boxShadows => [
        BoxShadow(
          offset: const Offset(-9, -9),
          blurRadius: 18,
          color: sourceColor,
        ),
        BoxShadow(
          offset: const Offset(9, 9),
          blurRadius: 18,
          color: shadowColor,
        ),
      ];
  BoxDecoration get boxDecoration =>
      BoxDecoration(color: backgroundColor, boxShadow: boxShadows);
  Border get border => Border(
        top: BorderSide(
          color: shadowColor,
          width: 4,
        ),
        left: BorderSide(
          color: shadowColor,
          width: 4,
        ),
        right: BorderSide(
          color: sourceColor,
          width: 4,
        ),
        bottom: BorderSide(
          color: sourceColor,
          width: 4,
        ),
      );
}
