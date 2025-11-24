import 'package:flutter/material.dart';

class TitleWithEditLogo extends StatelessWidget {
  final String title;
  final double height;
  final TextStyle? titleStyle;
  final VoidCallback? onPress;
  final List<Widget>? rightWidgets;

  const TitleWithEditLogo({
    super.key,
    required this.title,
    this.height = 18,
    this.titleStyle,
    this.onPress,
    this.rightWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle =
        titleStyle ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(title, textAlign: TextAlign.center, style: textStyle),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:
                  rightWidgets ??
                  [
                    InkWell(
                      onTap: onPress,
                      child: Image.asset(
                        "assets/icons/elevator_edit_icon.png",
                        height: 16,
                        width: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
            ),
          ),
        ],
      ),
    );
  }
}
