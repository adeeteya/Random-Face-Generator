import 'package:flutter/material.dart';

const String kDefaultUrl = "https://thispersondoesnotexist.com/";
const String kCorsUrl = "https://api.cors.lol/?url=thispersondoesnotexist.com/";
const String kHiveSystemPrefs = "system_prefs";
const kLightBackgroundColor = Color(0xFFE0E5EC);
const kLightSourceColor = Color(0x99FFFFFF);
const kLightShadowColor = Color(0x99A3B1C6);
const kDarkBackgroundColor = Color(0xFF24272C);
const kDarkSourceColor = Color(0xFF292D33);
const kDarkShadowColor = Color(0xFF1F2125);
const kRegentGray = Color(0xFF7E8A9A);
const kLimeGreen = Color(0xFF32C94E);

final ThemeData kLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(surface: kLightBackgroundColor),
  scaffoldBackgroundColor: kLightBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kLightBackgroundColor,
    elevation: 0,
  ),
  snackBarTheme: const SnackBarThemeData(backgroundColor: kDarkBackgroundColor),
);
final ThemeData kDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(surface: kDarkBackgroundColor),
  scaffoldBackgroundColor: kDarkBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kDarkBackgroundColor,
    elevation: 0,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: kLightBackgroundColor,
  ),
);
