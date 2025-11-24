import 'package:flutter/material.dart';

class FrequentlyQuestions extends StatelessWidget {
  const FrequentlyQuestions({super.key});

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
            "Frequently Asked Questions",
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
                  "Find quick answers to the most common \nquestions about our platform and services.",
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
            children: const [
              _FaqItem(
                question: "How do I record an elevator video pitch?",
                answer:
                "You can record directly on our website or through the EVP mobile app.",
              ),
              _FaqItem(
                question: "Who has access to my elevator video pitch?",
                answer:
                "Only you and recruiters you apply to will have access to your video pitch and resume.",
              ),
              _FaqItem(
                question:
                "Can recruiters outside EVP view my video if I share the link in my CV?",
                answer:
                "No—only EVP-subscribed recruiters you've applied to can access your video.",
              ),
              _FaqItem(
                question: "How do I delete my video pitch and profile?",
                answer:
                "Select Delete (not Deactivate). Your profile will be permanently removed after 30 days.",
              ),
              _FaqItem(
                question: "How do I close my account?",
                answer:
                "Select Delete (not Deactivate). Your account will be permanently closed after 30 days.",
              ),
              _FaqItem(
                question:
                "What’s the difference between deletion and deactivation?",
                answer:
                "• Monthly plan: Terminate within 3 days for a 75% refund (minus bank/foreign exchange fees).\n"
                    "• Yearly plan: Terminate within 30 days for a 75% refund.",
              ),
              _FaqItem(
                question: "How can I receive a refund for my subscription?",
                answer:
                "We’ve kept our subscription costs low to support jobseekers worldwide.\n\n"
                    "• Monthly subscriptions: Cancel within 3 days for a 75% refund.",
              ),
              _FaqItem(
                question:
                "Do all recruiters get to view my elevator pitch and resume?",
                answer:
                "Only EVP-subscribed recruiters you’ve applied to can access your materials.",
              ),
              _FaqItem(
                question:
                "Is Elevator Video Pitch Ltd. a registered data controller?",
                answer:
                "Yes, we’re registered with the UK Information Commissioner’s Office as a data controller.",
              ),
              _FaqItem(
                question: "Do you sell our data to third parties?",
                answer:
                "No. Please review our Privacy Policy for details.",
              ),
              _FaqItem(
                question: "What is the minimum age for using the platform?",
                answer:
                "• Members: 16 years and above\n• Recruiters: 18 years and above.",
              ),
              _FaqItem(
                question: "How do I change my password?",
                answer: "Select 'Forgot my password' to initiate the change process.",
              ),
              _FaqItem(
                question:
                "What should I wear for my elevator video pitch recording?",
                answer:
                "Dress appropriately for the industry and role you’re targeting!",
              ),
              _FaqItem(
                question: "Where can I view my payments history?",
                answer: "On your Payments History page.",
              ),
              _FaqItem(
                question: "Can I send a message to other members?",
                answer:
                "No. Members can only send their profile and application to a recruiter for a specific role.",
              ),
              _FaqItem(
                question: "Where can I view my messages?",
                answer: "In your messages panel.",
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

// FAQ widget
class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 3,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          visualDensity: VisualDensity(vertical: _isExpanded ? 0 : -4),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          childrenPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

          title: Text(
            widget.question,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF131313),
            ),
          ),

          // Custom arrow icons
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isExpanded
                ? Image.asset(
              'assets/icons/faqarrowdown.png',
              key: const ValueKey('up'),
              width: 8,
              height: 8,
              color: const Color(0xFF2042E3),
            )
                : Image.asset(
              'assets/icons/faq_arrow.png',
              key: const ValueKey('down'),
              width: 8,
              height: 8,
              color: const Color(0xFF2042E3),
            ),
          ),

          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },

          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.answer,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      color: Color(0xFF606267),
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
