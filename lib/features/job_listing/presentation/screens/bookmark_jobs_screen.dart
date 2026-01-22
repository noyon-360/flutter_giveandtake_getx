import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/theme/app_colors.dart';

import '../controllers/bookmark_controller.dart';
import 'job_details_screen.dart';

class BookmarkJobsScreen extends StatefulWidget {
  BookmarkJobsScreen({super.key});

  @override
  State<BookmarkJobsScreen> createState() => _BookmarkJobsScreenState();
}

class _BookmarkJobsScreenState extends State<BookmarkJobsScreen> {
  final BookmarkController controller = Get.isRegistered<BookmarkController>()
      ? Get.find<BookmarkController>()
      : Get.put(BookmarkController(), permanent: true);

  @override
  void initState() {
    super.initState();
    // Fetch bookmarks when the screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBookmarks();
    });
  }

  void _showMenu(BuildContext context, Map<String, dynamic> job) async {
    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: const [
        PopupMenuItem(value: 'view', child: Text('View Details')),
        PopupMenuItem(value: 'unsave', child: Text('Unsave')),
      ],
    );

    final original = job['original'] ?? job;

    if (choice == 'view') {
      Get.to(() => JobDetailsScreen(jobData: original));
    } else if (choice == 'unsave') {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Call the unsaveJob method which hits the API
      final success = await controller.unsaveJob(job);

      // Close loading dialog first
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Then show success/error snackbar
      if (success) {
        Get.snackbar(
          'Success',
          'Bookmark removed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.textGreen,
          colorText: AppColors.primaryWhite,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove bookmark',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.deleteButtonBackground,
          colorText: AppColors.primaryWhite,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Jobs'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = controller.savedJobs;
        if (list.isEmpty) {
          return const Center(child: Text('No saved jobs'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final job = list[index];
            // Now job is a snapshot with fields: title, company, location, logoUrl, original
            final title = job['title'] ?? '';
            final company = job['company'] ?? '';
            final location = job['location'] ?? '';
            final logo = job['logoUrl'] as String?;
            final original = job['original'] ?? job;

            return ListTile(
              leading: logo != null && logo.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        logo,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.business,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    )
                  : const Icon(Icons.business, color: AppColors.primaryBlue),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('$company \u2022 $location'),
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () => _showMenu(context, job),
              ),
              onTap: () => Get.to(() => JobDetailsScreen(jobData: original)),
            );
          },
        );
      }),
    );
  }
}
