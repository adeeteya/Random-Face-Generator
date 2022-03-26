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
  _NeumorphicElevatedButtonState createState() =>
      _NeumorphicElevatedButtonState();
}

class _NeumorphicElevatedButtonState extends State<NeumorphicElevatedButton> {
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
    final _customTheme =
        CustomTheme(Theme.of(context).brightness == Brightness.dark);
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        height: 60,
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: _isPressed ? _customTheme.border : null,
          boxShadow: (_isPressed) ? null : _customTheme.boxShadows,
        ),
        child: widget.child,
      ),
    );
  }
}
