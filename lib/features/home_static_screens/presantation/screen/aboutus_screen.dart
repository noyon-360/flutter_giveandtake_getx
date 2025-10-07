import 'package:flutter/material.dart';


class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
            "About Us",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,

        // Bottom text aligned left
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Padding(
            padding: EdgeInsets.fromLTRB(60, 0, 16, 12),
            child: Text(
              "Elevator Video Pitches was initially conceived in 2016 at a time of high employment amidst a 'skills shortage' which has abated. Today, millions of knowledgeable, highly skilled and competent professionals, graduates, and school leavers have tried unsuccessfully for years to find a job. We see you, we hear you, we care.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 10,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: Color(0xFF424242),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // Our Vision
            const Text(
              "Our Vision",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "To amplify the voices of millions of jobseekers globally and get everyone their desired jobs.",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

            /// Our Mission
            const Text(
              "Our Mission",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "To provide jobseekers and professionals globally with a platform to be seen and heard by leading employers, beyond a paper resume.",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.4,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

            /// What we offer
            const Text(
              "What we offer",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "We offer the opportunity for each candidate to pitch yourself to companies and companies and recruiters to pitch their corporate culture to you, after all it’s often said that job interviews are two-way meetings between a candidate and a company!",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.4,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

            /// Unique business content
            const Text(
              "Unique business content",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Our platform is the first global portal where you can:\n"
                  "\u00A0\u00A0\u00A0\u00A0\u2022 Upload your elevator video pitch for free (in most cases).\n"
                  "\u00A0\u00A0\u00A0\u00A0\u2022 Apply for jobs seamlessly.\n"
                  "\u00A0\u00A0\u00A0\u00A0\u2022 Receive timely feedback, positive or constructive, through our intuitive EVP dashboard.\n"
                  "Stay confident—your dream job is on its way!",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.8,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
