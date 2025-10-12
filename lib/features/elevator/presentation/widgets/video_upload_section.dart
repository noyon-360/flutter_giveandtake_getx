import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/elevator_resume_controller.dart';

class VideoUploadSection extends StatelessWidget {
  const VideoUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Your Elevator Speech'),
        const SizedBox(height: 8),
        const Text(
          'Upload a 60-second elevator video pitch introducing your agency and what makes you stand out from the rest!',
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: controller.pickElevatorVideo,
          child: const Text('Upload/Change Elevator Pitch'),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return GestureDetector(
            onTap: controller.pickElevatorVideo,
            child: Container(
              height: 105,
              color: Colors.black,
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
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: const Text('Copy URL', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
