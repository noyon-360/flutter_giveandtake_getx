import 'package:flutter/material.dart';

class JobRequestCard extends StatelessWidget {
  final String name;
  final String position;
  final String company;
  final String jobTitle;
  final String imageUrl;
  final VoidCallback onViewDetails;

  const JobRequestCard({
    super.key,
    required this.name,
    required this.position,
    required this.company,
    required this.jobTitle,
    required this.imageUrl,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text("$position\n$company",
                      style:
                          const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Job Title:",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(jobTitle,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2B7FD0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("View Details",
                  style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
