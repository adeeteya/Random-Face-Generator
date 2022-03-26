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
  await Hive.openBox(kHiveSystemPrefs);
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(kHiveSystemPrefs).listenable(),
      builder: (context, box, _) {
        bool _isDark = box.get("darkMode",
            defaultValue: ThemeMode.system == ThemeMode.dark);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            backgroundColor: kLightBackgroundColor,
            scaffoldBackgroundColor: kLightBackgroundColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: kLightBackgroundColor,
              elevation: 0,
            ),
            snackBarTheme:
                const SnackBarThemeData(backgroundColor: kDarkBackgroundColor),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            backgroundColor: kDarkBackgroundColor,
            scaffoldBackgroundColor: kDarkBackgroundColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: kDarkBackgroundColor,
              elevation: 0,
            ),
            snackBarTheme:
                const SnackBarThemeData(backgroundColor: kLightBackgroundColor),
          ),
          themeMode: (_isDark) ? ThemeMode.dark : ThemeMode.light,
          home: Home(isDark: _isDark),
        );
      },
    );
  }
}
