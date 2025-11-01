import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/recruiter_controller.dart'; // adjust import path

class ArchiveJobsPage extends StatelessWidget {
  const ArchiveJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recruiterController = Get.find<RecruiterController>();

    // Fetch archive jobs when screen opens
    recruiterController.fetchArchiveJobs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive Jobs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        // if (recruiterController.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        //
        // if (recruiterController.archiveJobs.isEmpty) {
        //   return const Center(
        //     child: Text('No archived jobs found'),
        //   );
        // }

        return ListView.separated(
          itemCount: recruiterController.archiveJobs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final job = recruiterController.archiveJobs[index];

            return ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Icons.business_center,
                  color: Colors.green, size: 32),
              title: Text(
                job.title ?? 'Untitled Job',
                style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${job.companyName ?? ''} | ${job.country ?? ''} (${job.jobType ?? ''})',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(job.location ?? '',
                      style:
                      const TextStyle(color: Colors.grey, fontSize: 13)),
                  Text('${job.daysAgo ?? ''} days ago',
                      style:
                      const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  // if (value == 'View Details') {
                  //   // Navigate to job detail
                  //   recruiterController.viewJobDetails(job.id);
                  // } else if (value == 'Copy link') {
                  //   recruiterController.copyJobLink(job.id);
                  // } else if (value == 'Unsave') {
                  //   recruiterController.unarchiveJob(job.id);
                  // }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  _buildMenuItem('View Details'),
                  _buildMenuItem('Copy link'),
                  _buildMenuItem('Unsave'),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            );
          },
        );
      }),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String label) {
    return PopupMenuItem<String>(
      value: label,
      child: Text(label),
    );
  }
}
