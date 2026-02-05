import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../job_listing/presentation/screens/job_details_screen.dart';

class CompanyJobCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String jobType;
  final String jobLevel;
  final int applicants;
  final String postedDate;

  const CompanyJobCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.jobType,
    required this.jobLevel,
    required this.applicants,
    required this.postedDate,
  });

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
                    'https://i.pravatar.cc/150?img=3',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.business),
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
                      jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      companyName,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              /// View details
              TextButton(
                onPressed: () {
                  Get.to(() => JobDetailsScreen( jobData: {}));
                },
                child: const Text("View details"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _jobTag(Icons.location_on, location),
              _jobTag(Icons.work_outline, jobType),
              _jobTag(Icons.school_outlined, jobLevel),
              _jobTag(Icons.people_outline, "$applicants applicants"),
            ],
          ),

          const SizedBox(height: 12),

          /// Date
          Text(
            postedDate,
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
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    ),
  );
}
