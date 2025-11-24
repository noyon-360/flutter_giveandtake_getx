import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/elevator_resume_controller.dart';

class VideoUploadSection extends StatelessWidget {
  const VideoUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Your Elevator Speech',
          style: TextStyle(fontSize: 10, color: AppColors.textGrey),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: screenWidth * 0.5,

              child: const Text(
                'Upload a 60-second elevator video pitch introducing your agency and what makes you stand out from the rest!',
                style: TextStyle(fontSize: 9, color: AppColors.textGrey),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: controller.pickElevatorVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.primaryWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                'Upload/Change Elevator Pitch',
                style: TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Obx(() {
          return GestureDetector(
            onTap: controller.pickElevatorVideo,
            child: Container(
              height: 105,
              decoration: BoxDecoration(
                color: AppColors.navBarIconInactive,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: controller.elevatorVideoPath.value != null
                  ? Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.videocam,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Text(
                            'Video selected',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 16,
                            image: AssetImage(
                              "assets/icons/elevator_pick_image_icon.png",
                            ),
                          ),
                          Text(
                            'Drop your files here',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Choose File',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        }),
      ],
    );
  }
}
