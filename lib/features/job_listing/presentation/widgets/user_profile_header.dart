import 'package:flutter/material.dart';
import 'package:karlfive/features/job_listing/data/models/user_profile_model.dart';

class UserProfileHeader extends StatelessWidget {
  final UserProfileModel? userProfile;
  final bool isLoading;

  const UserProfileHeader({
    super.key,
    required this.userProfile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (userProfile == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and name
          CircleAvatar(
                radius: 50,
                backgroundImage: userProfile!.avatarUrl != null
                    ? NetworkImage(userProfile!.avatarUrl!)
                    : null,
                child: userProfile!.avatarUrl == null
                    ? Text(
                        userProfile!.name.isNotEmpty
                            ? userProfile!.name[0].toUpperCase()
                            : '',
                        style: const TextStyle(fontSize: 32),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userProfile!.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userProfile!.title ?? userProfile!.role,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Contact information in a row
          Row(
            children: [
              // Location
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userProfile!.address.isNotEmpty
                            ? userProfile!.address
                            : 'No address',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Email
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userProfile!.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
