import 'package:flutter/material.dart';

class ElevatorSpeechResumeScreen extends StatelessWidget {
  const ElevatorSpeechResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Elevator Speech Resume")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(
                    height: 18,
                    width: screenWidth,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // center title stays centered regardless of right widgets
                        const Center(
                          child: Text(
                            "Your Elevator Speech",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // right aligned widgets
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Image(
                                image: AssetImage(
                                  "assets/icons/elevator_edit_icon.png",
                                ),
                                height: 16,
                                width: 16,
                              ),
                              SizedBox(width: 8),
                              // add more right widgets here
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 72.0),
                child: Text(
                  "Get a quick glimps of my work and creative process through this video portfolio",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ),
              // Add your widgets here
            ],
          ),
        ],
      ),
    );
  }
}
