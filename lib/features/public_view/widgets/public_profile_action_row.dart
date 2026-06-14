import 'package:flutter/material.dart';

class PublicProfileActionRow extends StatelessWidget {
  const PublicProfileActionRow({
    super.key,
    required this.onFollow,
    required this.onShare,
    this.isFollowing = false,
  });

  final VoidCallback onFollow;
  final VoidCallback onShare;
  final bool isFollowing;

  static const _blue = Color(0xFF2B7FD0);
  static const _lightBlue = Color(0xFFEAF3FF);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onFollow,
            borderRadius: BorderRadius.circular(9),
            child: Ink(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: _lightBlue,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: _blue.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFollowing
                        ? Icons.check_circle_outline
                        : Icons.person_add_alt_1,
                    color: _blue,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(
                      color: _blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onShare,
            borderRadius: BorderRadius.circular(9),
            child: Ink(
              height: 34,
              width: 36,
              decoration: BoxDecoration(
                color: _lightBlue,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: _blue.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.share, color: _blue, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
