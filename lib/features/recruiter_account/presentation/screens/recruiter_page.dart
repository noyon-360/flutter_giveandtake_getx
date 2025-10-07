import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';

import '../controller/image_controller.dart';

class RecruiterPageScreen extends StatefulWidget {
  const RecruiterPageScreen({super.key});

  @override
  State<RecruiterPageScreen> createState() => _RecruiterPageScreenState();
}

class _RecruiterPageScreenState extends State<RecruiterPageScreen> {
  final ImageController imagePickerController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Container(
          height: 250,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xFF191919),
                  ),
                  height: 150,
                  width: double.infinity,

                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Image.asset('assets/icons/gallery.png'),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Drop your files here',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      SizedBox(height: 9.5),
                      Text(
                        'Choose file',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 50,
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFD9D9D9),
                  ),
                  child: Center(
                    child: imagePickerController.selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            // same as container
                            child: Image.file(
                              imagePickerController.selectedImage.value!,
                              height: 110,
                              width: 110,
                              fit: BoxFit
                                  .cover, // makes image fill the container
                            ),
                          )
                        : const Text(
                            'photo/recruiter logo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
