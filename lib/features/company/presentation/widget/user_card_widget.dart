import 'package:flutter/material.dart';
import '../../data/model/seach_all_user_response_model.dart';

class UserCard extends StatelessWidget {
  final SeachAllUserResponseModel user;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile Row
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    (user.avatar?.url != null && user.avatar!.url!.isNotEmpty)
                        ? NetworkImage(user.avatar!.url!)
                        : null,
                child: (user.avatar?.url == null || user.avatar!.url!.isEmpty)
                    ? Text(
                        (user.name.isNotEmpty ? user.name[0] : '?')
                            .toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (user.immediatelyAvailable == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 8,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "Immediate",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (user.role.toLowerCase() == 'candidate') ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.person_outline,
                            color: Colors.green,
                            size: 18,
                          ),
                        ] else if (user.role.toLowerCase() == 'company') ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.business,
                            color: Colors.purple,
                            size: 18,
                          ),
                        ] else if (user.role.toLowerCase() == 'recruiter') ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.how_to_reg,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.address.isNotEmpty
                                ? user.address
                                : "No location",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("View Profile"),
            ),
          ),
        ],
      ),
    );
  }
}