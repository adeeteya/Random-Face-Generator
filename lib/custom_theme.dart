import 'package:flutter/material.dart';
import 'package:random_face_generator/constants.dart';

class CustomTheme with ChangeNotifier {
  late bool isDark;
  CustomTheme(this.isDark);

  Color get sourceColor => (isDark) ? kDarkSourceColor : kLightSourceColor;
  Color get shadowColor => (isDark) ? kDarkShadowColor : kLightShadowColor;

  List<BoxShadow> get boxShadows => [
    BoxShadow(offset: const Offset(-9, -9), blurRadius: 18, color: sourceColor),
    BoxShadow(offset: const Offset(9, 9), blurRadius: 18, color: shadowColor),
  ];
  BoxDecoration get boxDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: (isDark) ? kDarkBackgroundColor : kLightBackgroundColor,
    boxShadow: boxShadows,
  );
  Border get border => Border(
    top: BorderSide(color: shadowColor, width: 4),
    left: BorderSide(color: shadowColor, width: 4),
    right: BorderSide(color: sourceColor, width: 4),
    bottom: BorderSide(color: sourceColor, width: 4),
  );
}
