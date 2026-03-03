class OtpVerifyRequestModel {
  final String email;
  final String otp;

  OtpVerifyRequestModel({
    required this.email,
    required this.otp,
  });

  // Convert Model to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp": otp,
    };
  }

  // Optional: From JSON (if needed)
  factory OtpVerifyRequestModel.fromJson(Map<String, dynamic> json) {
    return OtpVerifyRequestModel(
      email: json["email"] ?? "",
      otp: json["otp"] ?? "",
    );
  }
}