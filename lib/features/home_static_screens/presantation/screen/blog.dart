import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogPosts = [
      {
        'title': 'How to Spot the Right Job for You',
        'author': 'Alex Robert',
        'date': 'May 27, 2025',
        'description':
        'Don’t just apply — align. Learn how to identify roles that match your career goals and values.',
        'image': 'assets/images/blog.jpg',
      },
      {
        'title': '5 Tips to Improve Your Elevator Pitch',
        'author': 'Sarah Lee',
        'date': 'May 25, 2025',
        'description':
        'Crafting an elevator pitch can open new opportunities — here’s how to make yours stand out.',
        'image': 'assets/images/blog.jpg',
      },
      {
        'title': 'Building a Strong Resume in 2025',
        'author': 'John Carter',
        'date': 'May 21, 2025',
        'description':
        'Learn the essential strategies for building a resume that catches employers’ attention.',
        'image': 'assets/images/blog.jpg',
      },
    ];

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
            "Blog",
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: blogPosts.map((post) {
              return GestureDetector(
                onTap: () {
                  // Get.to(() => BlogDetailsScreen(post: post));
                },
                child: Container(
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
                      /// Blog Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.asset(
                          post['image']!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      /// Blog Info
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${post['date']}      ${post['author']}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF7C7C7C),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              post['title']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              post['description']!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF545454),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Read More →",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2B7FD0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
