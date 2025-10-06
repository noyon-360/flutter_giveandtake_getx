class OtpVerificationRequestModel {
  final String email;
  final String otp;
  final String? newPassword; // Optional for reset password flow

  OtpVerificationRequestModel({
    required this.email,
    required this.otp,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    final map = {'email': email, 'otp': otp};
    if (newPassword != null) {
      map['newPassword'] = newPassword!;
    }
    return map;
  }
}
