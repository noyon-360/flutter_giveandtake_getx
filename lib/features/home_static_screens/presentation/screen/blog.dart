import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/home_static_screens/data/models/blog_model.dart';
import '../controller/blog_controller.dart';
import 'blog_details.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BlogController ctrl = Get.put(BlogController());

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
            "Blogs",
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

      /// BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Obx(() {
            if (ctrl.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (ctrl.error.value != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${ctrl.error.value}'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: ctrl.fetchBlogs,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final List<BlogModel> posts = ctrl.blogs;
            return Column(
              children: posts.map((post) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Blog Image
                      if (post.image != null && post.image!.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            post.image!,
                            height: 223,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.createdAt ?? '',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF7C7C7C),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              // Show a short preview of HTML/description by stripping tags if needed.
                              post.description.replaceAll(
                                RegExp(r'<[^>]*>|&[^;]+;'),
                                '',
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF545454),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () {
                                Get.to(() => BlogDetailsScreen(id: post.id));
                              },
                              child: const Text(
                                "Read More →",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2B7FD0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ),
    );
  }
}
