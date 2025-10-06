class SecurityQuestionsResponseModel {
  final bool success;
  final String message;
  final String? token;

  SecurityQuestionsResponseModel({
    required this.success,
    required this.message,
    this.token,
  });

  factory SecurityQuestionsResponseModel.fromJson(dynamic json) {
    // Handle null case - return default model
    if (json == null) {
      return SecurityQuestionsResponseModel(
        success: true,
        message: 'Success',
        token: null,
      );
    }

    // Handle non-Map types
    if (json is! Map<String, dynamic>) {
      return SecurityQuestionsResponseModel(
        success: true,
        message: 'Success',
        token: null,
      );
    }

    return SecurityQuestionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}
