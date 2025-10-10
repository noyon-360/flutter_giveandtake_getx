import 'package:flutter/material.dart';

class BlogDetailsScreen extends StatelessWidget {
  const BlogDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
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

              /// Section 1
              const Text(
                "Lorem ipsum dolor sit amet.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Novel research material refers to original, unexplored sources or data sets that offer fresh perspectives on a given topic, pushing the boundaries of existing knowledge and inviting rigorous scholarly inquiry. Unlike repurposed or derivative content, novel research material emerges from innovative methodologies—whether through cutting-edge experiments, newly digitized archives, under-studied communities, or interdisciplinary syntheses—that have not yet been subjected to extensive academic scrutiny. Its value lies not only in presenting previously hidden insights but also in challenging prevailing assumptions.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF545454),
                ),
              ),
              const SizedBox(height: 14),

              /// Section 2
              const Text(
                "Lorem ipsum dolor sit amet.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "1. novel research material often catalyzes collaboration across fields? \n2. novel research material often catalyzes collaboration across fields? \n3. novel research material often catalyzes collaboration across fields? \n4. novel research material often catalyzes collaboration across fields?",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.6,
                  color: Color(0xFF545454),
                ),
              ),
              const SizedBox(height: 14),

              /// Section 3
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "To instruct aspiring learners in the principles of fiscal legislation, begin by crafting a well-structured syllabus that balances theoretical frameworks with practical illustrations. Rather than merely lecturing, strive for participatory sessions: facilitate roundtable discussions on taxation reforms, assign case analyses of specific regulatory compliance, and assign capstone projects on major monetary statutes. Introduce scholarly articles and judicial opinions as reading materials, then guide students through critical appraisal, highlighting how court precedent shapes tax law, banking ordinances, or consumer protection norms. Tailor exercises to clarify employer-related issues—focusing on the budget cycle, fiscal accountability, and ethics in financial administration.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF545454),
                ),
              ),
              const SizedBox(height: 14),

              /// Section 4
              const Text(
                "Lorem ipsum dolor sit amet, consectetur.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "1. Lorem ipsum dolor sit amet, consectetur.\n2. Lorem ipsum dolor sit amet, consectetur.\n3. Lorem ipsum dolor sit amet, consectetur.\n4. Lorem ipsum dolor sit amet, consectetur.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.6,
                  color: Color(0xFF545454),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
