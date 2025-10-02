class OtpResponseModelRegister{
  final bool success;
  final String message;


  OtpResponseModelRegister({
    required this.success,
    required this.message,
  });

  factory OtpResponseModelRegister.fromJson(Map<String, dynamic> json) {
    return OtpResponseModelRegister(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
