class SecurityQuestionsResponseModel {
  final bool success;
  final String message;
  final String? token;

  SecurityQuestionsResponseModel({
    required this.success,
    required this.message,
    this.token,
  });

  factory SecurityQuestionsResponseModel.fromJson(Map<String, dynamic> json) {
    return SecurityQuestionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}
