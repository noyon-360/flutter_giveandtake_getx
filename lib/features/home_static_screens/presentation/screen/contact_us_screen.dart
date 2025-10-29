import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/contactus_model.dart';
import '../../domain/repo/contact_us_repimpl.dart';
import '../controller/contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  final EditProfileModel member;

  final controller = Get.put(
    ContactUsController(ContactUsRepoImpl(apiClient: ApiClient())),
  );

  ContactUsScreen({super.key, required this.member});

  // Create text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final subjectController = TextEditingController();
  final yourCompanyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Prefill fields from passed member when available but only if empty
    if (firstNameController.text.isEmpty)
      firstNameController.text = member.firstName;
    if (lastNameController.text.isEmpty)
      lastNameController.text = member.lastName;
    if (addressController.text.isEmpty)
      addressController.text =
          member.email; // if address not available, show email
    if (phoneNumberController.text.isEmpty)
      phoneNumberController.text = member.phone;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: Color(0xFF4D4D4D),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 22,
            left: 24,
            right: 24,
            bottom: 24,
          ),
          child: Column(
            children: [
              // First + Last Name
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "First Name*",
                      hintText: "Enter Your Surname",
                      controller: firstNameController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Last Name*",
                      hintText: "Enter Your Last Name",
                      controller: lastNameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Address
              _buildTextField(
                label: "Address",
                hintText: "Enter Your Address",
                controller: addressController,
              ),
              const SizedBox(height: 10),

              // Phone
              _buildTextField(
                label: "Phone Number",
                hintText: "Enter Phone Number",
                controller: phoneNumberController,
              ),
              const SizedBox(height: 10),

              // Subject
              _buildTextField(
                label: "Subject",
                hintText: "Enter Here",
                controller: subjectController,
              ),
              const SizedBox(height: 10),

              // Your Company (large height)
              _buildTextField(
                label: "Your message",
                hintText: "Tell us how we can help you",
                maxLines: 8,
                controller: yourCompanyController,
              ),
              const SizedBox(height: 43),

              // Contact Information section
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        color: Color(0xFF424242),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_mail.png",
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(width: 51),
                        const Text(
                          'example@gmail.com',
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // Phone
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_phone.png",
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(width: 51),
                        const Text(
                          '+880 1234 567890',
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // Address
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_location.png",
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(width: 51),
                        const Text(
                          '123, Main Street, Dhaka',
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // Time
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_clock.png",
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(width: 51),
                        const Text(
                          'www.example.com',
                          style: TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                  ],
                ),
              ),

              const SizedBox(height: 43),

              // Error / Success message
              Obx(() {
                if (controller.errorMessage.isNotEmpty) {
                  return Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                if (controller.successMessage.isNotEmpty) {
                  return Text(
                    controller.successMessage.value,
                    style: const TextStyle(color: Colors.green),
                  );
                }
                return const SizedBox();
              }),

              const SizedBox(height: 10),

              // Submit Button
              Align(
                alignment: Alignment.center,
                child: Obx(
                  () => SizedBox(
                    height: 39,
                    width: 342,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B7FD0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : _submitForm,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Send Message",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 170),
            ],
          ),
        ),
      ),
    );
  }

  // Submit form method
  void _submitForm() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final address = addressController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final subject = subjectController.text.trim();
    final yourCompany = yourCompanyController.text.trim();

    // Basic validation
    if (firstName.isEmpty || lastName.isEmpty) {
      controller.setError("First name and last name are required");
      return;
    }

    controller.clearError();
    controller.createContact(
      firstName: firstName,
      lastName: lastName,
      address: address,
      phoneNumber: phoneNumber,
      subject: subject,
      message: yourCompany,
    );
  }

  // Reusable TextField Builder with controller
  Widget _buildTextField({
    required String label,
    required String hintText,
    int maxLines = 1,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF787878), fontSize: 10),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF484848)),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF484848)),
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ],
    );
  }
}
