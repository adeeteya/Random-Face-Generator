import 'package:flutter/material.dart';
import 'package:random_face_generator/constants.dart';
import 'package:random_face_generator/custom_theme.dart';

class NeumorphicIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const NeumorphicIconButton(
      {Key? key, required this.icon, required this.onTap})
      : super(key: key);

  @override
  _NeumorphicIconButtonState createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
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
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _customTheme.backgroundColor,
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _customTheme.shadowColor,
              _customTheme.sourceColor,
            ],
          ),
        ),
        child: Icon(
          widget.icon,
          size: 24,
          color: kRegentGray,
        ),
      ),
    );
  }
}
