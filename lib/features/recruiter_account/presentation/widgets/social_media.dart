import 'package:flutter/material.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({
    super.key, required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFF8ABAF0),
          width: 1,
        ),
      ),
      child: Center(
        child: Image.asset(
          image,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.link,
            color: Color(0xFF2B7FD0),
            size: 18,
          ),
        ),
      ),
    );
  }
}
