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
  NeumorphicIconButtonState createState() => NeumorphicIconButtonState();
}

class NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _isPressed = false;
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
    final customTheme =
        CustomTheme(Theme.of(context).brightness == Brightness.dark);
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          shape: BoxShape.circle,
          gradient: (_isPressed)
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    customTheme.sourceColor,
                    customTheme.shadowColor,
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
