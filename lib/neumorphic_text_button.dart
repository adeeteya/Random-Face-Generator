import 'package:flutter/material.dart';
import 'package:random_face_generator/constants.dart';
import 'package:random_face_generator/custom_theme.dart';

class NeumorphicTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const NeumorphicTextButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  _NeumorphicTextButtonState createState() => _NeumorphicTextButtonState();
}

class _NeumorphicTextButtonState extends State<NeumorphicTextButton> {
  bool _isPressed = false;
  final _customTheme = CustomTheme();
  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        height: 60,
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _customTheme.backgroundColor,
          border: _isPressed ? _customTheme.border : null,
          boxShadow: (_isPressed) ? null : _customTheme.boxShadows,
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kRegentGray,
          ),
        ),
      ),
    );
  }
}
