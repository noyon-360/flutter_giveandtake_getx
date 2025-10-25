import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';
import '../controller/terms_controller.dart';

class TermsandConditions extends StatelessWidget {
  const TermsandConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            "Terms & Conditions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.termsContent.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null && controller.termsContent.value == null) {
          return Center(
            child: Text(
              controller.error.value ?? 'Failed to load',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final content = controller.termsContent.value;
        if (content == null) {
          return const Center(child: Text('No content available'));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchTermsContent(forceRefresh: true),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Html(
                    data: content.description,
                    style: {
                      "p": Style(
                        fontSize: FontSize(12),
                        color: const Color(0xFF424242),
                        lineHeight: const LineHeight(1.6),
                      ),
                      "h2": Style(
                        fontSize: FontSize(16),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B7FD0),
                      ),
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Last updated: ${content.updatedAt?.toLocal() ?? ''}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }),

      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

