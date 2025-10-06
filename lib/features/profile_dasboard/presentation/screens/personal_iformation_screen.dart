import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/bottomNavbar/screens/dashboard_screen.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';

import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';
import 'edit_personal_information_screen.dart';


class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.to(() =>  DashboardScreen());
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              /// Profile Image + Name + Email
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/images/profile.jpg"), // user image
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Brooklyn Simmons",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121)
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "brooklynsimmons@gmail.com",
                    style: TextStyle(fontSize: 14, color: Color(0xFF595959)),
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
        
        
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                       Get.to(() => EditProfile());
                      },
                      icon: Image.asset("assets/icons/editprofile.png", width: 20, height: 20 ),
                      ),
                    ),
                ],
              ),
        
        
              /// Editable Fields
              _textField(label: "First Name", hint: "Brooklyn"),
              _textField(label: "Last Name", hint: "Simmons"),
              _textField(label: "Email Address", hint: "brooklynsimmons@gmail.com"),
              _textField(label: "Phone", hint: "(58) 474748574"),
              _textField(label: "Country", hint: "USA"),
              _textField(label: "City/State", hint: "Alabama"),
              _textField(label: "Town", hint: "Berlin"),
              _textField(label: "Zip/Postal Code (Optional)", hint: "1212"),
        
              const SizedBox(height: 30),
        
              /// Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFD00003),
                          side: const BorderSide(color: Colors.red, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Deactivate Account",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD00003),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        
              /// Text
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    // height: 95,
                    width: 200,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "We’re sorry to see you leave! Your account and its data will be permanently deleted in the next 30 days. "
                          "Please consider deactivating your account first and then delete it after a break.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

    );
  }

  Widget _textField({
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 53,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF595959),
                ),
                filled: true,
                fillColor: Colors.white, // background color
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // radius
                  borderSide: const BorderSide(color: Color(0xFF595959), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF1A3E74), width: 1.5), // focus color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
