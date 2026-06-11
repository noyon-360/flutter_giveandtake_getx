import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String duration;
  final String salary;
  final String timePosted;
  final String? logoUrl;
  final VoidCallback? onTap;
  final VoidCallback? onEasyApply;

  /// Apply is candidate-only — recruiters/companies pass false to hide it.
  final bool canApply;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.salary,
    required this.timePosted,
    this.logoUrl,
    this.onTap,
    this.onEasyApply,
    this.canApply = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Logo, Title, Apply
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: logoUrl != null && logoUrl!.isNotEmpty
                    ? Image.network(
                        logoUrl!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                             const Icon(Icons.business, size: 40, color: Colors.grey),
                      )
                    : const Icon(Icons.business, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (canApply) ...[
                    OutlinedButton(
                      onPressed: onEasyApply,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text("Apply", style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(height: 4),
                  ],
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      "View details",
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            "We are looking for a knowledgeable and patient $title to join our academic team.", // Dynamic description
            style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
           GestureDetector(
             onTap: onTap,
             child: Padding(
               padding: const EdgeInsets.only(top: 4.0),
               child: const Text("See more", style: TextStyle(color: AppColors.primaryBlue, fontSize: 13, fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
             )
           ),

          const SizedBox(height: 16),

          // Profile Fit Section (Static for UI)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FA), // Light blueish gray
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                 const Icon(Icons.auto_awesome, size: 20, color: Colors.cyan),
                 const SizedBox(width: 8),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("PROFILE FIT", style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                       const Text("Check your fit", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                     ],
                   ),
                 ),
                 OutlinedButton(
                   onPressed: () {},
                   style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.grey.shade400),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                       minimumSize: const Size(0, 30),
                   ),
                   child: const Text("Analyze", style: TextStyle(color: Colors.black87, fontSize: 12)),
                 ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // Chips / Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip(Icons.location_on_outlined, location),
              _buildChip(null, salary),
              _buildChip(null, "Remote"), // Mock data for now
              _buildChip(null, duration), // Full-Time
              _buildChip(Icons.people_outline, "0 applicants"), // Mock
            ],
          ),

           const SizedBox(height: 16),
           
           // Footer Date
           Text(
             timePosted.contains("ago") ? timePosted : "Posted on $timePosted",
             style: const TextStyle(
               color: Colors.green,
               fontWeight: FontWeight.bold,
               fontSize: 13,
             ),
           )

        ],
      ),
    );
  }

  Widget _buildChip(IconData? icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0FC), // Light purple/blue bg
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
             Icon(icon, size: 14, color: Colors.black54),
             const SizedBox(width: 4),
          ],
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
