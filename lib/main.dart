import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_face_generator/constants.dart';
import 'package:random_face_generator/home.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  Box systemPrefsBox = await Hive.openBox(kHiveSystemPrefs);
  bool isDark = systemPrefsBox.get("darkMode",
      defaultValue: ThemeMode.system == ThemeMode.dark);
  FlutterNativeSplash.remove();
  runApp(RandomFaceGeneratorApp(isDark: isDark));
}

class RandomFaceGeneratorApp extends StatelessWidget {
  final bool isDark;
  const RandomFaceGeneratorApp({Key? key, required this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: (isDark) ? kDarkTheme : kLightTheme,
      builder: (context, themeData) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData,
          home: Home(
            isInitialDark: isDark,
          ),
        );
      },
    );
  }
}
