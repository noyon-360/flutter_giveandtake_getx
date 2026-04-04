import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_buttoms.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/input_decoration_extensions.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../profile_dasboard/controller/change_pass_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePassword> {
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  final TextEditingController currentCtrl = TextEditingController();
  final TextEditingController newCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  // @override
  // void dispose() {
  //   _currentCtrl.dispose();
  //   _newCtrl.dispose();
  //   _confirmCtrl.dispose();
  //   _currentFocus.dispose();
  //   _newFocus.dispose();
  //   _confirmFocus.dispose();
  //   super.dispose();
  // }
  //
  // Future _submit () async{
  //   if (!_formKey.currentState!.validate()) return;
  //   _recruiterCtrl.changePassword(_currentCtrl.text, _confirmCtrl.text);
  // }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Change Password', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // /// Profile Avatar
              // const CircleAvatar(
              //   radius: 50,
              //   backgroundImage: AssetImage("assets/images/profile.jpg"),
              // ),
              //
              // const SizedBox(height: 12),
              // const Text(
              //   "Brooklyn Simmons",
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: Color(0xFF212121),
              //   ),
              // ),
              // const SizedBox(height: 4),
              // const Text(
              //   "brooklynsimmons@gmail.com",
              //   style: TextStyle(fontSize: 14, color: Color(0xFF595959)),
              // ),
              // const SizedBox(height: 24),
              // const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Fields
              Obx(
                () => _passwordField(
                  hint: "Enter Current Password",
                  controller: currentCtrl,
                  onChanged: (val) => controller.currentPassword.value = val,
                  hasError: controller.hasError.value,
                ),
              ),
              const SizedBox(height: 20),

              Obx(
                () => _passwordField(
                  hint: "New Password",
                  controller: newCtrl,
                  onChanged: (val) => controller.newPassword.value = val,
                  hasError: controller.hasError.value,
                ),
              ),
              const SizedBox(height: 20),

              Obx(
                () => _passwordField(
                  hint: "Confirm Password",
                  controller: confirmCtrl,
                  onChanged: (val) => controller.confirmPassword.value = val,
                  hasError: controller.hasError.value,
                ),
              ),
              const SizedBox(height: 8),

              /// Error message
              /// Error message
              Obx(
                () => controller.hasError.value
                    ? const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Text(
                            "Passphrase must be at least 12 characters and \n include one uppercase, one lowercase, one number, \n and one special character.",
                            style: TextStyle(
                              color: Color(0xFFB90000),
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              /// Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.validateAndSubmit();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B7FD0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(
                              color: Color(0xFFF4F4F4),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Server error or success
              Obx(() {
                if (controller.serverError.isNotEmpty) {
                  return Text(
                    controller.serverError.value,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                if (controller.isSuccess.value) {
                  return const Text(
                    "Password changed successfully",
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required Function(String) onChanged,
    required bool hasError,
    String? hint,
    double height = 53,
  }) {
    final isObscure = true.obs;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Obx(
        () => SizedBox(
          height: height,
          child: TextFormField(
            controller: controller,
            obscureText: isObscure.value,
            obscuringCharacter: "*",
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF212121),
            ),
            decoration: InputDecoration(
              prefixIcon: SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: Image.asset(
                    "assets/icons/changepass_lock.png",
                    width: 18,
                    height: 18,

                    color: const Color(0xFF999999),
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Image.asset(
                  "assets/icons/eye_closed.png",
                  width: 20,
                  height: 20,
                  color: const Color(0xFF999999),
                ),
                onPressed: () {
                  isObscure.value = !isObscure.value;
                },
              ),
              hintText: hint ?? "Enter password",
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: hasError ? Colors.red : const Color(0xFF737373),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF4B5563),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : const Color(0xFF4B5563),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
