import 'package:flutter/material.dart';
import 'package:giveandtake/features/home_static_screens/data/models/blog_model.dart';
import 'package:get/get.dart';

import '../controller/blog_details_controller.dart';

class BlogDetailsScreen extends StatelessWidget {
  final BlogModel? post;
  final String? id;

  const BlogDetailsScreen({super.key, this.post, this.id});

  @override
  Widget build(BuildContext context) {
    final BlogDetailsController ctrl = Get.put(BlogDetailsController());

    if (post == null && id != null) {
      // fetch the blog if id provided and no post model passed
      ctrl.fetchById(id!);
    }

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
            "Blog Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.only(right: 2, bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: const Offset(60, 0),
                child: const Text(
                  "Explore insights, tips, and updates on careers, \nhiring, and the job market.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8593A3),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      /// ---------------- Body ----------------
      body: SafeArea(
        child: Obx(() {
          // if a post was passed in we show it; otherwise use controller
          final BlogModel? model = post ?? ctrl.blog.value;
          if (post == null && ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (post == null && ctrl.error.value != null) {
            return Center(child: Text('Error: ${ctrl.error.value}'));
          }

          if (model == null) {
            return const Center(child: Text('No blog found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (model.image != null && model.image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      model.image!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/blog.jpg',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 18),

                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  model.description.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: Color(0xFF545454),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }
}
