import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payments = List.generate(
      8,
          (index) => {
        "txn": "TXN23007891",
        "date": "2025-06-20 10:45 AM",
        "plan": "Resume Highlight",
        "amount": "150",
        "method": "PayPal",
        "status": "Successful",
        "receipt": "Download"
      },
    );

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
      body: SingleChildScrollView(
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

            /// Payment History Title
            const Text(
              "Payment History",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            /// Table Header
            Container(
              height: 40,
              child: Row(
                children: const [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Transaction ID",
                        style: TextStyle(
                          fontSize: 6.36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8), // gap

                  Expanded(
                    child: Center(
                      child: Text(
                        "Date & Time",
                        style: TextStyle(
                          fontSize: 6.36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Plan Name",
                        style: TextStyle(
                          fontSize: 6.36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Amount Paid",
                        style: TextStyle(
                          fontSize: 6.36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Payment Method",
                        style: TextStyle(
                          fontSize: 6.36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 6.36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Receipt",
                        style: TextStyle(
                          fontSize: 6.36,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            const Divider(thickness: 1, color: Color(0xFFE0E0E0)),

            /// Table Rows
            ...payments.map((payment) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(payment["txn"]!,
                              style: const TextStyle(fontSize: 6)),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Center(
                          child: Text(payment["date"]!,
                              style: const TextStyle(fontSize: 6)),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Center(
                          child: Text(payment["plan"]!,
                              style: const TextStyle(fontSize: 6)),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Center(
                          child: Text(payment["amount"]!,
                              style: const TextStyle(fontSize: 6)),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Center(
                          child: Text(payment["method"]!,
                              style: const TextStyle(fontSize: 6)),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Center(
                          child: Text(payment["status"]!,
                              style: const TextStyle(
                                fontSize: 6,

                              )),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Center(
                          child: Text(payment["receipt"]!,
                              style: const TextStyle(
                                fontSize: 6,
                              )),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                ],
              );
            }).toList(),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
