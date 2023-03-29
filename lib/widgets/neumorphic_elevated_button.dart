import 'package:flutter/material.dart';
import 'package:random_face_generator/custom_theme.dart';

class NeumorphicElevatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const NeumorphicElevatedButton({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  NeumorphicElevatedButtonState createState() =>
      NeumorphicElevatedButtonState();
}

class NeumorphicElevatedButtonState extends State<NeumorphicElevatedButton> {
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
        height: 60,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: !_isPressed ? customTheme.boxShadows : null,
        ),
        child: widget.child,
      ),
    );
  }
}
