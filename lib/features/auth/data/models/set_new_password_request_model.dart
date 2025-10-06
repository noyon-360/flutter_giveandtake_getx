class SetNewPasswordRequestModel {
  final String email;
  final String newPassword;
  final String otp;

  SetNewPasswordRequestModel({
    required this.email,
    required this.newPassword,
    required this.otp,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': newPassword, // API expects 'password' not 'newPassword'
      'otp': otp,
    };
  }
}
