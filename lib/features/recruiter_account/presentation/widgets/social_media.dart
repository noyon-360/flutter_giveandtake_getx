import 'package:flutter/material.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({
    super.key, required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
      ),
      child: Center(
        child: Image.asset(
          image,
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}