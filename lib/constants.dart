import 'package:flutter/material.dart';

const String kDefaultUrl = "https://fakeface.rest/face/json";
const String kInitialUrl = "https://thispersondoesnotexist.com/image";
const String kCorsProxyUrl =
    "https://random-face-generator-proxy.herokuapp.com/";
const String kHiveSystemPrefs = "system_prefs";
const kLightBackgroundColor = Color(0xFFE0E5EC);
const kLightSourceColor = Color(0x99FFFFFF);
const kLightShadowColor = Color(0x99A3B1C6);
const kDarkBackgroundColor = Color(0xFF292D32);
const kDarkSourceColor = Color(0xFF30343A);
const kDarkShadowColor = Color(0xFF25262D);
const kRegentGray = Color(0xFF7E8A9A);
const kLimeGreen = Color(0xFF32C94E);

final ThemeData kLightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: kLightBackgroundColor,
  scaffoldBackgroundColor: kLightBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kLightBackgroundColor,
    elevation: 0,
  ),
  snackBarTheme: const SnackBarThemeData(backgroundColor: kDarkBackgroundColor),
);
final ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: kDarkBackgroundColor,
  scaffoldBackgroundColor: kDarkBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kDarkBackgroundColor,
    elevation: 0,
  ),
  snackBarTheme:
      const SnackBarThemeData(backgroundColor: kLightBackgroundColor),
);
