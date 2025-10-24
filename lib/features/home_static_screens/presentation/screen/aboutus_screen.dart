import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../controller/about_controller.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "About Us",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading && controller.aboutContent == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error != null &&
            controller.aboutContent == null) {
          return Center(
            child: Text(
              controller.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final about = controller.aboutContent;
        if (about == null) {
          return const Center(child: Text("No data available"));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchAboutContent(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(
                  data: about.description,
                  style: {
                    "h2": Style(
                      fontSize: FontSize(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    "p": Style(
                      fontSize: FontSize(12),
                      color: const Color(0xFF545454),
                      lineHeight: const LineHeight(1.6),
                    ),
                    "span": Style(
                      fontSize: FontSize(12),
                      color: const Color(0xFF545454),
                    ),
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  "Last updated: ${about.updatedAt.toLocal()}",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
