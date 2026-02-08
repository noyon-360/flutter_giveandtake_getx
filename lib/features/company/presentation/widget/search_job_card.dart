
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';

import '../../../job_listing/presentation/screens/job_details_screen.dart';

class CompanyJobCard extends StatefulWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String location_Type;
  final String employement_Type;
  final int applicants;
  final String postedDate;
  final String description;
  final String? companyLogo; 
  final VoidCallback? onEasyApply;
  final VoidCallback? onTap;// new field

  const CompanyJobCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.location_Type,
    required this.employement_Type,
    required this.applicants,
    required this.postedDate,
    required this.description,
    this.companyLogo,
    this.onEasyApply,
    this.onTap, // 👈 new
  });

  @override
  State<CompanyJobCard> createState() => _CompanyJobCardState();
}

class _CompanyJobCardState extends State<CompanyJobCard> {
  bool isExpanded = false; // track if description is expanded

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Company logo (square)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.companyLogo ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.business),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Job title + company
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.companyName,
                      style: const TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
               Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   OutlinedButton(
                    onPressed: widget.onEasyApply,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text("Apply", style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: widget.onTap,
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

              /// View details
              // TextButton(
              //   onPressed: () {
              //     Get.to(() => JobDetailsScreen(jobData: {}));
              //   },
              //   child: const Text("View details"),
              // ),
            ],
          ),

          const SizedBox(height: 12),
          if (widget.description.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  maxLines: isExpanded ? null : 2,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                if (widget.description.length >
                    100) // show "See More" only if text is long
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Text(
                      isExpanded ? "See Less" : "See More",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 24),

          /// Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _jobTag(Icons.location_on, widget.location),
              _jobTag(Icons.work_outline, widget.location_Type),
              _jobTag(Icons.school_outlined, widget.employement_Type),
              _jobTag(Icons.people_outline, "${widget.applicants} applicants"),
            ],
          ),

          const SizedBox(height: 12),

          // /// Description with See More
   
          const SizedBox(height: 12),

          /// Date
          Text(
            widget.postedDate,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _jobTag(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F4F8),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
      ],
    ),
  );
}
