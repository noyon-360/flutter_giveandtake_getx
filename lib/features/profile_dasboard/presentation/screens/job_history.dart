import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';

import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';
import 'edit_personal_information_screen.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.to(() => const ProfileDashboardScreen());
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Profile Info
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
              const SizedBox(height: 12),
              const Text(
                "Brooklyn Simmons",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "brooklynsimmons@gmail.com",
                style: TextStyle(fontSize: 14, color: Color(0xFF595959)),
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
        
              const SizedBox(height: 22),
        
              /// Job History Title
              const Text(
                "Job History",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
        
              /// Table Header
              Container(
                height: 20.50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F3FF),
                  borderRadius: BorderRadius.circular(3.40),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Job Title",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Company Name",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Applied Date",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
        
              /// Table Rows
              Column(
                children: List.generate(7, (index) {
                  bool isRejected = index % 2 == 0;
                  return Container(
                    height: 18,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6FBFF),
                      borderRadius: BorderRadius.circular(3.40),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Backend Developer",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Arrex Digital",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "June 17",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              isRejected ? "Not Shortlisted" : "Reviewing",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: isRejected ? Colors.red : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
