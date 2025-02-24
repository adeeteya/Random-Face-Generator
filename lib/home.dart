import 'dart:io';
import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:random_face_generator/constants.dart';
import 'package:random_face_generator/custom_theme.dart';
import 'package:random_face_generator/widgets/neumorphic_elevated_button.dart';
import 'package:random_face_generator/widgets/neumorphic_icon_button.dart';

class Home extends StatefulWidget {
  final bool isDark;
  const Home({super.key, required this.isDark});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // int _minimumAge = 0, _maximumAge = 100, _selectedIndex = 2;
  late Uint8List imageList;
  bool _loading = true;
  @override
  void initState() {
    _fetchImage();
    super.initState();
  }

  // void _setMale() {
  //   setState(() {
  //     _selectedIndex = 0;
  //   });
  // }
  //
  // void _setFemale() {
  //   setState(() {
  //     _selectedIndex = 1;
  //   });
  // }
  //
  // void _setRandom() {
  //   setState(() {
  //     _selectedIndex = 2;
  //   });
  // }
  //
  // void _setAgeRange(RangeValues range) {
  //   setState(() {
  //     _minimumAge = range.start.floor();
  //     _maximumAge = range.end.floor();
  //   });
  // }
  //
  // void _setGenderQuery() {
  //   switch (_selectedIndex) {
  //     case 0:
  //       queryUrl = "$kDefaultUrl?gender=male";
  //       break;
  //     case 1:
  //       queryUrl = "$kDefaultUrl?gender=female";
  //       break;
  //     case 2:
  //       queryUrl = kDefaultUrl;
  //       break;
  //   }
  // }
  //
  // void _setAgeQuery() {
  //   if (_selectedIndex != 2) {
  //     if (_minimumAge != 0) {
  //       queryUrl += "&minimum_age=$_minimumAge";
  //     }
  //     if (_maximumAge != 100) {
  //       queryUrl += "&maximum_age=$_maximumAge";
  //     }
  //   } else {
  //     if (_minimumAge != 0) {
  //       queryUrl += "?minimum_age=$_minimumAge";
  //       if (_maximumAge != 100) {
  //         queryUrl += "&maximum_age=$_maximumAge";
  //       }
  //     } else if (_maximumAge != 100) {
  //       queryUrl += "?maximum_age=$_maximumAge";
  //     }
  //   }
  // }

