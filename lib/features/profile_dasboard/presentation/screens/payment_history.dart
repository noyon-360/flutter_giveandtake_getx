import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

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
        
              /// Current Plan Title
              const Text(
                "Current Plan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
        
              /// Current Plan Card
              SizedBox(
                height: 349.94,
                width: 250.63,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B7FD0),
                    borderRadius: BorderRadius.circular(11.08),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PREMIUM PLAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 14),
        
                      /// Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "\$49.99",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          Padding(
                            padding: EdgeInsets.only(bottom: 45),
                            child: Text(
                              "Per year",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
        
                      // const SizedBox(height: 0),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: const Text(
                          "What the user will get",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
        
                      const SizedBox(height: 13),
        
                      const Text(
                        "Plan description: Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.8,
                        ),
                      ),
        
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.4)),
        
                      const SizedBox(height: 12),
        
                      /// Features list
                      _buildFeature("A 60-sec elevator pitch"),
                      const SizedBox(height: 11),
                      _buildFeature("A free CV review and alteration online"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  /// Helper function to build a feature row
  Widget _buildFeature(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
