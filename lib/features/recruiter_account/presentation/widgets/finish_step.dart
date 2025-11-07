import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posting_controller.dart';
import '../screens/job_preview_screen.dart';

class FinishStep extends StatelessWidget {
  const FinishStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your job posting is ready!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Preview Button
              OutlinedButton(
                onPressed: () {
                  Get.to(() => JobPreviewScreen());
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2B7FD0), width: 1.5),
                  minimumSize: const Size(160, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Preview Your Post",
                  style: TextStyle(
                    color: Color(0xFF2B7FD0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Publish Button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement publishing logic here
                  Get.snackbar(
                    "Success",
                    "Job post published successfully!",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B7FD0),
                  minimumSize: const Size(160, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Publish Your Post",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
