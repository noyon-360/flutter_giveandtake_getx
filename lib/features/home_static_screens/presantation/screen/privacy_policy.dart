import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
            "Privacy Policy",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,

        // Bottom text perfectly aligned with title
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Padding(
                padding: const EdgeInsets.only(right: 2, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: const Offset(60, 0),
                    child: const Text(
                      "Your data is protected—learn how we collect,\nuse, and safeguard your information.",
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
          ),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Our Vision
            const Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "we value and respect your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your personal information when you visit our website [yourwebsite.com] or make a purchase from us.By using our website, you agree to the practices described in this Privacy Policy. Please read it carefully to understand our views and practices regarding your personal data",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

            // Information we collect
            const Text(
              "Information We Collect",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "We collect various types of information to provide and improve our auction services, including:",
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF645949),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 14), // 🔹 indent bullets slightly
                  child: Text(
                    "\u2022 Personal Information: When you register for an account, place a bid, or use certain features on our Site, we may collect your name, email address, phone number, billing address, shipping address, and payment details.\n\n"
                        "\u2022 Transaction Information: We collect details of your bidding activity, including bids placed, items purchased, and payment history.\n\n"
                        "\u2022 Usage Data: We collect information about your interactions with the Site, including IP address, browser type, device type, pages visited, and time spent on the Site. This helps us improve your user experience and optimize our services.\n\n"
                        "\u2022 Cookies and Tracking Technologies: We use cookies, web beacons, and other tracking technologies to enhance your experience and collect information about how you use our Site.",
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      color: Color(0xFF645949),
                    ),
                  ),
                ),
              ],
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
                  height: 1.2,
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
                  "• Upload your elevator video pitch for free (in most cases).\n"
                  "• Apply for jobs seamlessly.\n"
                  "• Receive timely feedback, positive or constructive, through our intuitive EVP dashboard.\n"
                  "• Stay confident—your dream job is on its way!",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
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
