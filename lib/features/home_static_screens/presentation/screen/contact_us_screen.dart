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

  // Brand colour reused across the screen.
  static const Color _primary = Color(0xFF2B7FD0);

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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro
              const Text(
                'Get in touch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Fill out the form and we'll get back to you shortly.",
                style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
              ),
              const SizedBox(height: 22),

              // First + Last Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "First Name*",
                      hintText: "Enter your first name",
                      controller: firstNameController,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTextField(
                      label: "Last Name*",
                      hintText: "Enter your last name",
                      controller: lastNameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address
              _buildTextField(
                label: "Address",
                hintText: "Enter your address",
                controller: addressController,
              ),
              const SizedBox(height: 16),

              // Phone
              _buildTextField(
                label: "Phone Number",
                hintText: "Enter Phone Number",
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Subject
              _buildTextField(
                label: "Subject",
                hintText: "Enter subject",
                controller: subjectController,
              ),
              const SizedBox(height: 16),

              // Message
              _buildTextField(
                label: "Your message",
                hintText: "Tell us how we can help you",
                maxLines: 6,
                controller: yourCompanyController,
              ),
              const SizedBox(height: 28),

              // Contact Information card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6F0FA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _contactRow(
                      "assets/icons/contactus_mail.png",
                      'Email',
                      'example@gmail.com',
                    ),
                    _contactRow(
                      "assets/icons/contactus_phone.png",
                      'Phone',
                      '+880 1234 567890',
                    ),
                    _contactRow(
                      "assets/icons/contactus_location.png",
                      'Address',
                      '123, Main Street, Dhaka',
                    ),
                    _contactRow(
                      "assets/icons/contactus_clock.png",
                      'Website',
                      'www.example.com',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Error / Success message
              Obx(() {
                if (controller.errorMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  );
                }
                if (controller.successMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      controller.successMessage.value,
                      style: const TextStyle(
                        color: Color(0xFF10B287),
                        fontSize: 13,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Submit Button — full width and responsive
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      disabledBackgroundColor: const Color(0xFF9DC3E6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.isLoading.value ? null : _submitForm,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Send Message",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
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

  // A single contact-info line: icon + caption + value.
  Widget _contactRow(String asset, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Image.asset(asset, width: 38, height: 38),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF90A0B0),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable TextField Builder with controller
  Widget _buildTextField({
    required String label,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
            isDense: true,
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: _primary, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: const Color(0xFFFAFBFC),
            filled: true,
          ),
        ),
      ],
    );
  }
}
