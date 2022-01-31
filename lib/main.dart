import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:random_face_generator/constants.dart';
import 'package:random_face_generator/custom_theme.dart';
import 'package:random_face_generator/face.dart';
import 'package:random_face_generator/neumorphic_icon_button.dart';
import 'package:random_face_generator/neumorphic_radio_button.dart';
import 'package:random_face_generator/neumorphic_text_button.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _minimumAge = 0, _maximumAge = 100, _selectedIndex = 2;
  late String queryUrl, imageUrl;
  CustomTheme customTheme = CustomTheme();
  @override
  void initState() {
    queryUrl = kDefaultUrl;
    imageUrl = kInitialUrl;
    if (kIsWeb) imageUrl = kCorsProxyUrl + imageUrl;
    super.initState();
    customTheme.addListener(() {
      setState(() {});
    });
  }

  void _setMale() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  void _setFemale() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _setRandom() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void _setAgeRange(RangeValues range) {
    setState(() {
      _minimumAge = range.start.floor();
      _maximumAge = range.end.floor();
    });
  }

  void _setGenderQuery() {
    switch (_selectedIndex) {
      case 0:
        queryUrl = kDefaultUrl + "?gender=male";
        break;
      case 1:
        queryUrl = kDefaultUrl + "?gender=female";
        break;
      case 2:
        queryUrl = kDefaultUrl;
        break;
    }
  }

  void _setAgeQuery() {
    if (_selectedIndex != 2) {
      if (_minimumAge != 0) {
        queryUrl += "&minimum_age=$_minimumAge";
      }
      if (_maximumAge != 100) {
        queryUrl += "&maximum_age=$_maximumAge";
      }
    } else {
      if (_minimumAge != 0) {
        queryUrl += "?minimum_age=$_minimumAge";
        if (_maximumAge != 100) {
          queryUrl += "&maximum_age=$_maximumAge";
        }
      } else if (_maximumAge != 100) {
        queryUrl += "?maximum_age=$_maximumAge";
      }
    }
  }

  Future _displayErrorAlert(String title, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future _fetchImage() async {
    _setGenderQuery();
    _setAgeQuery();
    try {
      if (kIsWeb) queryUrl = kCorsProxyUrl + queryUrl;
      final response = await http.get(Uri.parse(queryUrl));
      imageUrl = Face.fromJson(jsonDecode(response.body)).imageUrl;
      if (kIsWeb) imageUrl = kCorsProxyUrl + imageUrl;
    } catch (e) {
      if (e.runtimeType == SocketException) {
        _displayErrorAlert(
          "Network Error",
          "Unable to connect to the internet. Please check your internet connection and try again.",
        );
      } else if (e.runtimeType == FormatException) {
        _displayErrorAlert(
          "Invalid Range",
          "Unable to generate a face in this age range. Please try again with a different range.",
        );
      } else if (e.runtimeType == http.ClientException) {
        _displayErrorAlert(
          "Unknown Error Occurred",
          "Please Try using our app.",
        );
      }
      return;
    }
    setState(() {});
  }

  Widget _imageView() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: customTheme.boxDecoration.copyWith(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame == null) {
                return const FittedBox(
                  child: SizedBox(),
                );
              }
              return child;
            },
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return FittedBox(
                fit: BoxFit.none,
                child: CircularProgressIndicator(
                  color: kRegentGray,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: customTheme.boxDecoration.copyWith(
        border: customTheme.border,
      ),
      child: Row(
        children: [
          Text(
            "$_minimumAge yrs",
            style: const TextStyle(fontSize: 14, color: kRegentGray),
          ),
          if (_minimumAge < 10)
            Text(
              "0",
              style:
                  TextStyle(fontSize: 14, color: customTheme.backgroundColor),
            ),
          Flexible(
            child: RangeSlider(
              values: RangeValues(
                _minimumAge.toDouble(),
                _maximumAge.toDouble(),
              ),
              min: 0,
              max: 100,
              activeColor: kRegentGray,
              inactiveColor: customTheme.shadowColor,
              onChanged: _setAgeRange,
            ),
          ),
          if (_maximumAge < 10)
            Text(
              "0",
              style:
                  TextStyle(fontSize: 14, color: customTheme.backgroundColor),
            ),
          Text(
            "$_maximumAge yrs",
            style: const TextStyle(fontSize: 14, color: kRegentGray),
          ),
        ],
      ),
    );
  }

  Widget _optionsView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 60,
            decoration: customTheme.boxDecoration,
            child: Row(
              children: [
                Flexible(
                  child: NeumorphicRadioButton(
                    onTap: _setMale,
                    isSelected: (_selectedIndex == 0),
                    icon: Icons.male,
                  ),
                ),
                Flexible(
                  child: NeumorphicRadioButton(
                    onTap: _setFemale,
                    isSelected: (_selectedIndex == 1),
                    icon: Icons.female,
                  ),
                ),
                Flexible(
                  child: NeumorphicRadioButton(
                    onTap: _setRandom,
                    isSelected: (_selectedIndex == 2),
                    icon: Icons.shuffle,
                  ),
                ),
              ],
            ),
          ),
          _buildSlider(),
          NeumorphicTextButton(
            text: "Generate",
            onTap: _fetchImage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: customTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Random Face Generator",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            shadows: customTheme.boxShadows,
            color: kRegentGray,
          ),
        ),
        actions: [
          NeumorphicIconButton(
            icon: customTheme.icon,
            onTap: () {
              customTheme.switchTheme();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700 ||
              constraints.maxWidth > constraints.maxHeight) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _imageView(),
                  const SizedBox(width: 30),
                  _optionsView(),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  _imageView(),
                  _optionsView(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