  Future _displayErrorAlert(String title, String content) async {
    return await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
    // _setGenderQuery();
    // _setAgeQuery();
    setState(() {
      _loading = true;
    });
    try {
      // final response = await http.get(Uri.parse(queryUrl));
      // imageUrl = Face.fromJson(jsonDecode(response.body)).imageUrl;
      imageList = await http.readBytes(
        Uri.parse((kIsWeb) ? kCorsUrl : kDefaultUrl),
      );
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
      } else {
        _displayErrorAlert("Unknown Error Occurred", "Please Try again Later.");
      }
      return;
    }
    setState(() {
      _loading = false;
    });
  }

  Future<String> getDestinationPathName(
    String pathName, {
    bool isBackwardSlash = true,
  }) async {
    String destinationPath =
        "$pathName${isBackwardSlash ? "\\" : "/"}randomface.png";
    int i = 1;
    bool isFileExists = await File(destinationPath).exists();
    while (isFileExists) {
      isFileExists =
          await File(
            "$pathName${isBackwardSlash ? "\\" : "/"}randomface($i).png",
          ).exists();
      if (isFileExists == false) {
        destinationPath =
            "$pathName${isBackwardSlash ? "\\" : "/"}randomface($i).png";
        break;
      }
      i++;
    }
    return destinationPath;
  }

  Future _downloadImage() async {
    if (_loading) return;
    Directory? appDir;
    final stream = Stream.fromIterable(imageList);
    if (kIsWeb) {
      await download(stream, "randomface.png");
      return;
    } else if (Platform.isAndroid) {
      appDir = Directory("/storage/emulated/0/Download");
    } else if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getDownloadsDirectory();
    }
    String pathName = appDir?.path ?? "";
    String destinationPath = await getDestinationPathName(
      pathName,
      isBackwardSlash: Platform.isWindows,
    );
    await download(stream, destinationPath);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "The image has been downloaded successfully to $destinationPath",
          style: const TextStyle(color: kRegentGray),
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _imageView() {
    return DecoratedBox(
      decoration: CustomTheme(
        widget.isDark,
      ).boxDecoration.copyWith(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child:
            (_loading)
                ? FittedBox(
                  fit: BoxFit.none,
                  child: CircularProgressIndicator(color: kRegentGray),
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(imageList),
                ),
      ),
    );
  }

  // Widget _buildSlider() {
  //   return Container(
  //     height: 71,
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     decoration: CustomTheme(widget.isDark).boxDecoration,
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 "Age Range",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   color: kRegentGray,
  //                 ),
  //               ),
  //               Text(
  //                 "$_minimumAge - $_maximumAge years",
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   color: kRegentGray,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: 35,
  //           child: RangeSlider(
  //             min: 0,
  //             max: 100,
  //             activeColor: kRegentGray,
  //             inactiveColor: CustomTheme(widget.isDark).shadowColor,
  //             onChanged: _setAgeRange,
  //             values: RangeValues(
  //               _minimumAge.toDouble(),
  //               _maximumAge.toDouble(),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // return Expanded(
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       Container(
  //         height: 60,
  //         padding: const EdgeInsets.all(1),
  //         decoration: CustomTheme(widget.isDark).boxDecoration,
  //         child: Row(
  //           children: [
  //             Flexible(
  //               child: NeumorphicRadioButton(
  //                 onTap: _setMale,
  //                 isSelected: (_selectedIndex == 0),
  //                 icon: Icons.male_rounded,
  //               ),
  //             ),
  //             Flexible(
  //               child: NeumorphicRadioButton(
  //                 onTap: _setFemale,
  //                 isSelected: (_selectedIndex == 1),
  //                 icon: Icons.female_rounded,
  //               ),
  //             ),
  //             Flexible(
  //               child: NeumorphicRadioButton(
  //                 onTap: _setRandom,
  //                 isSelected: (_selectedIndex == 2),
  //                 icon: Icons.shuffle_rounded,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       _buildSlider(),
  //       Row(
  //         children: [
  //           Expanded(
  //             flex: 5,
  //             child: NeumorphicElevatedButton(
  //               onTap: _fetchImage,
  //               child: const Text(
  //                 "Generate",
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w600,
  //                   color: kRegentGray,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 20),
  //           Expanded(
  //             child: NeumorphicElevatedButton(
  //               onTap: _downloadImage,
  //               child: const Icon(Icons.download, color: kLimeGreen),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Random Face Generator",
          style: TextStyle(fontWeight: FontWeight.w600, color: kRegentGray),
        ),
        actions: [
          NeumorphicIconButton(
            icon: (widget.isDark) ? Icons.light_mode : Icons.dark_mode,
            onTap: () {
              Hive.box(kHiveSystemPrefs).put("darkMode", !widget.isDark);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > constraints.maxHeight) {
            final double imageSize =
                (constraints.maxWidth - constraints.maxHeight < 175)
                    ? constraints.maxHeight - 175
                    : constraints.maxHeight;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: _imageView(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: [
                          Spacer(flex: 2),
                          NeumorphicElevatedButton(
                            onTap: _fetchImage,
                            child: const Text(
                              "Generate",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: kRegentGray,
                              ),
                            ),
                          ),
                          Spacer(),

                          NeumorphicElevatedButton(
                            onTap: _downloadImage,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.download, color: kLimeGreen),
                                SizedBox(width: 10),
                                Text(
                                  "Download",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: kLimeGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final double imageSize =
                (constraints.maxHeight - constraints.maxWidth < 175)
                    ? constraints.maxWidth - 175
                    : constraints.maxWidth;
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                children: [
                  SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: _imageView(),
                  ),
                  Spacer(),
                  NeumorphicElevatedButton(
                    onTap: _fetchImage,
                    child: const Text(
                      "Generate",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kRegentGray,
                      ),
                    ),
                  ),
                  Spacer(),
                  NeumorphicElevatedButton(
                    onTap: _downloadImage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.download, color: kLimeGreen),
                        SizedBox(width: 10),
                        Text(
                          "Download",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kLimeGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
