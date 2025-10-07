class OtpVerificationResponseModel {
  final bool success;
  final String message;

  OtpVerificationResponseModel({required this.success, required this.message});

  factory OtpVerificationResponseModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return OtpVerificationResponseModel(success: true, message: 'Success');
    }
    return OtpVerificationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
