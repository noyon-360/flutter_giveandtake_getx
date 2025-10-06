import 'package:flutter/material.dart';

import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';

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
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                        "\u2022 Personal Information: When you register for an account, place a bid, or \u00A0\u00A0\u00A0use certain features on our Site, we may collect your name, email \u00A0\u00A0\u00A0address, phone number, billing address, shipping address, and \u00A0\u00A0\u00A0payment details.\n\n"
                        "\u2022 Transaction Information: We collect details of your bidding activity, \u00A0\u00A0\u00A0including bids placed, items purchased, and payment history.\n\n"
                        "\u2022 Usage Data: We collect information about your interactions with the \u00A0\u00A0\u00A0Site, including IP address, browser type, device type, pages visited, \u00A0\u00A0\u00A0and time spent on the Site. This helps us improve your user experience \u00A0\u00A0\u00A0and optimize our services.\n\n"
                        "\u2022 Cookies and Tracking Technologies: We use cookies, web beacons, \u00A0\u00A0\u00A0and other tracking technologies to enhance your experience and \u00A0\u00A0\u00A0collect information about how you use our Site.",
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

            //How We Use Your Information
            const Text(
              "How We Use Your Information",
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
                  "We use the information we collect to:",
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF645949),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                        "\u2022 Provide and manage the auction services, including processing bids, \u00A0\u00A0\u00A0managing payments, and shipping orders.\n"
                        "\u2022 Communicate with you about your account, bids, and purchases.\n"
                        "\u2022 Respond to customer service inquiries and resolve any issues.\n"
                        "\u2022 Personalize your experience on our Site and recommend relevant \u00A0\u00A0\u00A0products or auctions.\n"
                        "\u2022 Analyze and improve the performance and functionality of the Site\n"
                        "\u2022 Ensure compliance with our terms of service, legal obligations, and \u00A0\u00A0\u00A0prevent fraud.\n",


                    style: TextStyle(
                      fontSize: 10,
                      height: 1.8,
                      color: Color(0xFF645949),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            //How We Share Your Information
            const Text(
              "How We Share Your Information",
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
                  "We may share your personal information in the following situations:",
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF645949),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                        "\u2022 Service Providers: We may share your data with trusted third-party \u00A0\u00A0\u00A0service providers who assist us in operating the Site, processing \u00A0\u00A0\u00A0payments, and fulfilling orders. These providers are required to use \u00A0\u00A0\u00A0your data solely for the purpose of providing services to us.\n\n"
                        "\u2022 Legal Requirements: We may disclose your personal information if \u00A0\u00A0\u00A0required to do so by law or in response to valid requests by public \u00A0\u00A0\u00A0authorities (e.g., a court or government agency).\n\n"
                        "\u2022 Business Transfers: In the event of a merger, acquisition, or sale of \u00A0\u00A0\u00A0assets, your personal information may be transferred as part of the \u00A0\u00A0\u00A0transaction.\n\n",

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

            // Data Security
            const Text(
              "Data Security",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "We take the security of your personal information seriously and use industry-standard security measures to protect it. However, no data transmission over the internet is completely secure, and we cannot guarantee the absolute security of your information.",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

            //Your Data Rights
            const Text(
              "Your Data Rights",
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
                  "Depending on your location, you may have certain rights regarding your personal data, including:",
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF645949),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(

                    "\u2022 The right to access the personal information we hold about you.\n"
                    "\u2022 The right to correct any inaccuracies in your personal information.\n"
                    "\u2022 The right to delete your personal information, subject to legal and \u00A0\u00A0\u00A0\u00A0contractual obligations.\n"
                    "\u2022 The right to withdraw consent where we process data based on \u00A0\u00A0\u00A0\u00A0consent.\n"
                    "\u2022 The right to opt-out of marketing communications.\n",

                    style: TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      color: Color(0xFF645949),
                    ),
                  ),
                ),

                Text(
                  "If you wish to exercise any of these rights, please contact us at [contact@yourwebsite.com].",
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF645949),
                  ),
                ),


              ],
            ),
            const SizedBox(height: 24),

            // Data Retention
            const Text(
              "Data Retention",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "We retain your personal information for as long as necessary to provide services, comply with legal obligations, and resolve disputes. Once your data is no longer needed, we will securely delete or anonymize it.",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

            // Cookies
            const Text(
              "Cookies",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "We use cookies to enhance your browsing experience. A cookie is a small file stored on your device that helps us remember your preferences, analyze Site usage, and improve functionality. You can control cookies through your browser settings, but disabling cookies may affect your ability to use certain features of the Site.",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),
            // Children’s Privacy
            const Text(
              "Children’s Privacy",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "Our Site is not intended for children under the age of 13, and we do not knowingly collect personal information from children. If we become aware that we have inadvertently collected personal information from a child under 13, we will take steps to delete that information.",

              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

            // Changes to This Privacy Policy
            const Text(
              "Changes to This Privacy Policy",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            const Text( "We may update this Privacy Policy from time to time. Any changes will be posted on this page, and the Effective Date at the top will be updated. We encourage you to review this policy periodically to stay informed about how we protect your information.",
              style: TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  letterSpacing: 0.4,
                  color: Color(0xFF545454)
              ),
            ),

            const SizedBox(height: 24),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
