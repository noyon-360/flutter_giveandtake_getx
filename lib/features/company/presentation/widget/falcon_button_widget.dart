import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FaIconButton extends StatelessWidget {
  final FaIconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isLast;
  final double size; // to skip the right border for the last icon

  const FaIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isLast = false,
    this.size = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // space inside the square box
      decoration: BoxDecoration(
        border: Border(
          right: isLast
              ? BorderSide.none
              : const BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: FaIcon(icon, color: color, size: size),
      ),
    );
  }
}
