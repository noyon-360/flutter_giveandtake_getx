import 'package:flutter/material.dart';

class PublicProfileActionRow extends StatelessWidget {
  const PublicProfileActionRow({
    super.key,
    required this.onFollow,
    required this.onShare,
    this.isFollowing = false,
    this.isBusy = false,
    this.showFollow = true,
    this.followerCount,
  });

  final VoidCallback onFollow;
  final VoidCallback onShare;
  final bool isFollowing;
  final bool isBusy;
  final bool showFollow;

  /// When non-null and greater than 0, a small follower badge is shown to the
  /// left of the buttons (mirrors the web's "N followers" label).
  final int? followerCount;

  static const _blue = Color(0xFF2B7FD0);
  static const _lightBlue = Color(0xFFEAF3FF);

  @override
  Widget build(BuildContext context) {
    final count = followerCount ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (count > 0) ...[
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFF8ABAF0)),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people_alt_outlined, color: _blue, size: 14),
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
        if (showFollow) ...[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isBusy ? null : onFollow,
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
                    if (isBusy)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        isFollowing
                            ? Icons.person_remove_alt_1
                            : Icons.person_add_alt_1,
                        color: _blue,
                        size: 14,
                      ),
                    const SizedBox(width: 5),
                    Text(
                      isBusy
                          ? 'Wait'
                          : isFollowing
                          ? 'Unfollow'
                          : 'Follow',
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
        ],
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
