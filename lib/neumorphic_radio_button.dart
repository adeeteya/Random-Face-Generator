import 'package:flutter/material.dart';
import 'package:random_face_generator/constants.dart';
import 'package:random_face_generator/custom_theme.dart';

class NeumorphicRadioButton extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;
  const NeumorphicRadioButton(
      {Key? key,
      required this.isSelected,
      required this.icon,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          border: (isSelected) ? CustomTheme().border : null,
        ),
        child: Icon(
          icon,
          color: kRegentGray,
        ),
      ),
    );
  }
}
